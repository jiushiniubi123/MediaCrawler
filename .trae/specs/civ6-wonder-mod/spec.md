# 文明6奇观增强MOD Spec

## Why
原版文明6中有部分奇观性价比较低，在游戏中很少被玩家选择建造。本MOD对21个奇观进行效果增强和条件优化，让每个奇观更有吸引力，增加游戏的策略多样性和可玩性。

## What Changes
以下是对21个奇观的修改，每个修改都经过可行性分析：

### 1. 大浴场 (Great Bath)
- **原版效果**：+1住房，+1宜居度，沿河单元格免受洪水损害，洪水后地块+1信仰
- **新增**：水磨可以信仰购买
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_BUILDING_CAN_BE_PURCHASED_WITH_FAITH` 或通过ModifierArguments设置 `PurchaseYield` 为 `YIELD_FAITH`，目标建筑为 `BUILDING_WATER_MILL`。

### 2. 空中花园 (Hanging Gardens)
- **原版效果**：所有城市+15%成长速度，+2住房
- **修改**：所在城市额外+15%粮食，提供的住房改为3，宜居度改为2
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_CITY_YIELD_MODIFIER` 加粮食百分比；`EFFECT_ADJUST_CITY_HOUSING` 改住房；`AMENITY_CITY_HOUSING` 或宜居度相关Modifier。

### 3. 巨石阵 (Stonehenge)
- **原版效果**：获得一个大先知（创立宗教），+2信仰
- **新增**：该奇观临近一格内战斗单位和信仰单位回合结束回满血
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_UNIT_HEAL_PER_TURN` 配合 `REQUIREMENT_PLOT_ADJACENT_FRIENDLY_TERRITORY` 和单位类型过滤（战斗单位+信仰单位），设置回复量为最大值。

### 4. 大图书馆 (Great Library)
- **原版效果**：+2科技，每回合+1大作家点数，其他文明招募大科学家时随机获得该时代一个科技提升
- **新增**：该城市每人口+0.5科技
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_CITY_YIELD_PER_POPULATION`，设置 `YieldType=YIELD_SCIENCE`，`Amount=0.5`。

### 5. 大本钟 (Big Ben)
- **原版效果**：需要银行，建成时国库金币翻倍，+1经济政策槽位，+3大商人点数
- **修改**：移除前置建筑要求（银行），移除建成时金币获得效果，新增该城市金币+20%
- **可行性**：✅ 可行。移除前置：在Wonder的SQL/XML中删除PrereqBuilding；金币百分比使用 `EFFECT_ADJUST_CITY_YIELD_MODIFIER`，`Amount=20`。

### 6. 摩诃菩提寺 (Mahabodhi Temple)
- **原版效果**：获得2个使徒，+2信仰，+1大先知点数
- **新增**：该城市森林地块+2信仰+1食物
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_PLOT_YIELD`，配合 `REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES`（`FEATURE_FOREST`），分别加信仰和食物。

### 7. 高德院 (Kotoku-in)
- **原版效果**：获得4个武僧，+1大先知点数
- **新增**：武僧+10战斗力，跨越河流无移动力惩罚
- **可行性**：✅ 可行。+10战斗力使用 `EFFECT_ADJUST_UNIT_COMBAT_STRENGTH` 针对 `UNIT_WARRIOR_MONK`；跨河无惩罚使用 `ABILITY_IGNORE_RIVER_CROSSING` 或相关Modifier绑定到武僧单位。

### 8. 圣索菲亚大教堂 (Hagia Sophia)
- **原版效果**：所有传教士和使徒+1传教次数，+4信仰，+2大先知点数
- **新增**：该城市每人口+0.3文化
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_CITY_YIELD_PER_POPULATION`，`YieldType=YIELD_CULTURE`，`Amount=0.3`。

