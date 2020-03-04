
;************************************************************************
;*  Display								*
;*----------------------------------------------------------------------*
;*  Displays a ugp picture / animation (animation: for one cycle)       *
;*  Parameter:                                                          *
;*  NOTE: if you want to use it for sprites, you shouldn't use slow     *
;*        interleaved and/or compressed pictures.                       *
;*  Input:                                                              *
;*    d0.w = x-position                                                 *
;*    d1.w = y-position                                                 *
;*    d2.w = Delay per Picture (for animations only) in 1/350 seconds	*
;*    a0.l = pointer to ugp-image (mustn't be odd address)              *
;*    a1.l = pointer to most-significant screen plane (e.g. LCD_MEM)    *
;*    a2.l = pointer to plane with the next significance (2 greyplanes) *
;*    a3.l = pointer to least-significant plane (3 greyplanes)          *
;*  Output:                                                             *
;*    d3.b = 0: Ok d3.b != 0: Error                                     *
;*  All other registers are kept.                                       *
;************************************************************************
ugplib::Display		EQU	ugplib@0000

;************************************************************************
;*  AutoDisp								*
;*----------------------------------------------------------------------*
;*  Switches to the right gray-mode, clears the screen, and displays the*
;*  UGP-picture/animation centered. Afterwards it waits for keypress.   *
;*  Animations are played forward, and repeated permanent. If a key is  *
;*  pressed, AutoDisp disables grayscale, and returns.                  *
;*  NOTE:                                                               *
;*    * When an animation is played, a keypress is only checked after   *
;*      each cycle. So: don't panik, if it doesn't return immediately.  *
;*    * When you call ugplib::AutoDisp, grayscale have to be disabled,  *
;*      else your program will die a horrible death.                    *
;*  Input:                                                              *
;*    a0 = pointer to UGP-pic(/ani) (mustn't be odd address)		*
;*    d2.w = (animations only) delaytime per picture in 1/350 seconds   *
;*  Return:                                                             *
;*    d0.b = 0: OK d0.b != 0: Error                                     *
;*  All other registers are kept.                                       *
;************************************************************************
ugplib::AutoDisp	EQU	ugplib@0001

