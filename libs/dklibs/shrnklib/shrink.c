/*
; SHRINK92 - Copyright 1998, 1999 David Kuehling
; Adaptation for TI-89/92+ - Copyright 2002, 2003, 2004, 2005 Patrick Pelissier
;
; This file is part of the SHRINK92 Library.
;
; The SHRINK92 Library is free software; you can redistribute it and/or modify
; it under the terms of the GNU Lesser General Public License as published by
; the Free Software Foundation; either version 2.1 of the License, or (at your
; option) any later version.
;
; The SHRINK92 Library is distributed in the hope that it will be useful, but
; WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
; License for more details.
;
; You should have received a copy of the GNU Lesser General Public License
; along with the MPFR Library; see the file COPYING.LIB.  If not, write to
; the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
; MA 02111-1307, USA.
*/

/*
 * This file contains some compression and extraction routines for a primitive
 * kind of archive. The compression algorithm is a combination of Huffman
 * Compression, RLE and an optimized variation of LZSS. Compression is quite
 * slow but uncompression may be quite fast. This algorithm was designed to
 * be used for compressing files on the PC and uncompressing them on the
 * programable calculator TI-92 with an assembly program, using the assembly
 * shell Fargo by David Ellsworth. That's why the size of the input files
 * is limited to 65535 and the output archive's size have to be so small that
 * the greatest offset of an archive's section is smaller than 65536.
 * Archives are created in a way that each file can be uncompressed separated
 * from the others although they use the same Huffman tree. No scanning
 * through the archive is necessary. This is because each section begins on a
 * byte boundary.
 *
 * For a detailed description of each routine look up `SHRINK.H'.
 *
 * If you want to know details about this compression algorithm ask me, don't
 * watch this source. I modified it many times, for that reason it's not very
 * clear.
 */


/****************************************************************************/
#include <stdio.h>
#include <string.h>
#include <malloc.h>
/****************************************************************************/

extern void *xmalloc (size_t num);

/****************************************************************************/
#define  MAX_FILES 256          /* maximum number of files in an archive */

#define  RLE_ESC 256            /* introduces RLE token */
#define  REP_ESC 257            /* greater or equal introduce repetition token */
#define  START_REP_BITS 4       /* beginning number of bits for rep    on coding */
#define  REP_CODES 64           /* number of codes, used for repetition coding */
#define  CODES 256+REP_CODES+1  /* total number of codes */
#define  MIN_REP 3              /* minimum length of a repetition */
#define  RLE_CODES 32           /* total number of length codes for RLE */
#define  RLE_BITS 5             /* number of bits required for RLE coding */
/****************************************************************************/

//#define  DEBUG


/**********************************************************
   DATA TYPES
 **********************************************************/

/**
 * Errors
 */
typedef enum ERROR_NUM
{
   NO_ERROR = 0,        // there is no error
   MEMORY,              // not enough memory
   TOO_MANY_FILES,      // too many input files (compression only)
   INPUT_SIZE,          // an input file is too big (compression only)
   OUTPUT_SIZE,         // the output archive is too big (compression only)

   FORMAT,              // illegal archive format (extraction only)
} ERROR_NUM;

/**
 * Linked list for character occurences
 */
typedef struct CHR_OCCURENCE
{
   long offs;                   // offset of occurence
   struct CHR_OCCURENCE *next;  // next occurence
} CHR_OCCURENCE;

/**
 * Compression info at one offset
 */
typedef struct COMPR_DATA
{
   enum COMPR_TYPE      // type of compression that is most efficent
   {
      RLE,
      REP,
      HUFF
   } type;

   long remBits;        // size of the remaining file in bits

   struct RLE_DATA      // RLE data
   {
      int len;             // length of RLE sequence
   } rle;
   struct REP_DATA      // Repetition Encoding data
   {
      int len;             // length of repetition
      long offs;           // offset of repetition
      int bits;            // number of bits, required for encoding `offs'
   } rep;

   unsigned char chr;   // current character (for RLE / Huffman)
} COMPR_DATA;

/**
 * Huffman tree element
 */
typedef struct HUFF_TREE_ELM
{
   struct HUFF_TREE_ELM *left, *right;
   int    chr;          // is -1 if element is a junction
} HUFF_TREE_ELM;

/**
 * Unresolved Huffman Tree element
 */
typedef struct UNRESOLVED_HUFF
{
   HUFF_TREE_ELM          *elm;
   int                    weight;
} UNRESOLVED_HUFF;

/**
 * Bit list for huffman compression of one byte
 */
typedef struct BIT
{
   int bit;
   struct BIT *next;
} BIT;

