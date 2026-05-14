# MediaCrawler 项目代码文档

## 项目概述

MediaCrawler 是一个功能强大的多平台自媒体数据采集工具，支持小红书、抖音、快手、B站、微博、贴吧、知乎等主流平台的公开信息抓取。

### 技术特点

- **核心框架**：基于 Playwright 浏览器自动化框架
- **无需 JS 逆向**：利用保留登录态的浏览器上下文环境，通过 JS 表达式获取签名参数
- **CDP 模式支持**：支持连接用户本地 Chrome 浏览器，降低风控检测风险
- **异步架构**：全面采用 asyncio 异步编程，提升爬取效率
- **多数据存储**：支持 CSV、JSON、JSONL、Excel、SQLite、MySQL、MongoDB 等多种存储方式

---

## 项目架构

```
MediaCrawler/
├── api/                    # WebUI API 服务
│   ├── routers/            # API 路由
│   ├── schemas/            # Pydantic 数据模型
│   ├── services/           # 业务服务
│   └── webui/              # 前端静态资源
├── base/                   # 基础抽象类
├── cache/                  # 缓存层实现
├── cmd_arg/                # 命令行参数解析
├── config/                 # 配置文件
├── constant/               # 常量定义
├── database/               # 数据库模块
├── docs/                   # 项目文档
├── libs/                   # 第三方 JS 库
├── media_platform/         # 平台爬虫实现
│   ├── bilibili/           # B站
│   ├── douyin/             # 抖音
│   ├── kuaishou/           # 快手
│   ├── tieba/              # 贴吧
│   ├── weibo/              # 微博
│   ├── xhs/                # 小红书
│   └── zhihu/              # 知乎
├── model/                  # 数据模型
├── proxy/                  # 代理 IP 模块
├── store/                  # 数据存储实现
├── test/                   # 测试模块
├── tests/                  # 单元测试
└── tools/                  # 工具函数
```

---

## 核心模块详解

### 1. base/base_crawler.py - 爬虫基类

定义所有平台爬虫必须实现的抽象接口。

#### 抽象类 AbstractCrawler

```python
class AbstractCrawler(ABC):
    async def start(self)           # 启动爬虫
    async def search(self)          # 搜索功能
    async def launch_browser()      # 启动浏览器
    async def launch_browser_with_cdp()  # CDP 模式启动浏览器
```

#### 抽象类 AbstractLogin

```python
class AbstractLogin(ABC):
    async def begin()               # 开始登录
    async def login_by_qrcode()     # 二维码登录
    async def login_by_mobile()     # 手机号登录
    async def login_by_cookies()    # Cookie 登录
```

#### 抽象类 AbstractStore

```python
class AbstractStore(ABC):
    async def store_content()       # 存储内容数据
    async def store_comment()       # 存储评论数据
    async def store_creator()        # 存储创作者数据
```

#### 抽象类 AbstractApiClient

```python
class AbstractApiClient(ABC):
    async def request()             # HTTP 请求
    async def update_cookies()      # 更新 Cookie
```

---

### 2. cmd_arg/arg.py - 命令行参数解析

使用 Typer 框架构建命令行界面，支持丰富的参数配置。

#### 平台枚举 PlatformEnum

| 值 | 平台 |
|---|---|
| `xhs` | 小红书 |
| `dy` | 抖音 |
| `ks` | 快手 |
| `bili` | B站 |
| `wb` | 微博 |
| `tieba` | 贴吧 |
| `zhihu` | 知乎 |

#### 登录类型 LoginTypeEnum

| 值 | 登录方式 |
|---|---|
| `qrcode` | 二维码登录 |
| `phone` | 手机号登录 |
| `cookie` | Cookie 登录 |

#### 爬虫类型 CrawlerTypeEnum

| 值 | 模式 |
|---|---|
| `search` | 关键词搜索 |
| `detail` | 指定帖子详情 |
| `creator` | 创作者主页 |

#### 数据存储 SaveDataOptionEnum

| 值 | 存储方式 |
|---|---|
| `csv` | CSV 文件 |
| `json` | JSON 文件 |
| `jsonl` | JSONL 文件 |
| `excel` | Excel 文件 |
| `sqlite` | SQLite 数据库 |
| `db` | MySQL 数据库 |
| `mongodb` | MongoDB 数据库 |

