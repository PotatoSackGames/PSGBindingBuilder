class_name PSGUtilities
extends RefCounted

static func get_dominant_direction_string(direction: Vector2) -> String:
  var quadrant = atan2(direction.y, direction.x)
  
  if quadrant < 0:
    quadrant += 2 * PI
  
  quadrant = rad_to_deg(quadrant)
  
  if quadrant < 45 or quadrant > 315:
    return "Right"
    
  elif quadrant >= 45 and quadrant < 135:
    return "Down"
  
  elif quadrant >= 135 and quadrant < 225:
    return "Right"
    
  else:
    return "Up"