/**********************************************************
   DATA
 **********************************************************/

unsigned char   *Input,          // current input source
                **Inputs,        // pointer to the list of input sources
                *Output;         // output destination
short int       *HuffInput,      // current huffman input source
                *HuffInputs[MAX_FILES];// list of all huffman input sources

long            HuffFreqs[CODES],// character frequencies in input, reduced to
                                 // 8 bits
                InputOffs,       // input offset (in current input source)
                InputRem,        // remaining bytes in current input
                InputSize,       // size of current input
                *InputSizes,     // list of input sizes
                HuffInputSize,   // size of current huffman input
                HuffInputSizes[MAX_FILES],// list of huffman input sizes
                OutputOffs,      // output offset
                OutputSize,      // size of output
                TotalInputSize,  // sum of lengths of all input sources
                TotalInputOffs;  // total offset within all input sources

int             CodeLen[CODES],  // length(bit) of each code (huffman)
                HuffTreeSize,    // junctions_in_huffman_tree * 4
                CurPass,         // number of current pass
                CurInput,        // number of current input
                Passes = 16,     // number of compression passes
                InputNum;        // number of input sources

CHR_OCCURENCE   *ChrOccure[256]; // occurences of each character in `Input'
HUFF_TREE_ELM   *HuffRoot;       // root of Huffman tree
BIT             *HuffCodes[CODES];// huffman codes of each code
ERROR_NUM       ShrinkError;     // error number
COMPR_DATA      *ComprData,      // compression data of current file
                *ComprDatas[MAX_FILES]; // compression data of all files


/**
 * Pointer to the routine that is called for displaying compression progres.
 *
 * It's argument:
 *    progress:      a value between 0 and 1000 that indicates the compression
 *                   rogress: 0 = compression begin, 1000 = end of compression
 */
void DefaultComprInfo (int);
void  (*ComprInfo) (int progress) = DefaultComprInfo;

/**********************************************************
   COMPRESSION
 **********************************************************/

/**
 * Default compression info routine. Outputs information to stdout.
 */
void DefaultComprInfo (int progress)
{
   printf ("\rCompressing file%s... ", InputNum > 1 ? "s" : "");

   if (progress < 1000)
      printf ("%02i%%", progress / 10);
   else
      printf ("done\n");

   fflush (stdout);
}

/* Bitwise Output
 ************************************************/

int OutputBitNum;               // number of current output bit

/**
 * Initialize bitwise output
 */
void InitBitOutput ()
{
   OutputBitNum = 0;
   Output[OutputOffs] = 0;
}

/**
 * End of bitwise output -- go to next byte, leaving some unused bits in
 * the current output byte;
 */
void EndBitOutput ()
{
   if (OutputBitNum)
      OutputOffs++;
}

/**
 * Output one bit to `Output[OutputOffs]'
 */
void OutputBit (int bit)
{
   Output[OutputOffs] |= bit << OutputBitNum;

   if (++OutputBitNum == 8)
   {
      OutputBitNum = 0;
      Output[++OutputOffs] = 0;
   }
}

/**
 * Output `n' bits of `v' to `Output[OutputOffs]'.
 * Output the most significant bit first, the least significant last.
 * (uncompression may be implemented easier in this way)
 */
void OutputNBits (int v, int n)
{
   for (n-- ; n >= 0; n--)
      OutputBit (v >> n & 1);
}


/* Bitwise Input
 ************************************************/

int InputBitNum;               // number of current input bit

/**
 * Initialize bitwise input
 */
void InitBitInput ()
{
   InputBitNum = 0;
}

/**
 * Read one bit from `Input[InputOffs]'
 */
int ReadBit ()
{
   int bit = Input[InputOffs] >> InputBitNum & 1;

   if (++InputBitNum == 8)
   {
      InputBitNum = 0;
      InputOffs++;
   }

   return (bit);
}

/**
 * Read `n' bits from `Input[InputOffs]'. The first read bit is the most
 * significant one, the last is the least significant.
 */
long ReadNBits (int n)
{
   long bits = 0;

   for (n-- ; n >= 0; n--)
      bits = bits << 1 | ReadBit ();

   return (bits);
}


/* RLE
 **********************************************/

int            RLETokenLen;   // length of one RLE token

/**
 * Initialize RLE compression (have to be called before compression)
 */
void InitRLE ()
{
   RLETokenLen = CodeLen[RLE_ESC]+RLE_BITS;
}

/**
 * Writes all data about RLE compressio at the current input offset into
 * the `COMPR_DATA' structure's element `data->rle'.
 */
