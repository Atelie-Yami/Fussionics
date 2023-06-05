class_name CampaignBook extends RefCounted

enum Saga {
	MAKINO, CHAM_INK, WILLO
}
enum PhaseConfig {
	NORMAL, MINIBOSS_A, MINIBOSS_B, MINIBOSS_C, BOSS
}
enum Campagn {
	NAME, PHASES_CONFIG, SKINS, SKINS_BACKGROUND, BOTS, COLOR, WIDGETS, DROPS, LEVEL_CONFIG
}

class Widget:
	var atomic_number: int
	var ranking: BaseEffect.Ranking
	func _init(a, r):
		atomic_number = a; ranking = r

class LevelConfig:
	var level: PhaseConfig
	var widgets: Array[Widget]
	var drops: Array[Widget]
	func _init(l, w, d):
		level = l; widgets = w; drops = d


static var SAGAS := [
	LevelConfig.new( # MAKINO
		PhaseConfig.NORMAL,
		[
			Widget.new(0, BaseEffect.Ranking.NORMAL),
			Widget.new(1, BaseEffect.Ranking.IMPROVED)
		], [
			Widget.new(0, BaseEffect.Ranking.IMPROVED)
		],
	),
	LevelConfig.new( # CHAM_INK
		PhaseConfig.NORMAL,
		[
			Widget.new(0, BaseEffect.Ranking.NORMAL),
			Widget.new(1, BaseEffect.Ranking.IMPROVED)
		], [
			Widget.new(0, BaseEffect.Ranking.IMPROVED)
		],
	),
	LevelConfig.new( # WILLO
		PhaseConfig.NORMAL,
		[
			Widget.new(0, BaseEffect.Ranking.NORMAL),
			Widget.new(1, BaseEffect.Ranking.IMPROVED)
		], [
			Widget.new(0, BaseEffect.Ranking.IMPROVED)
		],
	)
]

