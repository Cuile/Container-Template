#!/bin/bash
# Prefect 环境初始化脚本

set -e  # 遇到错误立即退出

# 1. 等待 API 就绪
echo "⏳ 等待 Prefect API 就绪..."
while ! curl -s -f http://192.168.1.16:4200/api/health > /dev/null 2>&1; do
    sleep 2
done
echo "✅ API 已就绪"

# 初始化函数，确保命令失败时脚本退出（除非明确忽略）
init_work_pool() {
    echo "🔧 创建/检查 Work Pool 'local-pool'..."
    podman exec prefect-worker /bin/bash -c '
        prefect work-pool create local-pool --type process 2>/dev/null || {
            echo "ℹ️  local-pool 已存在或创建失败"
        }
    '
}

init_work_queue() {
    local queue_name=$1
    local limit=$2
    echo "🔧 创建/检查 Work Queue '$queue_name'..."
    podman exec prefect-worker /bin/bash -c "
        prefect work-queue create $queue_name --pool local-pool --limit $limit 2>/dev/null || {
            echo 'ℹ️  $queue_name 已存在或创建失败'
        }
        prefect work-queue set-concurrency-limit $queue_name $limit --pool local-pool 2>/dev/null || true
    "
}

init_work_pool
init_work_queue "local-queue" 6
init_work_queue "net-queue" 6

echo "🎉 Prefect 初始化完成！"