void getRLEData (COMPR_DATA *data)
{
   unsigned char  *s = Input+InputOffs;   // scanning pointer to input
   int            I = -1,                 // length of repetition counter
                  chr;                    // character to repeat

   if (InputOffs >= 1)
      for (I = 0, chr = s[-1]; I < RLE_CODES+1 && I < InputRem && *s++ == chr; I++);

   data->rle.len = I >= 2 ? I : -1;
}

/**
 * Return the number of bits in the input file from `data' to the end
 * in case that RLE compression is used on the current position.
 * If no RLE compression is possible return 0x7FFFFFFF.
 */
long getRLEremBits (COMPR_DATA *data)
{
   int  I,
        minLen;         // length corresponding to the minimum number of bits
   long minBits;        // minimum number of bits

   if (data->rle.len < 0)
      return (0x7FFFFFFF);

   for (I = 2, minBits = 0x7FFFFFFF, minLen = -1; I <= data->rle.len; I++)
      if (data[I].remBits <= minBits)
         minBits = data[I].remBits, minLen = I;

   data->rle.len = minLen;

   return (minBits + RLETokenLen);
}

/**
 * Code an RLE sequence by the data, contained in the `COMPR_DATA' structure's
 * element `data->rle'. Return the number of characters coded.
 */
int CodeRLE (COMPR_DATA *data)
{
   #ifdef DEBUG
      printf ("%5li: RLE '%c' * %i\n", InputOffs, data->chr, data->rle.len);
   #endif

   HuffInput[OutputOffs++] = RLE_ESC;
   HuffInput[OutputOffs++] = data->rle.len-2;

   return (data->rle.len);
}

/* Repetition Encoding
 **********************************************/

int     RepBits,        // number of offset bits in Repetition Token
        RepRange;       // range in which repetitions can be coded with the
                        // current number of bits `RepBits'

/**
 * Skip one character from the input source. Add this character's occurence
 * to the `ChrOccure' - list. All characters in the input source have to be
 * skipped using that routine, else `getRepData' won't work.
 */
void SkipCharacter ()
{
   CHR_OCCURENCE *chr;                  // occurence of current character
   unsigned char c = Input[InputOffs];  // current character

   chr = malloc (sizeof (CHR_OCCURENCE));
   if (chr == NULL)
   {
      ShrinkError = MEMORY;
      return;
   }
   chr->offs = InputOffs++;
   chr->next = ChrOccure[c];
   ChrOccure[c] = chr;

   InputRem--;
}

/**
 * Free the character-occurence table `ChrOccure'
 */
void FreeChrOccure ()
{
   int           I;
   CHR_OCCURENCE *Iocc,
                 *toFree;

   for (I = 0; I < 256; I++)
      for (Iocc = ChrOccure[I]; Iocc;)
      {
         toFree = Iocc;
         Iocc = Iocc->next;
         free (toFree);
      }
}

/**
 * Initialize repetition data processing by `getRepData'
 */
void InitRep ()
{
   bzero (ChrOccure, sizeof(ChrOccure));

   RepBits = START_REP_BITS;
   RepRange = 1<<RepBits;
}

/**
 * Store the longest repetition's data into the `COMPR_DATA' structure's
 * element `data->rep'.
 */
void getRepData (COMPR_DATA *data)
{
   CHR_OCCURENCE *Iocc;         // character occurence pointer
   int           I,             // repetition length counter
                 maxLen,        // maximum repetition's length
                 maxOffs = 0;   // maximum repetition's offset
   long          cmp1, cmp2;    // comparison offsets

   while (RepRange+MIN_REP <= InputOffs)
      RepRange <<= 1, RepBits++;

   for (Iocc = ChrOccure[Input[InputOffs]], maxLen = -1; Iocc; Iocc = Iocc->next)
   {
      /** check repetition's length at that offset (`Iocc->offs') */
      for (I = 0, cmp1 = Iocc->offs, cmp2 = InputOffs;
              Input[cmp1] == Input[cmp2] &&
              I < REP_CODES + MIN_REP-1 && I < InputRem && cmp1 < InputOffs;
           I++, cmp1++, cmp2++);

      if (I >= MIN_REP && I > maxLen)
         maxLen = I, maxOffs = Iocc->offs;
   }

   data->rep.len = maxLen;
   data->rep.offs = maxOffs;
   data->rep.bits = RepBits;
}

/**
 * Return the number of bits in the input file from `data' to the end
 * in case that Repetition compression is used on the current position.
 * If no Repetition compression is possible return 0x7FFFFFFF.
 */
