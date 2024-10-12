class_name PSGOneTimeBinding
extends PSGBindingBase

func attach() -> void:
  _node.set(_property_name, _value)
