extends Node

var current_bindings = []

func _ready() -> void:
  var node = get_tree().current_scene
  bind_all_children(node)
  get_tree().node_added.connect(_on_node_added)
  get_tree().node_removed.connect(_on_node_removed)

func bind_all_children(node: Node) -> void:
  _on_node_added(node)
  for child in node.get_children():
    bind_all_children(child)

func _on_node_removed(node: Node) -> void:
  for binding in current_bindings:
    if is_instance_valid(binding) and is_instance_valid(binding._node) and binding._node == node:
      binding.detach()
      current_bindings.erase(binding)
  
func _on_node_added(node: Node) -> void:
  var meta = node.get_meta("psg_binding_value") if node.has_meta("psg_binding_value") else null
  if null == meta or (meta is String and "" == meta):
    return
  
  for property_name in meta.keys():
    if meta[property_name] == "" or meta[property_name] == null:
      continue

    var context_path = meta[property_name]
    var context_value = safe_navigate(node, context_path)
    
    if context_value == null:
      continue
        
    # Continue processing to determine if an actual binding should be made. 
    var binding = _select_binding(node, property_name, context_value, meta)
    current_bindings.push_back(binding)
    binding.attach()

func _select_binding(node: Node, property_name: String, value: Variant, meta: Variant) -> PSGBindingBase:
  var result = PSGOneTimeBinding.new(node, property_name, value)
  
  if node.has_signal(property_name):
    result = PSGSignalBinding.new(node, property_name, value)
  elif property_name in node:
    if value is PSGObservableArray:
      result = PSGArrayBinding.new(node, property_name, value)
    elif value is PSGObservableValue:
      result = PSGValueBinding.new(node, property_name, value)
  elif property_name == "items" and node is BoxContainer:
    var template = meta.get("item_template", null)
    var template_selector = meta.get("item_template_selector", null)
    if template != null:
      result = PSGItemsWithTemplateBinding.new(node, property_name, value, template)
    elif template_selector != null:
      result = PSGItemsWithTemplateSelectorBinding.new(node, property_name, value, template_selector)
    else:
      # Handled by OneTimeBinding as it's just a normal array, or there's no way for us to handle it
      pass
  
  
  return result

# This nice little function navigates across the string path given a root variant to start at, picks off the final value, and sends it back.
# If anything breaks along the way, it returns null.
func safe_navigate(root: Variant, path: String) -> Variant:    
  var properties = path.split(".")
  var current_value = root
  for prop in properties:
    if current_value == null:
        return null
    elif not is_instance_valid(current_value):
      return null
    elif not prop in current_value:
      var tree_root = get_tree().root
      if tree_root.has_node(prop):
        current_value = tree_root.get_node(prop)
        continue
      print_debug("Navigation stopped: Property '", prop, "' does not exist on object ", current_value)
      return null
    
    if current_value.has_method(prop):
      current_value = Callable(current_value, prop)
      break
    current_value = current_value.get(prop)
  return current_value
