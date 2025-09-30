#!/usr/bin/env bash
#
# 功能：遍历指定目录，检测并删除所有0字节文件
# 目标目录：脚本所在路径下的 target/libs-releases/org/gradle
# 适用场景：清理Gradle Tooling API下载过程中产生的无效0字节文件
#作者：android_zero 别名：零丶

set -eu

# 1. 初始化目标目录（基于脚本所在路径）
script_dir=$(dirname $(realpath $0))
target_root_dir="$script_dir/target/libs-releases/org/gradle"

# 2. 前置检查：目标目录是否存在
if ! [[ -d "$target_root_dir" ]]; then
    echo "错误：目标目录不存在 -> $target_root_dir"
    echo "请先执行下载脚本，确保目录已生成"
    exit 1
fi

# 3. 统计初始化
total_zero_files=0
deleted_files=()

# 4. 遍历目录下所有文件（递归遍历子目录）
echo "=================================================="
echo "开始扫描目标目录：$target_root_dir"
echo "仅检测并删除0字节文件，正常文件将跳过..."
echo "=================================================="

# 使用find命令递归查找所有文件，排除目录（仅处理文件）
find "$target_root_dir" -type f | while read -r file; do
    # 获取文件大小（兼容Linux/macOS）
    if [[ "$(uname)" == "Darwin" ]]; then
        file_size=$(stat -f "%z" "$file")  # macOS系统stat参数
    else
        file_size=$(stat -c "%s" "$file")  # Linux系统stat参数
    fi

    # 检测是否为0字节文件
    if [[ $file_size -eq 0 ]]; then
        echo "发现0字节文件：$file"
        # 删除文件并记录
        if rm -f "$file"; then
            deleted_files+=("$file")
            total_zero_files=$((total_zero_files + 1))
            echo "已删除：$file"
        else
            echo "警告：删除失败 -> $file"
        fi
    fi
done

# 5. 输出清理结果
echo -e "\n=================================================="
if [[ $total_zero_files -eq 0 ]]; then
    echo "清理完成！未发现任何0字节文件"
else
    echo "清理完成！共发现 $total_zero_files 个0字节文件，已全部删除："
    for deleted in "${deleted_files[@]}"; do
        echo " - $deleted"
    done
fi
echo "=================================================="
