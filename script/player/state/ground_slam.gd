class_name PlayerStateGroundSlam extends PlayerState

const BREAK_WOOD_AUDIO = preload("uid://cw7xqw7lq3wbv")
const DASH_AUDIO = preload("uid://dmg8ec6qcvcmp")
const BOOM_AUDIO = preload("uid://cvjp5hpxjekjh")
const HIT_WOOD_LARGE = preload("uid://pvcwphc4k27d")
const HIT_WOOD_MEDIUM = preload("uid://oaquuokgx81b")
const HIT_WOOD_SMALL = preload("uid://m8pb7r3uk7i")

@export var velocity: float = 400
@export var effect_delay: float = 0.075

@onready var damage_area: DamageArea = %DamageArea
@onready var ground_slam_attack_area: AttackArea = %GroundSlamAttackArea
@onready var ground_slam_shape_cast: ShapeCast2D = %GroundSlamShapeCast


var effect_timer: float = 0



# what happens when this state is initialized?
func init() -> void:
	
	pass


# what happens when we enter this state?
func enter() -> void:
	player.animation_player.play("ground_slam")
	player.sprite.tween_color()
	Audio.play_spatial_sound(DASH_AUDIO, player.global_position)
	damage_area.start_invulnerable()
	ground_slam_attack_area.set_active()
	pass


#what happens when we exit this state?
func exit()-> void:
	VisualEffects. camera_shake(10.0)
	VisualEffects.land_dust(player.global_position)
	VisualEffects.hit_dust(player.global_position)
	Audio.play_spatial_sound(BOOM_AUDIO, player.global_position)
	damage_area.end_invulnerable()
	ground_slam_attack_area.set_active(false)
	pass


# what happens when an input is pressed?
func handle_input(_event : InputEvent) -> PlayerState:
	
	return null


# what happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	check_collisions(_delta)
	effect_timer -= _delta
	if effect_timer < 0:
		effect_timer = effect_delay
		player.sprite.ghost()
	return null


# what happens each physics_process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity = Vector2(0, velocity)
	if player.is_on_floor():
		if not check_collisions(_delta):
			return idle
	return null


func check_collisions(_delta: float) -> bool:
	ground_slam_shape_cast.target_position.y = velocity * _delta + 3
	ground_slam_shape_cast.force_shapecast_update()
	if ground_slam_shape_cast.is_colliding():
		for i in ground_slam_shape_cast.get_collision_count():
			var c = ground_slam_shape_cast.get_collider(i)
			var pos: Vector2 = ground_slam_shape_cast.get_collision_point(i)
			VisualEffects.hit_dust(pos)
			VisualEffects.camera_shake(10.0)
			if c.get_parent() is Breakable:
				var b: Breakable = c.get_parent()
				b.queue_free()
				Audio.play_spatial_sound(b.destroyed_audio, pos)
				for p in b.destroy_particles:
					VisualEffects.hit_particles(pos, Vector2.DOWN, p)
			else:
				c.queue_free()
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_LARGE)
				VisualEffects.hit_particles(pos, Vector2.DOWN, HIT_WOOD_MEDIUM)
				VisualEffects.hit_particles(pos, Vector2.UP, HIT_WOOD_SMALL)
				Audio.play_spatial_sound(BREAK_WOOD_AUDIO, pos)
		return true
	return false
