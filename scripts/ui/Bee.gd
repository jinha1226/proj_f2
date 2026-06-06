extends Node2D
## 들판을 자유롭게 배회하는 생산기(벌/나비). 목표점을 향해 날아가다
## 도착하면 새 목표점을 고른다(자연스러운 방랑). 코드로 그린다.

var kind: String = "bee"
var _bounds: Rect2
var _target: Vector2
var _speed: float = 140.0

func setup(p_kind: String, bounds: Rect2) -> void:
	kind = p_kind
	_bounds = bounds
	position = _rand_point()
	_target = _rand_point()
	_speed = 110.0 + randf() * 90.0
	queue_redraw()

func _rand_point() -> Vector2:
	return Vector2(
		_bounds.position.x + randf() * _bounds.size.x,
		_bounds.position.y + randf() * _bounds.size.y)

func _process(delta: float) -> void:
	var to := _target - position
	var dist := to.length()
	if dist < 10.0:
		_target = _rand_point()
	else:
		position += to / dist * min(_speed * delta, dist)

## 미니멀 픽셀: 벌 = 노란 블록 한 칸, 나비 = 보라 블록 두 칸.
const SIZE := 8.0  # 블록 한 칸 크기(px)

func _draw() -> void:
	if kind == "butterfly":
		draw_rect(Rect2(-SIZE, -SIZE * 0.5, SIZE, SIZE), Color(0.62, 0.42, 1.0), true)
		draw_rect(Rect2(0, -SIZE * 0.5, SIZE, SIZE), Color(0.78, 0.6, 1.0), true)
	else:
		draw_rect(Rect2(-SIZE * 0.5, -SIZE * 0.5, SIZE, SIZE), Color(1, 0.85, 0.15), true)
