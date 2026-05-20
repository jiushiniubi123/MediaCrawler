-- ============================================================
-- Civ6 Wonder Rebalance Mod - Gameplay Data
-- ============================================================

-- ============================================================
-- SECTION 1: CLEANUP - 清理原版效果
-- ============================================================

DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_BIG_BEN' AND ModifierId='BIG_BEN_DOUBLE_TREASURY';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_UNIVERSITY_SANKORE' AND ModifierId='SANKORE_TRADE_ROUTE_SCIENCE';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_UNIVERSITY_SANKORE' AND ModifierId='SANKORE_TRADE_ROUTE_FAITH';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_HANGING_GARDENS' AND ModifierId='HANGING_GARDENS_GROWTH';
DELETE FROM BuildingModifiers WHERE BuildingType='BUILDING_STATUE_OF_ZEUS' AND ModifierId='STATUE_ZEUS_ANTI_CAVALRY_PRODUCTION';
DELETE FROM Building_RequiredBuildings WHERE BuildingType='BUILDING_BIG_BEN';
DELETE FROM Building_RequiredBuildings WHERE BuildingType='BUILDING_STATUE_OF_ZEUS';
DELETE FROM Building_RequiredBuildings WHERE BuildingType='BUILDING_COLOSSEUM';
DELETE FROM Building_RequiredFeatures WHERE BuildingType='BUILDING_JEBEL_BARKAL';
DELETE FROM Building_RequiredFeatures WHERE BuildingType='BUILDING_MACHU_PICCHU';
DELETE FROM Building_ValidFeatures WHERE BuildingType='BUILDING_JEBEL_BARKAL' AND FeatureType='FEATURE_DESERT_HILLS';

UPDATE Buildings SET Housing=3 WHERE BuildingType='BUILDING_HANGING_GARDENS';

UPDATE ModifierArguments SET Value='2' WHERE ModifierId='STATUE_OF_ZEUS_GRANT_SPEARMEN' AND Name='Amount';
UPDATE ModifierArguments SET Value='2' WHERE ModifierId='STATUE_OF_ZEUS_GRANT_ARCHERS' AND Name='Amount';
UPDATE ModifierArguments SET Value='1' WHERE ModifierId='STATUE_OF_ZEUS_GRANT_BATTERING_RAM' AND Name='Amount';

UPDATE ModifierArguments SET Value='10' WHERE ModifierId IN (
    'KILWA_KISIWANI_CITY_STATE_BONUS_FOOD','KILWA_KISIWANI_CITY_STATE_BONUS_PRODUCTION',
    'KILWA_KISIWANI_CITY_STATE_BONUS_GOLD','KILWA_KISIWANI_CITY_STATE_BONUS_SCIENCE',
    'KILWA_KISIWANI_CITY_STATE_BONUS_CULTURE','KILWA_KISIWANI_CITY_STATE_BONUS_FAITH',
    'KILWA_KISIWANI_CITY_STATE_BONUS_FOOD_DOUBLE','KILWA_KISIWANI_CITY_STATE_BONUS_PRODUCTION_DOUBLE',
    'KILWA_KISIWANI_CITY_STATE_BONUS_GOLD_DOUBLE','KILWA_KISIWANI_CITY_STATE_BONUS_SCIENCE_DOUBLE',
    'KILWA_KISIWANI_CITY_STATE_BONUS_CULTURE_DOUBLE','KILWA_KISIWANI_CITY_STATE_BONUS_FAITH_DOUBLE'
) AND Name='Amount';

-- ============================================================
-- SECTION 2: REQUIREMENTS
-- ============================================================

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_UNIT_IS_WARRIOR_MONK', 'REQUIREMENT_UNIT_TYPE_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_UNIT_IS_WARRIOR_MONK', 'UnitType', 'UNIT_WARRIOR_MONK');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_PLOT_HAS_FOREST', 'REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_PLOT_HAS_FOREST', 'FeatureType', 'FEATURE_FOREST');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_DISTRICT_IS_IZ', 'REQUIREMENT_DISTRICT_TYPE_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_DISTRICT_IS_IZ', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_BUILDING_IS_BARRACKS', 'REQUIREMENT_BUILDING_TYPE_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_BUILDING_IS_BARRACKS', 'BuildingType', 'BUILDING_BARRACKS');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_UNIT_IS_LAND_COMBAT', 'REQUIREMENT_UNIT_DOMAIN_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_UNIT_IS_LAND_COMBAT', 'UnitDomain', 'DOMAIN_LAND');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_CITY_HAS_BUILDING_WONDER', 'REQUIREMENT_CITY_HAS_BUILDING');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_CITY_HAS_BUILDING_WONDER', 'BuildingType', 'BUILDING_TAJ_MAHAL');

