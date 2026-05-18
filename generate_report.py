import json

with open('/workspace/sdv_mods_report.json', 'r') as f:
    data = json.load(f)

# Category inference based on mod names
def infer_category(name):
    name_lower = name.lower()
    if any(k in name_lower for k in ['android', 'touch', 'mobile']):
        return 'Android/移动端'
    if any(k in name_lower for k in ['automate', 'auto', 'automatic', 'automation']):
        return '自动化'
    if any(k in name_lower for k in ['chest', 'storage', 'inventory', 'backpack', 'organize', 'sort']):
        return '物品管理/存储'
    if any(k in name_lower for k in ['fish', 'fishing', 'bait']):
        return '钓鱼'
    if any(k in name_lower for k in ['crop', 'farm', 'harvest', 'plant', 'seed', 'scythe', 'grass', 'sprinkler', 'irrigation', 'foraging', 'fertilizer']):
        return '农业/种植'
    if any(k in name_lower for k in ['mine', 'cavern', 'monster', 'combat', 'weapon', 'sword', 'gear', 'bomb']):
        return '采矿/战斗'
    if any(k in name_lower for k in ['npc', 'villager', 'friendship', 'gift', 'social', 'romance', 'soulmate', 'dialogue']):
        return '社交/NPC'
    if any(k in name_lower for k in ['ui', 'interface', 'menu', 'map', 'info', 'zoom', 'indicator', 'alert', 'display', 'overlay']):
        return 'UI/界面'
    if any(k in name_lower for k in ['skill', 'profession', 'mastery', 'prestige', 'experience', 'level']):
        return '技能/等级'
    if any(k in name_lower for k in ['building', 'house', 'coop', 'barn', 'craft', 'construct', 'carpenter', 'bridge']):
        return '建筑/建造'
    if any(k in name_lower for k in ['magic', 'spell', 'wand', 'tome', 'wizard', 'enchant']):
        return '魔法/奇幻'
    if any(k in name_lower for k in ['expand', 'expansion', 'content', 'add', 'new']):
        return '内容扩展'
    if any(k in name_lower for k in ['visual', 'texture', 'sprite', 'portrait', 'recolor', 'aesthetic', 'beautify']):
        return '视觉美化'
    if any(k in name_lower for k in ['save', 'checkpoint', 'load']):
        return '存档管理'
    if any(k in name_lower for k in ['time', 'clock', 'speed', 'delay', 'pause']):
        return '时间管理'
    if any(k in name_lower for k in ['luck', 'rng', 'random', 'gamble']):
        return '随机/运气'
    if any(k in name_lower for k in ['economy', 'price', 'money', 'gold', 'sell', 'buy', 'shop', 'market', 'merchant']):
        return '经济/交易'
    if any(k in name_lower for k in ['ai', 'assistant', 'helper']):
        return 'AI/助手'
    if any(k in name_lower for k in ['framework', 'core', 'api', 'toolkit', 'library']):
        return '框架/核心库'
    if any(k in name_lower for k in ['pet', 'animal', 'dog', 'cat', 'horse']):
        return '动物/宠物'
    return '其他/综合'

# Android compatibility inference
def infer_android(name, author):
    name_lower = name.lower()
    if any(k in name_lower for k in ['android', 'touch', 'mobile']):
        return '是'
    # Core framework mods usually don't work on Android
    if any(k in name_lower for k in ['framework', 'core', 'api', 'toolkit']):
        return '不确定'
    # SMAPI mods generally can work on Android  
    return '不确定'

# Build Markdown report
lines = []
lines.append('# 星露谷物语 N网Mod 详细信息报告')
lines.append('')
lines.append(f'> 共 {data["total_target"]} 个Mod | 全部从SMAPI兼容性数据库匹配成功')
lines.append('> ')
lines.append('> **重要说明**: 由于Nexus Mods启用了Cloudflare高级防护，本环境无法直接访问N网页面获取评论区、Bug报告区和完整介绍。')
lines.append('> 以下信息来源于SMAPI官方兼容性数据库及名称分析。建议自行访问N网页面查看完整描述和评论。')
lines.append('')
lines.append('---')
lines.append('')

# Summary stats
cats = {}
for m in data['mods']:
    c = infer_category(m['name'])
    cats[c] = cats.get(c, 0) + 1

lines.append('## 分类统计')
lines.append('')
for c, n in sorted(cats.items(), key=lambda x: -x[1]):
    lines.append(f'- **{c}**: {n} 个')
lines.append('')
lines.append('---')
lines.append('')

# Detailed mod list
lines.append('## Mod详细信息')
lines.append('')

