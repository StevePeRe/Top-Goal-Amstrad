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
.include "man/entity.h.s"
; .include "render.h.s"
.include "globals.h.s"
.include "physics.h.s"

.globl player1_jump
.globl player2_jump

; ETIQUETAS
player1_jump: .db #-1
player2_jump: .db #-1
ball_jump: .db #-1
bool_direc_ball: .db #00
ball_collision: .db #0; 0 con el pie, 1 con la cabeza
; on_the_floor: .db #00; 0 si, 1 no

jump_table:
    .db #-13, #-10, #-8, #-6 ;; 53
    .db #-5, #-4, #-3, #-2
    .db #-1, #00, #00, #01
    .db #02, #04, #05, #07
    .db #09, #11, #13, #0x80
    ;; para saber cuando parar
     
jump_table_Ball_foot:
    .db #-15, #-12, #-10, #-8 ;; 59
    .db #-6, #-4, #-2, #-1
    .db #-1, #00, #00, #01 
    .db #02, #04, #07, #11
    .db #15, #19, #0x80

; ; jump_table_Ball_head:
;     .db #-8, #-6, #-4, #-2 ;; 17
;     .db #-1, #-1, #00, #00
;     .db #00, #02, #02, #04 
;     .db #06, #08, #0x80
jump_table_Ball_head:
    .db #-8, #-6, #-4, #-2 ;; 17
    .db #-1, #-1, #00, #00
    .db #00, #02, #02, #04 
    .db #06, #08, #0x80

;; ==============================================================
;                           FUNCIONES
;; ==============================================================
sys_physics_init:


    ret

;;===================================
;;          CONTROL SALTO
;;===================================

; ; 
; ; INPUT 'a' para saber que jugador salta
; idea de optimizacion para el salto
; sys_physics_start_jump:
;     ld  a, a
;     cp  #-1
;     jr  z, start_jump_P1 

;     ;; Si el salto esta inactivo, lo activo
;         ld  a, #0
;         ld  (player1_jump), a  ;; player1_jump = 0 (activado)

;    start_jump_P1:
;         ;; Si el salto esta inactivo, lo activo
;         ld  a, #0
;         ld  (player1_jump), a  ;; player1_jump = 0 (activado)
;     ret

sys_physics_start_jump_P1:
    ld  a, (player1_jump)
    cp  #-1
    ret  nz

    ;; Si el salto esta inactivo, lo activo
    ld  a, #0
    ld  (player1_jump), a  ;; player1_jump = 0 (activado)

    ret

sys_physics_jump_control_P1:
    ld  a, (player1_jump) ;; A = player1_jump valor
    cp  #-1               ;; A == -1?
    ret  z

    ; sigo con el salto
    ld  hl, #jump_table  ;; HL apunta al inicio del array de salto
    ld  c, a
    ld  b, #0           ;; BC = A
    add  hl, bc          ;; HL +=BC

    ;; comprobar final salto
    ld  a, (hl)
    cp  #0x80
    jr  z, final_salto_P1

    ;; hacer mov salto
    ld  b, a
    ld  a, e_y(ix)
    add  b
    ld  e_y(ix), a

    ; incrementar indice salto
    ld  a, (player1_jump)
    inc  a
    ld  (player1_jump), a

    ret

    ; Poner -1 en el indice para indicar que el salto ha acabado
    final_salto_P1:
        ld  a, #-1              ;|
        ld  (player1_jump), a   ;| player1_jump = -1
    ret

;;===================================
;;          AWSD KEYS
;;===================================
sys_physics_update_AWSD:

    call sys_physics_Move_Up_W
    call sys_physics_jump_control_P1
    call sys_physics_Move_Right_D
    call sys_physics_Move_Left_A

  ret

sys_physics_Move_Up_W:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_W      ;; HL = Key_W keycode
    call  cpct_isKeyPressed_asm  ;; check if key_W is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, w_not_pressed

        ;; w_pressed
        call sys_physics_start_jump_P1
        
    w_not_pressed: ;; si no pulsa la 'W' pasa directamente aqui sin sumar su pos

    ret

