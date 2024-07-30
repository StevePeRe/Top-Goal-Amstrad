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
.include "render.h.s"
.include "globals.h.s"
.include "src/sprites/fondo_estadio.h.s"

.globl cpct_setVideoMemoryOffset_asm
.globl cpct_zx7b_decrunch_s_asm

.globl _sprite_player1
.globl _sprite_player2
.globl _sprite_fondo
.globl _sprite_fondo_pelota
.globl _sprite_pelota
.globl _sprite_porteriaD
.globl _sprite_porteriaI


;; ====================================
;               FUNCIONES
;; ====================================
sys_render_init:
    
    ld   l, #0
    call cpct_setVideoMemoryOffset_asm  ;;cambiamos el offset de la memoria (donde empieza lo que se ve)

    ld  hl, #_fondo_estadio_end
    ld  de, #0xFFFF 
    call cpct_zx7b_decrunch_s_asm
    
    call sys_init_draw_number

    ret

;; INPUT
;;  IX: Puntero a la primera entidad para el render
;;  A:  numero de entidades para hacer el render
sys_render_update:
    ; call man_entity_getNumEntities_A
    buc: ;; desde aqui para meter otra vez 'a' en la pila ya que en cada ejecucion se cambia la 'a'
        push  af ;; guardo en la pila la 'a' que me pasan por parametro
    ;; Dibujar personaje
    
        ld  de, #0xC000
        ld  c, e_x(ix) ;; pos x
        ld  b, e_y(ix) ;; pos y
        call cpct_getScreenPtr_asm
; ==========================================
        ; ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
        ; ld  hl, #_sprite_pelota    ;; sprite de la pelota
        ; ld  bc, #0x0A03           ;;6x10 pixeles, en el alto se pone la mitad del tamanyo y se pone al reves
        ; call cpct_drawSprite_asm

; ==========================================

        ld a, e_var(ix)
        and #e_type_player1
        jp  nz, pintar_jug1

        ld a, e_var(ix)
        and #e_type_player2
        jp  nz, pintar_jug2

        ld a, e_var(ix)
        and #e_type_goalI
        jp  nz, pintar_goalI

        ld a, e_var(ix)
        and #e_type_goalD
        jp  nz, pintar_goalD

            ; ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
            ; ld  a, e_col(ix) ;; color
            ; ld  b, e_h(ix) ;; alto
            ; ld  c, e_w(ix) ;; ancho 
            ; call cpct_drawSolidBox_asm
            ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
            ld  hl, #_sprite_pelota    ;; sprite del jugador
            ld  b, e_h(ix) ;; alto
            ld  c, e_w(ix) ;; ancho 
            call cpct_drawSprite_asm
            jr continuar

        pintar_jug1:
            ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
            ld  hl, #_sprite_player1    ;; sprite del jugador
            ld  b, e_h(ix) ;; alto
            ld  c, e_w(ix) ;; ancho 
            call cpct_drawSprite_asm
            jr continuar

        pintar_jug2:
            ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
            ld  hl, #_sprite_player2    ;; sprite del jugador
            ld  b, e_h(ix) ;; alto
            ld  c, e_w(ix) ;; ancho 
            call cpct_drawSprite_asm
            jr continuar
        
        pintar_goalI:
            ex  de, hl
            ld  hl, #_sprite_porteriaI    ;; sprite de la porteria
            ld  b, e_h(ix) ;; alto
            ld  c, e_w(ix) ;; ancho 
            call cpct_drawSprite_asm
            jr continuar

        pintar_goalD:
            ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
            ld  hl, #_sprite_porteriaD    ;; sprite de la porteria
            ld  b, e_h(ix) ;; alto
            ld  c, e_w(ix) ;; ancho 
            call cpct_drawSprite_asm
            
        continuar:

        pop  af ;; recupero el valor de 'a'

        dec  a
        ret  z

        ; ld  bc, #entity_size
        call man_entity_getEntitySize_BC
        add  ix, bc ;; sumo a ix para acceder al array desde la siguiente entidad
    jr  nz, buc

    ret

sys_render_erase_OneEntity_Player:
    ld  de, #0xC000
        ld  c, e_x(ix) ;; pos x
        ld  b, e_y(ix) ;; pos y
        call cpct_getScreenPtr_asm

        ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
        ld  hl, #_sprite_fondo    ;; sprite del jugador fondo
        ld  b, e_h(ix) ;; alto
        ld  c, e_w(ix) ;; ancho 
        call cpct_drawSprite_asm

    ret

sys_render_erase_OneEntity_Ball:
    ld  de, #0xC000
        ld  c, e_x(ix) ;; pos x
        ld  b, e_y(ix) ;; pos y
        call cpct_getScreenPtr_asm

        ex  de, hl ;; mete en de lo que devuelve cpct_getScreenPtr_asm que es hl
        ld  hl, #_sprite_fondo_pelota    ;;sprite de la pelota fondo
        ld  b, e_h(ix) ;; alto
        ld  c, e_w(ix) ;; ancho 
        call cpct_drawSprite_asm

    ret

sys_render_erase:
        ; para solo borrar a los jugadores
    dec a
    dec a

    erase_buc:
            push  af

            ld a, e_var(ix)
            and #e_type_ball
            jp  nz, erase_ball            

            call sys_render_erase_OneEntity_Player
            jr seguir_render

            erase_ball:
            call sys_render_erase_OneEntity_Ball

            seguir_render:
            pop  af ;; recupero el valor de 'a'
            dec  a
                ret  z
            call man_entity_getEntitySize_BC
            add  ix, bc ;; sumo a ix para acceder al array desde la siguiente entidad
    
    jr  nz, erase_buc

    ret

sys_init_draw_number:

    ld l, #15                       
    ld h, #0                        
    call cpct_setDrawCharM0_asm     

    ld hl, #player1_gol_pos ;; Posicion en memoria de video del primer marcador (izquierda)

    xor a                    
    and #0x0F                       
    add #48                         
    ld e, a                       
    call cpct_drawCharM0_asm 

    ld l, #15                       
    ld h, #0                        
    call cpct_setDrawCharM0_asm     

    ld hl, #player2_gol_pos ;; Posicion en memoria de video del segundo marcador (derecha)
 
    xor a                  
    and #0x0F                       
    add #48                         
    ld e, a                         
    call cpct_drawCharM0_asm 
ret