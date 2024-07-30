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


.include "game.h.s"
.include "entity.h.s"
.include "./../sys/render.h.s"
.include "./../sys/collision.h.s"

.globl player1_goles
.globl player2_goles

player1_goles::  .db 0
player2_goles::  .db 0

man_game_init::
    call sys_render_init

    ld  hl, #player1
    call man_entity_create  ;; primero le paso las entidades a crear para que las meta en el array

    ld  hl, #player2
    call man_entity_create 

    ld  hl, #players_ball
    call man_entity_create 

    ld  hl, #players_goalD
    call man_entity_create 

    ld  hl, #players_goalI
    call man_entity_create 

ret

man_game_play::

    call man_entity_getEntityArray_IX ;; llamo a la funcion de arriba para no llamar direct a la variable
    call man_entity_getNumEntities_A ;; hay que llevar cuidado de donde se pone la 'a' ya que puede modificar lo de otras funciones
    call sys_render_erase
    call man_entity_getEntityArray_IX ;; llamo a la funcion de arriba para no llamar direct a la variable
    call man_entity_getNumEntities_A ;; hay que llevar cuidado de donde se pone la 'a' ya que puede modificar lo de otras funciones
    call man_entity_update            ;; llama al mov de las entidades
    ;;call man_entity_getEntityArray_IX
    call sys_collision_update
    call man_entity_getEntityArray_IX ;; llamo a la funcion de arriba para no llamar direct a la variable
    call man_entity_getNumEntities_A ;; hay que llevar cuidado de donde se pone la 'a' ya que puede modificar lo de otras funciones
    call sys_render_update

    call man_game_check
    
    ; jr nz, man_game_init
    

ret

man_game_check::
    ;; Cargamos en ix el balon para comprobar que su colision es igual a GOL
    call man_entity_getBall
    ld a, e_collision(ix)
    cp #e_collision_type_gol
    jr z, check_score_side

    ret

    ;; Comprobamos en que porteria ha sido el gol
    check_score_side:
        ld a, e_collision_dir(ix)
        sub #e_left
        jr z, player2_scorer
        ld a, e_collision_dir(ix)
        sub #e_rigth
        jr z, player1_scorer

    ret

    ;; Sumamos los goles del jugador 2 y lo pintamos
    player2_scorer:
        ld a, (player2_goles)
        inc a
        ld (player2_goles), a
        call man_draw_gol2

    jr continue2

    ;; Sumamos los goles del jugador 1 y lo pintamos
    player1_scorer:
        ld a, (player1_goles)
        inc a
        ld (player1_goles), a
        call man_draw_gol1

    continue2:

    ;; Antes de resetear se debe mostrar animacion gol y ver si ya se ha acabado el partido
    ;; si player 1 tiene tres goles ponemos la variables winner a 1
    ld a, (player1_goles)
    sub #3
    jr z, change_winner1
    ld a, (player2_goles)
    sub #3
    jr z, change_winner2

    jr no_winner

    change_winner1:
        ld a, #1
        ld (winner), a
        jr reset

    change_winner2:
        ld a, #2
        ld (winner), a

    reset:
        ld a, #0
        ld (player1_goles), a
        ld (player2_goles), a
        call man_reset_gol
    ret

    no_winner:

    ;; Llamamos el reset si ha sido gol para resetar la posicion de los jugadores y balon
    ; borrar sprite jugadores y balon
    ; call man_entity_getEntityArray_IX
    ; call man_entity_getEntitySize_BC
    ; call sys_render_erase
    
    call man_reset_gol
    ; call game_play
ret

man_draw_gol1:

    ld l, #15                       
    ld h, #0                        
    call cpct_setDrawCharM0_asm     

    ld hl, #player1_gol_pos ;; Posicion en memoria de video del segundo marcador (derecha)
 
    ld a, (player1_goles)                 
    and #0x0F                       
    add #48                         
    ld e, a                         
    call cpct_drawCharM0_asm
ret

man_draw_gol2:

    ld l, #15                       
    ld h, #0                        
    call cpct_setDrawCharM0_asm     

    ld hl, #player2_gol_pos ;; Posicion en memoria de video del segundo marcador (derecha)
 
    ld a, (player2_goles)                      
    and #0x0F                       
    add #48                         
    ld e, a                         
    call cpct_drawCharM0_asm
ret

man_reset_gol:

    ;; Reseteamos las posiciones de los jugadores y del balon
    call man_entity_getEntityArray_IX

    ;; Reseteamos la posicion del player1
    call sys_render_erase_OneEntity_Player
    ld a, #0x12
    ld e_x(ix), a

    call man_entity_getEntitySize_BC
    add ix, bc 

    ;; Reseteamos la posicion del player2
    call sys_render_erase_OneEntity_Player
    ld a, #0x35
    ld e_x(ix), a

    call man_entity_getEntitySize_BC
    add ix, bc

    ;; Reseteamos la posicion del balon
    call sys_render_erase_OneEntity_Ball
    ld a, #0x25
    ld e_x(ix), a

ret