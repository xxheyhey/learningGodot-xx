extends CharacterBody2D

const MAX_SPEED = 200.0
const ACC = 10
const JUMP_VELOCITY = -200.0
const MOVE_DOWN_VELOCITY = -JUMP_VELOCITY

var jumps_left = 6


func _physics_process(delta: float) -> void:
    var grounded = is_on_floor()

    # Jumping
    if grounded:
        jumps_left = 6
    if Input.is_action_just_pressed("jump") and jumps_left > 0:
        velocity.y = JUMP_VELOCITY
        jumps_left -= 1

    # Moving down
    if Input.is_action_just_pressed("move_down") and not grounded and velocity.y >= -50:
        # TODO: Fix it so that the player doesn't slow down when down is
        # already pressed once and they are still falling
        velocity.y = MOVE_DOWN_VELOCITY
    elif not grounded:
        velocity += get_gravity() * delta

    # Sideways movement
    var direction = Input.get_axis("move_left", "move_right")
    if direction and abs(velocity.x) <= MAX_SPEED:
        velocity.x += direction * ACC
        $ExlamSprite.play("walking")
    elif velocity.x > 0:
        velocity.x -= ACC
        $ExlamSprite.animation = "idle"
    elif velocity.x < 0:
        velocity.x += ACC
        $ExlamSprite.animation = "idle"

    move_and_slide()
