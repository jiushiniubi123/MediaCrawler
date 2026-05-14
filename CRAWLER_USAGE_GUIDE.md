# MediaCrawler 全平台爬虫使用指南

## 📌 快速开始

### 1. 环境准备

```bash
# 进入项目目录
cd /workspace

# 安装依赖
uv sync

# 检查帮助信息
uv run main.py --help
```

### 2. 基础配置（config/base_config.py）

```python
# 平台选择
PLATFORM = "xhs"  # xhs | dy | ks | bili | wb | tieba | zhihu

# 登录方式
LOGIN_TYPE = "qrcode"  # qrcode | phone | cookie

# 爬虫模式
CRAWLER_TYPE = "search"  # search | detail | creator

# 关键词搜索（search模式）
KEYWORDS = "aawa1103,SS,麦穗嘉"

# 数据存储方式
SAVE_DATA_OPTION = "jsonl"  # jsonl | csv | excel | db | sqlite

# 评论爬取
ENABLE_GET_COMMENTS = True
ENABLE_GET_SUB_COMMENTS = True
```

---

## 🔍 全平台爬取命令

### 小红书 (xhs)

```bash
# 关键词搜索模式 - 爬取包含关键词的笔记
uv run main.py --platform xhs --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"

# 创作者主页模式 - 需要先获取创作者主页URL
uv run main.py --platform xhs --lt qrcode --type creator --creator_id "创作者URL或ID"

# 帖子详情模式 - 爬取指定帖子
uv run main.py --platform xhs --lt qrcode --type detail --specified_id "帖子URL或ID"
```

### 抖音 (dy)

```bash
uv run main.py --platform dy --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform dy --lt qrcode --type creator --creator_id "创作者URL"
uv run main.py --platform dy --lt qrcode --type detail --specified_id "视频URL"
```

### 快手 (ks)

```bash
uv run main.py --platform ks --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform ks --lt qrcode --type creator --creator_id "创作者URL"
uv run main.py --platform ks --lt qrcode --type detail --specified_id "视频URL"
```

### B站 (bili)

```bash
uv run main.py --platform bili --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform bili --lt qrcode --type creator --creator_id "UP主UID"
uv run main.py --platform bili --lt qrcode --type detail --specified_id "视频URL"
```

### 微博 (wb)

```bash
uv run main.py --platform wb --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform wb --lt qrcode --type creator --creator_id "博主主页URL"
uv run main.py --platform wb --lt qrcode --type detail --specified_id "微博URL"
```

### 贴吧 (tieba)

```bash
uv run main.py --platform tieba --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform tieba --lt qrcode --type creator --creator_id "用户主页URL"
uv run main.py --platform tieba --lt qrcode --type detail --specified_id "帖子URL"
```

### 知乎 (zhihu)

```bash
uv run main.py --platform zhihu --lt qrcode --type search --keywords "aawa1103,SS,麦穗嘉"
uv run main.py --platform zhihu --lt qrcode --type creator --creator_id "用户主页URL"
uv run main.py --platform zhihu --lt qrcode --type detail --specified_id "内容URL"
```

---

## 🎯 一次性爬取所有平台

创建一个批量执行脚本 `batch_crawl.sh`:

```bash
#!/bin/bash

KEYWORDS="aawa1103,SS,麦穗嘉"
PLATFORMS=("xhs" "dy" "ks" "bili" "wb" "tieba" "zhihu")
LABELS=("小红书" "抖音" "快手" "B站" "微博" "贴吧" "知乎")

for i in "${!PLATFORMS[@]}"; do
    echo "=========================================="
    echo "开始爬取: ${LABELS[$i]} (${PLATFORMS[$i]})"
    echo "关键词: $KEYWORDS"
    echo "=========================================="
    
    uv run main.py \
        --platform "${PLATFORMS[$i]}" \
        --lt qrcode \
        --type search \
        --keywords "$KEYWORDS" \
        --get_comment true \
        --save_data_option jsonl
    
    echo "${LABELS[$i]} 爬取完成"
    echo ""
done

echo "全部平台爬取完成！"
```

运行脚本:
```bash
chmod +x batch_crawl.sh
./batch_crawl.sh
```

---

## 📋 配置说明

### CDP 模式（推荐）

CDP 模式使用本地 Chrome 浏览器，反检测能力更强：

1. 开启 Chrome 远程调试：
   - 地址栏输入 `chrome://inspect/#remote-debugging`
   - 勾选 "Allow remote debugging"

2. 配置 `config/base_config.py`：
```python
ENABLE_CDP_MODE = True
CDP_CONNECT_EXISTING = True
HEADLESS = False  # 调试时可设为 True
```

### IP 代理配置

```python
ENABLE_IP_PROXY = True
IP_PROXY_POOL_COUNT = 5
IP_PROXY_PROVIDER_NAME = "kuaidaili"  # 或 "wandouhttp"
```

### 数据存储配置

| 方式 | 配置值 | 说明 |
|------|--------|------|
| JSONL | `jsonl` | 每行一个JSON，推荐 |
| JSON | `json` | 完整JSON数组 |
| CSV | `csv` | 逗号分隔 |
| Excel | `excel` | 格式化表格 |
| SQLite | `sqlite` | 本地数据库 |
| MySQL | `db` | 需要配置数据库 |

---

## 📊 爬取数据类型

每个平台可获取的数据类型：

### 内容数据
- 帖子/视频 ID
- 标题、描述
- 发布时间
- 点赞/评论/收藏/分享数
- 作者信息
- 原始链接

### 评论数据
- 评论内容
- 评论者信息
- 发布时间
- 点赞数
- 子评论（二级评论）

### 创作者数据
- 用户 ID
- 昵称、头像
- 粉丝数、关注数
- 个人简介

---

## ⚠️ 重要提示

1. **频率控制**：合理设置爬取间隔，避免被封禁
   ```python
   CRAWLER_MAX_SLEEP_SEC = 2  # 爬取间隔（秒）
   CRAWLER_MAX_NOTES_COUNT = 15  # 最大爬取数量
   ```

2. **合规使用**：
   - 仅供学习研究
   - 遵守平台服务条款
   - 不要大规模爬取
   - 尊重用户隐私

3. **登录要求**：
   - 需要扫码登录获取 Cookie
   - 建议使用小号/测试账号
   - 保存登录状态避免重复登录

---

## 🔧 常见问题

### Q: 扫码登录失败？
A: 设置 `HEADLESS = False`，手动在浏览器中完成验证

### Q: 被平台封禁？
A: 启用 IP 代理，降低爬取频率

### Q: 如何获取创作者ID？
A: 从创作者主页 URL 中提取，例如：
- 小红书：`/user/profile/5f58bd990000000001003753`
- 抖音：`/user/MS4wLjABAAA...`

### Q: 数据保存在哪里？
A: 默认保存在 `data/{platform}/` 目录下

---

*使用前请确保遵守各平台的使用条款和相关法律法规*
