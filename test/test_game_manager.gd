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

func test_buy_upgrade_rejected_when_poor():
	gm.pollen = 5.0
	var ok = gm.buy_upgrade("daisy")
	assert_false(ok, "잔액 부족이면 거부")
	assert_eq(gm.pollen, 5.0, "거부 시 차감 없음")
	assert_eq(gm.flower_levels["daisy"], 0)

func test_buy_upgrade_succeeds_and_deducts():
	gm.pollen = 100.0
	var ok = gm.buy_upgrade("daisy")  # 첫 데이지 비용 10
	assert_true(ok)
	assert_eq(gm.pollen, 90.0, "비용 10 차감")
	assert_eq(gm.flower_levels["daisy"], 1)

func test_buy_upgrade_increases_tap_power():
	gm.pollen = 100.0
	gm.buy_upgrade("daisy")  # tap_power +1
	assert_eq(gm.tap_power(), 2, "기본1 + 데이지1")

func test_buy_upgrade_price_rises():
	gm.pollen = 1000.0
	gm.buy_upgrade("daisy")  # 10
	gm.buy_upgrade("daisy")  # 11 (10*1.15)
	assert_eq(gm.pollen, 1000.0 - 10 - 11)
