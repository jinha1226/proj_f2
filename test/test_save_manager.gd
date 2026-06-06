extends GutTest

var gm
var sm

func before_each():
	gm = preload("res://scripts/GameManager.gd").new()
	add_child_autoqfree(gm)
	gm.reset_state()
	sm = preload("res://scripts/SaveManager.gd").new()
	add_child_autoqfree(sm)

func test_to_dict_captures_state():
	gm.pollen = 123.0
	gm.flower_levels["daisy"] = 2
	gm.producer_counts["bee"] = 3
	var d = sm.to_dict(gm, 1000)
	assert_eq(d["pollen"], 123.0)
	assert_eq(d["flower_levels"]["daisy"], 2)
	assert_eq(d["producer_counts"]["bee"], 3)
	assert_eq(d["saved_at"], 1000)

func test_apply_dict_restores_state():
	var d = {
		"pollen": 77.0,
		"flower_levels": {"daisy": 1, "tulip": 0, "rose": 0},
		"producer_counts": {"bee": 4, "butterfly": 0},
		"saved_at": 500,
	}
	sm.apply_dict(gm, d)
	assert_eq(gm.pollen, 77.0)
	assert_eq(gm.flower_levels["daisy"], 1)
	assert_eq(gm.producer_counts["bee"], 4)

func test_offline_earnings_basic():
	# 초당 2, 100초 경과 → 200
	var earned = sm.offline_earnings(2.0, 1000, 1100)
	assert_eq(earned, 200.0)

func test_offline_earnings_capped():
	# 초당 1, 10000초 경과지만 캡 7200초 → 7200
	var earned = sm.offline_earnings(1.0, 0, 10000)
	assert_eq(earned, 7200.0)

func test_offline_earnings_zero_rate():
	assert_eq(sm.offline_earnings(0.0, 0, 5000), 0.0)

func test_offline_earnings_no_negative_time():
	# 시계 역행 등으로 now < saved_at 이면 0
	assert_eq(sm.offline_earnings(5.0, 1000, 500), 0.0)

func test_save_and_load_roundtrip():
	gm.pollen = 42.0
	gm.producer_counts["bee"] = 2
	sm.save_game(gm, 1234)
	gm.reset_state()
	var loaded = sm.load_game(gm)
	assert_true(loaded, "저장 파일이 있으면 true")
	assert_eq(gm.pollen, 42.0)
	assert_eq(gm.producer_counts["bee"], 2)
	assert_eq(sm.last_saved_at, 1234)

func test_load_returns_false_when_no_file():
	# 파일 없는 상태 보장
	if FileAccess.file_exists(sm.SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(sm.SAVE_PATH))
	assert_false(sm.load_game(gm))
