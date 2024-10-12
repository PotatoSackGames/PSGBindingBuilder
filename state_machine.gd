extends Node

var current_state = null

var current_direction = "Right"

var actor

var direction_as_string: String:
  get:
    var result = current_direction
    var current_str = PSGUtilities.get_dominant_direction_string(current_input)
    if not current_input.is_zero_approx():
      result = current_str
      current_direction = result
      if current_input == Vector2.LEFT:
        Globals.player.CurrentScale.value = Vector2(-1, 1)
      elif current_input == Vector2.RIGHT:
        Globals.player.CurrentScale.value = Vector2(1, 1)
    return result
    
      
var current_input: Vector2:
  get:
    return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

func _ready() -> void:
  for child in get_children():
    child.state_machine = self
  
  change_state.call_deferred("Idle")

func change_state(to_state: String) -> void:
  if current_state == null or (current_state.name != to_state and not to_state.is_empty()):
    var next_state = get_node(to_state)
    current_state = next_state
    actor.player_view_model.CurrentState.value = current_state

func _physics_process(delta: float) -> void:
  current_state.physics_process(delta)
