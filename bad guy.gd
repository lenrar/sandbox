extends KinematicBody2D
class_name Enemy

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 350
const MAXSPEED = 100
const JUMPFORCE = 400
const EXTRAJUMPS = 2
const ACCEL = 10

const KILL_ANGLES = Vector2(PI / 4, 3 * PI / 4)

var motion = Vector2()

var isMovingRight = true

var health = 2

func _process(delta):
	move_character()
	
func detect_turn_around(): 
	if (!$detectors/floordetector.is_colliding() or $detectors/walldetector.is_colliding()) and is_on_floor():
		isMovingRight = !isMovingRight
		$detectors.scale.x = - $detectors.scale.x
	
func move_character():
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	

	motion.x += ACCEL if isMovingRight else -ACCEL

	detect_turn_around()
		
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
		
	motion = move_and_slide(motion, UP)

func _on_hitarea_body_entered(body: KinematicBody2D) -> void:
	if body is Player:
		var normal = position.direction_to(body.position)
		
		if(normal.y < -0.85):
			hit(1)
		else:
			body.hit(1)
			
		body.motion = normal * body.ENEMYKNOCKBACK
		
func hit(amount: int) -> void:
	health -= amount
	if(health <= 0):
		queue_free()
		