long getRepRemBits (COMPR_DATA *data)
{
   int  I,
        minLen;         // length corresponding to the minimum number of bits
   long minBits,        // minimum number of bits
        bits;           // number of bits for current rep compression

   if (data->rep.len < 0)
      return (0x7FFFFFFF);

   for (I = MIN_REP, minBits = 0x7FFFFFFF, minLen = -1; I <= data->rep.len; I++)
      if ((bits = data[I].remBits + CodeLen[REP_ESC+I-MIN_REP]+data->rep.bits) <= minBits)
         minBits = bits, minLen = I;

   data->rep.len = minLen;

   return (minBits);
}

/**
 * Code a repetition by the data stored in the `COMPR_DATA' structure's
 * element `data->rep'. Return the number of character's coded.
 */
int CodeRep (COMPR_DATA *data)
{
   #ifdef DEBUG
      printf ("%5li: REP [%li] %i (%i bits)\n", InputOffs,
              data->rep.offs, data->rep.len, data->rep.bits);
   #endif

   HuffInput[OutputOffs++] = REP_ESC + data->rep.len-MIN_REP;
   HuffInput[OutputOffs++] = data->rep.bits;
   HuffInput[OutputOffs++] = data->rep.offs;

   return (data->rep.len);
}


/* Do the Repetition and RLE compression
 **********************************************/

/**
 * Set the `ComprData' array to the best repetition and RLE sequences'
 * lengths, offsets etc. in the current input source `Input'. This routine
 * has to be called on every file before `RepRLECompress' is executed.
 * `ComprData' is expected to point to a free memory region of at least
 * `InputSize' + 1 bytes.
 */
void getRepRLEData1 ()
{
   InitRLE ();
   InitRep ();

   /** get the compression data for each byte and algorithm *
    ** (Huffman, RLE and Repetition Encoding                */
   if (ComprData == NULL)
   {
      ShrinkError = MEMORY;
      return;
   }

   for (InputOffs = 0, InputRem = InputSize;
        InputRem && ShrinkError == NO_ERROR;
        SkipCharacter (), TotalInputOffs++)
   {
      ComprData[InputOffs].chr = Input[InputOffs];
      getRLEData (&ComprData[InputOffs]);
      getRepData (&ComprData[InputOffs]);

      if (!(InputOffs&127) && ComprInfo != NULL)
         ComprInfo (TotalInputOffs * 999 / TotalInputSize);
   }

   FreeChrOccure ();
}

/**
 * Get repetition/RLE data of all files
 */
void getRepRLEData ()
{
   for (CurInput = TotalInputOffs = 0; CurInput < InputNum; CurInput++)
   {
      Input = Inputs[CurInput];
      InputSize = InputSizes[CurInput];
      ComprData = ComprDatas[CurInput] =
                  malloc ((InputSize+1)*sizeof (COMPR_DATA));
      if (ComprData == NULL)
      {
         ShrinkError = MEMORY;
         return;
      }
      getRepRLEData1 ();
   }
}

/**
 * Repetition / RLE compression of the current input `Input'.
 * Output result to `HuffInput' which is expected to point to an empty memory
 * region containing as many elements as the input source bytes.
 * `HuffInputSize' is set to the number of elements in `HuffInput'
 * The `CodeLen' - table is expected to be initialized.
 */
void RepRLECompress1 ()
{
   long       RLEbits,          // number of remaining bits when using RLE
              repBits,          // remaining bits when using Repetition Enc.
              huffBits,         // remaining bits when using huffman compression
              remBits;          // current number of remaining bits in file


   /** check, which algorithm is the most efficent one */
   for (InputOffs = InputSize-1, ComprData[InputSize].remBits = remBits = 0; InputOffs >= 0; InputOffs--)
   {
      huffBits = remBits + CodeLen[ComprData[InputOffs].chr];
      RLEbits = getRLEremBits (&ComprData[InputOffs]);
      repBits = getRepRemBits (&ComprData[InputOffs]);

      if (huffBits < RLEbits && huffBits < repBits)
      {
         ComprData[InputOffs].type = HUFF;
         remBits = huffBits;
      }
      else if (RLEbits < repBits)
      {
         ComprData[InputOffs].type = RLE;
         remBits = RLEbits;
      }
      else
      {
         ComprData[InputOffs].type = REP;
         remBits = repBits;
      }
      ComprData[InputOffs].remBits = remBits;
   }

   /** output the compression to `HuffInput' */
   for (OutputOffs = InputOffs = 0; InputOffs < InputSize;)
   {
      if (ComprData[InputOffs].type == HUFF)
      {
         #ifdef DEBUG
            printf ("%5li: '%c'\n", InputOffs, Input[InputOffs]);
         #endif
         HuffInput[OutputOffs++] = ComprData[InputOffs].chr;
         InputOffs += 1;
      }
      else if (ComprData[InputOffs].type == RLE)
         InputOffs += CodeRLE (&ComprData[InputOffs]);
      else
         InputOffs += CodeRep (&ComprData[InputOffs]);
   }

   HuffInputSize = OutputOffs;
}

