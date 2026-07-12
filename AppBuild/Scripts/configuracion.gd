extends Control

@onready var option_bt_splash = $MARGIN_SCREEN/MarginContainer/VBoxContainer/HBoxContainer/OptionBt_Splash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
     pass

func _on_option_bt_splash_item_selected(index: int) -> void:
     if index == 0:
          AppManager.set_default_init()
          print("Splash de inicio por defecto")
     if index == 1:
          AppManager.set_modern_init()
          print("Splash de inicio moderna")
     if index == 2:
          AppManager.set_black_init()
          print("Splash de inicio oscura")

func _on_button_close_settings_pressed() -> void:
     self.hide()

func _on_reiniciar_app_pressed() -> void:
     get_tree().change_scene_to_file("res://AppBuild/Scenes/intro.tscn")
