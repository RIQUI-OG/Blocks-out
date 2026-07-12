extends Control

@onready var panel_settings = $Configuracion
@onready var panel_info = $Info

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
     pass

func _on_button_hide_pressed() -> void:
     self.hide()


func _on_button_quit_pressed() -> void:
     get_tree().quit()

func _on_button_settings_pressed() -> void:
     panel_settings.show()

func _on_button_info_pressed() -> void:
     panel_info.show()
