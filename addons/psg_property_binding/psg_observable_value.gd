class_name PSGObservableValue
extends Resource

func _init(initial_value: Variant) -> void:
  value = initial_value

var value: Variant:
  set(val):
    if val != value:
      value = val
      if not suspend_changes:
        emit_changed()

var suspend_changes: bool = false
