#!/usr/bin/env bash

#
#English translation：
#version 2.1
#2.1 version Improved Producer: android_zero (零丶)
#illustrate: 
# 1. Batch download: Change from a single download version to a multi-version queue, and download all required version files to the queue one by one.
# 2. Check for empty files: Check for 0-byte blank files and skip them if they exist
#3. Check Files: Skip the downloaded files
#
#中文：
#版本 2.1
#2.1 版本制作人：android_zero  别名：零丶
#illustrate：
# 1.批量下载：从单下载版本更改为多版本队列，将所有需要的版本文件逐个下载到队列中。
# 2.检查空文件：检查 0 字节的空白文件，如果存在，则跳过它们
#3.检查文件：跳过下载的文件

#  This file is part of ZeroStudio.
#
#  ZeroStudio is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  ZeroStudio is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#   along with ZeroStudio.  If not, see <https://www.gnu.org/licenses/>.
#

set -eu

# 初始化基础配置
script_dir=$(dirname $(realpath $0))
group=android.zero.studio.gradle.toolingapi
artifactId=gradle-tooling-api
serverId=ossrh
PUBLISH_URL=https://s01.oss.sonatype.org/service/local/staging/deploy/maven2/
DOWNLOAD_BASE_URL="https://repo.gradle.org/gradle/libs-releases/org/gradle/$artifactId"

