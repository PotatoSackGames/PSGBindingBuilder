extends Resource
class_name EquipmentViewModel

var Head := PSGObservableValue.new(null)
var Chest := PSGObservableValue.new(null)
var Arms := PSGObservableValue.new(null)
var Legs := PSGObservableValue.new(null)
var Neck := PSGObservableValue.new(null)

func be_naked() -> void:
  Head.value = null
  Chest.value = null
  Arms.value = null
  Legs.value = null
  Neck.value = null

func use_chain() -> void:
  Head.value = preload("res://nose-helmet.png")
  Chest.value = preload("res://chain-chest.png")
  Arms.value = preload("res://chain-arms.png")
  Legs.value = null
  Neck.value = preload("res://chain-gorget.png")

func use_plate() -> void:
  Head.value = preload("res://winged-helmet.png")
  Chest.value = preload("res://plate-chest.png")
  Arms.value = preload("res://plate-arms.png")
  Legs.value = null
  Neck.value = preload("res://plate-gorget.png")
