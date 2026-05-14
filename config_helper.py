#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MediaCrawler 配置助手
帮助用户配置爬取目标并运行爬虫
"""

import os
import sys
import shutil
from pathlib import Path

PROJECT_ROOT = Path(__file__).parent

TARGET_USERS = ["aawa1103", "SS", "麦穗嘉"]

PLATFORM_CONFIGS = {
    "xhs": {
        "name": "小红书",
        "config_file": "config/xhs_config.py",
        "list_key": "XHS_CREATOR_ID_LIST",
        "url_format": "https://www.xiaohongshu.com/user/profile/{user_id}?xsec_token={token}&xsec_source=pc_search",
        "instructions": """
【小红书配置说明】
1. 打开小红书网页版: https://www.xiaohongshu.com
2. 登录你的账号
3. 进入目标用户的个人主页
4. 复制浏览器地址栏中的完整URL
5. URL格式示例: https://www.xiaohongshu.com/user/profile/5f58bd990000000001003753?xsec_token=xxx&xsec_source=pc_search
6. 将完整的URL添加到 XHS_CREATOR_ID_LIST 列表中
"""
    },
    "wb": {
        "name": "微博",
        "config_file": "config/weibo_config.py",
        "list_key": "WEIBO_CREATOR_ID_LIST",
        "url_format": "https://weibo.com/u/{user_id}",
        "instructions": """
【微博配置说明】
1. 打开微博网页版: https://weibo.com
2. 登录你的账号
3. 进入目标用户的个人主页
4. 从URL中提取用户ID（通常是数字）
   - 例如: https://weibo.com/u/5756404150 中的 5756404150
5. 将用户ID添加到 WEIBO_CREATOR_ID_LIST 列表中
"""
    },
    "bili": {
        "name": "B站",
        "config_file": "config/bilibili_config.py",
        "list_key": "BILI_CREATOR_ID_LIST",
        "url_format": "https://space.bilibili.com/{uid}",
        "instructions": """
【B站配置说明】
1. 打开B站网页版: https://www.bilibili.com
2. 登录你的账号
3. 进入目标用户的个人主页
4. 从URL中提取UID（通常是数字）
   - 例如: https://space.bilibili.com/434377496 中的 434377496
5. 将UID添加到 BILI_CREATOR_ID_LIST 列表中
"""
    },
    "dy": {
        "name": "抖音",
        "config_file": "config/dy_config.py",
        "list_key": "DY_CREATOR_ID_LIST",
        "url_format": "https://www.douyin.com/user/{sec_user_id}",
        "instructions": """
【抖音配置说明】
1. 打开抖音网页版: https://www.douyin.com
2. 登录你的账号
3. 进入目标用户的个人主页
4. 从URL中提取 sec_user_id
   - 例如: https://www.douyin.com/user/MS4wLjABAAAAxxx
5. 将 sec_user_id 添加到 DY_CREATOR_ID_LIST 列表中
"""
    }
}


def print_banner():
    print("=" * 60)
    print("  MediaCrawler 配置助手")
    print("  目标用户: " + ", ".join(TARGET_USERS))
    print("=" * 60)
    print()


def show_instructions():
    print("[设置说明]")
    print()
    print("此爬虫需要以下步骤来配置:")
    print()
    print("1. 登录认证（需要二维码扫描）")
    print("   - 使用本地Chrome浏览器")
    print("   - 启用Chrome远程调试功能")
    print()
    print("2. 配置目标用户")
    print("   - 需要从各平台获取用户主页URL")
    print("   - 小红书需要完整的 xsec_token")
    print()
    print("3. Chrome远程调试设置:")
    print("   a. 关闭所有Chrome窗口")
    print("   b. 命令行启动Chrome:")
    print("      - Windows: ")
    print("        chrome.exe --remote-debugging-port=9222")
    print("      - macOS: ")
    print("        /Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome --remote-debugging-port=9222")
    print("      - Linux: ")
    print("        google-chrome --remote-debugging-port=9222")
    print("   c. 在Chrome中打开: chrome://inspect/#remote-debugging")
    print("   d. 勾选 'Allow remote debugging'")
    print()
    print("=" * 60)


def configure_platform(platform_key: str):
    config = PLATFORM_CONFIGS.get(platform_key)
    if not config:
        print(f"[错误] 不支持的平台: {platform_key}")
        return

    print(f"\n{'=' * 60}")
    print(f"  配置 {config['name']}")
    print(f"{'=' * 60}")

    print(config['instructions'])

    user_ids_input = input(f"\n请输入 {config['name']} 用户ID/URL（多个用逗号分隔）:\n> ")

    if not user_ids_input.strip():
        print("跳过此平台")
        return

    user_ids = [uid.strip() for uid in user_ids_input.split(",") if uid.strip()]

    config_file = PROJECT_ROOT / config['config_file']
    if not config_file.exists():
        print(f"[错误] 配置文件不存在: {config_file}")
        return

    print(f"\n请手动编辑 {config_file} 文件:")
    print(f"将以下内容添加到 {config['list_key']} 列表中:")
    print()
    for uid in user_ids:
        print(f'    "{uid}",')
    print()
    input("按 Enter 键继续...")


def generate_run_commands():
    print("\n" + "=" * 60)
    print("  爬虫运行命令")
    print("=" * 60)
    print()

    platforms = ["xhs", "wb", "bili", "dy"]

    print("在项目目录下运行以下命令:")
    print()

    for platform in platforms:
        config = PLATFORM_CONFIGS.get(platform)
        print(f"# {config['name']}:")
        print(f"uv run main.py --platform {platform} --lt qrcode --type creator --save_data_option jsonl")
        print()


def main():
    print_banner()
    show_instructions()

    print("\n[配置步骤]")
    print()
    print("1. 依次为每个平台配置目标用户")
    print("2. 配置完成后，运行爬虫")
    print()

    response = input("是否现在开始配置平台？(y/n): ").strip().lower()

    if response == 'y':
        for platform in PLATFORM_CONFIGS.keys():
            configure_platform(platform)

    generate_run_commands()

    print("\n" + "=" * 60)
    print("  配置完成!")
    print("=" * 60)
    print()
    print("下一步:")
    print("1. 确保已启用Chrome远程调试")
    print("2. 在项目目录运行: uv run main.py --platform <平台> --lt qrcode --type creator")
    print("3. 扫描浏览器中显示的二维码进行登录")
    print()


if __name__ == "__main__":
    main()
