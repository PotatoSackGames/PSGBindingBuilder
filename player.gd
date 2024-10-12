extends CharacterBody2D


var player_view_model := preload("res://player_main_viewmodel.tres") # Note it is preloaded, same as Globals, meaning they'll reference the same .tres due to Godot's resource handling

func _ready() -> void:
  %StateMachine.actor = self
  %AnimatedSprite2D.play("IdleRight")

func _physics_process(delta: float) -> void:
  move_and_slide()
  if %AnimatedSprite2D.animation != player_view_model.CurrentState.value.animation_name:
    %AnimatedSprite2D.play(player_view_model.CurrentState.value.animation_name)
