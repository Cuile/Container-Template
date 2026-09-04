#!/bin/bash
podman-compose -f ../container/prefect.yaml up -d

set -e  # 遇到错误立即退出

# 1. 等待 API 就绪
echo "⏳ 等待 Prefect API 就绪..."
while ! curl -s -f http://192.168.1.16:4200/api/health > /dev/null 2>&1; do
    sleep 2
done
echo "✅ API 已就绪"