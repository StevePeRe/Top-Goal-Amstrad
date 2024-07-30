##-----------------------------LICENSE NOTICE------------------------------------
##  This file is part of CPCtelera: An Amstrad CPC Game Engine 
##  Copyright (C) 2018 ronaldo / Fremos / Cheesetea / ByteRealms (@FranGallegoBR)
##
##  This program is free software: you can redistribute it and/or modify
##  it under the terms of the GNU Lesser General Public License as published by
##  the Free Software Foundation, either version 3 of the License, or
##  (at your option) any later version.
##
##  This program is distributed in the hope that it will be useful,
##  but WITHOUT ANY WARRANTY; without even the implied warranty of
##  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##  GNU Lesser General Public License for more details.
##
##  You should have received a copy of the GNU Lesser General Public License
##  along with this program.  If not, see <http://www.gnu.org/licenses/>.
##------------------------------------------------------------------------------
############################################################################
##                        CPCTELERA ENGINE                                ##
##                 Automatic image conversion file                        ##
##------------------------------------------------------------------------##
## This file is intended for users to automate image conversion from JPG, ##
## PNG, GIF, etc. into C-arrays.                                          ##
############################################################################

##
## NEW MACROS
##

## 16 colours palette
#PALETTE=0 1 2 3 6 9 11 12 13 15 16 18 20 24 25 26

## Default values
#$(eval $(call IMG2SP, SET_MODE        , 0                  ))  { 0, 1, 2 }
#$(eval $(call IMG2SP, SET_MASK        , none               ))  { interlaced, none }
#$(eval $(call IMG2SP, SET_FOLDER      , src/               ))
#$(eval $(call IMG2SP, SET_EXTRAPAR    ,                    ))
#$(eval $(call IMG2SP, SET_IMG_FORMAT  , sprites            ))	{ sprites, zgtiles, screen }
#$(eval $(call IMG2SP, SET_OUTPUT      , c                  ))  { bin, c }
#$(eval $(call IMG2SP, SET_PALETTE_FW  , $(PALETTE)         ))
#$(eval $(call IMG2SP, CONVERT_PALETTE , $(PALETTE), g_palette ))
#$(eval $(call IMG2SP, CONVERT         , img.png , w, h, array, palette, tileset))

##
## OLD MACROS (For compatibility)
##

## Example firmware palette definition as variable in cpct_img2tileset format

## 16 colours palette
PALETTE=0 1 4 5 6 7 9 11 13 14 16 20 21 24 17 26

## Default values
$(eval $(call IMG2SP, SET_MODE        , 0                  ))  #{ 0, 1, 2 }
#$(eval $(call IMG2SP, SET_MASK        , interlaced         ))  #{ interlaced, none }
$(eval $(call IMG2SP, SET_FOLDER      , src/sprites        ))
$(eval $(call IMG2SP, SET_EXTRAPAR    ,                    ))
$(eval $(call IMG2SP, SET_IMG_FORMAT  , sprites            ))	#{ sprites, zgtiles, screen }
$(eval $(call IMG2SP, SET_OUTPUT      , c                  ))  #{ bin, c }
$(eval $(call IMG2SP, SET_PALETTE_FW  , $(PALETTE)         ))
$(eval $(call IMG2SP, CONVERT_PALETTE , $(PALETTE), g_palette ))

# $(eval $(call IMG2SPRITES,img/player1.png,0,sprite,24,24,$(PALETTE),,src/sprites,hwpalette))
# $(eval $(call IMG2SPRITES,img/player2.png,0,sprite_player,24,24,$(PALETTE),,src/sprites,hwpalette))
$(eval $(call IMG2SP, CONVERT         , img/player1.png, 20, 24, sprite_player1, , ))
$(eval $(call IMG2SP, CONVERT         , img/player2.png, 20, 24, sprite_player2, , ))
$(eval $(call IMG2SP, CONVERT         , img/fondo.png, 20, 24, sprite_fondo, , ))
$(eval $(call IMG2SP, CONVERT         , img/fondo_pelota.png, 8, 13, sprite_fondo_pelota, , ))