/**
 * Compress all input sources `Inputs' to the huffman inputs `HuffInputs'.
 * `HuffInputs' is allocated by this routine.
 */
void DoRepRLECompression ()
{
   for (CurInput = 0; CurInput < InputNum; CurInput++)
   {
      Input = Inputs[CurInput];
      InputSize = InputSizes[CurInput];
      ComprData = ComprDatas[CurInput];

      HuffInput = HuffInputs[CurInput] = malloc (InputSize*sizeof(short int) * 4/3);
      if (HuffInput == NULL)
      {
         ShrinkError = MEMORY;
         return;
      }
      RepRLECompress1 ();
      HuffInputSizes[CurInput] = HuffInputSize;
   }
}

/* Huffman Compression
 **********************************************/

/**
 * Calculate the characer frequencies of the input sources `Inputs'. Codes
 * after Esc-sequences aren't counted.
 * The frequencies are stored to `HuffFreqs'; they are reduced to only take
 * 8 bit!
 */
void CalculateHuffFreqs ()
{
   long  I,
         maxFreq;       // maximum character frequency
   int   J;
   short int c;         // current code

   /** count frequencies */
   bzero (HuffFreqs, sizeof (HuffFreqs));
   for (J = 0; J < InputNum; J++)
      for (I = 0; I < HuffInputSizes[J]; I++)
      {
         c = HuffInputs[J][I];
         HuffFreqs[c]++;

         if (c == RLE_ESC)
            I++;
         if (c >= REP_ESC)
            I += 2;
      }

   /** get maximum frequency */
   for (I = 0, maxFreq = -1; I < CODES; I++)
      if (HuffFreqs[I] > maxFreq)
         maxFreq = HuffFreqs[I];

   /** stretch/reduce frequencies to 0...255 */
   for (I = 0; I < CODES; I++)
   {
      if (!HuffFreqs[I])
         HuffFreqs[I] = 0;
      else
         HuffFreqs[I] = (HuffFreqs[I]*254) / maxFreq + 1;
   }
}

/**
 * Return address of unresolved Huffman tree element with the lowest weight.
 * (Search through the global array `UnresHuff' that has `num' entries).
 */
UNRESOLVED_HUFF *getLowestHuffElm (UNRESOLVED_HUFF *unres, int num)
{
   UNRESOLVED_HUFF *ptrMin;  // pointer to pointer to element with lowest weight
   int             minWeight,
                   I;

   for (I = 0, minWeight = 32767, ptrMin = NULL; I < num; I++)
      if (unres[I].weight < minWeight)
         minWeight = unres[I].weight, ptrMin = &unres[I];

   return (ptrMin);
}

/**
 * Build the huffman tree, using the frequencies from `HuffFreqs'.
 * Set the global variable `HuffTreeSize' to the number of junctions in the
 * tree * 4.
 */
void BuildHuffTree ()
{
   int             I,
                   weight1,      // weight of unresolved element #1
                   unresNum;     // number of elements in `unres'
   UNRESOLVED_HUFF unres[CODES], // array of unresolved huffman tree elements
                   *first,       // pointer to first used entry in `unres'
                   *min1, *min2; // direct pointer to elements with lowest weight
   HUFF_TREE_ELM   *newHuff,     // new Huffman tree element
                   *elm1;        // pointer to unresolved huffman element #1

   /** initialize Table of Unresolved Elements to the Leaves */
   for (I = unresNum = 0; I < CODES; I++)
      if (HuffFreqs[I])
      {
         unres[unresNum].weight = HuffFreqs[I];
         unres[unresNum].elm = xmalloc (sizeof (HUFF_TREE_ELM));
         unres[unresNum].elm->chr = I;
         unresNum++;
      }

   /** build the Huffman Tree (loop until only one unresolved element is left) */
   for (HuffTreeSize = 0, first = unres; unresNum > 1; HuffTreeSize += 4)
   {
      min1 = getLowestHuffElm (first, unresNum);
      weight1 = min1->weight;
      elm1 = min1->elm;

      /** remove that element from the array of unresolved elements */
      memmove (min1, first++, sizeof (UNRESOLVED_HUFF)); // replace it by first elm.
      unresNum--;

      min2 = getLowestHuffElm (first, unresNum);

      /** replace minimum element #2 by the junction */
      newHuff = xmalloc (sizeof (HUFF_TREE_ELM));
      newHuff->chr = -1;
      newHuff->left = elm1;
      newHuff->right = min2->elm;
      min2->elm = newHuff;
      min2->weight += weight1;
   }
   HuffRoot = first->elm;
}