#### 核心函数

```python
async def parse_cmd(argv: Optional[Sequence[str]] = None) -> SimpleNamespace:
    """解析命令行参数，返回配置命名空间"""
```

---

### 3. config/ - 配置模块

#### base_config.py - 基础配置

```python
PLATFORM = "xhs"                      # 平台选择
KEYWORDS = "关键词1,关键词2"           # 搜索关键词
LOGIN_TYPE = "qrcode"                 # 登录类型
CRAWLER_TYPE = "search"               # 爬虫类型
SAVE_DATA_OPTION = "jsonl"            # 数据存储方式
ENABLE_CDP_MODE = True                # 是否启用 CDP 模式
CDP_DEBUG_PORT = 9222                 # CDP 调试端口
HEADLESS = False                      # 无头模式
ENABLE_GET_COMMENTS = True            # 是否爬取评论
ENABLE_GET_SUB_COMMENTS = False       # 是否爬取二级评论
CRAWLER_MAX_NOTES_COUNT = 15          # 最大爬取数量
MAX_CONCURRENCY_NUM = 1               # 最大并发数
ENABLE_IP_PROXY = False               # 是否启用 IP 代理
```

#### 平台特定配置

- `bilibili_config.py` - B站配置
- `xhs_config.py` - 小红书配置
- `dy_config.py` - 抖音配置
- `ks_config.py` - 快手配置
- `weibo_config.py` - 微博配置
- `tieba_config.py` - 贴吧配置
- `zhihu_config.py` - 知乎配置

---

### 4. media_platform/ - 平台实现

每个平台都有独立的模块，包含以下文件：

| 文件 | 职责 |
|---|---|
| `client.py` | API 客户端，处理 HTTP 请求和签名 |
| `core.py` | 核心爬虫逻辑 |
| `login.py` | 登录逻辑 |
| `field.py` | 字段枚举定义 |
| `help.py` | 辅助函数 |
| `exception.py` | 自定义异常 |
| `extractor.py` | HTML/响应解析器（部分平台） |

#### 小红书平台示例 (media_platform/xhs/)

**XiaoHongShuClient** - API 客户端核心方法：

```python
class XiaoHongShuClient(AbstractApiClient):
    async def get_note_by_keyword()     # 关键词搜索
    async def get_note_by_id()          # 获取笔记详情
    async def get_note_comments()        # 获取评论
    async def get_note_sub_comments()   # 获取子评论
    async def get_note_all_comments()   # 获取所有评论
    async def get_creator_info()        # 获取创作者信息
    async def get_notes_by_creator()    # 获取创作者笔记
    async def get_all_notes_by_creator() # 获取所有笔记
    async def pong()                    # 检测登录状态
```

---

### 5. database/ - 数据库模块

#### db.py - 数据库管理

```python
async def init_db(db_type: str)    # 初始化数据库
async def close()                   # 关闭数据库连接
```

#### models.py - ORM 模型

定义所有平台的数据表模型，主要包括：

| 模型类 | 说明 |
|---|---|
| `BilibiliVideo` | B站视频 |
| `BilibiliVideoComment` | B站视频评论 |
| `DouyinAweme` | 抖音作品 |
| `DouyinAwemeComment` | 抖音作品评论 |
| `KuaishouVideo` | 快手视频 |
| `WeiboNote` | 微博笔记 |
| `WeiboNoteComment` | 微博评论 |
| `XhsNote` | 小红书笔记 |
| `XhsNoteComment` | 小红书评论 |
| `TiebaNote` | 贴吧帖子 |
| `ZhihuContent` | 知乎内容 |

#### db_session.py - 数据库会话管理

负责数据库连接创建和表结构创建。

---

### 6. store/ - 数据存储

#### excel_store_base.py - Excel 存储

使用 openpyxl 库实现 Excel 导出功能：

```python
class ExcelStoreBase(AbstractStore):
    @classmethod
    def get_instance(cls, platform: str, crawler_type: str) -> "ExcelStoreBase":
        """获取单例实例"""
    
    @classmethod
    def flush_all(cls):
        """刷新所有实例并保存文件"""
    
    async def store_content()       # 存储内容
    async def store_comment()       # 存储评论
    async def store_creator()        # 存储创作者
    def flush()                      # 保存工作簿
```

