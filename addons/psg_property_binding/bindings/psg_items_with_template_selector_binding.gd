class_name PSGItemsWithTemplateSelectorBinding
extends PSGBindingBase

var _template_selector: PSGItemTemplateSelector

func _init(node: Node, prop_name: String, value: Variant, selector: PSGItemTemplateSelector) -> void:
  super._init(node, prop_name, value)
  _template_selector = selector

func attach() -> void:
  pass
  
func detach() -> void:
  pass
