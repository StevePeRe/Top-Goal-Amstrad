;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of 1to1 Soccer: An Amstrad CPC Game
;;  Copyright (C) 2023 Spaghetti Carbonara (@SpaghetiStudios)
;;
;;  This program is free software: you can redistribute it and/or modify
;;  it under the terms of the GNU Lesser General Public License as published by
;;  the Free Software Foundation, either version 3 of the License, or
;;  (at your option) any later version.
;;
;;  This program is distributed in the hope that it will be useful,
;;  but WITHOUT ANY WARRANTY; without even the implied warranty of
;;  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;  GNU Lesser General Public License for more details.
;;
;;  You should have received a copy of the GNU Lesser General Public License
;;  along with this program.  If not, see http://www.gnu.org/licenses/.
;;-------------------------------------------------------------------------------

.include "controls.h.s"
.include "cpctelera.h.s"
;; Inicializamos el menu con la imagen de fondo con los controles

.globl _fondo_controles_end
man_controls_init::

    ld   l, #0
    call cpct_setVideoMemoryOffset_asm  ;;cambiamos el offset de la memoria (donde empieza lo que se ve)

    ld  hl, #_fondo_controles_end
    ld  de, #0xFFFF 
    call cpct_zx7b_decrunch_s_asm
ret

man_controls_exit::
    ;; Seguiremos en esta pantalla mientras las teclas pulsadas no sean ESC o 3 para salir y volver al menu 
    call cpct_scanKeyboard_asm

    ld  hl, #Key_Esc
    call cpct_isKeyPressed_asm
    jr  nz, exit

    ld  hl, #Key_3
    call cpct_isKeyPressed_asm
    jr  nz, exit

    call  cpct_isAnyKeyPressed_f_asm
    jr z, man_controls_exit  

    exit: 
ret