#### 各平台存储实现

每个平台都有对应的存储实现文件：
- `bilibili/bilibilli_store_media.py`
- `douyin/douyin_store_media.py`
- `xhs/xhs_store_media.py`
- `weibo/weibo_store_media.py`

---

### 7. proxy/ - 代理 IP 模块

#### proxy_ip_pool.py - IP 代理池

```python
class ProxyIpPool:
    def __init__(self, ip_pool_count, enable_validate_ip, ip_provider)
    async def load_proxies()                    # 加载代理列表
    async def get_proxy() -> IpInfoModel         # 获取随机代理
    async def get_or_refresh_proxy() -> IpInfoModel  # 获取或刷新代理
    def is_current_proxy_expired() -> bool       # 检查代理是否过期
```

#### base_proxy.py - 代理提供者基类

```python
class ProxyProvider(ABC):
    @abstractmethod
    async def get_proxy(self, count: int) -> List[IpInfoModel]:
        """获取指定数量的代理"""
```

#### providers/ - 代理提供商实现

- `kuaidl_proxy.py` - 快代理
- `wandou_http_proxy.py` - 豌豆 HTTP 代理

---

### 8. cache/ - 缓存层

#### abs_cache.py - 缓存抽象基类

```python
class AbsCache(ABC):
    @abstractmethod
    async def get(key: str) -> Optional[str]
    
    @abstractmethod
    async def set(key: str, value: str, ttl: Optional[int] = None) -> bool
    
    @abstractmethod
    async def delete(key: str) -> bool
    
    @abstractmethod
    async def clear() -> None
```

#### 实现类

| 类名 | 说明 |
|---|---|
| `LocalCache` | 本地内存缓存 |
| `RedisCache` | Redis 缓存 |
| `CacheFactory` | 缓存工厂 |

---

### 9. tools/ - 工具模块

#### app_runner.py - 应用运行器

```python
def run(
    main_func,                    # 异步主函数
    cleanup_func,                 # 清理函数
    cleanup_timeout_seconds=30.0, # 超时时间
    on_first_interrupt=None       # 首次中断回调
)
```

#### browser_launcher.py - 浏览器启动器

```python
class BrowserLauncher:
    async def launch() -> BrowserContext  # 启动浏览器上下文
    async def launch_with_cdp() -> BrowserContext  # CDP 模式启动
```

#### cdp_browser.py - CDP 浏览器管理

```python
class CdpBrowserManager:
    async def start()                     # 启动 CDP 连接
    async def create_context()             # 创建浏览器上下文
    async def cleanup()                    # 清理资源
```

#### utils.py - 通用工具函数

```python
def convert_browser_context_cookies()  # 转换浏览器 Cookie
def setup_logger()                     # 配置日志
```

#### crawler_util.py - 爬虫工具函数

#### httpx_util.py - HTTP 客户端工具

```python
def make_async_client(proxy=None) -> httpx.AsyncClient:
    """创建异步 HTTP 客户端"""
```

---

### 10. api/ - WebUI 服务

#### main.py - FastAPI 应用

```python
from fastapi import FastAPI

app = FastAPI(
    title="MediaCrawler WebUI API",
    version="1.0.0"
)

# 路由
app.include_router(crawler_router, prefix="/api")
app.include_router(data_router, prefix="/api")
app.include_router(websocket_router, prefix="/api")
```

#### 路由模块

| 路由文件 | 职责 |
|---|---|
| `crawler_router.py` | 爬虫控制接口 |
| `data_router.py` | 数据查询接口 |
| `websocket_router.py` | WebSocket 实时通信 |

#### schemas/ - Pydantic 模型

定义 API 请求和响应的数据模型。

#### services/ - 业务服务

`crawler_manager.py` - 爬虫管理器，处理爬虫的生命周期。

---

## main.py - 程序入口