sys_physics_Move_Right_D:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_D      ;; HL = Key_D keycode
    call  cpct_isKeyPressed_asm  ;; check if key_d is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, d_not_pressed

        ;; d_pressed
            ;; Primero comprobamos de que tipo de colision de trata
            ld a, e_collision(ix)
            cp #e_collision_type_noCollision
            jp  z, continuar_d
            
            ld a, e_collision_dir(ix)
            cp #e_left
            jp z, not_move_D          

            continuar_d:
                ld a, e_colision(ix)
                ld  a, e_x(ix) ;; guardo en a la pos de x
                add e_vx(ix)   ;; sumo a 'a' la velocidad de x  ->  add  a, e_vx(ix)
                cp  #70-10      
                jr  z, not_move_D ;; no sumo a la pos de x

                ld  e_x(ix), a  ;; asigno la nueva pos a la entiedad en x

    not_move_D:
    d_not_pressed: ;; si no pulsa la 'D' pasa directamente aqui sin sumar su pos

    ;; Reseteamos el movimiento a idle ya que en esta parte el jugador esta parado
    ; ld a, #e_idle
    ; ld e_collision_dir(ix), a

    ret

sys_physics_Move_Left_A:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_A       ;; HL = Key_A keycode
    call  cpct_isKeyPressed_asm  ;; check if Key_A is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, a_not_pressed

        ;; d_pressed
            ; Comprobamos la direccion desde se colisiona
             ;; Primero comprobamos de que tipo de colision de trata
            ld a, e_collision(ix)
            cp #e_collision_type_noCollision
            jp z, continuar_a
            
            ld a, e_collision_dir(ix)
            cp #e_rigth
            jp z, not_move_A          

            continuar_a:
                ld  a, e_x(ix) ;; guardo en a la pos de x
                sub e_vx(ix)   ;; resto a 'a' la velocidad de x
                cp  #10      
                jp  m, not_move_A ;; no sumo a la pos de x

                ld  e_x(ix), a  ;; asigno la nueva pos a la entiedad en x

    not_move_A:
    a_not_pressed: ;; si no pulsa la 'A' pasa directamente aqui sin sumar su pos

    ;; Reseteamos el movimiento a idle ya que en esta parte el jugador esta parado
    ; ld a, #e_idle
    ; ld e_collision_dir(ix), a

    ret

;;===================================
;;          ARROW KEYS
;;===================================
sys_physics_update_ArrowK:

    call sys_physics_Move_Up_I
    call sys_physics_jump_control_P2
    call sys_physics_Move_Right_L
    call sys_physics_Move_Left_J

    ret

sys_physics_Move_Up_I:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_I       ;; HL = Key_I keycode
    call  cpct_isKeyPressed_asm  ;; check if Key_I is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, i_not_pressed

        ;; d_pressed
        call sys_physics_start_jump_P2

    i_not_pressed: ;; si no pulsa la flecha derecha del teclado numerico pasa directamente aqui sin sumar su pos

    ret

sys_physics_Move_Right_L:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_L       ;; HL = Key_L keycode
    call  cpct_isKeyPressed_asm  ;; check if Key_L is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, l_not_pressed

        ;; d_pressed
            ld a, e_collision(ix)
            cp #e_collision_type_noCollision
            jp  z, continuar_l
            
            ld a, e_collision_dir(ix)
            cp #e_left
            jp z, not_move_l          

            continuar_l:
                ld  a, e_x(ix) ;; guardo en a la pos de x
                add e_vx(ix)   ;; sumo a 'a' la velocidad de x  ->  add  a, e_vx(ix)
                cp  #70-10      
                jr  z, not_move_l ;; no sumo a la pos de x

                ld  e_x(ix), a  ;; asigno la nueva pos a la entiedad en x

    not_move_l:
    l_not_pressed: ;; si no pulsa la flecha derecha del teclado numerico pasa directamente aqui sin sumar su pos

    ret

