extends Node

@onready var is_basis: bool
@onready var cientific: bool = false
@onready var weight: bool = false
var default_startup: bool = false
var modern_startup: bool = false
var black_startup: bool = false

func _ready() -> void:
     is_basis = true
     get_info_device()

func get_info_device():
     print(OS.get_name())
     
func set_default_init():
     default_startup = true
     modern_startup = false
     black_startup = false
     print("default")
     
func set_modern_init():
     default_startup = false
     modern_startup = true
     black_startup = false
     print("modern")
     
func set_black_init():
     default_startup = false
     modern_startup = false
     black_startup = true
     print("black")