/**
 * Free the huffman-tree `tree'
 */
void FreeHuffTree (HUFF_TREE_ELM *tree)
{
   /** if it is a junction --> free subtrees */
   if (tree->chr == -1)
   {
      FreeHuffTree (tree->left);
      FreeHuffTree (tree->right);
   }

   free (tree);
}

/**
 * Trace through the Huffman tree, storing the bits required for each code
 * into the bit lists in `HuffCodes', also setting the elements of `CodeLen'
 * to the length (in bits) of each code.
 */
void BuildHuffBitLists (HUFF_TREE_ELM *root)
{
   static int bits[256],        // list of bits for current code
              bitNum;           // number of bits of current code

   /** initialisation */
   if (root == HuffRoot)
   {
      int I;

      bitNum = 0;
      for (I = 0; I < CODES; I++)
         CodeLen[I] = 20, HuffCodes[I] = NULL;
   }

   /** this is a junction --> trace the subtrees */
   if (root->chr == -1)
   {
      bits[bitNum++] = 0;
      BuildHuffBitLists (root->left);
      bitNum--;
      bits[bitNum++] = 1;
      BuildHuffBitLists (root->right);
      bitNum--;
   }
   /** this is a leaf --> output bits to bit list of code */
   else
   {
      BIT **ptrBit;
      int I;

      CodeLen[root->chr] = bitNum;

      for (I = 0, ptrBit = &HuffCodes[root->chr]; I < bitNum; I++)
      {
         *ptrBit = xmalloc (sizeof (BIT));
         (*ptrBit)->next = NULL;
         (*ptrBit)->bit = bits[I];
         ptrBit = &(*ptrBit)->next;
      }
   }
}

/**
 * Free the bit lists in `HuffCodes'
 */
void FreeHuffBitLists ()
{
   int I;
   BIT *bit,    // current bit (part of bit list)
       *kill;   // bit to free (part of bit list)

   for (I = 0; I < CODES; I++)
      for (bit = HuffCodes[I]; bit;)
      {
         kill = bit;
         bit = bit->next;
         free (kill);
      }
}


/**
 * Output the huffman code `code' to Output. Bitwise output has to be
 * enabled.
 */
void OutputHuffCode (int code)
{
   BIT *Ibit;           // pointer into bit list

   for (Ibit = HuffCodes[code]; Ibit; Ibit = Ibit->next)
      OutputBit (Ibit->bit);
}

/**
 * Output the character frequencies used for building the huffman tree
 * to `Output' and increase `OutputOffs' according.
 */
void OutputHuffFreqs ()
{
   int I, J,
       freq;

   for (I = 0, freq = -1; I < CODES; I++)
   {
      freq = HuffFreqs[I];
      /** how many frequencies are equal? (is RLE possible here?) */
      for (J = 1; J+I < CODES && HuffFreqs[I+J] == freq && J < 32; J++);

      if (J >= 3 || (freq >= 0xE0))
      {
         /** code an RLE sequenc */
         Output[OutputOffs++] = (J-1)|0xE0;
         I += J-1;
      }
      Output[OutputOffs++] = freq;
   }
}


/**
 * Huffman compress the data from `HuffInput' to `Output'.
 */
void HuffCompress1 ()
{
   long I,
        startOffs;
   int  code;

   startOffs = OutputOffs;
   InitBitOutput ();

   for (I = 0; I < HuffInputSize; I++)
   {
      OutputHuffCode (code = HuffInput[I]);

      /** copy escape-sequence-data without huffman compression */
      if (code == RLE_ESC)
         OutputNBits (HuffInput[++I], RLE_BITS);
      else if (code >= REP_ESC)
      {
         int bits = HuffInput[++I];
         OutputNBits (HuffInput[++I], bits);
      }

   }

   EndBitOutput ();
}

/**
 * Huffman compress the data from the huffman input sources `HuffInputs'
 * to `Output'. Each new input will begin on a new byte.
 * At the begin of output a list is created that contains the beginning
 * offset of each section of the archive (each of the input sources) and the
 * size of each section. Each entry has 4 bytes:
 * 00: offset (high) (relative to the length/offset table's begin)
 * 01: offset (low)  ( -"- )
 * 02: length (high)
 * 03: length (low)
 * Before that list the size of the archive descriptor for extraction is
 * stored. (first high, than low; = junctions*4 + 6)
 *
 * At the end of the compression the huffman input sources are freed.
 */