for m in data['mods']:
    lines.append(f'### [{m["id"]}] {m["name"]}')
    lines.append('')
    lines.append(f'- **作者**: {m["author"]}')
    lines.append(f'- **N网链接**: {m["nexus_url"]}')
    
    cat = infer_category(m['name'])
    lines.append(f'- **分类**: {cat}')
    
    android = infer_android(m['name'], m['author'])
    lines.append(f'- **安卓兼容性**: {android}')
    
    if m.get('alt_names'):
        lines.append(f'- **别名**: {m["alt_names"]}')
    
    if m.get('summary'):
        lines.append(f'- **兼容性摘要**: {m["summary"]}')
    
    if m.get('unofficial_version'):
        lines.append(f'- **非官方更新版**: {m["unofficial_version"]}')
    
    if m.get('broke_in'):
        lines.append(f'- **已知损坏版本**: {m["broke_in"]}')
    
    if m.get('warnings'):
        for w in m['warnings']:
            lines.append(f'- **⚠ 警告**: {w}')
    
    if m.get('source_url'):
        lines.append(f'- **源码**: {m["source_url"]}')
    
    # Generate functional description from name
    name = m['name']
    lines.append('')
    lines.append('#### 功能推测')
    lines.append('')
    lines.append(f'_（基于mod名称推断，完整功能请访问N网页面: {m["nexus_url"]}）_')
    lines.append('')
    
    # Inferred description
    desc_lines = []
    name_lower = name.lower()
    
    if 'android' in name_lower:
        desc_lines.append('- 专为安卓版星露谷物语设计的mod')
    if 'touch' in name_lower:
        desc_lines.append('- 提供触屏操作界面优化')
    if 'zoom' in name_lower:
        desc_lines.append('- 调整/移除游戏缩放限制')
    if 'chest' in name_lower or 'storage' in name_lower or 'organize' in name_lower or 'sort' in name_lower:
        desc_lines.append('- 箱子/存储管理功能')
    if 'automate' in name_lower or 'automation' in name_lower or 'auto' in name_lower:
        desc_lines.append('- 自动化生产/操作功能')
    if 'harvest' in name_lower:
        desc_lines.append('- 收获功能改进')
    if 'scythe' in name_lower:
        desc_lines.append('- 镰刀相关功能')
    if 'fish' in name_lower or 'fishing' in name_lower:
        desc_lines.append('- 钓鱼相关功能')
    if 'crop' in name_lower or 'farm' in name_lower or 'plant' in name_lower:
        desc_lines.append('- 农作物/农业功能')
    if 'mine' in name_lower or 'cavern' in name_lower or 'monster' in name_lower:
        desc_lines.append('- 矿井/战斗相关功能')
    if 'npc' in name_lower or 'friend' in name_lower or 'gift' in name_lower or 'social' in name_lower:
        desc_lines.append('- NPC互动/社交功能')
    if 'ui' in name_lower or 'interface' in name_lower or 'menu' in name_lower or 'map' in name_lower:
        desc_lines.append('- UI/界面改进')
    if 'skill' in name_lower or 'profession' in name_lower or 'mastery' in name_lower:
        desc_lines.append('- 技能/职业系统调整')
    if 'magic' in name_lower or 'wand' in name_lower or 'tome' in name_lower or 'spell' in name_lower:
        desc_lines.append('- 魔法/奇幻元素添加')
    if 'expand' in name_lower or 'expansion' in name_lower:
        desc_lines.append('- 内容扩展/添加新元素')
    if 'save' in name_lower or 'checkpoint' in name_lower:
        desc_lines.append('- 存档管理功能')
    if 'time' in name_lower or 'clock' in name_lower or 'speed' in name_lower:
        desc_lines.append('- 时间/速度调整功能')
    if 'luck' in name_lower:
        desc_lines.append('- 运气相关功能')
    if 'price' in name_lower or 'money' in name_lower or 'sell' in name_lower or 'economy' in name_lower or 'shop' in name_lower:
        desc_lines.append('- 经济/价格/交易功能')
    if 'backpack' in name_lower or 'pocket' in name_lower or 'inventory' in name_lower:
        desc_lines.append('- 背包/物品栏扩展')
    if 'building' in name_lower or 'house' in name_lower or 'coop' in name_lower or 'barn' in name_lower:
        desc_lines.append('- 建筑相关功能')
    if 'ring' in name_lower or 'glove' in name_lower:
        desc_lines.append('- 戒指/饰品槽位扩展')
    if 'sprinkler' in name_lower or 'irrigation' in name_lower:
        desc_lines.append('- 洒水器/灌溉功能')
    if any(k in name_lower for k in ['portal', 'teleport', 'warp', 'network']):
        desc_lines.append('- 传送/快速旅行功能')
    if 'ai' in name_lower or 'assistant' in name_lower:
        desc_lines.append('- AI辅助/智能助手功能')
    if 'framework' in name_lower or 'core' in name_lower or 'api' in name_lower:
        desc_lines.append('- 框架/核心库')
    if 'pet' in name_lower or 'animal' in name_lower or 'dog' in name_lower or 'cat' in name_lower:
        desc_lines.append('- 宠物/动物相关功能')
    if 'music' in name_lower or 'sound' in name_lower or 'radio' in name_lower:
        desc_lines.append('- 音乐/音效相关')
    if 'survival' in name_lower or 'hunger' in name_lower:
        desc_lines.append('- 生存/饥饿机制')
    if 'vampire' in name_lower:
        desc_lines.append('- 吸血鬼主题内容')
    if 'prism' in name_lower or 'prismatic' in name_lower:
        desc_lines.append('- 五彩/棱镜主题')
    
    if not desc_lines:
        desc_lines.append(f'- {name}')
    
    for dl in desc_lines:
        lines.append(dl)
    
    lines.append('')
    lines.append('#### 前置依赖')
    lines.append('')
    lines.append('- **SMAPI** (必须)')
    lines.append('- 具体前置请访问N网页面查看Requirements部分')
    lines.append('')
    
    lines.append('#### Bug与注意事项')
    lines.append('')
    lines.append('- 因Cloudflare限制无法访问Bug报告区')
    lines.append('- 建议访问N网页面Bugs标签查看已知问题')
    if m.get('warnings'):
        for w in m['warnings']:
            lines.append(f'- ⚠ SMAPI警告: {w}')
    lines.append('')
    lines.append('---')
    lines.append('')

# Write report
report_path = '/workspace/SDV_Mods_Report.md'
with open(report_path, 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines))

print(f'Report written to {report_path}')
print(f'Total lines: {len(lines)}')