INSERT OR REPLACE INTO Requirements (RequirementId, RequirementType) VALUES ('REQ_WR_UNIT_IS_RELIGIOUS', 'REQUIREMENT_UNIT_FORMATION_CLASS_MATCHES');
INSERT OR REPLACE INTO RequirementArguments (RequirementId, Name, Value) VALUES ('REQ_WR_UNIT_IS_RELIGIOUS', 'UnitFormationClass', 'FORMATION_CLASS_RELIGIOUS');

-- ============================================================
-- SECTION 3: REQUIREMENT SETS
-- ============================================================

INSERT OR REPLACE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('REQSET_WR_STONEHENGE_HEAL', 'REQUIREMENTSET_TEST_ALL');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_STONEHENGE_HEAL', 'PLOT_ADJACENT_FRIENDLY_REQUIREMENT');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_STONEHENGE_HEAL', 'REQ_WR_UNIT_IS_LAND_COMBAT');

INSERT OR REPLACE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('REQSET_WR_STONEHENGE_HEAL_FAITH', 'REQUIREMENTSET_TEST_ALL');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_STONEHENGE_HEAL_FAITH', 'PLOT_ADJACENT_FRIENDLY_REQUIREMENT');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_STONEHENGE_HEAL_FAITH', 'REQ_WR_UNIT_IS_RELIGIOUS');

INSERT OR REPLACE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('REQSET_WR_FOREST', 'REQUIREMENTSET_TEST_ALL');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_FOREST', 'REQ_WR_PLOT_HAS_FOREST');

INSERT OR REPLACE INTO RequirementSets (RequirementSetId, RequirementSetType) VALUES ('REQSET_WR_WARRIOR_MONK', 'REQUIREMENTSET_TEST_ALL');
INSERT OR REPLACE INTO RequirementSetRequirements (RequirementSetId, RequirementId) VALUES ('REQSET_WR_WARRIOR_MONK', 'REQ_WR_UNIT_IS_WARRIOR_MONK');

-- ============================================================
-- SECTION 4: MODIFIERS
-- ============================================================

-- 4.1 大浴场: 水磨信仰购买
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_GREAT_BATH_FAITH_PURCHASE_WATERMILL', 'MODIFIER_PLAYER_CITIES_ENABLE_BUILDING_FAITH_PURCHASE', NULL);

-- 4.2 空中花园: +2宜居度
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_HANGING_GARDENS_AMENITY', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_AMENITIES', NULL);

-- 4.3 空中花园: +15%粮食
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_HANGING_GARDENS_FOOD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', NULL);

-- 4.4 巨石阵: 相邻战斗单位回血
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_STONEHENGE_HEAL_COMBAT', 'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN', 'REQSET_WR_STONEHENGE_HEAL');

-- 4.5 巨石阵: 相邻信仰单位回血
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_STONEHENGE_HEAL_FAITH', 'MODIFIER_PLAYER_UNITS_ADJUST_HEAL_PER_TURN', 'REQSET_WR_STONEHENGE_HEAL_FAITH');

-- 4.6 大图书馆: 每人口+0.5科技
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_GREAT_LIBRARY_SCIENCE_PER_POP', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION', NULL);

-- 4.7 大本钟: +20%金币
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_BIG_BEN_GOLD_MODIFIER', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', NULL);

-- 4.8 摩诃菩提寺: 森林+2信仰
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_MAHABODHI_FOREST_FAITH', 'MODIFIER_SINGLE_CITY_ADJUST_PLOT_YIELD', 'REQSET_WR_FOREST');

