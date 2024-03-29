extends KinematicBody2D
class_name Player


const UP = Vector2(0, -1)
const GRAVITY = 20
const MAXFALLSPEED = 350
const MAXSPEED = 200
const JUMPFORCE = 400
const EXTRAJUMPS = 2
const ACCEL = 80

const ENEMYKNOCKBACK = 500

const C = "c"
const A = "a"
const F = "f"
const G = "g"

var songs = {
	[C, A, G, F]: 0, #Attack
	[F, G, A, C]: 1 # Defend
}

var motion = Vector2()
var extraJumps = EXTRAJUMPS

var soundQueue = []
var sound;

var fourSoundCounter = []

var health = 4

# UP, DOWN, RIGHT, LEFT - Attack
#LEFT, RIGHT, DOWN, UP - Defend

func _ready():
	pass # Replace with function body.
	
	
func update_sound_counter(sound):
	if(fourSoundCounter.size() == 4):
		fourSoundCounter.clear()
	fourSoundCounter.push_back(sound)
	
	
func attack():
	print("attack!")
	var attack_radius = $attack
	var bodies = attack_radius.get_overlapping_bodies()
	print(bodies)
	for body in bodies:
		body.hit(1)
	
func perform_songs():
	var song = null
	if(fourSoundCounter.size() == 4):
		song = songs.get(fourSoundCounter)
		if(song != null):
			match song:
				0: attack()
				1: null
	
		
func play_sounds():
	if((sound == null || !sound.playing) && soundQueue.size() > 0):
		sound = soundQueue.pop_front()
		update_sound_counter(sound.name)
		perform_songs()
		sound.play()
		
	if(Input.is_action_just_pressed("up_instr")):
		soundQueue.push_back($sounds/c)
	elif(Input.is_action_just_pressed("right_instr")):
		soundQueue.push_back($sounds/g)
	elif(Input.is_action_just_pressed("left_instr")):
		soundQueue.push_back($sounds/f)
	elif(Input.is_action_just_pressed("down_instr")):
		soundQueue.push_back($sounds/a)

func _physics_process(delta):
	
	play_sounds()
	
	motion.y += GRAVITY
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
	else:
		motion.x = lerp(motion.x, 0, 0.2)
		
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
		
	if Input.is_action_just_pressed("up"):
		if is_on_floor():
			motion.y = -JUMPFORCE
			extraJumps = EXTRAJUMPS
		elif extraJumps > 0:
			motion.y = -JUMPFORCE
			extraJumps -= 1
		
	motion = move_and_slide(motion, UP)
		
	
	

func hit(amount: int) -> void:
	health -= amount
	if(health <= 0):
		restart_level()

func restart_level():
	health = 4
	get_tree().change_scene("res://TestLevel.tscn")

func _on_fallzone_body_entered(body):
	restart_level()
