extends GutTest

var gm

func before_each():
	# autoload 싱글톤을 직접 테스트하지 않고, 깨끗한 인스턴스로 테스트
	gm = preload("res://scripts/GameManager.gd").new()
	add_child_autoqfree(gm)
	gm.reset_state()

func test_starts_with_zero_pollen():
	assert_eq(gm.pollen, 0.0)

func test_tap_adds_base_power():
	gm.tap()
	assert_eq(gm.pollen, 1.0, "기본 탭은 +1")

func test_tap_emits_signal():
	watch_signals(gm)
	gm.tap()
	assert_signal_emitted(gm, "pollen_changed")