-- 4.9 摩诃菩提寺: 森林+1食物
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_MAHABODHI_FOREST_FOOD', 'MODIFIER_SINGLE_CITY_ADJUST_PLOT_YIELD', 'REQSET_WR_FOREST');

-- 4.10 高德院: 武僧+10战斗力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_KOTOKU_IN_MONK_COMBAT', 'MODIFIER_PLAYER_UNITS_ADJUST_UNIT_COMBAT_STRENGTH', 'REQSET_WR_WARRIOR_MONK');

-- 4.11 高德院: 武僧跨河无惩罚
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_KOTOKU_IN_MONK_GRANT_ABILITY', 'MODIFIER_PLAYER_UNITS_GRANT_ABILITY', 'REQSET_WR_WARRIOR_MONK');

-- 4.12 圣索菲亚: 每人口+0.3文化
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_HAGIA_SOPHIA_CULTURE_PER_POP', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_POPULATION', NULL);

-- 4.13 博尔戈尔山: 军事单位+20%生产力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_JEBEL_BARKAL_MILITARY_PROD', 'MODIFIER_PLAYER_CITIES_ADJUST_MILITARY_UNITS_PRODUCTION', NULL);

-- 4.14 宙斯神像: 赠送2建造者
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_STATUE_ZEUS_GRANT_BUILDERS', 'MODIFIER_PLAYER_GRANT_UNIT_IN_CITY', NULL);

-- 4.15 宙斯神像: 军事单位返还信仰
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_STATUE_ZEUS_FAITH_ON_MILITARY', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_MODIFIER', NULL);

-- 4.16 兵马俑: 兵营+2生产力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TERRACOTTA_BARRACKS_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_BUILDING_YIELD_CHANGE', NULL);

-- 4.17 兵马俑: 六格内兵营+2生产力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TERRACOTTA_BARRACKS_RANGE_PROD', 'MODIFIER_PLAYER_CITIES_ADJUST_BUILDING_YIELD_CHANGE', NULL);

-- 4.18 桑科雷大学: +1商路
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_SANKORE_TRADE_ROUTE_CAPACITY', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_CAPACITY', NULL);

-- 4.19 桑科雷大学: 所有商路+1科技
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_SANKORE_TRADE_SCIENCE', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', NULL);

-- 4.20 桑科雷大学: 所有商路+2金币
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_SANKORE_TRADE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', NULL);

-- 4.21 威尼斯军械库: 工业区邻接→科技
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_VENETIAN_ARSENAL_IZ_TO_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_DISTRICT', NULL);

-- 4.22 泰姬陵: 每奇观+3科技
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TAJ_MAHAL_SCIENCE_PER_WONDER', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_DISTRICT', NULL);

-- 4.23 泰姬陵: 每奇观+3文化
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TAJ_MAHAL_CULTURE_PER_WONDER', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_PER_DISTRICT', NULL);

-- 4.24 泰姬陵: 地格奇观额外科技
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TAJ_MAHAL_WONDER_SCIENCE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_CHANGE', NULL);

-- 4.25 泰姬陵: 地格奇观额外文化
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_TAJ_MAHAL_WONDER_CULTURE', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_CHANGE', NULL);

-- 4.26 金门大桥: 每奇观商路+4金币
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_GOLDEN_GATE_TRADE_GOLD', 'MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD', NULL);

-- 4.27 休伊神庙: 无湖城市+2生产力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_HUEY_TEOCALLI_NO_LAKE_PROD', 'MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_CHANGE', NULL);

-- 4.28 佩特拉: 少沙漠+2粮食
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_PETRA_LOW_DESERT_FOOD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_CHANGE', NULL);

-- 4.29 奇琴伊察: 少雨林+2生产力
INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_CHICHEN_ITZA_LOW_JUNGLE_PROD', 'MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD_CHANGE', NULL);

-- ============================================================
-- SECTION 5: MODIFIER ARGUMENTS
-- ============================================================

-- 5.1 大浴场: 水磨信仰购买
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_GREAT_BATH_FAITH_PURCHASE_WATERMILL', 'BuildingType', 'BUILDING_WATER_MILL');

-- 5.2 空中花园: +2宜居度
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HANGING_GARDENS_AMENITY', 'Amount', '2');

