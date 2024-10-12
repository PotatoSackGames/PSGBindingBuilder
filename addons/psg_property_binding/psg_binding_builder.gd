@tool
extends EditorPlugin

class_name BindingBuilderDock

var _root: PanelContainer
var _dock: VBoxContainer
var _selected_node

func _enter_tree():
  add_autoload_singleton("BindingCreator", "res://addons/psg_property_binding/binding_creator_singleton.gd")
  var new_sb = StyleBoxFlat.new()
  new_sb.bg_color = Color("#21262EFF")
  _root = PanelContainer.new()
  _root.add_theme_stylebox_override("panel", new_sb)
  _root.name = "Binding Builder"
  _root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  var scroll = ScrollContainer.new()
  scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
  _root.add_child(scroll)
  _dock = VBoxContainer.new()
  _dock.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  scroll.add_child(_dock)
  _dock.add_theme_constant_override("separation", 0)
  add_control_to_dock(DOCK_SLOT_RIGHT_UR, _root)
  set_process(true)
  #print_color_lists()

func print_color_lists() -> void:
  var default_theme = ThemeDB.get_default_theme()
  var theme = get_editor_interface().get_base_control()
  print(theme.get_theme_color("prop_section", "Editor"))
    

func _exit_tree():
  remove_autoload_singleton("BindingCreator")
  remove_control_from_docks(_root)
  _root.queue_free()
  set_process(false)

func _process(delta):
  var selected_nodes = get_editor_interface().get_selection().get_selected_nodes()
  if selected_nodes != null and selected_nodes.size() == 1:
    var selected_node = selected_nodes[0]
    if null != selected_node and selected_node != _selected_node:
      _selected_node = selected_node
      update_dock(selected_node)
  else:
    _selected_node = null
    for child in _dock.get_children():
      child.queue_free()
  
func update_dock(selected_node: Node):
  for child in _dock.get_children():
    child.free()
  
  _add_new_dock_children(selected_node)
  
func _get_user_defined_properties(node: Node, script: GDScript) -> Array:
  var user_properties = []
  var property_list = script.get_script_property_list()
  for prop in property_list:
    if prop.usage != PROPERTY_USAGE_CATEGORY:
      user_properties.append(prop.name)
    
  return user_properties

func _add_new_dock_children(selected_node: Node):
  var selected_node_script = selected_node.get_script()
  if selected_node_script != null:
    var user_def_props = _get_user_defined_properties(selected_node, selected_node_script)
    if not user_def_props.is_empty():
      var user_group_container = _create_group("User-defined")
      for property in user_def_props:
        _add_property_binding(user_group_container, selected_node, property)
      _dock.add_child(user_group_container)
  
  if "position" in selected_node or "global_position" in selected_node:
    var transform_group_container = _create_group("Transform")
    _add_property_binding(transform_group_container, selected_node, "position")
    _add_property_binding(transform_group_container, selected_node, "global_position")
    _add_property_binding(transform_group_container, selected_node, "rotation")
    _add_property_binding(transform_group_container, selected_node, "global_rotation")
    _add_property_binding(transform_group_container, selected_node, "scale")
    _dock.add_child(transform_group_container)
  elif "translation" in selected_node or "global_transform" in selected_node:
    var transform_group_container = _create_group("Transform")
    _add_property_binding(transform_group_container, selected_node, "translation")
    _add_property_binding(transform_group_container, selected_node, "rotation")
    _add_property_binding(transform_group_container, selected_node, "scale")
    _add_property_binding(transform_group_container, selected_node, "global_transform")
    _dock.add_child(transform_group_container)

  if "modulate" in selected_node or "self_modulate" in selected_node:
    var appearance_group_container = _create_group("Appearance")
    _add_property_binding(appearance_group_container, selected_node, "modulate")
    _add_property_binding(appearance_group_container, selected_node, "self_modulate")
    _add_property_binding(appearance_group_container, selected_node, "visible")
    if "disabled" in selected_node:
      _add_property_binding(appearance_group_container, selected_node, "disabled")
    _dock.add_child(appearance_group_container)

  if "text" in selected_node:
    var text_group_container = _create_group("Text")
    _add_property_binding(text_group_container, selected_node, "text")
    if "editable" in selected_node:
      _add_property_binding(text_group_container, selected_node, "editable")
    _dock.add_child(text_group_container)

  if "texture" in selected_node:
    var texture_group_container = _create_group("Texture")
    _add_property_binding(texture_group_container, selected_node, "texture")
    _add_property_binding(texture_group_container, selected_node, "flip_h")
    _add_property_binding(texture_group_container, selected_node, "flip_v")
    if selected_node is Control:
      _add_property_binding(texture_group_container, selected_node, "stretch_mode")
    else:
      _add_property_binding(texture_group_container, selected_node, "hframes")
      _add_property_binding(texture_group_container, selected_node, "vframes")
      _add_property_binding(texture_group_container, selected_node, "frame")
      _add_property_binding(texture_group_container, selected_node, "skew")
    _dock.add_child(texture_group_container)

  if "velocity" in selected_node:
    var physics_group_container = _create_group("Physics")
    _add_property_binding(physics_group_container, selected_node, "velocity")
    _dock.add_child(physics_group_container)

    # Add Items group for container nodes that support lists
  if selected_node is BoxContainer or selected_node is GridContainer:
    var items_group_container = _create_group("Items")
    _add_property_binding(items_group_container, selected_node, "items")
    _add_property_binding(items_group_container, selected_node, "item_template")
    _add_property_binding(items_group_container, selected_node, "item_template_selector")
    
    if not selected_node is GridContainer:
      _add_property_binding(items_group_container, selected_node, "alignment")
      _add_property_binding(items_group_container, selected_node, "separation")
    else:
      _add_property_binding(items_group_container, selected_node, "columns")
      _add_property_binding(items_group_container, selected_node, "h_separation")
      _add_property_binding(items_group_container, selected_node, "v_separation")
    _dock.add_child(items_group_container)
  
  if selected_node is Control:
    var control_group_container = _create_group("Control")
    _add_property_binding(control_group_container, selected_node, "focus_mode")
    _add_property_binding(control_group_container, selected_node, "size_flags_horizontal")
    _add_property_binding(control_group_container, selected_node, "size_flags_vertical")
    _add_property_binding(control_group_container, selected_node, "mouse_filter")
    _dock.add_child(control_group_container)
    
  if selected_node is Node2D and "z_index" in selected_node:
    var node2d_group_container = _create_group("Node2D")
    _add_property_binding(node2d_group_container, selected_node, "z_index")
    _add_property_binding(node2d_group_container, selected_node, "z_index_relative")
    _dock.add_child(node2d_group_container)

  var animation_group_container = null
  if "animation" in selected_node or "current_animation" in selected_node:
    animation_group_container = _create_group("Animation")
    _add_property_binding(animation_group_container, selected_node, "current_animation")
    _add_property_binding(animation_group_container, selected_node, "speed_scale")
  if "active" in selected_node:
    if animation_group_container == null:
      animation_group_container = _create_group("Animation")
    _add_property_binding(animation_group_container, selected_node, "active")
    if selected_node is AnimationTree and selected_node.tree_root is AnimationNodeStateMachine:
      _add_property_binding(animation_group_container, selected_node, "current_state")
  if animation_group_container != null and animation_group_container.get_child_count() != 0:
    _dock.add_child(animation_group_container)
  
  _add_signals_group(selected_node)

