# Tasks

## 阶段一：MOD基础架构
- [ ] Task 1: 创建MOD目录结构和modinfo文件
  - [ ] 创建MOD目录结构 `Civ6WonderRebalance/`
  - [ ] 创建 `Civ6WonderRebalance.modinfo` 文件，定义MOD元数据、组件列表和文件引用
  - [ ] 创建 `Data/` 和 `Text/` 子目录

## 阶段二：奇观效果实现（难度低，可并行）
- [ ] Task 2: 实现大浴场水磨信仰购买
  - [ ] 创建Modifier：允许信仰购买 `BUILDING_WATER_MILL`
  - [ ] 绑定到 `BUILDING_GREAT_BATH`
  - [ ] 输入数据：BUILDING_GREAT_BATH → BUILDING_WATER_MILL 信仰购买

- [ ] Task 3: 实现空中花园效果增强
  - [ ] 修改住房值为3（覆盖原版+2）
  - [ ] 添加+2宜居度Modifier
  - [ ] 添加所在城市+15%粮食Modifier
  - [ ] 移除原版所有城市+15%成长速度效果

- [ ] Task 4: 实现巨石阵单位回复
  - [ ] 创建范围1格的单位回血效果
  - [ ] 过滤：仅战斗单位和信仰单位
  - [ ] 设置回复量为最大生命值

- [ ] Task 5: 实现大图书馆每人口科技
  - [ ] 添加 `EFFECT_ADJUST_CITY_YIELD_PER_POPULATION` Modifier
  - [ ] YieldType=YIELD_SCIENCE, Amount=0.5

- [ ] Task 6: 实现大本钟效果重构
  - [ ] 移除PrereqBuilding（银行）
  - [ ] 移除建成时金币翻倍效果
  - [ ] 添加该城市金币+20% Modifier

- [ ] Task 7: 实现摩诃菩提寺森林加成
  - [ ] 添加森林地块+2信仰Modifier
  - [ ] 添加森林地块+1食物Modifier
  - [ ] 配合 REQUIREMENT_PLOT_FEATURE_TYPE_MATCHES (FEATURE_FOREST)

- [ ] Task 8: 实现高德院武僧强化
  - [ ] 添加武僧+10战斗力Modifier
  - [ ] 添加武僧跨越河流无惩罚Modifier

- [ ] Task 9: 实现圣索菲亚大教堂每人口文化
  - [ ] 添加 `EFFECT_ADJUST_CITY_YIELD_PER_POPULATION` Modifier
  - [ ] YieldType=YIELD_CULTURE, Amount=0.3

- [ ] Task 10: 实现博尔戈尔山军事生产力
  - [ ] 移除沙漠丘陵放置条件
  - [ ] 添加军事单位+20%生产力Modifier

- [ ] Task 11: 实现宙斯神像重构
  - [ ] 移除兵营前置条件
  - [ ] 修改赠送单位列表：2矛兵、2弓箭手、1攻城锤、2建造者
  - [ ] 添加生产军事单位时返还50%产能信仰的Modifier

- [ ] Task 12: 实现兵马俑兵营加成
  - [ ] 添加兵营+2生产力Modifier（所在城市）
  - [ ] 添加6格内兵营+2生产力Modifier

- [ ] Task 13: 实现桑科雷大学商路重构
  - [ ] 移除原版商路效果Modifier
  - [ ] 添加+1商路容量Modifier
  - [ ] 添加所有商路+1科技+2金币Modifier

- [ ] Task 14: 实现威尼斯军械库科技转化
  - [ ] 创建工业区邻接加成→科技转换Modifier
  - [ ] 使用GRANT_YIELD_BASED_ON_ADJACENCY_BONUS类型效果

- [ ] Task 15: 实现泰姬陵奇观加成
  - [ ] 创建每个奇观+3科技Modifier
  - [ ] 创建每个奇观+3文化Modifier
  - [ ] 使用WONDER_YIELD_CHANGE机制

- [ ] Task 16: 实现金门大桥商路金币
  - [ ] 创建每个奇观为全部商路+4金币Modifier
  - [ ] 可能需要Lua辅助脚本

- [ ] Task 17: 实现罗马斗兽场条件移除
  - [ ] 移除娱乐中心相邻条件
  - [ ] 移除竞技场前置要求

- [ ] Task 18: 实现马丘比丘放置条件变更
  - [ ] 移除山脉相邻条件
  - [ ] 添加丘陵条件
  - [ ] 添加相邻市中心条件

- [ ] Task 19: 实现休伊神庙无湖城市加成
  - [ ] 为所有无湖泊城市添加+2生产力
  - [ ] 使用REQUIREMENT_CITY_HAS_NO_FEATURE或自定义条件

- [ ] Task 20: 实现基尔瓦基斯瓦尼数值调整
  - [ ] 修改ModifierArguments: Amount从15改为10
  - [ ] 涉及两种城邦类型的增产效果

- [ ] Task 21: 实现佩特拉古城少沙漠加成
  - [ ] 添加条件：沙漠地块<10时+2粮食
  - [ ] 使用REQUIREMENT_COLLECTION_COUNT条件

- [ ] Task 22: 实现奇琴伊察少雨林加成
  - [ ] 添加条件：雨林地块<5时+2生产力
  - [ ] 使用REQUIREMENT_COLLECTION_COUNT条件

## 阶段三：本地化和收尾
- [ ] Task 23: 创建简体中文汉化文件
  - [ ] 为所有修改的奇观效果创建中文描述文本
  - [ ] 使用 LocalizedText 表格添加翻译条目
  - [ ] 确保每个新增/修改的效果都有对应的中文描述

- [ ] Task 24: 验证和收尾
  - [ ] 检查所有XML文件语法正确性
  - [ ] 确保modinfo文件引用所有必要文件
  - [ ] 生成MOD最终目录结构

# Task Dependencies
- Task 2-22（阶段二）全部依赖 Task 1（MOD基础架构）
- Task 2-22 之间无依赖，可并行实现
- Task 23 依赖阶段二全部完成
- Task 24 依赖 Task 23 完成