# 定义需要下载和发布的所有版本（队列）
declare -a ALL_VERSIONS=(
    "0.9.2"
    "1.0-milestone-1" "1.0-milestone-2" "1.0-milestone-2a" "1.0-milestone-3" "1.0-milestone-4"
    "1.0-milestone-5" "1.0-milestone-6" "1.0-milestone-7" "1.0-milestone-8" "1.0-milestone-8a"
    "1.0-milestone-9" "1.0-rc-1" "1.0-rc-2" "1.0-rc-3" "1.0"
    "1.1-rc-1" "1.1-rc-2" "1.1"
    "1.2-rc-1" "1.2"
    "1.3-rc-1" "1.3-rc-2" "1.3"
    "1.4-rc-1" "1.4-rc-2" "1.4-rc-3" "1.4"
    "1.5-rc-1" "1.5-rc-2" "1.5-rc-3" "1.5"
    "1.6-rc-1" "1.6"
    "1.7-rc-1" "1.7-rc-2" "1.7"
    "1.8-rc-1" "1.8-rc-2" "1.8"
    "1.9-rc-1" "1.9-rc-2" "1.9-rc-3" "1.9-rc-4" "1.9"
    "1.10-rc-1" "1.10-rc-2" "1.10"
    "1.11-rc-1" "1.11"
    "1.12-rc-1" "1.12-rc-2" "1.12"
    "2.0-rc-1" "2.0-rc-2" "2.0"
    "2.1-rc-1" "2.1-rc-2" "2.1-rc-3" "2.1-rc-4" "2.1"
    "2.2-rc-1" "2.2-rc-2" "2.2"
    "2.2.1-rc-1" "2.2.1"
    "2.3-rc-1" "2.3-rc-2" "2.3-rc-3" "2.3-rc-4" "2.3"
    "2.4-rc-1" "2.4-rc-2" "2.4"
    "2.5-rc-1" "2.5-rc-2" "2.5"
    "2.6-rc-1" "2.6-rc-2" "2.6"
    "2.7-rc-1" "2.7-rc-2" "2.7"
    "2.8-rc-1" "2.8-rc-2" "2.8"
    "2.9-rc-1" "2.9"
    "2.10-rc-1" "2.10-rc-2" "2.10"
    "2.11-rc-1" "2.11-rc-2" "2.11-rc-3" "2.11"
    "2.12-rc-1" "2.12"
    "2.13-rc-1" "2.13-rc-2" "2.13"
    "2.14-rc-1" "2.14-rc-2" "2.14-rc-3" "2.14-rc-4" "2.14-rc-5" "2.14-rc-6" "2.14"
    "2.14.1-rc-1" "2.14.1-rc-2" "2.14.1"
    "3.0-milestone-1" "3.0-milestone-2" "3.0-rc-1" "3.0-rc-2" "3.0"
    "3.1-rc-1" "3.1"
    "3.2-rc-1" "3.2-rc-2" "3.2-rc-3" "3.2" "3.2.1"
    "3.3-rc-1" "3.3"
    "3.4-rc-1" "3.4-rc-2" "3.4-rc-3" "3.4" "3.4.1"
    "3.5-rc-1" "3.5-rc-2" "3.5-rc-3" "3.5" "3.5.1"
    "4.0-milestone-1" "4.0-milestone-2" "4.0-rc-1" "4.0-rc-2" "4.0-rc-3" "4.0" "4.0.1" "4.0.2"
    "4.1-milestone-1" "4.1-rc-1" "4.1-rc-2" "4.1"
    "4.2-rc-1" "4.2-rc-2" "4.2" "4.2.1"
    "4.3-rc-1" "4.3-rc-2" "4.3-rc-3" "4.3-rc-4" "4.3" "4.3.1"
    "4.4-rc-1" "4.4-rc-2" "4.4-rc-3" "4.4-rc-4" "4.4-rc-5" "4.4-rc-6" "4.4" "4.4.1"
    "4.5-rc-1" "4.5-rc-2" "4.5" "4.5.1"
    "4.6-rc-1" "4.6-rc-2" "4.6"
    "4.7-rc-1" "4.7-rc-2" "4.7"
    "4.8-rc-1" "4.8-rc-2" "4.8-rc-3" "4.8" "4.8.1"
    "4.9-rc-1" "4.9-rc-2" "4.9"
    "4.10-rc-1" "4.10-rc-2" "4.10-rc-3" "4.10" "4.10.1" "4.10.2" "4.10.3"
    "5.0-milestone-1" "5.0-rc-1" "5.0-rc-2" "5.0-rc-3" "5.0-rc-4" "5.0-rc-5" "5.0"
    "5.1-milestone-1" "5.1-rc-1" "5.1-rc-2" "5.1-rc-3" "5.1" "5.1.1"
    "5.2-rc-1" "5.2" "5.2.1"
    "5.3-rc-1" "5.3-rc-2" "5.3-rc-3" "5.3" "5.3.1"
    "5.4-rc-1" "5.4" "5.4.1"
    "5.5-rc-1" "5.5-rc-2" "5.5-rc-3" "5.5-rc-4" "5.5" "5.5.1"
    "5.6-rc-1" "5.6-rc-2" "5.6" "5.6.1" "5.6.2" "5.6.3" "5.6.4"
    "6.0-rc-1" "6.0-rc-2" "6.0-rc-3" "6.0" "6.0.1"
    "6.1-milestone-1" "6.1-milestone-2" "6.1-milestone-3" "6.1-rc-1" "6.1-rc-2" "6.1-rc-3" "6.1" "6.1.1"
    "6.2-rc-1" "6.2-rc-2" "6.2-rc-3" "6.2" "6.2.1" "6.2.2"
    "6.3-rc-1" "6.3-rc-2" "6.3-rc-3" "6.3-rc-4" "6.3"
    "6.4-rc-1" "6.4-rc-2" "6.4-rc-3" "6.4-rc-4" "6.4" "6.4.1"
    "6.5-milestone-1" "6.5-milestone-2" "6.5-rc-1" "6.5" "6.5.1"
    "6.6-milestone-1" "6.6-milestone-2" "6.6-milestone-3" "6.6-rc-1" "6.6-rc-2" "6.6-rc-3" "6.6-rc-4" "6.6-rc-5" "6.6-rc-6" "6.6" "6.6.1"
    "6.7-rc-1" "6.7-rc-2" "6.7-rc-3" "6.7-rc-4" "6.7-rc-5" "6.7" "6.7.1"
    "6.8-milestone-1" "6.8-milestone-2" "6.8-milestone-3" "6.8-rc-1" "6.8-rc-2" "6.8-rc-3" "6.8-rc-4" "6.8-rc-5" "6.8" "6.8.1" "6.8.2" "6.8.3"
    "6.9-rc-1" "6.9-rc-2" "6.9" "6.9.1" "6.9.2" "6.9.3" "6.9.4"
    "7.0-milestone-1" "7.0-milestone-2" "7.0-milestone-3" "7.0-rc-1" "7.0-rc-2" "7.0" "7.0.1" "7.0.2"
    "7.1-rc-1" "7.1-rc-2" "7.1" "7.1.1"
    "7.2-rc-1" "7.2-rc-2" "7.2-rc-3" "7.2"
    "7.3-rc-1" "7.3-rc-2" "7.3-rc-3" "7.3-rc-4" "7.3-rc-5" "7.3" "7.3.1" "7.3.2" "7.3.3-rc-1" "7.3.3"
    "7.4-rc-1" "7.4-rc-2" "7.4" "7.4.1" "7.4.2"
    "7.5-milestone-1" "7.5-rc-1" "7.5-rc-2" "7.5-rc-3" "7.5-rc-4" "7.5-rc-5" "7.5" "7.5.1"
    "7.6-milestone-1" "7.6-rc-1" "7.6-rc-2" "7.6-rc-3" "7.6-rc-4" "7.6" "7.6.1" "7.6.2" "7.6.3" "7.6.4" "7.6.5" "7.6.6"
    "8.0-milestone-1" "8.0-milestone-2" "8.0-milestone-3" "8.0-milestone-4" "8.0-milestone-5" "8.0-milestone-6" "8.0-rc-1" "8.0-rc-2" "8.0-rc-3" "8.0-rc-4" "8.0-rc-5" "8.0" "8.0.1" "8.0.2"
    "8.1-rc-1" "8.1-rc-2" "8.1-rc-3" "8.1-rc-4" "8.1" "8.1.1"
    "8.2-milestone-1" "8.2-rc-1" "8.2-rc-2" "8.2-rc-3" "8.2" "8.2.1"
    "8.3-rc-1" "8.3-rc-2" "8.3-rc-3" "8.3-rc-4" "8.3"
    "8.4-rc-1" "8.4-rc-2" "8.4-rc-3" "8.4"
    "8.5-rc-1" "8.5-rc-2" "8.5-rc-3" "8.5-rc-4" "8.5"
    "8.6-milestone-1" "8.6-rc-1" "8.6-rc-2" "8.6-rc-3" "8.6-rc-4" "8.6"
    "8.7-rc-1" "8.7-rc-2" "8.7-rc-3" "8.7-rc-4" "8.7"
    "8.8-rc-1" "8.8-rc-2" "8.8"
    "8.9-rc-1" "8.9-rc-2" "8.9"
    "8.10-rc-1" "8.10" "8.10.1" "8.10.2-milestone-1" "8.10.2"
    "8.11-milestone-1" "8.11-rc-1" "8.11-rc-2" "8.11-rc-3" "8.11" "8.11.1"
    "8.12-rc-1" "8.12-rc-2" "8.12" "8.12.1-milestone-1" "8.12.1"
    "8.13-milestone-1" "8.13-milestone-2" "8.13-milestone-3" "8.13-rc-1" "8.13-rc-2" "8.13"
    "8.14-milestone-1" "8.14-milestone-2" "8.14-milestone-3" "8.14-milestone-4" "8.14-milestone-5" "8.14-milestone-6" "8.14-milestone-7" "8.14-milestone-8" "8.14-rc-1" "8.14-rc-2" "8.14-rc-3" "8.14" "8.14.1" "8.14.2" "8.14.3"
    "9.0-milestone-1" "9.0-milestone-2" "9.0-milestone-3" "9.0-milestone-4" "9.0-milestone-5" "9.0-milestone-6" "9.0-milestone-7" "9.0.0-milestone-8" "9.0.0-milestone-9" "9.0.0-milestone-10" "9.0.0-rc-1" "9.0.0-rc-2" "9.0.0-rc-3" "9.0.0-rc-4" "9.0.0"
    "9.1.0-rc-1" "9.1.0-rc-2" "9.1.0-rc-3" "9.1.0-rc-4" "9.1.0"
    "9.2.0-milestone-1" "9.2.0-milestone-2"
)

