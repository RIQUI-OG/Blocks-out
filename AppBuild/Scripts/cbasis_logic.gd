extends PanelContainer

@onready var operacion_txt = $VBoxContainer/Resultado/MarginContainer/VBoxContainer/Line_op
@onready var grid_botones = $VBoxContainer/Cont_Botones/MarginContainer/GridContainer
@onready var box_advanced_ops = $VBoxContainer/Box_avanzado
@onready var result_txt = $VBoxContainer/Resultado/MarginContainer/VBoxContainer/Resultados
@onready var root_canvas = $"../../.."

var current_input: String = ""
var first_op: float = 0.0
var current_op: String = ""
var is_typping: bool = false
var open_parenthesis_count: int = 0
var sequence_formula: String = ""
var is_show_advc: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
     operacion_txt.editable = false
     result_txt.hide()
     
     limpiar_calculadora()
     _conectar_botones()
     
func _conectar_botones():
     for child in grid_botones.get_children():
          if child is Button:
               child.pressed.connect(_on_button_pressed.bind(child.text))
               
func _on_button_pressed(bt_text: String):
     match bt_text:
          "C":
               limpiar_calculadora()
          "=":
               _calcular_resultado()
          "+", "-", "*", "/":
               handle_operator(bt_text)
          ".":
               handle_decimal()
          "SC":
               root_canvas.show_shorcut_panel()
          "DEL":
               handle_delete()
          "%":
               handle_percentage()
          _:
               handle_number(bt_text)
               
               
func handle_number(digito: String):
     if sequence_formula == "0":
          sequence_formula = digito
     else :
          sequence_formula += digito
               
     _actualizar_secuencia()
     _calculate_realtime()
               
func handle_operator(operacion: String):
     if sequence_formula == "" or sequence_formula == "0":
          if operacion == "-":
               sequence_formula = "-"
               _actualizar_secuencia()
          return
     
     var last_symb = sequence_formula.right(1)
     if last_symb in ["+", "-", "*", "/"]:
          sequence_formula = sequence_formula.left(sequence_formula.length() - 1) + operacion
     else:
          sequence_formula += operacion
          
     _actualizar_secuencia()
     #_calculate_realtime()
     
func handle_delete():
     if sequence_formula.length() > 0 and sequence_formula != "0":
          var remover_val = sequence_formula.right(1)
          if remover_val == "(": open_parenthesis_count -= 1
          elif remover_val == ")": open_parenthesis_count += 1
          
          sequence_formula = sequence_formula.left(sequence_formula.length() - 1)
          
     if sequence_formula == "" or sequence_formula == "-":
          sequence_formula = "0"
     _actualizar_secuencia()
     _calculate_realtime()
     
func handle_percentage():
     var last_val = sequence_formula.right(1)
     if last_val.is_valid_int() or last_val== ")":
          sequence_formula += "/100.0"
               
     _actualizar_secuencia()
     _calculate_realtime()
     
func _format_result(value: float) -> String:
     if value == int(value):
          return str(int(value))
     else:
          return str(snapped(value, 0.000001))
     
func calcular_unidad(operacion: String):
     if sequence_formula == "0" or sequence_formula == "":
          return
          
     var regex = RegEx.new()
     regex.compile("([0-9.]+)$")
     var resultado = regex.search(sequence_formula)
     
     if resultado:
          var ultimo_numero = resultado.get_string()
          var secuencia = sequence_formula.left(sequence_formula.length() - ultimo_numero.length())
          sequence_formula = secuencia + operacion + "(" + ultimo_numero + ")"
    
     _actualizar_secuencia()
     _calculate_realtime()
     
func handle_decimal():
     var last_val = sequence_formula.right(1)
     if last_val.is_valid_int() or sequence_formula == "":
          sequence_formula += "."
     
     _actualizar_secuencia()
               
func limpiar_calculadora():
     sequence_formula = "0"
     open_parenthesis_count = 0
     _actualizar_secuencia()
     result_txt.text = "0"
     result_txt.hide()
     
func handle_parentesis():
     if sequence_formula == "0" or sequence_formula == "":
          sequence_formula = "("
          open_parenthesis_count += 1
          _actualizar_secuencia()
          return
          
     var last_val = sequence_formula.right(1)
          
     if open_parenthesis_count > 0 and not (last_val in ["+", "-", "*", "/", "("]):
          sequence_formula += ")"
          open_parenthesis_count -= 1
     else:
          if last_val.is_valid_int() or last_val == ")":
               sequence_formula += "*("
          else:
               sequence_formula += "("
          #current_input += ")"
          open_parenthesis_count += 1
     
     _actualizar_secuencia()
     _calculate_realtime()
     
func toggle_simbol():
     if sequence_formula != "0" and sequence_formula != "":
          if sequence_formula.begins_with("-(") and sequence_formula.ends_with(")"):
               sequence_formula = sequence_formula.substr(2, sequence_formula.length() - 3)
          else:
               sequence_formula = "-(" + sequence_formula + ")"
               
     _actualizar_secuencia()
     _calculate_realtime()
     
func _calcular_resultado():
     var final_result = _parse_and_solve(sequence_formula)
     
     if final_result != "Error":
          sequence_formula = final_result
          _actualizar_secuencia()
          #result_txt.text = "0"
     else:
          result_txt.text = "Error de sintaxis"
     
func _calculate_realtime():
     if sequence_formula == "" or sequence_formula == "0":
          result_txt.hide()
          return
     
     if sequence_formula.right(1) in ["+", "-", "*", "/"]:
          return
     
     var result = _parse_and_solve(sequence_formula) 
     if result != "Error":
          result_txt.show()
          result_txt.text = "[b]" + result + "[/b]"
     
func _parse_and_solve(expresion: String) -> String:
     var tech_exp = expresion
     for i in range(open_parenthesis_count):
          tech_exp += ")"
          
     var expression = Expression.new()
     var error = expression.parse(tech_exp)
     
     if error != OK:
          return "Error"
     
     var result = expression.execute([], null, false)
     if expression.has_execute_failed():
          return "Error"
          
     return _format_result(result)

func _actualizar_secuencia():
     operacion_txt.text = sequence_formula
     operacion_txt.caret_column = sequence_formula.length()

func _on_button_raiz_pressed() -> void:
     calcular_unidad("sqrt")

func _on_button_parentesis_pressed() -> void:
     handle_parentesis()

func _on_button_viceversa_pressed() -> void:
     toggle_simbol()
     
func _on_button_cos_pressed() -> void:
     calcular_unidad("cos")

func _on_button_tan_pressed() -> void:
     calcular_unidad("tan")

func _on_bt_advanced_mode_toggled(toggled_on: bool) -> void:
     is_show_advc = toggled_on
     
     if is_show_advc:
          box_advanced_ops.show()
     else:
          box_advanced_ops.hide()