-- 5.3 空中花园: +15%粮食
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HANGING_GARDENS_FOOD', 'YieldType', 'YIELD_FOOD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HANGING_GARDENS_FOOD', 'Amount', '15');

-- 5.4 巨石阵: 战斗单位回满血
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STONEHENGE_HEAL_COMBAT', 'Amount', '100');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STONEHENGE_HEAL_COMBAT', 'Type', 'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_FROM_COMBAT');

-- 5.5 巨石阵: 信仰单位回满血
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STONEHENGE_HEAL_FAITH', 'Amount', '100');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STONEHENGE_HEAL_FAITH', 'Type', 'MODIFIER_PLAYER_UNIT_ADJUST_HEAL_FROM_COMBAT');

-- 5.6 大图书馆: 每人口+0.5科技
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_GREAT_LIBRARY_SCIENCE_PER_POP', 'YieldType', 'YIELD_SCIENCE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_GREAT_LIBRARY_SCIENCE_PER_POP', 'Amount', '0.5');

-- 5.7 大本钟: +20%金币
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_BIG_BEN_GOLD_MODIFIER', 'YieldType', 'YIELD_GOLD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_BIG_BEN_GOLD_MODIFIER', 'Amount', '20');

-- 5.8 摩诃菩提寺: 森林+2信仰
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_MAHABODHI_FOREST_FAITH', 'YieldType', 'YIELD_FAITH');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_MAHABODHI_FOREST_FAITH', 'Amount', '2');

-- 5.9 摩诃菩提寺: 森林+1食物
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_MAHABODHI_FOREST_FOOD', 'YieldType', 'YIELD_FOOD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_MAHABODHI_FOREST_FOOD', 'Amount', '1');

-- 5.10 高德院: 武僧+10战斗力
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_KOTOKU_IN_MONK_COMBAT', 'Amount', '10');

-- 5.11 高德院: 武僧跨河无惩罚
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_KOTOKU_IN_MONK_GRANT_ABILITY', 'AbilityType', 'ABILITY_WR_MONK_IGNORE_RIVER');

-- 5.12 圣索菲亚: 每人口+0.3文化
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HAGIA_SOPHIA_CULTURE_PER_POP', 'YieldType', 'YIELD_CULTURE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HAGIA_SOPHIA_CULTURE_PER_POP', 'Amount', '0.3');

-- 5.13 博尔戈尔山: 军事单位+20%生产力
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_JEBEL_BARKAL_MILITARY_PROD', 'Amount', '20');

-- 5.14 宙斯神像: 赠送2建造者
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STATUE_ZEUS_GRANT_BUILDERS', 'UnitType', 'UNIT_BUILDER');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STATUE_ZEUS_GRANT_BUILDERS', 'Amount', '2');

-- 5.15 宙斯神像: 军事单位返还50%产能信仰
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STATUE_ZEUS_FAITH_ON_MILITARY', 'YieldType', 'YIELD_FAITH');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_STATUE_ZEUS_FAITH_ON_MILITARY', 'Amount', '50');

-- 5.16 兵马俑: 兵营+2生产力(本地)
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_PROD', 'BuildingType', 'BUILDING_BARRACKS');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_PROD', 'Amount', '2');

-- 5.17 兵马俑: 六格内兵营+2生产力
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_RANGE_PROD', 'BuildingType', 'BUILDING_BARRACKS');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_RANGE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TERRACOTTA_BARRACKS_RANGE_PROD', 'Amount', '2');

-- 5.18 桑科雷大学: +1商路
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_SANKORE_TRADE_ROUTE_CAPACITY', 'Amount', '1');

-- 5.19 桑科雷大学: 商路+1科技
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_SANKORE_TRADE_SCIENCE', 'YieldType', 'YIELD_SCIENCE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_SANKORE_TRADE_SCIENCE', 'Amount', '1');

-- 5.20 桑科雷大学: 商路+2金币
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_SANKORE_TRADE_GOLD', 'YieldType', 'YIELD_GOLD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_SANKORE_TRADE_GOLD', 'Amount', '2');