# 前置检查：确保pom.xml.in模板存在
if ! [[ -f "$script_dir/pom.xml.in" ]]; then
    echo "错误：未找到POM模板文件 $script_dir/pom.xml.in"
    exit 1
fi

# ======================== 核心新增：文件存在性校验函数 ========================
# 功能：检测单个文件URL是否存在（避免下载不存在的文件）
# 参数：$1 = 文件URL
# 返回：0=文件存在，1=文件不存在（404+目标错误JSON），2=网络异常
check_file_exist() {
    local file_url="$1"
    local temp_response="/tmp/file_check_response.tmp"  # 临时存储响应内容

    # 发送HEAD请求（轻量，仅获取响应头，不下载文件），超时10秒，重试2次
    if ! curl -s -I -L --max-time 10 --retry 2 "$file_url" -o "$temp_response" 2>/dev/null; then
        rm -f "$temp_response"
        return 2  # 网络异常（超时/连接失败）
    fi

    # 提取HTTP状态码（如200=存在，404=不存在）
    local http_status=$(grep -oE '^HTTP/[0-9.]+ [0-9]+' "$temp_response" | awk '{print $2}')

    # 情况1：状态码200 → 文件存在
    if [[ "$http_status" -eq 200 ]]; then
        rm -f "$temp_response"
        return 0
    fi

    # 情况2：状态码404 → 进一步检查响应体是否为目标错误JSON
    if [[ "$http_status" -eq 404 ]]; then
        # 下载响应体（仅404时下载，内容少，不耗时）
        local response_body=$(curl -s -L --max-time 10 "$file_url" 2>/dev/null)
        # 匹配错误特征：包含"status" : 404 和 "Could not find resource"
        if echo "$response_body" | grep -q '"status" : 404' && echo "$response_body" | grep -q 'Could not find resource'; then
            rm -f "$temp_response"
            return 1  # 确认文件不存在（目标404错误）
        fi
    fi

    # 其他情况（如500服务器错误）→ 按网络异常处理
    rm -f "$temp_response"
    return 2
}

