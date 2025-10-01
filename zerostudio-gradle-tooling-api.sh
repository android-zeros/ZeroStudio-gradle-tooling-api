#!/usr/bin/env bash


#
#English translation：
#version 2.2
#2.2 version Improved Producer: android_zero (零丶)
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
group=io.github.android-zeros
artifactId=gradle-tooling-api
serverId=github
PUBLISH_URL=https://maven.pkg.github.com/android-zeros/ZeroStudio-gradle-tooling-api
DOWNLOAD_BASE_URL="https://repo.gradle.org/libs-releases/org/gradle/$artifactId"


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

# ======================== 核心修复1：精准远程文件存在性校验 ========================
# 功能：检测远程文件是否存在（仅200状态码视为存在，404直接返回不存在）
# 参数：$1 = 文件URL
# 返回：0=存在，1=不存在，2=网络异常
check_file_exist() {
    local file_url="$1"
    # 发送HEAD请求（轻量），超时10秒，重试2次，仅保留状态码
    local http_status=$(curl -s -I -L --max-time 10 --retry 2 "$file_url" | grep -oE '^HTTP/[0-9.]+ [0-9]+' | awk '{print $2}')
    
    if [[ -z "$http_status" ]]; then
        return 2  # 无响应 → 网络异常
    elif [[ "$http_status" -eq 200 ]]; then
        return 0  # 200 → 文件存在
    elif [[ "$http_status" -eq 404 ]]; then
        return 1  # 404 → 文件不存在
    else
        return 2  # 其他状态码（500等）→ 网络异常
    fi
}

