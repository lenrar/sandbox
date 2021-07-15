extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 350
const MAXSPEED = 100
const JUMPFORCE = 400
const EXTRAJUMPS = 2
const ACCEL = 10

var motion = Vector2()

var isMovingRight = true


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