void DoHuffCompression ()
{
   int  I;
   long listOffs,       // offset of current element in offset/length list
        relOffs,        // relative offset of section to the offs/length list
        relOffsBase,    // base for relative offsets (begin of offs/length list)
        treeSizeOffs;   // offset where huffman tree size is stored

   /** initialize huffman compression */
   OutputOffs = 0;
   CalculateHuffFreqs ();
   BuildHuffTree ();
   BuildHuffBitLists (HuffRoot);
   OutputHuffFreqs ();

   /** leave space for the offset/length list */
   OutputOffs = ++OutputOffs & 0xFFFE;  // align output offs. on even addr.
   treeSizeOffs = OutputOffs;
   OutputOffs += 2;
   listOffs = relOffsBase = OutputOffs;
   OutputOffs += InputNum*4;

   /** do the huffman compression */
   for (I = 0; I < InputNum; I++)
   {
      HuffInput = HuffInputs[I];
      HuffInputSize = HuffInputSizes[I];
      InputSize = InputSizes[I];
      CurInput = I;

      /** update the list */
      relOffs = OutputOffs-relOffsBase;
      if (relOffs >= 65536)
      {
         ShrinkError = OUTPUT_SIZE;
         return;
      }
      if (InputSizes[I] >= 65536)
      {
         ShrinkError = INPUT_SIZE;
         return;
      }
      Output[listOffs++] = relOffs >> 8;          // offset (high)
      Output[listOffs++] = relOffs & 0xFF;        // offset (low)
      Output[listOffs++] = InputSize >> 8;        // length (high)
      Output[listOffs++] = InputSize & 0xFF;      // length (low)

      HuffCompress1 ();

      HuffTreeSize += 6;      // size of archive descriptor
      Output[treeSizeOffs]   = HuffTreeSize >> 8;
      Output[treeSizeOffs+1] = HuffTreeSize & 0xFF;

      free (HuffInput);
   }

   OutputSize = OutputOffs;
   FreeHuffTree (HuffRoot);
   FreeHuffBitLists ();
}

/* Total compression
 **********************************************/

/**
 * Compress the data from `Inputs' to `Output'. `Output' is automatically
 * allocated
 */
void DoCompression ()
{
   int  I;
   unsigned char *bestOutput = NULL; // best compression result
   long          bestOutputSize;     // size of best compression result

   /** inialize code lengths */
   for (I = 0; I < 256; I++)
      CodeLen[I] = 7;
   for (I = 256; I < CODES; I++)
      CodeLen[I] = 10;

   /** allocate output-memory */
   for (I = TotalInputSize = 0; I < InputNum; I++)
      TotalInputSize += InputSizes[I];
   Output = malloc (TotalInputSize * 4/3 + 512 + 4*MAX_FILES);

   if (Output == NULL)
   {
      ShrinkError = MEMORY;
      return;
   }

   getRepRLEData ();    // initializes data for `DoRepRLECompression'

   for (CurPass = 0, bestOutputSize= 0x7FFFFFFF;
        CurPass < Passes && ShrinkError == NO_ERROR; CurPass++)
   {
      DoRepRLECompression ();
      if (ShrinkError != NO_ERROR)
         break;

      DoHuffCompression ();

      if (OutputSize < bestOutputSize)
      {
         if ((bestOutput = malloc (OutputSize)) == NULL)
         {
            ShrinkError = MEMORY;
            return;
         }
         memcpy (bestOutput, Output, OutputSize);
         bestOutputSize = OutputSize;
      }

      #ifdef DEBUG
         getkey ();
      #endif
   }

   for (I = 0; I < InputNum; I++)
      free (ComprDatas[I]);

   free (Output);
   Output = bestOutput;
   OutputSize = bestOutputSize;

   /** call compression progress indicator callback routine: 100% */
   if (ComprInfo != NULL)
      ComprInfo (1000);
}

/**
 * Compress the inputs, given by the list `inputs' and `inputSizes' to the
 * output `*output'. Set `output' to point to the allocated region where the
 * compression destination lies. You may free it by `free'.
 * Returns the size of the output.
 * If an error occured returns -1 and sets ShrinkError to the error's number.
 */
