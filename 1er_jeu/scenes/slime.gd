extends Node2D
const speed = 60
var dir = 1
@onready var ray_castright = $RayCastright
@onready var ray_castleft = $RayCastleft
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $killZone/CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_castleft.is_colliding():
		dir=1
		animated_sprite_2d.flip_h = false
		collision_shape_2d.scale.x=1
	if ray_castright.is_colliding():
		dir=-1
		animated_sprite_2d.flip_h = true
		collision_shape_2d.scale.x=-1
	position.x += speed*delta*dir
	
func take_damage(amount:int) -> void:
	print("attack touched")
	self.queue_free()
