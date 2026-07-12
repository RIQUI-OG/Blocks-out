extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     _handled_scr_size()

func _notification(what):
     if what == NOTIFICATION_RESIZED:
          _handled_scr_size()
          
func _handled_scr_size():
     var os_name = OS.get_name()
     if os_name == "Android":
          var screen_size = get_viewport_rect().size
          var safe_area = DisplayServer.get_display_safe_area()
          var top_area = safe_area.position.y
          var sides_area = safe_area.position.x
          if screen_size.x > screen_size.y:
               var margin_safe = 65
               add_theme_constant_override("margin_top", margin_safe)
               add_theme_constant_override("margin_bottom", margin_safe)
               
          