```python
class CrawlerFactory:
    CRAWLERS: dict[str, Type[AbstractCrawler]] = {
        "xhs": XiaoHongShuCrawler,
        "dy": DouYinCrawler,
        "ks": KuaishouCrawler,
        "bili": BilibiliCrawler,
        "wb": WeiboCrawler,
        "tieba": TieBaCrawler,
        "zhihu": ZhihuCrawler,
    }
    
    @staticmethod
    def create_crawler(platform: str) -> AbstractCrawler:
        """工厂方法：创建对应平台的爬虫"""

async def main() -> None:
    """主函数：初始化并启动爬虫"""
    
async def async_cleanup() -> None:
    """异步清理：关闭浏览器和数据库连接"""
```

---

## 依赖关系图

```
main.py
├── cmd_arg (命令行解析)
├── config (配置模块)
├── database (数据库)
├── media_platform/* (各平台爬虫)
│   ├── base (基础类)
│   ├── proxy (代理)
│   ├── store (存储)
│   └── tools (工具)
└── tools
    └── app_runner (应用运行器)

api/main.py
├── fastapi
├── uvicorn
└── routers/*
    ├── crawler_router (爬虫控制)
    ├── data_router (数据查询)
    └── websocket_router (实时通信)
```

---

## 项目运行方式

### 环境准备

```bash
# 1. 安装 uv (推荐)
curl -LsSf https://astral.sh/uv/install.sh | sh

# 2. 安装 Node.js (>=16.0.0)
# 下载地址: https://nodejs.org/en/download/

# 3. 安装依赖
cd MediaCrawler
uv sync
```

### 运行爬虫

```bash
# 关键词搜索爬取
uv run main.py --platform xhs --lt qrcode --type search

# 指定帖子详情爬取
uv run main.py --platform xhs --lt qrcode --type detail

# 创作者主页爬取
uv run main.py --platform xhs --lt qrcode --type creator

# 查看所有参数
uv run main.py --help
```

### WebUI 模式

```bash
# 启动 API 服务器
uv run uvicorn api.main:app --port 8080 --reload

# 访问 http://localhost:8080
```

### 常用参数

| 参数 | 说明 | 示例 |
|---|---|---|
| `--platform` | 平台选择 | `xhs`, `dy`, `ks`, `bili`, `wb`, `tieba`, `zhihu` |
| `--lt` | 登录类型 | `qrcode`, `phone`, `cookie` |
| `--type` | 爬虫类型 | `search`, `detail`, `creator` |
| `--keywords` | 搜索关键词 | `--keywords "关键词1,关键词2"` |
| `--get_comment` | 是否爬评论 | `true`, `false` |
| `--save_data_option` | 存储方式 | `jsonl`, `csv`, `db`, `excel` |
| `--headless` | 无头模式 | `true`, `false` |

### 数据库初始化

```bash
# 初始化 SQLite
uv run main.py --init_db sqlite

# 初始化 MySQL
uv run main.py --init_db mysql

# 初始化 PostgreSQL
uv run main.py --init_db postgres
```

---

## 配置说明

### CDP 模式配置

CDP 模式允许连接用户本地的 Chrome 浏览器，具有更好的反检测能力：

```python
# config/base_config.py
ENABLE_CDP_MODE = True              # 启用 CDP 模式
CDP_DEBUG_PORT = 9222               # 调试端口
CDP_CONNECT_EXISTING = True         # 连接已有浏览器
AUTO_CLOSE_BROWSER = True           # 结束时自动关闭
```

使用前需在 Chrome 中开启远程调试：
1. 打开 `chrome://inspect/#remote-debugging`
2. 勾选 "Allow remote debugging for this browser instance"

### IP 代理配置

```python
ENABLE_IP_PROXY = True                          # 启用代理
IP_PROXY_POOL_COUNT = 2                         # 代理池数量
IP_PROXY_PROVIDER_NAME = "kuaidaili"            # 代理提供商
```

支持的代理提供商：
- `kuaidaili` - 快代理
- `wandouhttp` - 豌豆 HTTP

### 数据存储配置

```python
SAVE_DATA_OPTION = "jsonl"      # 存储格式
SAVE_DATA_PATH = ""             # 存储路径（空为默认 data 目录）
```

---

## 关键类速查表

### 爬虫类

