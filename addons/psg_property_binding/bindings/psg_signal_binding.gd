class_name PSGSignalBinding
extends PSGBindingBase

func attach() -> void:
  if _value is Callable:
    var available_signals = _node.get_signal_list()
    for sig in available_signals:
      if sig.name == _property_name:
        _node.connect(_property_name, _value, CONNECT_REFERENCE_COUNTED) # Assume the _value is the right form of callable, with the right parameters. Should error here otherwise, in theory?
        break

func detach() -> void:
  _node.disconnect(_property_name, _value)
