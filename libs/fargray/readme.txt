
                            F  A  R  G  R  A  Y

                  - The Picture Converter for the TI-92

===============================================================================
                               Fargray v0.2.4
              Copyright (C) 1996-1998 Kristian Kræmmer Nielsen
                             All rights reserved.
===============================================================================

THIS RELEASE IS MARKED: "current", meaning that it's just a snapshot of my
                        working directory; I stopped working on fargray a few
                        months ago and havn't had the time to start again yet
                        so until then you should be able to use this version
                        to create fargray pictures for use with Fargo II !!!

NEW v0.2.4 (unsupported prerelease of v0.2.6):
    - Library has been recompiled for Fargo 0.2.7.1
    - Fargray is now able to write Fargo 0.2.7.1 compatible asm-files
    - New effects-library has been added for use in the included templates (NOT INCLUDED)
    - Misc templates have been added, including fade, picturesplit and
      scroll entering templates (NOT INCLUDED)
    - Changed the version numbering scheme.
    - Piclink has been updated to Fargo 0.2.7.1
    - Small bug in the parallel linkroutine has been corrected

    - v0.2.6 will also come with lots of more nice features.... ;-)


WARNING: This prerelease might contain a damn lot of bugs, so don't blame me if your
         calculator crashes or the program doesn't work totally as it should.
         I havn't been working on the program nor tried it for the past three months.
         This release is simply a zip-file of my working directory, which I havn't
         touched in a long long time. Still if you find any bugs or have any problems
         using the program free fell to email me at jkkn@ctav.com.


NEW v2.0:
    - New configuration panel
    - Added support for LPTx for PicLINK !
    - Added Template-support in FarGray !
    - Added support for scrolling-images (requires a plugin!)
    - New improved compression format.
    - New improved -very- fast decompression library for fargo.
    - Now includes a demo fade-routine !

NEW v2.0b:
    - New Interface (Very easy to use, added windows, colors & more)
    - New Picture contrast editor (shows how the picture will appear)
    - New improved compression format
    - Added 7-shades support
    - Added compression for 1,2 & 3 plane-graphics !
    - Added PicLINK, lets you test out the graphics
      before doing the actual conversion !
    - Possible to only create the BIN-file !
    - Now asks for description !
    - Implemented BMP converter for 2, 4 & 8 bitsperpixel BMP-file !
    - Auto. Converts the picture to grayscale !

NEW v1.2:
    - BETTER PICTURE QUALITY (correct gray-shades)

NEW v1.0:
    - Added compression :-)
    - Converts both grayscale -AND- Black & White pictures !
    - NEW FGPLIB.92P - including all the gray-decompress-routines !
    - NEW SPRITE.ASM - demo on how to make sprites using FGPLIB.92P with compression.

===========================================================================================

PLEASE NOTICE:
    - The AutoCompile doesn't work yet, sorry :(
    - The OneLineCompression is only use to make scrolling-images !
    - Spilt.exe is only used to make scrolling-images ! (NOT INCLUDE IN THIS RELEASE)


HOW TO USE:
    1. Load your picture into Paint Shop Pro or Adobe PhotoShop.
    2. Reduce the size to max. 240x128 (rotate the picture if necessary)
    3. Convert the picture to grayscale with as low number of colors as possible.
       (ex. 4 colors for use for 2-plane images, 7 colors for use for 3-plane images)
       The idea is to use your graphicsporgrams error diffusion.
    4. Then convert it to 256 colors grayscale (1 channel).
    5. Save it as a RAW-file (8 bit) or BMP-file (if using BMP, make sure you save it as
       Windows, 2, 4 or 8 bit uncompressed)
    6. Run FARGRAY and load the picture.
       Enter the filename w/o the extension (ex. CAR.BMP -> "CAR")
       (if you are using RAW - you need to enter the size of your reduced picture)
    7. Compile the new .asm-file with FARGO.BAT
       (make sure you have install Fargo correctly with the FARGO-enviroment)
    7a.Remember to copy the headerfiles placed in INCLUDE\ to your fargo INCLUDE-directory
    8. Send the returned .92p-file and fargray.92p (if using compression) to your calc.
    9. Start the .92p-file by selecting it from the fbrowser or by simply starting it
       like it was a TI-Basic program - then your picture will be displayed
       in GRAYSCALE or B&W on your TI-92!
   10. Have fun!

NICE TO KNOW:
    - The filesize of a RAW, when it's saved as 8 bit, is ALWAYS = width x height !


Here is exactly how to convert your pictures to RAW :

Adobe PhotoShop (tested in v3.0.5):
1. Load your picture !
2. Click "Mode" and select "GrayScale",
   (if asked, then answer Yes, discard color information)
3. Click "Image" and select "Image Size..."
4. Rescale your picture to a maximum size of 240x128 pixels !
   (remember you can rotate you picture if necessary)
5. Click "Mode" and select "RGB Color" (all modes will then become avaiable)
6. Click "Mode" and select "Indexed Color"
7. Select "Other" and write "4" (this will convert the image to 4 grayscale-colors)
   (the way the picture is displayed now is very near to the way
    it is going to appear on your calculator)
   Remember to write "7" if you're going to convert your picture into a 3-planed
   picture.
8. In "Palette", select "Adaptive" and then "Diffusion", click "OK" !
9. Click "Mode" and select "RGB Color" (yes, again :-))
10. Click "Mode" and select "Indexed Color"
11. Now select "8 bits/pixel", palette: "System", Dither: "None" !
12. Click "OK" !
13. Click on "File" then "Save As..."
14. Select Save As: "Raw (*.RAW)" and write a filename 
15. Click "OK" !
16. Click "OK" !
17. Sometimes Adobe Photoshop doesn't convert the picture correct,
    try closing the picture and loading the rawfile again.
    It is possible that Adobe has made the picture negativ, if so
    just click on "Image" and then select "Map" and then "Invert"
    then just klik "File" and "Save", then "OK" !
The Raw file is now ready to be converted by FarGray !

Paint Shop Pro (works in v4.11):
1. Load your picture !
2. Click "Colors" and select "GrayScale"
3. Click "Image" and select "Resample"
4. Rescale your picture to a maximum size of 240x128 pixels !
   (remember you can rotate you picture if necessary)
3. Click "Colors" and select "Decrease Color Depth" and then "16 colors"
4. Select "Optimized", "Error diffusion" and click "OK"
5. Click "Colors" and select "Increase Color Depth" and then "256 colors"
6. Click "File" and select "Save As..."
7. Select Filetype: "RAW - Raw File Format" and write a filename.
8. Click "OK" !
The Raw file is now ready to be converted by FarGray !


TO DO:
      - Documentation to FARGRAY.92P
      - Make the AutoCompile-function :)
      - Make a lot of templates :)


This program has been released as CAREWARE, this means that if you're
using this program, you should email the author and let him know.
If you have any ideas to improve the program, you are also welcome
to send email to jkkn@ctav.com!

If you're having any trouble using this program, please let me know!



Enjoy!

Kristian K. Nielsen,
Aarhus, Denmark
<jkkn@ctav.com>
