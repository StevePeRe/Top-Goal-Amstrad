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


.include "cpctelera.h.s"
.include "game.h.s"
.include "menu.h.s"

;; Inicializamos el menu con la imagen de fondo con las opciones
man_menu_init::

    ld   l, #0
    call cpct_setVideoMemoryOffset_asm  ;;cambiamos el offset de la memoria (donde empieza lo que se ve)

    ld  hl, #_fondo_menu_end
    ld  de, #0xFFFF 
    call cpct_zx7b_decrunch_s_asm
ret

man_menu_run::          

    call cpct_scanKeyboard_asm

    ld  hl, #Key_1
    call cpct_isKeyPressed_asm
    jr  nz, game_init

    ld  hl, #Key_2
    call cpct_isKeyPressed_asm
    jr  nz, open_controls

    ld  hl, #Key_3
    call cpct_isKeyPressed_asm
    jr  nz, exit

    ld  hl, #Key_4
    call cpct_isKeyPressed_asm
    jr  z, man_menu_run 

    game_init:
        ;; Guardamos la tecla que se ha pulsado en este caso 1
        ld a, #1
        ld (eleccion_menu), a
    ret
    
    open_controls:
        ;; Guardamos la tecla que se ha pulsado en este caso 2
        ld a, #2
        ld (eleccion_menu), a
    ret

    exit:
        ;; Guardamos la tecla que se ha pulsado en este caso 3
        ld a, #3
        ld (eleccion_menu), a
        ;; Salir del juego


ret
