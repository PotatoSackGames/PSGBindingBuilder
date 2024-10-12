class_name PSGValueBinding
extends PSGBindingBase

func attach() -> void:
  _value.changed.connect(_on_value_changed, CONNECT_REFERENCE_COUNTED)
  _on_value_changed()
  if _node.has_signal(_property_name + "_changed"):
    # Will have to investigate to see if this is the primary naming convention, and ensure it has one parameter
    _node.connect(_property_name + "_changed", _on_property_changed, CONNECT_REFERENCE_COUNTED)
  
func detach() -> void:
  _value.changed.disconnect(_on_value_changed)
  
func _on_value_changed() -> void:
  _node.set(_property_name, _value.value)
  
func _on_property_changed(new_value) -> void:
  _value.suspend_changes = true
  _value.value = new_value
  _value.suspend_changes = false
  
