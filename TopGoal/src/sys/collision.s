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
.include "collision.h.s"
.include "globals.h.s"

sys_collision_update::    

    ;; Colisiones balon con porteria Derecha
    call man_entity_getEntityArray_HL 
    call man_entity_getEntitySize_BC

    add  hl, bc
    add  hl, bc

    ld__ix_hl

    add  hl, bc

    ld__iy_hl

    call sys_collision_check
    jr c, no_hay_collision_porteriaD

    call check_entity_collision

    ret

    ;; Colisiones balon con jugador 2
    no_hay_collision_porteriaD:

    ;; Colisiones balon con porteria iz
    call man_entity_getEntityArray_HL 
    call man_entity_getEntitySize_BC

    add  hl, bc
    add  hl, bc

    ld__ix_hl

    add  hl, bc
    add  hl, bc

    ld__iy_hl

    call sys_collision_check
    jr c, no_hay_collision_porteriaI

    call check_entity_collision

    ret

    ;; Colisiones balon con jugador 2
    no_hay_collision_porteriaI:

    ;; Colisiones balon con jugador 1
    call man_entity_getEntityArray_HL 
    call man_entity_getEntitySize_BC

    ld__iy_hl

    add  hl, bc
    add  hl, bc

    ld__ix_hl

    call sys_collision_check
    jr c, no_hay_collision_p1

    call check_entity_collision

    ret

    ;; Colisiones balon con jugador 2
    no_hay_collision_p1:

    call man_entity_getEntityArray_HL 
    call man_entity_getEntitySize_BC

    add  hl, bc

    ld__iy_hl
    
    add  hl, bc

    ld__ix_hl

    call sys_collision_check
    jr c, no_hay_collision_p2

    call check_entity_collision

    ret

    ;; Colision jugador 1 con jugador 2
    no_hay_collision_p2:

    call man_entity_getEntityArray_HL 
    call man_entity_getEntitySize_BC

    ld__ix_hl
    
    add  hl, bc

    ld__iy_hl

    call sys_collision_check
    jr c, no_hay_collision_p3

    call check_entity_collision

    ret

    no_hay_collision_p3:



ret

sys_collision_check::
    ld a, e_x(ix)
    add e_w(ix)
    sub e_x(iy)
    jr c, no_collision

    ld a, e_x(iy)
    add e_w(iy)
    sub e_x(ix)
    jr c, no_collision    

    ld a, e_y(ix)
    add e_h(ix)
    sub e_y(iy)
    jr c, no_collision

    ld a, e_y(iy)
    add e_h(iy)
    sub e_y(ix)
    jr c, no_collision

    ret

    no_collision:
        ld a, #e_collision_type_noCollision
        ld e_collision(ix), a
        ld a, #e_collision_type_noCollision
        ld e_collision(iy), a
ret


check_entity_collision::
; ix balon    iy jugador

    ; ld a, e_x(iy)
    ; add #0x07
    ; sub e_x(ix)
    ; jp m, change_collision_direction_R ; si es m, el primero es menor que el segundo

    ; ; ld a, e_x(iy)
    ; ; add #0x03
    ; ; sub e_x(ix)
    ; ; jp nz, change_collision_direction_L

    ; change_collision_direction_L:
    ;     ld a, #e_left
    ;     ld e_collision_dir(ix), a
    ;     ld a, #e_rigth
    ;     ld e_collision_dir(iy), a
    ; jr seguir_direcL
    ; change_collision_direction_R:
    ;     ld a, #e_rigth
    ;     ld e_collision_dir(ix), a
    ;     ld a, #e_left
    ;     ld e_collision_dir(iy), a
    ; seguir_direcL:

    ld a, e_x(ix)
    sub e_x(iy)
    jp c, change_collision_direction

    ld a, #e_rigth
    ld e_collision_dir(ix), a
    ld a, #e_left
    ld e_collision_dir(iy), a
    jr continue

    change_collision_direction:
        ld a, #e_left
        ld e_collision_dir(ix), a
        ld a, #e_rigth
        ld e_collision_dir(iy), a

    continue: 
        ld a, e_var(ix)
        and #e_type_player1
        jr  nz, change_collision_ix_player

        ld a, e_var(ix)
        and #e_type_player2
        jr  nz, change_collision_ix_player

        ld a, e_var(ix)
        and #e_type_ball
        jr  nz, change_collision_ix_ball

        ld a, e_var(ix)
        and #e_type_goalD
        jr nz, change_collision_ix_goal

        ld a, e_var(ix)
        and #e_type_goalI
        jr nz, change_collision_ix_goal

    change_collision_ix_player:        
        ld a, e_var(iy)
        and #e_type_player2
        jp  nz, collision_players       

        ld a, e_var(iy)
        and #e_type_player1
        jr  nz, collision_players

        ld a, e_var(iy)
        and #e_type_ball
        jp  nz, collision_player_ball

        ld a, e_var(iy)
        and #e_type_goalD
        jp nz, collision_player_goal

        ld a, e_var(iy)
        and #e_type_goalI
        jp nz, collision_player_goal

    ret
    change_collision_ix_ball:
        ld a, e_var(iy)
        and #e_type_player1
        jr  nz, collision_player_ball

        ld a, e_var(iy)
        and #e_type_player2
        jr  nz, collision_player_ball

        ld a, e_var(iy)
        and #e_type_goalD
        jp nz, collision_ball_goal

        ld a, e_var(iy)
        and #e_type_goalI
        jp nz, collision_ball_goal  
    ret
    change_collision_ix_goal:
        ld a, e_var(iy)
        and #e_type_player1
        jr  nz, collision_player_goal

        ld a, e_var(iy)
        and #e_type_player2
        jr  nz, collision_player_goal

        ld a, e_var(iy)
        and #e_type_ball
        jr  nz, collision_ball_goal
    ret
    collision_players:
        ld a, #e_collision_type_jugador
        ld e_collision(ix), a
        ld e_collision(iy), a
    
    ret    
    collision_player_ball:
    ; ix balon
    ; iy jugador
    
    ld  a, e_y(iy); 
    add #0x03
    sub e_y(ix)
    jr c, __foot;si hay carry no hay colision como en collision check

    ; ld a, #e_collision_type_balon_foot
    ld a, #e_collision_type_balon_head
    jr continuarHead

    __foot:
    ; ld a, #e_collision_type_balon_head
    ld a, #e_collision_type_balon_foot
    continuarHead:

        ld e_collision(ix), a
        ld e_collision(iy), a
    ; HASTA AQUI EL CODIGO ESTA DEBUG Y LO HACE BIEN

    ret
    collision_player_goal:
        ld a, #e_collision_type_porteria
        ld e_collision(ix), a
        ld e_collision(iy), a

    ret
    collision_ball_goal:
        ld a, e_var(iy)
        and #e_type_goalI
        jp nz, collision_goal_side_I

        collision_goal_side_D:
            ld a, #e_rigth
            ld e_collision_dir(ix), a
            ld e_collision_dir(iy), a
            ld a, #e_collision_type_gol
            ld e_collision(ix), a
            ld e_collision(iy), a            
        ret

        collision_goal_side_I:
            ld a, #e_left
            ld e_collision_dir(ix), a
            ld e_collision_dir(iy), a
            ld a, #e_collision_type_gol
            ld e_collision(ix), a
            ld e_collision(iy), a
    ret