func _create_group(group_name: String, is_pressed := false) -> VBoxContainer:
  var group_container = VBoxContainer.new()
  group_container.add_theme_constant_override("separation", 0)
  group_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  var group_header = Button.new()
  group_header.text = "%s %s" % ["▶" if is_pressed else "▼", group_name]
  group_header.flat = true
  group_header.toggle_mode = true
  group_header.button_pressed = is_pressed
  group_header.alignment = HORIZONTAL_ALIGNMENT_LEFT
  group_header.icon_alignment = HORIZONTAL_ALIGNMENT_LEFT
  group_header.pressed.connect(_on_group_toggled.bind(group_header).bind(group_container))
  group_header.focus_mode = Control.FOCUS_NONE
  var editor_interface = get_editor_interface().get_base_control()
  group_header.add_theme_font_override("font", editor_interface.get_theme_font("editor_icons"))
  group_header.add_theme_color_override("font_color", Color.WHITE)
  _dock.add_child(group_header)
  group_container.visible = not is_pressed
  return group_container

func _add_property_binding(group_container: VBoxContainer, node: Node, property_name: String):
  var hsplit = HSplitContainer.new()
  hsplit.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED
  hsplit.size_flags_horizontal = HSplitContainer.SIZE_EXPAND_FILL

  var property_label = Label.new()
  property_label.text = "     " + property_name
  var editor_interface = get_editor_interface().get_base_control()
  property_label.add_theme_font_override("font", editor_interface.get_theme_font("editor_icons"))
  property_label.add_theme_color_override("font_color", Color(1, 1, 1, 0.627451))
  property_label.size_flags_horizontal = Label.SIZE_EXPAND_FILL

  var binding_field = LineEdit.new()
  binding_field.placeholder_text = "None yet"
  var binding_value = node.get_meta("psg_binding_value", {})
  var binding_field_text = binding_value.get(property_name, "")
  binding_field.text = binding_field_text
  binding_field.text_changed.connect(_on_binding_changed.bind(property_name).bind(node))
  binding_field.add_theme_color_override("font_color", Color(1, 1, 1, 0.627451))
  binding_field.size_flags_horizontal = LineEdit.SIZE_EXPAND_FILL

  hsplit.add_child(property_label)
  hsplit.add_child(binding_field)
  group_container.add_child(hsplit)

func _on_binding_changed(context_property_name: String, selected_node, node_property_name):
    var binding_value = selected_node.get_meta("psg_binding_value", {})
    binding_value[node_property_name] = context_property_name
    selected_node.set_meta("psg_binding_value", binding_value)

func _on_group_toggled(group_container, header_button):
  group_container.visible = not group_container.visible
  var arrow_2 = "▶" if header_button.button_pressed else "▼"
  var arrow_1 = "▼" if header_button.button_pressed else "▶"
  header_button.text = header_button.text.replace(arrow_1, arrow_2)
  
func get_color(name: String) -> Color:
  return get_editor_interface().get_base_control().get_theme_color(name, "Editor")
  
func _add_signals_group(selected_node: Node):
  var signals_group_container = _create_group("Signals", true)
  var signals = selected_node.get_signal_list()
  for sig in signals:
    var signal_name = sig.name
    _add_property_binding(signals_group_container, selected_node, signal_name)
  if signals_group_container.get_child_count() > 0:
    _dock.add_child(signals_group_container)
