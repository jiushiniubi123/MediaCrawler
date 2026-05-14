# -*- coding: utf-8 -*-
"""
爬虫配置文件 - 用于爬取 aawa1103、SS、麦穗嘉 的信息
使用方法：将此文件中的配置复制到对应的平台配置文件中
"""

# ============================================
# 小红书配置 (xhs_config.py)
# ============================================
# 创作者主页 URL 列表 - 需要从浏览器地址栏获取完整URL（包含 xsec_token）
XHS_CREATOR_ID_LIST = [
    # 替换为实际的创作者主页URL
    # 格式：https://www.xiaohongshu.com/user/profile/用户ID?xsec_token=xxx&xsec_source=xxx
    # "https://www.xiaohongshu.com/user/profile/用户ID?xsec_token=xxx&xsec_source=pc_search",
]

# ============================================
# 微博配置 (weibo_config.py)
# ============================================
# 微博用户 ID 列表
WEIBO_CREATOR_ID_LIST = [
    # 替换为实际的微博用户ID
    # 可以从用户主页 URL 中提取，如 https://weibo.com/u/5756404150 中的 5756404150
    "5756404150",  # 示例
]

# ============================================
# B站配置 (bilibili_config.py)
# ============================================
# B站创作者 UID 列表
BILI_CREATOR_ID_LIST = [
    # 替换为实际的B站用户UID
    # 可以从用户主页 URL 中提取，如 https://space.bilibili.com/434377496 中的 434377496
    "434377496",  # 示例
]

# ============================================
# 抖音配置 (dy_config.py)
# ============================================
# 抖音创作者 sec_user_id 列表
DY_CREATOR_ID_LIST = [
    # 替换为实际的抖音 sec_user_id
    # 可以从用户主页 URL 中提取
    # 格式：https://www.douyin.com/user/MS4wLjABAAAATJPY7LAlaa5X-c8uNdWkvz0jUGgpw4eeXIwu_8BhvqE
]
