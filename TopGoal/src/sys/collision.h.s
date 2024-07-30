;;-----------------------------LICENSE NOTICE------------------------------------
;;  This file is part of 1to1 Soccer: An Amstrad CPC Game
;;  Copyright (C) 2023 Spaghetti Carbonara (@Spaghetti)
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


.globl sys_collision_update
.globl sys_collision_check
.globl check_entity_collision
.globl man_entity_getEntityArray_HL
.globl man_entity_getEntityArray_IX
.globl man_entity_getEntitySize_BC

e_x = 0
e_y = 1
e_vx = 2
e_vy = 3
e_w = 4
e_h = 5
e_col = 6
e_var = 9
e_collision = 11
e_collision_dir = 12

e_type_player1 = 0x01
e_type_player2 = 0x02
e_type_ball = 0x04
e_type_goalD = 0x08
e_type_goalI = 0x10

;; Tipos de colisiones
e_collision_type_noCollision = 0xFF
e_collision_type_jugador = 0x01
e_collision_type_balon_head = 0x02
e_collision_type_balon_foot = 0x05
e_collision_type_porteria = 0x03
e_collision_type_gol = 0x04
;; Direcciones de la colision
e_left = 0x02
e_rigth = 0x03
e_top = 0x04
e_bottom = 0x05
e_idle = 0xFF