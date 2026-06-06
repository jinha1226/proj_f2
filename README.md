# Flower Clicker (MVP)

꽃 테마 캐주얼 클리커. 탭으로 꽃가루를 모아 꽃 업그레이드/자동 생산기에 재투자.

## 실행 (Windows Godot 에디터/플레이)
Godot_v4.6.2-stable_win64.exe --path .

## 테스트 (Linux 헤드리스, GUT)
GODOT_SILENCE_ROOT_WARNING=1 godot --headless -s res://addons/gut/gut_cmdln.gd -gconfig=res://.gutconfig.json

## 구조
- scripts/GameData.gd — 밸런스 데이터 테이블 (꽃3/생산기2, 1.15배 가격곡선)
- scripts/GameManager.gd — 게임 상태/로직 (autoload): tap, buy_upgrade, buy_producer, per_sec, 자동생산
- scripts/SaveManager.gd — JSON 저장 + 오프라인 적립(2시간 캡) (autoload)
- scenes/Main.tscn — 메인 씬 (중앙 꽃, 상점, 생산기 레이어, 오프라인 팝업)
- scripts/ui/ — UI 컨트롤러들
- test/ — GUT 단위 테스트 (25개)

## 현황
비주얼은 도형 프로토타입(파스텔 사각형). 루프 검증 후 AI 생성 스프라이트로 교체 예정.
머지/수익화/프레스티지는 범위 밖(향후).