### 9. 博尔戈尔山 (Jebel Barkal)
- **原版效果**：必须在沙漠丘陵建造，+4信仰，每回合+2铁，+4铁资源
- **新增**：移除建筑条件（沙漠丘陵），新增该城市生产军事单位时+20%生产力
- **可行性**：⚠️ 部分风险。移除放置条件需要修改Wonder的Placement条件（改为无）；军事单位生产力加成使用 `TRAIT_ADJUST_UNIT_PRODUCTION` 配合 `REQUIREMENT_UNIT_DOMAIN` 或 `REQUIREMENT_UNIT_TYPE_MATCHES` 过滤军事单位。**注意**：Jebel Barkal原版已由DLC引入（Nubia DLC），在不同扩展包中可能表现不同。基础游戏中可能不存在，需要确认目标版本。

### 10. 宙斯神像 (Statue of Zeus)
- **原版效果**：必须相邻兵营的军营区域，+3金币，反骑兵单位+50%生产力，赠送3矛兵3弓箭手1攻城锤
- **修改**：移除建筑条件，修改为获得2个矛兵、2个弓箭手、1个攻城锤、2个建造者，新增该城市生产军事单位时获得该单位产能50%的信仰
- **可行性**：⚠️ 部分风险。移除条件可行；修改赠送单位可行（修改 `ModifierArguments` 中的单位列表）；50%信仰返还通过 `EFFECT_ADJUST_CITY_YIELD_PER_PRODUCTION` 或使用 `EFFECT_GRANT_YIELD_BASED_ON_PRODUCTION` 类型的效果，配合军事单位过滤器。**注意**：这可能需要在生产完成时触发，需检查是否有现成的 `EFFECT_ADD_CITY_YIELD_PER_PRODUCTION_OF_UNIT` 类效果。

