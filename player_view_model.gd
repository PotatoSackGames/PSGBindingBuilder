extends Resource
class_name PlayerViewModel

const MaxHP = 20

var PlayerName := PSGObservableValue.new("Stannifer")

var CurrentGoldAmount := PSGObservableValue.new(0)
var CurrentHP := PSGObservableValue.new(MaxHP)
var CurrentEquipment: EquipmentViewModel = EquipmentViewModel.new()
var CurrentVelocity := PSGObservableValue.new(Vector2.ZERO)
var CurrentScale := PSGObservableValue.new(Vector2(1, 1))

var CurrentState := PSGObservableValue.new(null)

func add_200_gold() -> void:
  CurrentGoldAmount.value += 200
  
func add_2000_gold() -> void:
  CurrentGoldAmount.value += 2000
  
func add_20000_gold() -> void:
  CurrentGoldAmount.value += 20000