# 遍历所有版本，执行下载+发布
total_versions=${#ALL_VERSIONS[@]}
current_index=1

for DOWNLOAD_VERSION in "${ALL_VERSIONS[@]}"; do
    # 进度提示
    echo -e "\n=================================================="
    echo "正在处理版本 $current_index/$total_versions：$DOWNLOAD_VERSION"
    echo "=================================================="
    
    # 发布版本与下载版本保持一致
    PUBLISH_VERSION="$DOWNLOAD_VERSION"
    
    # 定义文件路径
    download_dir="$script_dir/target/libs-releases/org/gradle/$artifactId/$DOWNLOAD_VERSION"
    file_base="$download_dir/$artifactId-$DOWNLOAD_VERSION"
    mkdir -p "$download_dir"
    
    # 1. 先检查本地文件是否完整（复用原有逻辑）
    download_success=false
    zero_byte_retry=1
    retry_count=3

    check_files() {
        local has_zero_byte=0
        for file in "$file_base.jar" "$file_base-sources.jar" "$file_base-javadoc.jar"; do
            if [[ -f "$file" ]]; then
                if [[ "$(uname)" == "Darwin" ]]; then
                    file_size=$(stat -f "%z" "$file")
                else
                    file_size=$(stat -c "%s" "$file")
                fi
                if [[ $file_size -eq 0 ]]; then
                    echo "警告：检测到0字节文件，将删除并重新下载：$file"
                    rm -f "$file"
                    has_zero_byte=1
                fi
            else
                has_zero_byte=1
            fi
        done
        [[ $has_zero_byte -eq 0 ]] && return 0 || return 1
    }

    if check_files; then
        echo "文件已存在且完整，跳过下载：$DOWNLOAD_VERSION"
        download_success=true
    else
        # ======================== 核心改进：下载前先校验远程文件是否存在 ========================
        echo "开始校验远程文件是否存在（版本：$DOWNLOAD_VERSION）"
        local jar_url="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION.jar"
        local sources_url="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION-sources.jar"
        local javadoc_url="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION-javadoc.jar"
        local missing_files=()

        # 逐个校验3个文件的远程存在性
        for url in "$jar_url" "$sources_url" "$javadoc_url"; do
            file_name=$(basename "$url")
            if check_file_exist "$url"; then
                echo "✅ 远程文件存在：$file_name"
            else
                local check_result=$?
                if [[ $check_result -eq 1 ]]; then
                    echo "❌ 远程文件不存在（404）：$file_name → 跳过该文件下载"
                    missing_files+=("$file_name")
                else
                    echo "⚠️  远程文件校验失败（网络异常）：$file_name → 将尝试下载"
                fi
            fi
        done

        # 若3个文件都不存在 → 直接跳过当前版本（不执行下载）
        if [[ ${#missing_files[@]} -eq 3 ]]; then
            echo "警告：版本 $DOWNLOAD_VERSION 的3个核心文件均不存在，跳过下载"
            current_index=$((current_index + 1))
            continue
        fi

        # 2. 原有下载逻辑（仅下载存在的远程文件）
        # 处理0字节重试
        if [[ $zero_byte_retry -gt 0 ]]; then
            echo "开始处理0字节文件，重新下载版本 $DOWNLOAD_VERSION"
            local download_ok=1
            # 仅下载远程存在的文件
            [[ ! " ${missing_files[@]} " =~ " $(basename "$jar_url") " ]] && wget "$jar_url" -O "$file_base.jar" || download_ok=0
            [[ ! " ${missing_files[@]} " =~ " $(basename "$sources_url") " ]] && wget "$sources_url" -O "$file_base-sources.jar" || true
            [[ ! " ${missing_files[@]} " =~ " $(basename "$javadoc_url") " ]] && wget "$javadoc_url" -O "$file_base-javadoc.jar" || true
            
            if [[ $download_ok -eq 1 && check_files ]]; then
                echo "0字节文件修复成功：$DOWNLOAD_VERSION"
                download_success=true
                zero_byte_retry=0
            else
                echo "0字节文件修复失败，进行常规重试"
                zero_byte_retry=0
            fi
        fi

        # 常规下载重试
        while [[ $retry_count -gt 0 && $download_success == false ]]; do
            echo "常规下载重试 $((4 - retry_count))/3：$DOWNLOAD_VERSION"
            local download_ok=1
            [[ ! " ${missing_files[@]} " =~ " $(basename "$jar_url") " ]] && wget "$jar_url" -O "$file_base.jar" || download_ok=0
            [[ ! " ${missing_files[@]} " =~ " $(basename "$sources_url") " ]] && wget "$sources_url" -O "$file_base-sources.jar" || true
            [[ ! " ${missing_files[@]} " =~ " $(basename "$javadoc_url") " ]] && wget "$javadoc_url" -O "$file_base-javadoc.jar" || true
            
            if [[ $download_ok -eq 1 && check_files ]]; then
                echo "常规下载成功：$DOWNLOAD_VERSION"
                download_success=true
            else
                retry_count=$((retry_count - 1))
                echo "下载失败，5秒后重试（剩余：$retry_count）"
                sleep 5
            fi
        done
    fi

    # 下载失败跳过
    if [[ $download_success == false ]]; then
        echo "警告：版本 $DOWNLOAD_VERSION 下载失败，跳过发布"
        current_index=$((current_index + 1))
        continue
    fi

    # 2. 生成POM文件（不变）
    pom_file="$download_dir/pom-$DOWNLOAD_VERSION.xml"
    cp "$script_dir/pom.xml.in" "$pom_file"
    sed -i "s|@@GROUP@@|$group|g" "$pom_file"
    sed -i "s|@@ARTIFACT@@|$artifactId|g" "$pom_file"
    sed -i "s|@@VERSION@@|$PUBLISH_VERSION|g" "$pom_file"
    echo "生成POM文件：$pom_file"

    # 3. 发布（不变）
    echo "开始发布版本 $PUBLISH_VERSION"
    if mvn gpg:sign-and-deploy-file -e \
        -Durl="$PUBLISH_URL" \
        -DrepositoryId="$serverId" \
        -Dfile="$file_base.jar" \
        -Dsources="$file_base-sources.jar" \
        -Djavadoc="$file_base-javadoc.jar" \
        -DpomFile="$pom_file" \
        -DgroupId="$group" \
        -DartifactId="$artifactId" \
        -Dversion="$PUBLISH_VERSION" \
        -Dpackaging=jar \
        -DrepositoryLayout=default; then
        echo "发布成功：$PUBLISH_VERSION"
    else
        echo "警告：版本 $PUBLISH_VERSION 发布失败"
    fi

    current_index=$((current_index + 1))
done

# 完成提示
echo -e "\n=================================================="
echo "所有版本处理完成！共处理 $total_versions 个版本"
echo "下载文件存放于：$script_dir/target/libs-releases/org/gradle/$artifactId/"
echo "成功/失败详情请查看日志"
echo "=================================================="
