# -*- coding: utf-8 -*-
"""
自动化爬虫脚本 - 爬取 aawa1103、SS、麦穗嘉 在多个平台的信息
支持：小红书、抖音、快手、微博
"""

import subprocess
import sys
import os
from datetime import datetime

# 设置关键词
KEYWORDS = ["aawa1103", "SS", "麦穗嘉"]

# 平台列表
PLATFORMS = {
    "xhs": "小红书",
    "dy": "抖音",
    "ks": "快手",
    "wb": "微博"
}

def run_crawler(platform: str, keywords: list, crawler_type: str = "search"):
    """
    运行爬虫
    
    Args:
        platform: 平台名称 (xhs/dy/ks/wb)
        keywords: 关键词列表
        crawler_type: 爬取类型 (search/creator)
    """
    keyword_str = ",".join(keywords)
    
    print(f"\n{'='*60}")
    print(f"开始爬取 {PLATFORMS.get(platform, platform)} 平台")
    print(f"关键词: {keyword_str}")
    print(f"类型: {crawler_type}")
    print(f"{'='*60}\n")
    
    cmd = [
        sys.executable, "main.py",
        "--platform", platform,
        "--type", crawler_type,
        "--keywords", keyword_str,
        "--lt", "qrcode",
        "--save_data_option", "jsonl",
        "--get_comment", "true",
        "--get_sub_comment", "false",
        "--headless", "false"
    ]
    
    try:
        result = subprocess.run(
            cmd,
            cwd=os.path.dirname(os.path.abspath(__file__)),
            capture_output=False,
            text=True
        )
        return result.returncode == 0
    except Exception as e:
        print(f"爬虫运行出错: {e}")
        return False

def crawl_all_platforms():
    """爬取所有平台"""
    print(f"\n{'#'*60}")
    print(f"# 自动化爬虫开始 - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print(f"# 关键词: {KEYWORDS}")
    print(f"#{'#'*60}\n")
    
    results = {}
    
    for platform in PLATFORMS.keys():
        success = run_crawler(platform, KEYWORDS, "search")
        results[platform] = "✅ 成功" if success else "❌ 失败"
    
    # 打印汇总
    print(f"\n{'='*60}")
    print("爬取结果汇总")
    print(f"{'='*60}")
    for platform, status in results.items():
        print(f"{PLATFORMS[platform]}: {status}")
    print(f"{'='*60}\n")

if __name__ == "__main__":
    crawl_all_platforms()
