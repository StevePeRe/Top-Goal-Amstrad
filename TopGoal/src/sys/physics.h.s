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

.globl cpct_scanKeyboard_asm
.globl cpct_isKeyPressed_asm

.globl sys_physics_init


.globl sys_physics_update_AWSD
.globl sys_physics_update_ArrowK

;; TECLADO
     ;; AWSD
.globl sys_physics_Move_Up_W
.globl sys_physics_Move_Right_D
.globl sys_physics_Move_Left_A

; ;      ;; FLECHAS / Teclado: I=Salto J=Izquierda L=Derecha
.globl sys_physics_Move_Up_I
.globl sys_physics_Move_Right_L
.globl sys_physics_Move_Left_J

;;        BALL
.globl sys_physics_init_ball
.globl sys_physics_ball_movement

;;        GOAL
.globl sys_physics_init_goal

;; MACROS

; CONSTANTES - direccion de memoria
e_x = 0
e_y = 1
e_vx = 2
e_vy = 3
e_w = 4
e_h = 5
e_col = 6
e_colision = 11
e_collision_dir = 12

e_left = 0x02
e_rigth = 0x03
e_top = 0x04
e_bottom = 0x05
e_idle = 0xFF

e_collision_type_noCollision = 0xFF
e_collision_type_jugador = 0x01
e_collision_type_balon_head = 0x02
e_collision_type_balon_foot = 0x05
e_collision_type_porteria = 0x03
e_collision_type_gol = 0x04
e_collision_type_floor = 0x06