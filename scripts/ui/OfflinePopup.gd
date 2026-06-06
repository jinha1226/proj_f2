extends Panel
## 오프라인 적립 금액을 보여주는 간단 팝업. 탭하면 닫힘.

@onready var _label: Label = $Label

func _ready() -> void:
	hide()
	gui_input.connect(_on_input)

func show_earnings(amount: float) -> void:
	if amount <= 0.0:
		return
	_label.text = "그동안 🌸 %d 모았어요!" % int(amount)
	show()

func _on_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		hide()