-- 5.21 威尼斯军械库: 工业区邻接→科技
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_VENETIAN_ARSENAL_IZ_TO_SCIENCE', 'DistrictType', 'DISTRICT_INDUSTRIAL_ZONE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_VENETIAN_ARSENAL_IZ_TO_SCIENCE', 'YieldType', 'YIELD_SCIENCE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_VENETIAN_ARSENAL_IZ_TO_SCIENCE', 'Amount', '1');

-- 5.22 泰姬陵: 每奇观+3科技/文化 (按区域计)
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_SCIENCE_PER_WONDER', 'DistrictType', 'DISTRICT_WONDER');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_SCIENCE_PER_WONDER', 'YieldType', 'YIELD_SCIENCE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_SCIENCE_PER_WONDER', 'Amount', '3');

INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_CULTURE_PER_WONDER', 'DistrictType', 'DISTRICT_WONDER');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_CULTURE_PER_WONDER', 'YieldType', 'YIELD_CULTURE');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_TAJ_MAHAL_CULTURE_PER_WONDER', 'Amount', '3');

-- 5.23 金门大桥: 每奇观商路+4金币
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_GOLDEN_GATE_TRADE_GOLD', 'YieldType', 'YIELD_GOLD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_GOLDEN_GATE_TRADE_GOLD', 'Amount', '4');

-- 5.24 休伊神庙: 无湖城市+2生产力
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HUEY_TEOCALLI_NO_LAKE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_HUEY_TEOCALLI_NO_LAKE_PROD', 'Amount', '2');

-- 5.25 佩特拉: 少沙漠+2粮食
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_PETRA_LOW_DESERT_FOOD', 'YieldType', 'YIELD_FOOD');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_PETRA_LOW_DESERT_FOOD', 'Amount', '2');

-- 5.26 奇琴伊察: 少雨林+2生产力
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_CHICHEN_ITZA_LOW_JUNGLE_PROD', 'YieldType', 'YIELD_PRODUCTION');
INSERT OR REPLACE INTO ModifierArguments (ModifierId, Name, Value) VALUES ('WR_CHICHEN_ITZA_LOW_JUNGLE_PROD', 'Amount', '2');

-- ============================================================
-- SECTION 6: BUILDING MODIFIERS - 绑定Modifier到奇观
-- ============================================================

-- 大浴场
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_GREAT_BATH', 'WR_GREAT_BATH_FAITH_PURCHASE_WATERMILL');

-- 空中花园
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_HANGING_GARDENS', 'WR_HANGING_GARDENS_AMENITY');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_HANGING_GARDENS', 'WR_HANGING_GARDENS_FOOD');

-- 巨石阵
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STONEHENGE', 'WR_STONEHENGE_HEAL_COMBAT');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STONEHENGE', 'WR_STONEHENGE_HEAL_FAITH');

-- 大图书馆
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_GREAT_LIBRARY', 'WR_GREAT_LIBRARY_SCIENCE_PER_POP');

-- 大本钟
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_BIG_BEN', 'WR_BIG_BEN_GOLD_MODIFIER');

-- 摩诃菩提寺
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MAHABODHI_TEMPLE', 'WR_MAHABODHI_FOREST_FAITH');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_MAHABODHI_TEMPLE', 'WR_MAHABODHI_FOREST_FOOD');

-- 高德院
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_KOTOKU_IN', 'WR_KOTOKU_IN_MONK_COMBAT');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_KOTOKU_IN', 'WR_KOTOKU_IN_MONK_GRANT_ABILITY');

-- 圣索菲亚大教堂
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_HAGIA_SOPHIA', 'WR_HAGIA_SOPHIA_CULTURE_PER_POP');

-- 博尔戈尔山
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_JEBEL_BARKAL', 'WR_JEBEL_BARKAL_MILITARY_PROD');

-- 宙斯神像
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STATUE_OF_ZEUS', 'WR_STATUE_ZEUS_GRANT_BUILDERS');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_STATUE_OF_ZEUS', 'WR_STATUE_ZEUS_FAITH_ON_MILITARY');

-- 兵马俑
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_TERRACOTTA_ARMY', 'WR_TERRACOTTA_BARRACKS_PROD');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_TERRACOTTA_ARMY', 'WR_TERRACOTTA_BARRACKS_RANGE_PROD');