### 11. 兵马俑 (Terracotta Army)
- **原版效果**：必须相邻军营（兵营或马厩），+2大将军点数，所有现存陆军单位获得1次晋升
- **新增**：兵营+2生产力，六格内的兵营再+2生产力
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_BUILDING_YIELD_CHANGE` 为目标兵营加生产力（直接对城市内的兵营）；六格内使用 `REQUIREMENT_PLOT_ADJACENT_DISTANCE` 或 `COLLECTION_OWNER` 半径限制。

### 12. 桑科雷大学 (University of Sankore)
- **原版效果**：+1科技，+2信仰，+2大科学家点数，通往此城的商路+1科技+1信仰
- **修改**：移除原版商路效果，新增+1商路容量，所有商路+1科技/+2金币
- **可行性**：✅ 可行。移除原版效果：删除相应的Modifier；+1商路容量使用 `EFFECT_ADJUST_TRADE_ROUTE_CAPACITY`；商路加成使用 `EFFECT_ADJUST_PLAYER_TRADE_ROUTE_YIELD`。

### 13. 威尼斯军械库 (Venetian Arsenal)
- **原版效果**：必须相邻海岸和工业区，+2大工程师点数，训练海军单位时获得第二个复制单位
- **新增**：该城市工业区生产力加成等额转化为科技
- **可行性**：⚠️ 有挑战。需要将工业区（Industrial Zone）区域邻接加成（adjacency bonus）的生产力转换为科技。使用 `EFFECT_ADJUST_CITY_YIELD_MODIFIER` 基于相邻加成的转换比较困难。替代方案：使用 `EFFECT_GRANT_YIELD_BASED_ON_ADJACENCY_BONUS` 或自定义Modifier，将工业区产生的生产力等额加到科技上。可能需要使用 `REQUIREMENT_REQUIREMENTSET_IS_MET` 组合条件。

### 14. 泰姬陵 (Taj Mahal)
- **原版效果**：历史时刻+1时代分数，+1时代分数，+1大工程师点数
- **新增**：该城每一个奇观+3科技，+3文化
- **可行性**：✅ 可行。使用 `EFFECT_ADJUST_WONDER_YIELD_CHANGE` 或自定义 `MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD`，配合 `REQUIREMENT_CITY_HAS_WONDER` 的计数机制。更实际的做法是使用 `EFFECT_ADJUST_CITY_YIELD_MODIFIER` 基于奇观数量，但游戏内可能没有直接的"根据奇观数量加产出"内置效果。可用 `MODIFIER_PLAYER_CITIES_ADJUST_CITY_YIELD_PER_WONDER` 或通过 Lua 脚本实现。**备选方案**：直接为每个在该城市的奇观添加 `GrantYield`。

### 15. 金门大桥 (Golden Gate Bridge)
- **原版效果**：必须跨越海湾六角格，+3宜居度，所在城市改良设施和国家公园旅游业绩+100%
- **新增**：该城每个奇观为全部的商路+4金币
- **可行性**：⚠️ 有挑战。需要计算城市奇观数量并为每条商路增加金币。使用 `MODIFIER_PLAYER_ADJUST_TRADE_ROUTE_YIELD` 可以实现，但需要结合奇观计数。可能需要通过 Lua 脚本或使用 `COLLECTION_PLAYER_CITIES` 配合自定义需求集。

### 16. 罗马斗兽场 (Colosseum)
- **原版效果**：必须相邻拥有竞技场的娱乐中心，+2文化，6格内所有城市+3宜居度，+1大将军点数
- **修改**：移除建筑条件（需要娱乐中心和竞技场）
- **可行性**：✅ 可行。直接在SQL/XML中删除Colosseum的 `RequiresAdjacent` 和相关建筑需求即可。

### 17. 马丘比丘 (Machu Picchu)
- **原版效果**：必须相邻山脉，+4金币，所有商路+25%金币
- **修改**：建筑条件改为临近市中心的丘陵
- **可行性**：✅ 可行。修改放置条件：去掉 `REQUIRES_MOUNTAIN`，改为 `REQUIRES_HILL` + `REQUIRES_ADJACENT_CITY_CENTER` 或使用 `REQUIRES_PLOT_IS_HILLS` 和 `REQUIRES_PLOT_ADJACENT_TO_OWNER_CITY`。

### 18. 休伊神庙 (Huey Teocalli)
- **原版效果**：必须相邻湖泊，每相邻湖泊+1宜居度，全国每个湖泊+1粮食+1生产力
- **新增**：无湖泊的城市+2生产力
- **可行性**：⚠️ 有挑战。"无湖泊的城市"判断逻辑较复杂。实现方式：为所有没有湖泊单元格的城市添加生产力加成。需使用 `REQUIREMENT_CITY_HAS_NO_FEATURE`（`FEATURE_LAKE`）或自定义需求集合。或者简化为：为所有城市加+2生产力，再为有湖泊的城市移除加成（通过负值）。

### 19. 基尔瓦基斯瓦尼 (Kilwa Kisiwani)
- **原版效果**：必须相邻平坦海岸，+3使者，成为宗主国的每种城邦类型使该城对应产出+15%
- **修改**：两个15%的增幅改为10%
- **可行性**：✅ 可行。直接修改ModifierArguments中的Amount值从15到10。

### 20. 佩特拉古城 (Petra)
- **原版效果**：必须在平坦沙漠建造，所有沙漠地块+2粮食+2金币+1生产力
- **新增**：本城沙漠地块少于10时+2粮食
- **可行性**：✅ 可行。使用 `REQUIREMENT_COLLECTION_COUNT_LESS_THAN` 或自定义条件判断沙漠地块数量，配合 `MODIFIER_SINGLE_CITY_ADJUST_CITY_YIELD` 加粮食。

### 21. 奇琴伊察 (Chichen Itza)
- **原版效果**：必须在雨林建造，所有雨林地块+2文化+1生产力
- **新增**：本城雨林地块少于5时+2生产力
- **可行性**：✅ 可行。类似佩特拉古城的实现方式。

## Impact
- 受影响的文件：新建完整MOD结构
  - `Civ6WonderRebalance.modinfo`
  - `Data/Civ6WonderRebalance_Gameplay.xml` 或 `.sql`
  - `Data/Civ6WonderRebalance_Config.xml`
  - `Text/Civ6WonderRebalance_Text_zh_Hans.xml`（简体中文汉化）
- 受影响的游戏系统：奇观效果、建筑条件、放置条件、单位属性、商路系统
- 兼容性：需要确认目标游戏版本（基础版 / 迭起兴衰 / 风云变幻 / 全DLC），不同版本的奇观可能存在差异

## ADDED Requirements

### Requirement: 大浴场水磨信仰购买
系统应在拥有大浴场的城市中允许玩家使用信仰购买水磨建筑。

#### Scenario: 玩家拥有大浴场
- **WHEN** 玩家在拥有大浴场的城市查看建筑购买选项
- **THEN** 水磨应出现在信仰购买列表中

### Requirement: 空中花园效果增强
系统应将空中花园的住房调整为3、宜居度调整为2，并为所在城市提供+15%粮食加成。

#### Scenario: 建造空中花园
- **WHEN** 玩家完成空中花园的建造
- **THEN** 该城市获得+3住房、+2宜居度、+15%粮食加成（取代原版+2住房、所有城市+15%成长速度）

### Requirement: 巨石阵单位回复
系统应使巨石阵相邻一格内的战斗单位和信仰单位在回合结束时回复全部生命值。

#### Scenario: 单位站在巨石阵旁边
- **WHEN** 友方战斗单位或信仰单位在巨石阵相邻一格结束回合
- **THEN** 该单位回复全部生命值

### Requirement: 大图书馆每人口科技
系统应为拥有大图书馆的城市提供每人口+0.5科技的加成。

#### Scenario: 大图书馆城市人口增长
- **WHEN** 拥有大图书馆的城市人口增加
- **THEN** 该城市科技产出按人口×0.5增加

### Requirement: 大本钟效果重构
系统应移除大本钟对银行的前置要求，移除建成时的金币翻倍效果，新增该城市金币+20%。

#### Scenario: 建造大本钟
- **WHEN** 玩家解锁大本钟的建造且城市满足放置条件
- **THEN** 不再需要银行前置建筑，建成后城市金币产出+20%，不再获得国库翻倍金币

### Requirement: 摩诃菩提寺森林加成
系统应为拥有摩诃菩提寺的城市的森林地块提供+2信仰和+1食物。

#### Scenario: 摩诃菩提寺城市拥有森林
- **WHEN** 城市拥有摩诃菩提寺并存在森林地块
- **THEN** 这些森林地块额外产出+2信仰和+1食物

### Requirement: 高德院武僧强化
系统应为所有武僧单位提供+10战斗力和跨越河流无移动力惩罚的能力。

#### Scenario: 武僧战斗
- **WHEN** 玩家拥有高德院并训练武僧
- **THEN** 武僧获得+10战斗力加成且跨越河流不受移动力惩罚

### Requirement: 圣索菲亚大教堂每人口文化
系统应为拥有圣索菲亚大教堂的城市提供每人口+0.3文化的加成。

#### Scenario: 圣索菲亚城市人口增长
- **WHEN** 拥有圣索菲亚大教堂的城市人口增加
- **THEN** 该城市文化产出按人口×0.3增加

### Requirement: 博尔戈尔山军事生产力
系统应移除博尔戈尔山的沙漠丘陵放置限制，并为所在城市生产军事单位时提供+20%生产力。

#### Scenario: 建造博尔戈尔山后生产军事单位
- **WHEN** 玩家在拥有博尔戈尔山的城市生产军事单位
- **THEN** 该军事单位获得+20%生产力加成

### Requirement: 宙斯神像重构
系统应移除宙斯神像的兵营前置条件，改为赠送2矛兵、2弓箭手、1攻城锤、2建造者，新增生产军事单位时获得单位产能50%的信仰。

#### Scenario: 完成宙斯神像
- **WHEN** 玩家完成宙斯神像建造
- **THEN** 获得上述单位，且后续该城生产军事单位时返还50%产能的信仰

### Requirement: 兵马俑兵营加成
系统应为拥有兵马俑的城市中兵营建筑提供+2生产力，六格范围内的兵营再次+2生产力。

#### Scenario: 兵马俑城市兵营加成
- **WHEN** 玩家建成兵马俑
- **THEN** 该城市兵营+2生产力，六格内其他城市的兵营也+2生产力

### Requirement: 桑科雷大学商路重构
系统应移除桑科雷大学原版商路效果，新增+1商路容量，所有商路+1科技/+2金币。

#### Scenario: 建成桑科雷大学
- **WHEN** 玩家完成桑科雷大学建造
- **THEN** 获得+1商路容量，所有商路产出+1科技和+2金币

### Requirement: 威尼斯军械库科技转化
系统应为拥有威尼斯军械库的城市将工业区生产力邻接加成等额转化为科技。

#### Scenario: 威尼斯军械库城市的工业区
- **WHEN** 城市拥有威尼斯军械库且存在工业区
- **THEN** 工业区邻接加成的生产力等额加到科技产出上

### Requirement: 泰姬陵奇观加成
系统应为拥有泰姬陵的城市中每个奇观提供+3科技和+3文化。

#### Scenario: 泰姬陵城市多奇观
- **WHEN** 城市拥有泰姬陵和其他奇观
- **THEN** 每个奇观（包括泰姬陵自身）提供+3科技和+3文化

### Requirement: 金门大桥商路金币
系统应为拥有金门大桥的城市中每个奇观为全部商路提供+4金币。

#### Scenario: 金门大桥城市奇观商路加成
- **WHEN** 城市拥有金门大桥和若干奇观
- **THEN** 所有商路获得（奇观数量×4）的金币加成

### Requirement: 罗马斗兽场条件移除
系统应移除罗马斗兽场需要相邻娱乐中心和竞技场的建筑条件。

#### Scenario: 建造罗马斗兽场
- **WHEN** 玩家解锁罗马斗兽场
- **THEN** 只需满足基本的放置条件即可建造，不再需要娱乐中心和竞技场

### Requirement: 马丘比丘放置条件变更
系统应将马丘比丘的放置条件从"相邻山脉"改为"临近市中心的丘陵"。

#### Scenario: 放置马丘比丘
- **WHEN** 玩家选择马丘比丘的建造位置
- **THEN** 需要选择相邻市中心的丘陵地块

### Requirement: 休伊神庙无湖城市加成
系统应为没有湖泊单元格的城市提供+2生产力（当玩家拥有休伊神庙时）。

#### Scenario: 休伊神庙无湖加成
- **WHEN** 玩家拥有休伊神庙且某城市没有湖泊单元格
- **THEN** 该城市获得+2生产力

### Requirement: 基尔瓦基斯瓦尼数值调整
系统应将基尔瓦基斯瓦尼的城邦加成从15%降低到10%。

#### Scenario: 基尔瓦城邦加成
- **WHEN** 玩家拥有基尔瓦基斯瓦尼并成为某类型城邦的宗主国
- **THEN** 该类型城邦提供的对应产出加成从15%变为10%

### Requirement: 佩特拉古城少沙漠加成
系统应在佩特拉古城所在城市的沙漠地块少于10时提供+2粮食。

#### Scenario: 佩特拉城市沙漠少
- **WHEN** 佩特拉所在城市的沙漠地块数量少于10
- **THEN** 该城市获得+2粮食

### Requirement: 奇琴伊察少雨林加成
系统应在奇琴伊察所在城市的雨林地块少于5时提供+2生产力。

#### Scenario: 奇琴伊察城市雨林少
- **WHEN** 奇琴伊察所在城市的雨林地块少于5
- **THEN** 该城市获得+2生产力

## REMOVED Requirements
无。所有修改都是增量或替换，不删除任何奇观。