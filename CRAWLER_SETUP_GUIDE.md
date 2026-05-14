# MediaCrawler 爬虫配置指南

## 目标用户信息汇总

根据网络搜索结果，以下是目标用户在各平台的可能信息：

### 1. aawa1103
- 搜索结果中未直接找到此用户
- 可能需要手动搜索获取

### 2. SS
- **小红书**: 找到一个用户 "ss"，简介为"没更新是在学习。你们叫我蛇蛇或者ss都可以。。"

### 3. 麦穗嘉
- **小红书**: 搜索结果显示有恋综嘉宾转型小红书博主的案例，提到了"麦穗"，可能是用户提到的"麦穗嘉"

---

## 本地运行配置步骤

### 第一步：克隆项目到本地

```bash
git clone https://github.com/NanmiCoder/MediaCrawler.git
cd MediaCrawler
```

### 第二步：安装依赖

```bash
# 安装 uv (如果还没有)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装项目依赖
uv sync
```

### 第三步：启用 Chrome 远程调试

**Windows:**
1. 关闭所有 Chrome 窗口
2. 按 Win+R，输入:
   ```
   chrome.exe --remote-debugging-port=9222
   ```
3. 回车启动 Chrome

**macOS:**
```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222
```

**Linux:**
```bash
google-chrome --remote-debugging-port=9222
```

**验证设置:**
1. 打开 Chrome，访问 `chrome://inspect/#remote-debugging`
2. 确保勾选 "Allow remote debugging for this browser instance"

### 第四步：配置目标用户

编辑各平台的配置文件，添加用户 URL：

**小红书配置 (config/xhs_config.py):**
```python
XHS_CREATOR_ID_LIST = [
    # 从浏览器地址栏复制完整的用户主页URL
    # 格式: https://www.xiaohongshu.com/user/profile/用户ID?xsec_token=xxx&xsec_source=pc_search
]
```

**微博配置 (config/weibo_config.py):**
```python
WEIBO_CREATOR_ID_LIST = [
    # 从URL中提取用户ID，如 https://weibo.com/u/5756404150 中的 5756404150
]
```

**B站配置 (config/bilibili_config.py):**
```python
BILI_CREATOR_ID_LIST = [
    # 从URL中提取UID，如 https://space.bilibili.com/434377496 中的 434377496
]
```

**抖音配置 (config/dy_config.py):**
```python
DY_CREATOR_ID_LIST = [
    # 从URL中提取 sec_user_id
]
```

### 第五步：运行爬虫

```bash
# 小红书
uv run main.py --platform xhs --lt qrcode --type creator

# 微博
uv run main.py --platform wb --lt qrcode --type creator

# B站
uv run main.py --platform bili --lt qrcode --type creator

# 抖音
uv run main.py --platform dy --lt qrcode --type creator
```

### 第六步：登录认证

1. 运行命令后，Chrome 浏览器会弹出确认对话框
2. 点击"接受"按钮
3. 使用手机小红书APP扫描二维码
4. 等待登录成功

---

## 完整配置示例

### 小红书 (xhs)

需要获取用户主页的完整 URL，包括 xsec_token 参数：

1. 打开 Chrome，访问 https://www.xiaohongshu.com
2. 登录你的账号
3. 搜索目标用户 (aawa1103, SS, 麦穗嘉)
4. 进入用户主页
5. 复制浏览器地址栏的完整 URL
6. 将 URL 添加到 `XHS_CREATOR_ID_LIST` 列表中

### 微博 (wb)

从用户主页 URL 提取用户 ID：

1. 打开微博，搜索目标用户
2. 进入用户主页
3. URL 格式: `https://weibo.com/u/用户ID`
4. 提取数字用户ID，添加到 `WEIBO_CREATOR_ID_LIST`

### B站 (bili)

从用户主页 URL 提取 UID：

1. 打开B站，搜索目标用户
2. 进入用户主页
3. URL 格式: `https://space.bilibili.com/UID`
4. 提取数字 UID，添加到 `BILI_CREATOR_ID_LIST`

### 抖音 (dy)

从用户主页 URL 提取 sec_user_id：

1. 打开抖音网页版，搜索目标用户
2. 进入用户主页
3. URL 格式: `https://www.douyin.com/user/sec_user_id`
4. 提取 sec_user_id，添加到 `DY_CREATOR_ID_LIST`

---

## 数据输出

爬取的数据将保存在 `data/` 目录下：

```
data/
├── xhs/           # 小红书数据
│   ├── xhs_creator_20240101_120000.jsonl
│   ├── xhs_note_20240101_120000.jsonl
│   └── xhs_comment_20240101_120000.jsonl
├── wb/            # 微博数据
├── bili/          # B站数据
└── dy/            # 抖音数据
```

---

## 注意事项

1. **合规使用**: 本工具仅供学习研究使用，请遵守各平台的服务条款
2. **频率控制**: 建议设置合理的爬取间隔，避免对平台造成压力
3. **登录状态**: 首次登录后，登录状态会被缓存
4. **IP限制**: 如遇 IP 被封，可启用代理功能

---

## 故障排除

### 问题：二维码扫描后登录失败
**解决方案**: 确保 Chrome 远程调试已正确启用，尝试重新启动 Chrome

### 问题：提示 xsec_token 无效
**解决方案**: 需要从浏览器地址栏获取完整的 URL，包括 xsec_token 参数

### 问题：数据为空
**解决方案**: 检查用户 ID 是否正确，确认用户存在且有公开内容
