class_name PSGArrayBinding
extends PSGBindingBase

func attach() -> void:
  _value.changed.connect(_on_array_changed, CONNECT_REFERENCE_COUNTED)
  
func detach() -> void:
  _value.changed.disconnect(_on_array_changed)
  
func _on_array_changed() -> void:
  _node.set(_property_name, _value.items)
