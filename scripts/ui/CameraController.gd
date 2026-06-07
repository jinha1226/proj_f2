extends Camera2D
## 큰 월드를 비추는 카메라. 한 손가락 드래그=이동(슬라이드), 두 손가락 핀치=줌,
## 짧게 누르면(거의 안 움직이면)=탭으로 꽃가루 수집. 데스크톱은 마우스 드래그/휠/클릭.

const WORLD := Rect2(0, 0, 2160, 3600)
const ZOOM_MIN := 0.45   # 더 작게 = 더 넓게 보임
const ZOOM_MAX := 2.2
const TAP_MOVE_THRESHOLD := 18.0
const FLOATING := preload("res://scenes/FloatingText.tscn")

var _touches := {}        # index -> 현재 위치
var _moved := 0.0
var _did_pinch := false
var _last_dist := 0.0

func _ready() -> void:
	make_current()
	zoom = Vector2.ONE
	# 시작은 월드 중앙-상단
	position = Vector2(WORLD.size.x * 0.5, get_viewport_rect().size.y * 0.5 + 40.0)
	_clamp()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_on_touch(event)
	elif event is InputEventScreenDrag:
		_on_drag(event)
	elif event is InputEventMouseButton:
		_on_mouse_button(event)
	elif event is InputEventMouseMotion and (event.button_mask & MOUSE_BUTTON_MASK_LEFT):
		_pan(event.relative)
		_moved += event.relative.length()

# --- 터치 ---
func _on_touch(e: InputEventScreenTouch) -> void:
	if e.pressed:
		_touches[e.index] = e.position
		if _touches.size() == 1:
			_moved = 0.0
			_did_pinch = false
	else:
		_touches.erase(e.index)
		_last_dist = 0.0
		if _touches.is_empty() and not _did_pinch and _moved < TAP_MOVE_THRESHOLD:
			_tap(e.position)

func _on_drag(e: InputEventScreenDrag) -> void:
	_touches[e.index] = e.position
	if _touches.size() >= 2:
		_did_pinch = true
		_pinch()
	else:
		_pan(e.relative)
		_moved += e.relative.length()

func _pinch() -> void:
	var pts = _touches.values()
	var d: float = pts[0].distance_to(pts[1])
	if _last_dist > 0.0 and d > 0.0:
		_zoom_by(d / _last_dist)
	_last_dist = d

# --- 마우스 ---
func _on_mouse_button(e: InputEventMouseButton) -> void:
	if e.button_index == MOUSE_BUTTON_WHEEL_UP and e.pressed:
		_zoom_by(1.1)
	elif e.button_index == MOUSE_BUTTON_WHEEL_DOWN and e.pressed:
		_zoom_by(1.0 / 1.1)
	elif e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			_moved = 0.0
			_did_pinch = false
		elif _moved < TAP_MOVE_THRESHOLD:
			_tap(e.position)

# --- 공통 ---
func _pan(screen_delta: Vector2) -> void:
	position -= screen_delta / zoom
	_clamp()

func _zoom_by(factor: float) -> void:
	var z: float = clampf(zoom.x * factor, ZOOM_MIN, ZOOM_MAX)
	zoom = Vector2(z, z)
	_clamp()

func _clamp() -> void:
	var half := get_viewport_rect().size / (2.0 * zoom)
	var minx := WORLD.position.x + half.x
	var maxx := WORLD.end.x - half.x
	var miny := WORLD.position.y + half.y
	var maxy := WORLD.end.y - half.y
	position.x = (WORLD.position.x + WORLD.size.x * 0.5) if minx > maxx else clampf(position.x, minx, maxx)
	position.y = (WORLD.position.y + WORLD.size.y * 0.5) if miny > maxy else clampf(position.y, miny, maxy)

func _screen_to_world(sp: Vector2) -> Vector2:
	return position + (sp - get_viewport_rect().size * 0.5) / zoom

func _tap(screen_pos: Vector2) -> void:
	var wp := _screen_to_world(screen_pos)
	if PlantMode.is_active():
		# 심기 모드: 탭한 자리에 꽃 심기(잔액 부족이면 무시)
		GameManager.plant_flower(PlantMode.active_id, wp)
		return
	var gained := GameManager.tap_power()
	GameManager.tap()
	var ft = FLOATING.instantiate()
	get_parent().add_child(ft)
	ft.show_amount(gained, wp)
