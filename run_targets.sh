#!/bin/bash
# MediaCrawler 批量爬取脚本
# 用于爬取 aawa1103、SS、麦穗嘉 的用户信息

echo "=========================================="
echo "  MediaCrawler 批量爬取脚本"
echo "  目标用户: aawa1103、SS、麦穗嘉"
echo "=========================================="
echo ""

# 设置项目目录
PROJECT_DIR="/path/to/MediaCrawler"  # 请替换为你的实际项目路径

# 基础配置
PLATFORM=$1
LOGIN_TYPE="qrcode"
CRAWLER_TYPE="creator"
SAVE_OPTION="jsonl"

# 检查参数
if [ -z "$PLATFORM" ]; then
    echo "用法: bash run_targets.sh <平台> [用户名...]"
    echo ""
    echo "支持的平台:"
    echo "  xhs     - 小红书"
    echo "  wb      - 微博"
    echo "  bili    - B站"
    echo "  dy      - 抖音"
    echo "  ks      - 快手"
    echo "  tieba   - 贴吧"
    echo "  zhihu   - 知乎"
    echo "  all     - 所有平台"
    echo ""
    echo "示例:"
    echo "  bash run_targets.sh xhs          # 爬取小红书"
    echo "  bash run_targets.sh all         # 爬取所有平台"
    echo ""
    exit 1
fi

# 运行爬虫
run_crawler() {
    local platform=$1
    echo "----------------------------------------"
    echo "正在爬取平台: $platform"
    echo "----------------------------------------"

    cd "$PROJECT_DIR" || exit 1

    uv run main.py \
        --platform "$platform" \
        --lt qrcode \
        --type creator \
        --save_data_option "$SAVE_OPTION" \
        --get_comment true \
        --get_sub_comment false

    echo ""
    echo "平台 $platform 爬取完成!"
    echo ""
}

# 执行爬取
if [ "$PLATFORM" == "all" ]; then
    echo "将依次爬取所有平台..."
    echo ""

    for plat in xhs wb bili dy; do
        run_crawler "$plat"
        sleep 5  # 平台间休息5秒
    done

    echo "=========================================="
    echo "  所有平台爬取完成!"
    echo "=========================================="
else
    run_crawler "$PLATFORM"
fi

echo ""
echo "数据将保存到 data/ 目录下"
