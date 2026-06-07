class_name Grid
extends RefCounted
## 정원 타일 좌표 공용 헬퍼. 심기 모드에서 타일에 스냅해 열 맞춰 심는다.

const TILE := 120.0
const AREA := Rect2(150, 200, 1880, 3200)  # 타일 영역(월드 좌표)

static func cols() -> int:
	return int(AREA.size.x / TILE)

static func rows() -> int:
	return int(AREA.size.y / TILE)

## 월드 좌표 → 타일 인덱스.
static func cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		int(floor((pos.x - AREA.position.x) / TILE)),
		int(floor((pos.y - AREA.position.y) / TILE)))

## 타일 인덱스 → 타일 중심(월드 좌표).
static func center(c: Vector2i) -> Vector2:
	return AREA.position + Vector2((c.x + 0.5) * TILE, (c.y + 0.5) * TILE)

static func in_bounds(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < cols() and c.y < rows()
