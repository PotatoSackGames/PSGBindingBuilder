class_name PSGObservableArray
extends Resource

var items = []
var suspend_changes: bool = false

func _init(seed_items: Array) -> void:
  items = seed_items

func add_item(item: Variant) -> void:
  items.push_back(item)
  emit_changed_items()

func remove_item(item: Variant) -> void:
  items.erase(item)
  emit_changed_items()

func remove_at(position: int) -> void:
  items.remove_at(position)
  emit_changed_items()

func append_array(arr: Array) -> void:
  items.append_array(arr)
  emit_changed_items()
  
func clear() -> void:
  items.clear()
  emit_changed_items()

func insert(position: int, value: Variant) -> int:
  var result = items.insert(position, value)
  emit_changed_items()
  return result

func pop() -> Variant:
  var result = items.pop_back()
  emit_changed_items()
  return result

func sort() -> void:
  items.sort()
  emit_changed_items()

func sort_custom(callable: Callable) -> void:
  items.sort_custom(callable)
  emit_changed_items()

func shuffle() -> void:
  items.shuffle()
  emit_changed_items()

func reverse() -> void:
  items.reverse()
  emit_changed_items()

func emit_changed_items() -> void:
  if not suspend_changes:
    emit_changed()