| 类名 | 平台 | 文件 |
|---|---|---|
| `XiaoHongShuCrawler` | 小红书 | `media_platform/xhs/core.py` |
| `DouYinCrawler` | 抖音 | `media_platform/douyin/core.py` |
| `KuaishouCrawler` | 快手 | `media_platform/kuaishou/core.py` |
| `BilibiliCrawler` | B站 | `media_platform/bilibili/core.py` |
| `WeiboCrawler` | 微博 | `media_platform/weibo/core.py` |
| `TieBaCrawler` | 贴吧 | `media_platform/tieba/core.py` |
| `ZhihuCrawler` | 知乎 | `media_platform/zhihu/core.py` |

### 客户端类

| 类名 | 平台 | 核心方法 |
|---|---|---|
| `XiaoHongShuClient` | 小红书 | `get_note_by_keyword()`, `get_note_comments()` |
| `DouYinClient` | 抖音 | `search_note()`, `get_aweme_comments()` |
| `KuaishouClient` | 快手 | `search_video()`, `get_comments()` |
| `BilibiliClient` | B站 | `search_video()`, `get_comment_list()` |
| `WeiboClient` | 微博 | `get_notes_by_keyword()`, `get_comments()` |
| `TieBaClient` | 贴吧 | `get_note_list()`, `get_floor_list()` |
| `ZhihuClient` | 知乎 | `search_content()`, `get_comments()` |

### 存储类

| 类名 | 说明 |
|---|---|
| `ExcelStoreBase` | Excel 存储基类 |
| `MongoDBStoreBase` | MongoDB 存储基类 |

### 异常类

| 类名 | 说明 |
|---|---|
| `DataFetchError` | 数据获取错误 |
| `IPBlockError` | IP 被封禁错误 |
| `NoteNotFoundError` | 笔记/帖子未找到 |
| `LoginError` | 登录错误 |
| `ProxyError` | 代理错误 |

---

## 最佳实践

### 1. 登录状态保持

项目支持多种登录方式，推荐使用二维码登录以获得最佳稳定性：

```python
# 在 base_config.py 中配置
LOGIN_TYPE = "qrcode"
SAVE_LOGIN_STATE = True  # 保存登录状态
```

### 2. 代理使用

在大规模爬取时启用 IP 代理：

```python
ENABLE_IP_PROXY = True
IP_PROXY_POOL_COUNT = 5  # 根据需求调整
```

### 3. 请求频率控制

```python
CRAWLER_MAX_SLEEP_SEC = 2        # 爬取间隔（秒）
MAX_CONCURRENCY_NUM = 1           # 并发数
CRAWLER_MAX_NOTES_COUNT = 15      # 最大爬取数量
```

### 4. 数据存储选择

| 场景 | 推荐存储 |
|---|---|
| 快速测试 | `jsonl` |
| 少量数据 | `csv`, `excel` |
| 生产环境 | `db`, `mongodb` |
| 需要去重 | `db` |

---

## 扩展开发

### 添加新平台

1. 在 `media_platform/` 下创建新平台目录
2. 实现以下文件：
   - `client.py` - API 客户端（继承 `AbstractApiClient`）
   - `core.py` - 爬虫核心（继承 `AbstractCrawler`）
   - `login.py` - 登录逻辑（继承 `AbstractLogin`）
   - `field.py` - 字段枚举
   - `help.py` - 辅助函数
   - `exception.py` - 异常定义
3. 在 `model/` 下添加数据模型
4. 在 `store/` 下添加存储实现
5. 在 `main.py` 的 `CrawlerFactory.CRAWLERS` 中注册

### 添加新存储后端

1. 在 `store/` 下创建新存储文件
2. 继承 `AbstractStore` 抽象类
3. 实现所有抽象方法
4. 在 `config/base_config.py` 中添加配置项

---

## 注意事项

1. **合规使用**：本项目仅供学习和研究使用，请遵守各平台的使用条款
2. **频率控制**：请合理设置爬取间隔，避免对平台造成压力
3. **登录安全**：建议使用小号或测试账号进行登录
4. **数据保护**：妥善保管 Cookie 和登录状态文件
5. **IP 限制**：大规模爬取时建议配合 IP 代理使用

---

*文档版本：1.0.0*
*最后更新：2026-05-14*
