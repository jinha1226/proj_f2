extends Control
## 들판 전체를 덮는 탭 영역. 아무 곳이나 탭하면 꽃가루 획득 + "+N" 표시.
## 상점/상단바/팝업은 트리상 더 위(나중)라 그쪽 입력이 우선된다.

const FLOATING := preload("res://scenes/FloatingText.tscn")

func _ready() -> void:
	gui_input.connect(_on_input)

func _on_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.pressed:
		_tap(global_position + event.position)
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_tap(global_position + event.position)

func _tap(gpos: Vector2) -> void:
	var gained := GameManager.tap_power()
	GameManager.tap()
	var ft = FLOATING.instantiate()
	get_tree().current_scene.add_child(ft)
	ft.show_amount(gained, gpos)
