extends GutTest

func test_has_three_flowers():
	assert_eq(GameData.FLOWERS.size(), 3, "꽃 3종이어야 함")

func test_has_two_producers():
	assert_eq(GameData.PRODUCERS.size(), 2, "생산기 2종이어야 함")

func test_daisy_base_values():
	var d = GameData.FLOWERS["daisy"]
	assert_eq(d["base_cost"], 10)
	assert_eq(d["tap_power"], 1)

func test_price_curve_grows_1_15x():
	# 기본가 10, 1.15배 곡선. level=0 → 10, level=1 → 11(=10*1.15 내림)
	assert_eq(GameData.cost_at(10, 0), 10)
	assert_eq(GameData.cost_at(10, 1), 11)
	assert_eq(GameData.cost_at(100, 2), 132)  # 100*1.15^2 = 132.25 → 132