# sprite pelota
$(eval $(call IMG2SP, CONVERT         , img/pelota.png, 8, 13, sprite_pelota, , ))
# sprite porterias
$(eval $(call IMG2SP, CONVERT         , img/porteriaD.png, 20, 80, sprite_porteriaD, , ))
$(eval $(call IMG2SP, CONVERT         , img/porteriaI.png, 20, 80, sprite_porteriaI, , ))
# $(eval $(call IMG2SP, CONVERT         , img/1.png, 56, 49, numero_uno, , ))
# $(eval $(call IMG2SP, CONVERT         , img/2.png, 56, 49, numero_dos, , ))
# $(eval $(call IMG2SP, CONVERT         , img/winners1.png, 56, 33, winners_uno, , ))
# $(eval $(call IMG2SP, CONVERT         , img/winners2.png, 56, 33, winners_dos, , ))
# Sprites para winner 1 y Winner 2
# $(eval $(call IMG2SP, CONVERT         , img/player1_win.png , 62, 62, player1_win, , ))
# $(eval $(call IMG2SP, CONVERT         , img/player2_win.png , 130, 62, player2_win, , ))

#parte de las imgs de fondo
# $(eval $(call IMG2SP, SET_FOLDER      , src/sprites/menus/ ))
$(eval $(call IMG2SP, SET_IMG_FORMAT  , screen             ))
$(eval $(call IMG2SP, SET_OUTPUT      , bin                ))

$(eval $(call IMG2SP, CONVERT         , img/menu.png , 0, 0, fondo_menu, , ))
$(eval $(call IMG2SP, CONVERT         , img/controles.png , 0, 0, fondo_controles, , ))
# $(eval $(call IMG2SP, CONVERT         , img/win1.png , 0, 0, fondo_winner1, , ))
$(eval $(call IMG2SP, CONVERT         , img/estadio.png , 0, 0, fondo_estadio, , ))
$(eval $(call IMG2SP, CONVERT         , img/player1_wins.png , 0, 0, player1_wins, , ))
$(eval $(call IMG2SP, CONVERT         , img/player2_wins.png , 0, 0, player2_wins, , ))

# $(eval $(call IMG2SP, CONVERT         , img/pelota.png, 24, 24, sprite_pelota, , ))
# $(eval $(call IMG2SP, CONVERT         , assets/player2_string.png, 68, 28, sprite_player_2, , ))

############################################################################
##              DETAILED INSTRUCTIONS AND PARAMETERS                      ##
##------------------------------------------------------------------------##
##                                                                        ##
## Macro used for conversion is IMG2SPRITES, which has up to 9 parameters:##
##  (1): Image file to be converted into C sprite (PNG, JPG, GIF, etc)    ##
##  (2): Graphics mode (0,1,2) for the generated C sprite                 ##
##  (3): Prefix to add to all C-identifiers generated                     ##
##  (4): Width in pixels of each sprite/tile/etc that will be generated   ##
##  (5): Height in pixels of each sprite/tile/etc that will be generated  ##
##  (6): Firmware palette used to convert the image file into C values    ##
##  (7): (mask / tileset / zgtiles)                                       ##
##     - "mask":    generate interlaced mask for all sprites converted    ##
##     - "tileset": generate a tileset array with pointers to all sprites ##
##     - "zgtiles": generate tiles/sprites in Zig-Zag pixel order and     ##
##                  Gray Code row order                                   ##
##  (8): Output subfolder for generated .C/.H files (in project folder)   ##
##  (9): (hwpalette)                                                      ##
##     - "hwpalette": output palette array with hardware colour values    ##
## (10): Aditional options (you can use this to pass aditional modifiers  ##
##       to cpct_img2tileset)                                             ##
##                                                                        ##
## Macro is used in this way (one line for each image to be converted):   ##
##  $(eval $(call IMG2SPRITES,(1),(2),(3),(4),(5),(6),(7),(8),(9), (10))) ##
##                                                                        ##
## Important:                                                             ##
##  * Do NOT separate macro parameters with spaces, blanks or other chars.##
##    ANY character you put into a macro parameter will be passed to the  ##
##    macro. Therefore ...,src/sprites,... will represent "src/sprites"   ##
##    folder, whereas ...,  src/sprites,... means "  src/sprites" folder. ##
##                                                                        ##
##  * You can omit parameters but leaving them empty. Therefore, if you   ##
##  wanted to specify an output folder but do not want your sprites to    ##
##  have mask and/or tileset, you may omit parameter (7) leaving it empty ##
##     $(eval $(call IMG2SPRITES,imgs/1.png,0,g,4,8,$(PAL),,src/))        ##
############################################################################
