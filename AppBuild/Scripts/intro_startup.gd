extends Control

@export var wait_time: float = 2.0
var calc_scn = load("res://AppBuild/Scenes/calculadora.tscn")
#STARTUPS
@onready var default_startup = $Default_splash
@onready var modern_startup = $Modern_splash
@onready var black_startup = $Black_splash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     if is_inside_tree():
          set_imag_startup()
     await get_tree().process_frame
     start_logo()

func start_logo():
     await get_tree().create_timer(wait_time).timeout
     #get_tree().change_scene_to_packed(calc_scn)
     get_tree().change_scene_to_file("res://AppBuild/Scenes/calculadora.tscn")

func set_imag_startup():
     if AppManager.default_startup:
          default_startup.show()
          modern_startup.hide()
          black_startup.hide()
          
     if AppManager.modern_startup:
          default_startup.hide()
          modern_startup.show()
          black_startup.hide()
          
     if AppManager.black_startup:
          default_startup.hide()
          modern_startup.hide()
          black_startup.show()
