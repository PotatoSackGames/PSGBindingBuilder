class_name PSGBindingBase
extends RefCounted

var _node: Node
var _property_name: String
var _value: Variant

func _init(node: Node, prop_name: String, value: Variant) -> void:
  _node = node
  _property_name = prop_name
  _value = value

func attach() -> void:
  pass

func detach() -> void:
  pass
