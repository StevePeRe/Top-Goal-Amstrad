	;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of TopGoal: An Amstrad CPC Game
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
.include "globals.h.s"
.include "man/entity.h.s"
.include "sys/render.h.s"
.include "sys/physics.h.s"
.include "sys/collision.h.s"
.include "man/game.h.s"
.include "man/menu.h.s"
.include "man/controls.h.s"
.globl _g_palette

.globl cpct_isAnyKeyPressed_f_asm
.globl _player1_wins_end
.globl _player2_wins_end

eleccion_menu: .db 0
winner: .db 0
reiniciar: .db 0

.area _DATA
.area _CODE

;;
;; MAIN function. This is the entry point of the application.
;;    _main:: global symbol is required for correctly compiling and linking
;;

_main::

   call cpct_disableFirmware_asm

   ld  c, #0
   call cpct_setVideoMode_asm
   ld  hl, #_g_palette   ;; siempre con _ las variables de C
   ld  de, #16                ;; tiene 16 colores la paleta de mi sprite
   call cpct_setPalette_asm

   cpctm_setBorder_asm FW_BLACK

   call man_menu_init

loop:
   
   ;; Cargamos el menu para que se guarde la opcion elegida
   call man_menu_run  
   
   ;; Comprobamos que opcion se ha elegido
   ld a, (eleccion_menu)
   sub #1
   jr z, game_play
   
   ;; Restamos si el resultado que queda en A es 0 entramos
   ld a, (eleccion_menu)
   sub #2
   jr z, game_controls

   ld a, (eleccion_menu)
   sub #3
   jr z, game_exit

   jr continue

   game_play::
      ;; Primero limpiamos la pantalla para luego iniciar el game
      call clear_screen
      ;; Esto es para que cuando se vuelva a jugar ya vaya cargado el juego y no que hacer todo otra vez
      ld a, (reiniciar)
      cp #0
      jr z, first

      ;; Solo volvemos a pintar el estadio
      call sys_render_init
      jr bucle_game

      ;; Si es la primera vez creamos todo desde cero
      first:
         call man_game_init
      ;; En un futuro cuando se añada la pantalla victoria se añadira una variables para parar el bucle
      bucle_game:
         call man_game_play
         call cpct_waitVSYNC_asm
         ld a, (winner)
         sub #1
         jr z, draw_winner1
         ld a, (winner)
         sub #2
         jr z, draw_winner2
      jr nz, bucle_game
   
   game_controls:
      ;; Primero limpiamos pantallo y luego iniciamos la pantalla de controles
      call clear_screen
      call man_controls_init
      ;; Se queda esperando hasta que se pulse el 3 o el ESC
      call man_controls_exit
      jr continue


   game_exit:
      ret    

   ;; Esto es por si algun caso llegue aqui y no haya ganador
   jr continue
   ;; Llamamos la funcion que pinta el ganador y esperamos a que le da cualquier tecla para volver al menu
   ;; Falta poner el reset de goles
   draw_winner1:
      call winner_player1
      jr continue
   draw_winner2: 
      call winner_player2

   continue:
      ;; Si llega aqui es ha vuelto al menu principal y lo volvemos a pintar
      call clear_screen 
      call man_menu_init

   call cpct_waitVSYNC_asm

   jr    loop

ret

wait_keyboard:
   call cpct_scanKeyboard_asm

   ; ld  hl, #Key_1
   ; call cpct_isKeyPressed_asm
   ; jr  z, wait_keyboard

   call  cpct_isAnyKeyPressed_f_asm
   jr z, wait_keyboard 
ret

winner_player1:
   ld   l, #0
   call cpct_setVideoMemoryOffset_asm  ;;cambiamos el offset de la memoria (donde empieza lo que se ve)

   ld  hl, #_player1_wins_end
   ld  de, #0xFFFF 
   call cpct_zx7b_decrunch_s_asm

   call reset_win

   call wait_keyboard
ret

winner_player2:
   ld   l, #0
   call cpct_setVideoMemoryOffset_asm  ;;cambiamos el offset de la memoria (donde empieza lo que se ve)

   ld  hl, #_player2_wins_end
   ld  de, #0xFFFF 
   call cpct_zx7b_decrunch_s_asm

   call reset_win

   call wait_keyboard
ret

reset_win:

   ld a, #0
   ld (winner), a
   ld a, #1
   ld (reiniciar), a

ret

clear_screen:

   ;; Limpiamos la pantalla
   cpctm_clearScreen_asm 0x00

ret


