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

.globl cpct_getScreenPtr_asm
.globl cpct_drawSolidBox_asm
.globl cpct_drawSprite_asm
.globl cpct_setDrawCharM0_asm 
.globl cpct_drawCharM0_asm 

.globl sys_render_init
.globl sys_render_update
.globl sys_render_erase
.globl sys_render_erase_OneEntity_Player
.globl sys_render_erase_OneEntity_Ball
;; MACROS

; ; CONSTANTES - direccion de memoria
; e_x = 0
; e_y = 1
; e_vx = 2
; e_vy = 3
; e_w = 4
; e_h = 5
; e_col = 6
; e_up_l = 7  ;; lo divido en dos ya que upd son dos bytes
; e_up_h = 8

;;tipos de entidades
e_type_invalid = 0x00
e_type_player1 = 0x01
e_type_player2 = 0x02
e_type_ball = 0x04
e_type_goalD = 0x08
e_type_goalI = 0x10
player1_gol_pos = #0xE85F
player2_gol_pos = #0xE88D