-- 桑科雷大学
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_UNIVERSITY_SANKORE', 'WR_SANKORE_TRADE_ROUTE_CAPACITY');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_UNIVERSITY_SANKORE', 'WR_SANKORE_TRADE_SCIENCE');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_UNIVERSITY_SANKORE', 'WR_SANKORE_TRADE_GOLD');

-- 威尼斯军械库
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_VENETIAN_ARSENAL', 'WR_VENETIAN_ARSENAL_IZ_TO_SCIENCE');

-- 泰姬陵
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_TAJ_MAHAL', 'WR_TAJ_MAHAL_SCIENCE_PER_WONDER');
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_TAJ_MAHAL', 'WR_TAJ_MAHAL_CULTURE_PER_WONDER');

-- 金门大桥
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_GOLDEN_GATE_BRIDGE', 'WR_GOLDEN_GATE_TRADE_GOLD');

-- 休伊神庙
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_HUEY_TEOCALLI', 'WR_HUEY_TEOCALLI_NO_LAKE_PROD');

-- 佩特拉古城
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_PETRA', 'WR_PETRA_LOW_DESERT_FOOD');

-- 奇琴伊察
INSERT OR REPLACE INTO BuildingModifiers (BuildingType, ModifierId) VALUES ('BUILDING_CHICHEN_ITZA', 'WR_CHICHEN_ITZA_LOW_JUNGLE_PROD');

-- ============================================================
-- SECTION 7: UNIT ABILITIES - 单位能力 (高德院武僧跨河)
-- ============================================================

INSERT OR REPLACE INTO Types (Type, Kind) VALUES ('ABILITY_WR_MONK_IGNORE_RIVER', 'KIND_ABILITY');

INSERT OR REPLACE INTO TypeTags (Type, Tag) VALUES ('ABILITY_WR_MONK_IGNORE_RIVER', 'CLASS_WARRIOR_MONK');

INSERT OR REPLACE INTO UnitAbilities (UnitAbilityType, Name, Description, Inactive)
VALUES ('ABILITY_WR_MONK_IGNORE_RIVER', 'LOC_ABILITY_WR_MONK_IGNORE_RIVER_NAME', 'LOC_ABILITY_WR_MONK_IGNORE_RIVER_DESC', 0);

INSERT OR REPLACE INTO UnitAbilityModifiers (UnitAbilityType, ModifierId)
VALUES ('ABILITY_WR_MONK_IGNORE_RIVER', 'WR_MOD_MONK_IGNORE_RIVER');

INSERT OR REPLACE INTO Modifiers (ModifierId, ModifierType, SubjectRequirementSetId)
VALUES ('WR_MOD_MONK_IGNORE_RIVER', 'MODIFIER_PLAYER_UNIT_ADJUST_IGNORE_RIVERS', NULL);

-- ============================================================
-- SECTION 8: PLACEMENT CONDITION CHANGES - 放置条件变更
-- ============================================================

-- 博尔戈尔山: 允许在任何地块建造（只要有丘陵即可）
INSERT OR REPLACE INTO Building_ValidTerrains (BuildingType, TerrainType)
VALUES ('BUILDING_JEBEL_BARKAL', 'TERRAIN_DESERT_HILLS');

-- 马丘比丘: 改为需要丘陵 + 相邻市中心
INSERT OR REPLACE INTO Building_RequiredFeatures (BuildingType, FeatureType)
VALUES ('BUILDING_MACHU_PICCHU', 'FEATURE_HILL');

INSERT OR REPLACE INTO Building_RequiredAdjacentDistricts (BuildingType, DistrictType)
VALUES ('BUILDING_MACHU_PICCHU', 'DISTRICT_CITY_CENTER');

-- 移除宙斯神像兵营相邻要求
DELETE FROM Building_RequiredAdjacentDistricts WHERE BuildingType='BUILDING_STATUE_OF_ZEUS';

-- 罗马斗兽场: 移除娱乐中心相邻要求
DELETE FROM Building_RequiredAdjacentDistricts WHERE BuildingType='BUILDING_COLOSSEUM';