# ======================== 核心修复2：优化本地文件完整性检查 ========================
# 功能：检查本地文件是否存在且非0字节
# 参数：$1 = 文件基础路径（不含后缀）
# 返回：0=完整，1=不完整
check_local_files() {
    local file_base="$1"
    # 只检查核心文件（jar必选，sources/javadoc可选，存在则需非0字节）
    local required_file="${file_base}.jar"
    
    # 1. 必选jar文件不存在 → 不完整
    if ! [[ -f "$required_file" ]]; then
        return 1
    fi
    
    # 2. 必选jar文件为0字节 → 不完整
    if [[ "$(uname)" == "Darwin" ]]; then
        jar_size=$(stat -f "%z" "$required_file")
    else
        jar_size=$(stat -c "%s" "$required_file")
    fi
    if [[ $jar_size -eq 0 ]]; then
        rm -f "$required_file"  # 删除0字节jar，避免重复判断
        return 1
    fi
    
    # 3. 可选文件（sources/javadoc）存在则需非0字节
    for optional_suffix in "-sources.jar" "-javadoc.jar"; do
        local optional_file="${file_base}${optional_suffix}"
        if [[ -f "$optional_file" ]]; then
            if [[ "$(uname)" == "Darwin" ]]; then
                opt_size=$(stat -f "%z" "$optional_file")
            else
                opt_size=$(stat -c "%s" "$optional_file")
            fi
            if [[ $opt_size -eq 0 ]]; then
                rm -f "$optional_file"  # 删除0字节可选文件
            fi
        fi
    done
    
    # 所有检查通过 → 完整
    return 0
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
    download_dir="$script_dir/target/android/zero/studio/gradle/tooling-api/$artifactId/$DOWNLOAD_VERSION"
    file_base="$download_dir/$artifactId-$DOWNLOAD_VERSION"
    mkdir -p "$download_dir"
    
    # ======================== 步骤1：检查本地文件，完整则直接跳过下载 ========================
    if check_local_files "$file_base"; then
        echo "✅ 本地文件已完整，跳过下载：$DOWNLOAD_VERSION"
        download_success=true
    else
        download_success=false
        
        # ======================== 步骤2：校验远程文件，确定要下载的文件列表 ========================
        echo "🔍 校验远程文件存在性（版本：$DOWNLOAD_VERSION）"
        # 定义3个文件的URL和路径
        declare -A files=(
            ["jar"]="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION.jar|$file_base.jar"
            ["sources"]="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION-sources.jar|$file_base-sources.jar"
            ["javadoc"]="$DOWNLOAD_BASE_URL/$DOWNLOAD_VERSION/$artifactId-$DOWNLOAD_VERSION-javadoc.jar|$file_base-javadoc.jar"
        )
         to_download=()  # 存储需要下载的文件（URL|本地路径）
         missing_count=0
        
        for type in "${!files[@]}"; do
            IFS='|' read -r url local_path <<< "${files[$type]}"
            if check_file_exist "$url"; then
                to_download+=("${files[$type]}")
                echo "✅ 远程存在：$type 文件"
            else
                 check_res=$?
                if [[ $check_res -eq 1 ]]; then
                    echo "❌ 远程404：$type 文件不存在，跳过"
                    missing_count=$((missing_count + 1))
                    # 删除本地残留的该类型0字节文件（若有）
                    [[ -f "$local_path" ]] && rm -f "$local_path"
                else
                    echo "⚠️  网络异常：$type 文件校验失败，尝试下载"
                    to_download+=("${files[$type]}")
                fi
            fi
        done
        
        # 若jar文件不存在（必选），直接跳过当前版本
         has_jar=false
       # 遍历to_download数组，检查是否包含jar文件
       for file_info in "${to_download[@]}"; do
          if [[ "$file_info" =~ "|$artifactId-$DOWNLOAD_VERSION.jar" ]]; then
             has_jar=true
           break
          fi
       done
      # 核心判断：要么3个文件都缺失，要么有缺失且没有jar文件 → 跳过版本
      if [[ $missing_count -eq 3 || (! $has_jar && $missing_count -ge 1) ]]; then
          echo "❌ 核心jar文件不存在，跳过版本：$DOWNLOAD_VERSION"
               current_index=$((current_index + 1))
          continue
      fi


        
        # ======================== 步骤3：下载需要的文件，跳过404，删除0字节 ========================
        echo "📥 开始下载（共${#to_download[@]}个文件）"
         download_failed=0
        for file_info in "${to_download[@]}"; do
            IFS='|' read -r url local_path <<< "$file_info"
            file_type=$(basename "$local_path" | grep -oE '(-sources|-javadoc)\.jar$' || echo ".jar")
            
            # 下载前删除旧文件（避免覆盖不完整文件）
            [[ -f "$local_path" ]] && rm -f "$local_path"
            
            # 执行下载（超时30秒，重试2次）
            if wget --timeout=30 --tries=2 "$url" -O "$local_path" -q; then
                # 下载后检查是否为0字节
                if [[ "$(uname)" == "Darwin" ]]; then
                    file_size=$(stat -f "%z" "$local_path")
                else
                    file_size=$(stat -c "%s" "$local_path")
                fi
                if [[ $file_size -eq 0 ]]; then
                    echo "⚠️  下载到0字节文件，删除：$local_path"
                    rm -f "$local_path"
                    download_failed=1
                else
                    echo "✅ 下载成功：$local_path"
                fi
            else
                echo "❌ 下载失败：$local_path"
                download_failed=1
            fi
        done
        
        # 检查下载结果（jar文件必须成功，其他可选）
        if [[ -f "${file_base}.jar" ]]; then
            download_success=true
            echo "📥 版本 $DOWNLOAD_VERSION 下载完成（jar文件已获取）"
        else
            download_success=false
            echo "❌ 版本 $DOWNLOAD_VERSION 下载失败（核心jar文件缺失）"
        fi
    fi


    sonatype_group_path=$(echo "$group" | tr '.' '/')
    sonatype_url="$PUBLISH_URL/${sonatype_group_path}/${artifactId}/${PUBLISH_VERSION}/"
    # ======================== 步骤4：下载成功则生成POM并发布 ========================
    if [[ $download_success == true ]]; then
        # 生成POM文件
        pom_file="$download_dir/pom-$DOWNLOAD_VERSION.xml"
        cp "$script_dir/pom.xml.in" "$pom_file"
        sed -i "s|@@GROUP@@|$group|g" "$pom_file"
        sed -i "s|@@ARTIFACT@@|$artifactId|g" "$pom_file"
        sed -i "s|@@VERSION@@|$PUBLISH_VERSION|g" "$pom_file"
        echo "📝 生成POM文件：$pom_file"

        # 执行发布（跳过缺失的sources/javadoc文件）
        echo "🚀 开始发布版本 $PUBLISH_VERSION"
        # 注意：每行末尾的\必须是最后一个字符，后面不能有任何空格！
         mvn_cmd="mvn gpg:sign-and-deploy-file -e \
           -Durl=\"$PUBLISH_URL\" \
           -DrepositoryId=\"$serverId\" \
           -Dfile=\"$file_base.jar\" \
           -DpomFile=\"$pom_file\" \
           -DgroupId=\"$group\" \
           -DartifactId=\"$artifactId\" \
           -Dversion=\"$PUBLISH_VERSION\" \
           -Dpackaging=jar \
           -DrepositoryLayout=default \
           -Dgpg.useAgent=true \
           -Dgpg.passphrase=\"输入你的gpg密码\""
        
        # 若sources文件存在，添加到发布命令
        [[ -f "${file_base}-sources.jar" ]] && mvn_cmd+=" -Dsources=\"${file_base}-sources.jar\""
        # 若javadoc文件存在，添加到发布命令
        [[ -f "${file_base}-javadoc.jar" ]] && mvn_cmd+=" -Djavadoc=\"${file_base}-javadoc.jar\""
        
        # 执行发布命令
        if eval "$mvn_cmd"; then
            echo "✅ 发布成功：$sonatype_url"
        else
            echo "❌ 发布失败：$PUBLISH_VERSION"
        fi
    else
        echo "⚠️  版本 $DOWNLOAD_VERSION 跳过发布（下载未完成）"
    fi

    current_index=$((current_index + 1))
done

# 完成提示
echo -e "\n=================================================="
echo "所有版本处理完成！共处理 $total_versions 个版本"
echo "下载文件存放于：$script_dir/target/android/zero/studio/gradle/tooling-api/$artifactId/"
echo "=================================================="
