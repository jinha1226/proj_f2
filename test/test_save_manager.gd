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