long Compress (unsigned char *inputs[], long inputSizes[], int inputNum, unsigned char **output)
{
   ShrinkError = NO_ERROR;

   if (inputNum > MAX_FILES)
   {
      ShrinkError = TOO_MANY_FILES;
      return (-1);
   }

   Inputs = inputs;
   InputSizes = inputSizes;
   InputNum = inputNum;
   DoCompression ();

   *output = Output;

   return (ShrinkError != NO_ERROR ? -1 : OutputSize);
}

/**
 * Easy to use compression routine.
 * Compress the data, pointed to by `input', that consist of `number' bytes,
 * to an allocated memory region. Set `output' to point to this region.
 * Return the number of bytes in `output'.
 * If an error occures return -1 and set the global variable `ShrinkError'
 * to the error number.
 */
long EasyCompress (unsigned char *input, long number, unsigned char **output)
{
   unsigned char *o;
   long size;

   size = Compress (&input, &number, 1, &o);

   *output = o;

   return (size);
}


/**********************************************************
   EXTRACTION
 **********************************************************/


/**
 * Read the Huffman character frequencies from `Input' to `HuffFreqs'
 */
void ReadHuffFreqs ()
{
   int I, J,
       freq;            // current frequency

   long hufffreqs[CODES];

   memcpy (hufffreqs, HuffFreqs, sizeof(HuffFreqs));

   for (I = 0; I < CODES;)
   {
      freq = Input[InputOffs++];
      if (freq >= 0xE0)
      {
         /** extract RLE */
         for (J = (freq&0x1F) + 1, freq = Input[InputOffs++]; J > 0; J--)
            HuffFreqs[I++] = freq;
      }
      else
         HuffFreqs[I++] = freq;
   }
}


/**
 * Read one Huffman code from the current input position `InputOffs'.
 * Bitwise input has to be enabled.
 */
int ReadHuffCode ()
{
   HUFF_TREE_ELM *Ihuff;        // pointer into the huffman tree

   for (Ihuff = HuffRoot; Ihuff->chr == -1;)
      Ihuff = ReadBit () ? Ihuff->right : Ihuff->left;

   return (Ihuff->chr);
}

/**
 * Extract the data at the current input offset `InputOffs' until the number
 * of output bytes `OutputSize' is reached.
 */
void DoExtract ()
{
   int  code,
        I,
        chr,            // character for RLE extraction
        repBits,        // number of bits for coding a repetition's offset
        repRange;       // range in which offsets can lie with current `repBits'

   long offs;           // offset of Repetition

   InitBitInput ();
   repBits = START_REP_BITS;
   repRange = 1 << repBits;

   for (OutputOffs = 0; OutputOffs < OutputSize;)
   {
      code = ReadHuffCode ();

      if (code < 256)
         Output[OutputOffs++] = code;
      else if (code == RLE_ESC)
         /** extract RLE */
         for (chr = Output[OutputOffs-1], I = ReadNBits (RLE_BITS)+2; I > 0; I--)
            Output[OutputOffs++] = chr;
      else
      {
         /** extract Repetition Encoded sequence */
         while (repRange+MIN_REP <= OutputOffs)
            repBits++, repRange <<= 1;

         for (I = code-REP_ESC+MIN_REP, offs = ReadNBits (repBits); I > 0; I--)
            Output[OutputOffs++] = Output[offs++];
      }
   }

   if (OutputOffs != OutputSize)
      ShrinkError = FORMAT;
}


/**
 * Extract the file, specified by `fileN' (the file's number) from the
 * archive, pointed to by `input'. Set `output' to point to an allocated
 * region where the data were extracted to. Return the file's size or
 * -1 on error. If an error occures the global variable `ShrinkError' is
 * set to the error's number.
 */
long Extract (unsigned char *input, int fileN, unsigned char **output)
{
   int    sectDataOffs,    // offset of section-data (offset and length)
          relOffsBase;     // base of the relative offsets

   Input = input;
   InputOffs = 0;

   ReadHuffFreqs ();
   BuildHuffTree ();

   relOffsBase = ((InputOffs+3) & 0xFFFE);
   sectDataOffs = relOffsBase + 4*fileN;

   /** read archive data about the file (beginning offset and length) */
   InputOffs = relOffsBase + (Input[sectDataOffs]<<8 | Input[sectDataOffs+1]);
   OutputSize = Input[sectDataOffs+2]<<8 | Input[sectDataOffs+3];

   if ((Output = malloc (OutputSize)) == NULL)
      ShrinkError = MEMORY;
   else
      DoExtract ();

   *output = Output;

   FreeHuffTree (HuffRoot);

   return (ShrinkError != NO_ERROR ? -1 : OutputSize);
}

