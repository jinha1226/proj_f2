extends Panel
## 오프라인 적립 금액 팝업. 명시적 "닫기" 버튼 + 아무 곳이나 탭/클릭으로 닫힘.

@onready var _label: Label = $Label
var _close_btn: Button

func _ready() -> void:
	hide()
	gui_input.connect(_on_input)
	_close_btn = Button.new()
	_close_btn.text = "닫기"
	_close_btn.custom_minimum_size = Vector2(160, 72)
	add_child(_close_btn)
	# 패널 하단 중앙에 배치
	_close_btn.position = Vector2(size.x * 0.5 - 80, size.y - 88)
	_close_btn.pressed.connect(_close)

func show_earnings(amount: float) -> void:
	if amount <= 0.0:
		return
	_label.text = "그동안 🌸 %d 모았어요!" % int(amount)
	show()

func _close() -> void:
	hide()

## 데스크톱(마우스)·모바일(터치) 모두 닫기 지원.
func _on_input(event: InputEvent) -> void:
	var is_press: bool = (event is InputEventScreenTouch and event.pressed) \
		or (event is InputEventMouseButton and event.pressed)
	if is_press:
		_close()