sys_physics_Move_Left_J:
    call cpct_scanKeyboard_asm

    ld  hl, #Key_J       ;; HL = Key_J keycode
    call  cpct_isKeyPressed_asm  ;; check if Key_J is pressed, 1
    cp  #0                        ;; comparo si la salida da 0, A == 0
    jr  z, j_not_pressed

        ;; d_pressed
            ld a, e_collision(ix)
            cp #e_collision_type_noCollision
            jp z, continuar_j
            
            ld a, e_collision_dir(ix)
            cp #e_rigth
            jp z, not_move_j          

            continuar_j:
                ld  a, e_x(ix) ;; guardo en a la pos de x
                sub e_vx(ix)   ;; resto a 'a' la velocidad de x
                cp  #10      ;; 
                jr  z, not_move_j ;; no sumo a la pos de x

                ld  e_x(ix), a  ;; asigno la nueva pos a la entiedad en x

    not_move_j:
    j_not_pressed: ;; si no pulsa la flecha izquierda pasa directamente aqui sin sumar su pos

    ret

sys_physics_start_jump_P2:
    ld  a, (player2_jump)
    cp  #-1
    ret  nz

    ;; Si el salto esta inactivo, lo activo
    ld  a, #0
    ld  (player2_jump), a  ;; player2_jump = 0 (activado)

    ret

sys_physics_jump_control_P2:
    ld  a, (player2_jump) ;; A = player2_jump valor
    cp  #-1               ;; A == -1?
    ret  z

    ; sigo con el salto
    ld  hl, #jump_table  ;; HL apunta al inicio del array de salto
    ld  c, a
    ld  b, #0           ;; BC = A
    add  hl, bc          ;; HL +=BC

    ;; comprobar final salto
    ld  a, (hl)
    cp  #0x80
    jr  z, final_salto_P2

    ;; hacer mov salto
    ld  b, a
    ld  a, e_y(ix)
    add  b
    ld  e_y(ix), a

    ; incrementar indice salto
    ld  a, (player2_jump)
    inc  a
    ld  (player2_jump), a

    ret

    ; Poner -1 en el indice para indicar que el salto ha acabado
    final_salto_P2:
        ld  a, #-1              ;|
        ld  (player2_jump), a   ;| player2_jump = -1
    ret

; ===================================================
;                       BALL
; ===================================================
; ix siempre es el balon
sys_physics_start_jump_Ball::
    ld  a, (ball_jump)
    cp  #-1
    ret  nz

    ;; Si el salto esta inactivo, lo activo
    ld  a, #0
    ld  (ball_jump), a  ;; ball_jump = 0 (activado)

    ld  a, #1
    ld  e_vy(ix),a 

    ret

sys_physics_jump_control_Ball::
    ld  a, (ball_jump) ;; A = ball_jump valor
    cp  #-1               ;; A == -1?
    
    ret  z
    ; ld a, #0
    ; ld (ball_jump), a
        ; sigo con el salto - le va sumando 1 que es a
        ; ld  hl, #jump_table_Ball_foot  ;; HL apunta al inicio del array de salto
        ; ld a, #1
        
        ld  b, #0           ;; BC = A
        ld  c, a
        ; cp #0
        ; jr z, buuc 
        add  hl, bc          ;; HL +=BC
        ; buuc:

        ;; comprobar final salto
        ld  a, (hl)
        cp #0x80 ; B6 SUELO
        jr  z, final_salto_Ball

        ;; hacer mov y del salto
        ld  b, a
        ld  a, e_y(ix)
        add  b
        ld d, a
        sub #0x6A
        jp c, roof_limit
        ld  e_y(ix), d
        jr ssss
        roof_limit:
        jr final_salto_Ball

        ssss:
        ;; hacer mov x del salto
        ;  0 = derecha , 1 = izquierda
        ld  b, #1
        ld  a, (bool_direc_ball)
        cp  #0
        jr  z, move_D
            ld  a, e_x(ix)
            sub b
            cp  #0+8
            jr  z, seguir_abajo
            jr seguir
        move_D:
            ld  a, e_x(ix)
            add  b
            cp  #80-10
            jr  z, seguir_abajo
        seguir:
        ld  e_x(ix), a
    seguir_abajo:
    ; final_salto_Ball_x:
    ; incrementar indice salto

    ld  a, (ball_jump)
    inc  a
    ld  (ball_jump), a

    ret

        ; Poner -1 en el indice para indicar que el salto ha acabado
    final_salto_Ball:
        
        ld  a, #-1              ;|
        ld  (ball_jump), a   ;| ball_jump = -1
        ; dejo de saltar vy -> 0
        ld  a, #0
        ld  e_vy(ix), a 

    ret
    
