extends Control

@onready var shorcut_panel = $Shortcut_Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     hide_shorcut_panel()
     
func show_shorcut_panel():
     shorcut_panel.show()
     
func hide_shorcut_panel():
     shorcut_panel.hide()
