class_name PSGItemsWithTemplateBinding
extends PSGBindingBase

var _template: Node

func _init(node: Node, prop_name: String, value: Variant, template: Node) -> void:
  super._init(node, prop_name, value)
  _template = template
  var result = template.new()

func attach() -> void:
  pass
  
func detach() -> void:
  pass
