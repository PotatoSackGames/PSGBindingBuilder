extends Node

var animation_name: String:
  get:
    return "Idle" + state_machine.direction_as_string
    
var state_machine

func physics_process(delta: float) -> void:
  var input_vector = state_machine.current_input
  if not input_vector.is_zero_approx() and state_machine != null:
    state_machine.change_state("Moving")
  else:
    Globals.player.CurrentVelocity.value = Vector2.ZERO
