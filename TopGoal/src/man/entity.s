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


.include "cpctelera.h.s"
.include "entity.h.s"
.include "sys/physics.h.s"
.include "globals.h.s"

; ETIQUETAS
;; array de entidades con sus valores cada una
num_entities: .db 0
entity_array:
    .ds max_entities*entity_size
last_elem_ptr: .dw entity_array

;; CREACION DEL JUGADOR
DefineEntity player1, 0x15, 0xAA, 0x01, 0x01, 0x0A, 0x18, 0xFF, sys_physics_update_AWSD, e_type_player1, e_type_input, e_collision_type_noCollision, e_idle 
       
DefineEntity player2, 0x35, 0xAA, 0x01, 0x01, 0x0A, 0x18, 0xFF, sys_physics_update_ArrowK, e_type_player2, e_type_input, e_collision_type_noCollision, e_idle

;; CREACION DEL BALON
; el sys_physics_update_ArrowK sera ua funcion que llame el physics para el movimiento del balon
DefineEntity players_ball, 0x23, 0xB6, 0x00, 0x00, 0x04, 0x0D, 0xFF, sys_physics_init_ball, e_type_ball, e_type_movable, e_collision_type_noCollision, e_idle

;; CREACION DE LAS PORTERIAS
DefineEntity players_goalD, 0x46, 0x88, 0x01, 0x01, 0x0A, 0x40, 0xFF, sys_physics_init_goal, e_type_goalD, e_type_render, e_collision_type_noCollision, e_idle
DefineEntity players_goalI, 0x00, 0x88, 0x01, 0x01, 0x0A, 0x40, 0xFF, sys_physics_init_goal, e_type_goalI, e_type_render, e_collision_type_noCollision, e_idle
;; ====================================
;               FUNCIONES
;; ====================================
;; INPUT
;;  HL: puntero al byte inicializador de la entidad
man_entity_create:

    ; ld  hl, #entity_array ;; no pongo hl porque me lo pasan
    ld  de, (last_elem_ptr) ;; accedes a la pos de momeria
    ld  bc, #entity_size ;; valor inmediato
    ldir

    ; aumento el numero de entidades
    ld  a, (num_entities)
    inc  a
    ld  (num_entities), a

    ld  hl, (last_elem_ptr)
    ld  bc, #entity_size
    add  hl, bc ;; le sumo bc a hl que es el tamnyo de la entidad
    ; inc hl ;; no puedo incrementar hl asi
    ld  (last_elem_ptr), hl ;; para escribir lo que hay en hl simplemente asi

    ret

;; duda -> hay algun problema si llamo a una funcion de otra clase en esta de entidad?, no es por eso ya lo probe
;; era porque no habia aumentado el tamanyo de la entidad
;;  RECURSION DE COLA
man_entity_update:
    
    buc:
        ex af, af'
        call man_entity_funcion_call
        ex af, af'

        dec  a
        ret  z

        call man_entity_getEntitySize_BC
        add  ix, bc

    jr  nz, buc
                      
    ret

man_entity_funcion_call:
; llama a la funcion de la primera pos del array
    ld  h, e_up_h(ix)
        ld  l, e_up_l(ix)
        ld  bc, #aqui     ;; no tengo que simular el call ya que a la funcion que llamo ya se encarga de ir a donde tenga que ir
        ; push  bc
        jp  (hl)            ;; simula el call a la funcion
        ; pop  bc

    aqui:    
 ret

man_entity_getEntityArray_IX:
    ;; le devuelve el entity_array sin alterar del principio
    ld  ix, #entity_array
    ret

man_entity_getEntityArray_HL:
    ld hl, #entity_array
    ret

man_entity_getNumEntities_A:
    ld  a, (num_entities) ;; al crear cada entidad se le suma 1
    ret

man_entity_getEntitySize_BC:
    ld  bc, #entity_size
    ret
man_entity_getBall:
    call man_entity_getEntityArray_IX
    call man_entity_getEntitySize_BC
    add ix, bc
    add ix, bc
    ret
