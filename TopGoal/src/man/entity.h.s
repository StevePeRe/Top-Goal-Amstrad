;; de momento ya que algunas declaraciones estaran en el update y tras en el render

.globl man_entity_create
.globl man_entity_update
.globl man_entity_getEntityArray_IX
.globl man_entity_getEntityArray_HL
.globl man_entity_getNumEntities_A
.globl man_entity_getEntitySize_BC
.globl player1
.globl player2
.globl players_ball
.globl players_goalD
.globl players_goalI
.globl man_entity_getBall

;; MACROS
;; crear macros para definir el array
.macro DefineEntity _name, _x, _y, _vx, _vy, _w, _h, _col, _upd, _var, _tipo, _collision, _collision_dir
_name:
    ; .db  _tipo   ;; tipo de variable
    .db  _x, _y   ;; x, y
    .db  _vx, _vy ;; velocidad x e y
    .db  _w, _h   ;; width height
    .db  _col     ;; color
    .dw  _upd     ;; update
    .db  _var   ;; que variable es
    .db  _tipo   ;; tipo de variable
    .db _collision ;; Boolean si colisiona con algo True/False
    .db _collision_dir ;; Direccion desde donde colisiona izq, der, arriba, bajo
.endm

; CONSTANTES - direccion de memoria
;;tipos de entidades
e_type_invalid = 0x00
e_type_player1 = 0x01
e_type_player2 = 0x02
e_type_ball = 0x04
e_type_goalD = 0x08
e_type_goalI = 0x10

;; Tipos de colisiones jugador-jugador jugador-balon
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

entity_size = 13 ;; simbolo
max_entities = 5

e_x = 0
e_y = 1
e_vx = 2
e_vy = 3
e_w = 4
e_h = 5
e_col = 6
e_up_l = 7  ;; lo divido en dos ya que upd son dos bytes
e_up_h = 8
e_var = 9
e_tipo_var = 10
e_collision = 11
e_collision_dir = 12

;;tipos de componentes
e_type_render = 0x01     ;;entidad renderizable
e_type_movable = 0x02    ;;entidad que se puede mover
e_type_input = 0x04      ;;entidad controlable por input  
; e_type_ia = 0x08         ;;entidad controlable con ia
; e_type_animated = 0x10   ;;entidad animada
e_type_collider = 0x20   ;;entidad que puede colisionar
e_type_default = e_type_render | e_type_movable | e_type_collider  ;;componente por defecto
