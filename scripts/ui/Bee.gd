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

func _draw() -> void:
	if kind == "butterfly":
		_draw_butterfly()
	else:
		_draw_bee()

func _draw_bee() -> void:
	# 날개
	draw_circle(Vector2(-7, -11), 11.0, Color(1, 1, 1, 0.6))
	draw_circle(Vector2(7, -11), 11.0, Color(1, 1, 1, 0.6))
	# 몸통
	draw_circle(Vector2.ZERO, 15.0, Color(1, 0.82, 0.15))
	# 줄무늬
	draw_rect(Rect2(-13, -5, 26, 3), Color(0.15, 0.12, 0.05))
	draw_rect(Rect2(-13, 2, 26, 3), Color(0.15, 0.12, 0.05))

func _draw_butterfly() -> void:
	var c := Color(0.6, 0.4, 1.0)
	var c2 := Color(0.78, 0.6, 1.0)
	# 양쪽 날개(위/아래)
	draw_circle(Vector2(-13, -5), 13.0, c)
	draw_circle(Vector2(-12, 11), 10.0, c2)
	draw_circle(Vector2(13, -5), 13.0, c)
	draw_circle(Vector2(12, 11), 10.0, c2)
	# 몸통
	draw_rect(Rect2(-2, -13, 4, 28), Color(0.2, 0.15, 0.3))
