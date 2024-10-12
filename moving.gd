extends Node

var animation_name: String:
  get:
    return "Moving" + state_machine.direction_as_string
    
var state_machine

func physics_process(delta: float) -> void:
  var input_vector = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
  if not input_vector.is_zero_approx() and state_machine != null:
    state_machine.change_state("Moving")
    Globals.player.CurrentVelocity.value = input_vector.normalized() * 120.0
  else:
    state_machine.change_state("Idle")