sys_physics_to_the_floor::

    ;; seguir cayendo cuando esta en el aire
        
        ; sumar y
        ld a, #4
        ld  b, a
        ld  a, e_y(ix)
        add b
        cp #0xB6
        jr nc, floor_limit2
        ld  e_y(ix), a

        ; sumar x
        ld  b, #1
        ld a, e_collision_dir(ix)
        cp #e_left
        jr z, mov_ball_left_fall

            ld  a, e_x(ix)
            add  b
            cp  #80-10
            jr  z, floor_limit2
            jr seguir_fall

        mov_ball_left_fall:
            ld  a, e_x(ix)
            sub b
            cp  #0+8
            jr  z, floor_limit2
        seguir_fall:
        ld  e_x(ix), a 

    floor_limit2:

    ret

sys_physics_init_ball::

    ; ld a, e_collision(ix)
    ; cp #e_collision_type_noCollision
    ; jr nz, seguir_cod
    ; ret
    ; seguir_cod:

    call sys_physics_ball_movement

    ; elige tabla de pie o de cabeza
    ld a, (ball_collision)
    cp #0
    jr z, __foot

        ld  hl, #jump_table_Ball_head
        jr __head

    __foot:
    ld  hl, #jump_table_Ball_foot

    __head:

    call sys_physics_jump_control_Ball

    ; compruebo si ya no esta activo el mov de y
    ld a, e_vy(ix)
    cp #0
    jr nz, still_jumping
        call sys_physics_to_the_floor
    still_jumping:

    ret

sys_physics_ball_movement:

    ld a, e_collision(ix)
    cp #e_collision_type_balon_foot
    jr z, with_foot

    ld a, e_collision(ix)
    cp #e_collision_type_balon_head
    jr z, with_head

    ret

    with_foot:
    ld a, #0
    ld (ball_collision), a
    jr seguirFoot

    with_head:
    ld a, #1  
    ld (ball_collision), a  

    seguirFoot:

; reinicio el tipo de colision
    ld  a, #e_collision_type_noCollision
    ld e_collision(ix), a
    ld e_collision(iy), a

    ld a, e_collision_dir(ix)
    cp #e_left
    jr z, mov_ball_left

    mov_ball_rigth:
    ;   TODO hacer que se mueva de forma parabolica hacia la derecha
        ; aqui dentro pasarle si es con la cabeza
        ld  a, #0
        ld  (bool_direc_ball), a
        call sys_physics_start_jump_Ball

        ; ld a, (ball_collision)
        ; cp #0
        ; jr z, no__headR
            ld  a, #0              ;|
            ld  (ball_jump), a   ;| ball_jump = -1
        ; no__headR:

        ret

    mov_ball_left:
    ;   TODO hacer que se mueva de forma parabolica hacia la izquierda
        ld  a, #1
        ld  (bool_direc_ball), a
        call sys_physics_start_jump_Ball
        ; ld a, (ball_collision)
        ; cp #0
        ; jr z, no__headL
            ld  a, #0              ;|
            ld  (ball_jump), a   ;| ball_jump = -1
        ; no__headL:

    exit:
ret

; ===================================================
;                       GOAL
; ===================================================

sys_physics_init_goal:


ret