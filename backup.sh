 #!/usr/bin/env bash

# -------------------- Copyright --------------------
# FileName: backup.sh
# Description: 通过脚本 来批量打包备份文件到指定目录
# Version: 1.0
# Date: 2021/03/31
# Author: mengxinxin
# Email: andy_m129@163.com
# 
# -------------------- History --------------------
# 2021/03/31: v1.0 - 实现核心功能
# 
# -------------------- Usage --------------------
# sh backup.sh <file_list_str> [message]
# 通过批量打包压缩的方式，备份指定文件到特定目录
# 
# sh backup.sh Pods,Podfile,Podfile.lock 我是文件说明
# 该示例，会通过打包压缩的方式，备份相对当前目录的 Pods,Podfile,Podfile.lock 三个文件为 ~/Documents/BackupFiles/20210331195726_Pods_我是文件说明.zip，其中：
# 其备份的路径为 $backup_dir_path，可按照需要自行修改
# 其备份的名称为 $backup_file_name，其格式：<格式化日期>_<首个备份的文件名称>[_<所在GIT分支名>][_<注释>].zip，可按照需要自行修改
# 
# sh backup.sh Pods,Podfile,Podfile.lock 我是文件说明
# 假设当前在Git管理的项目目录下，则会将该3个文件压缩备份到 ~/Documents/BackupFiles/20210331195726_Pods_dev1.2.3_我是文件说明.zip
# 
# -------------------- Global Functions --------------------
debug() { echo "\033[1;2m$@\033[0m"; }      # debug 级别最低，可以随意的使用于任何觉得有利于在调试时更详细的了解系统运行状态的东东；
info() { echo "\033[1;36m$@\033[0m"; }      # info  重要，输出信息：用来反馈系统的当前状态给最终用户的；
success() { echo "\033[1;32m$@\033[0m"; }   # success 成功，输出信息：用来反馈系统的当前状态给最终用户的；
warn() { echo "\033[1;33m$@\033[0m"; }      # warn, 可修复，系统可继续运行下去；
error() { echo "\033[1;31m$@\033[0m"; }     # error, 可修复性，但无法确定系统会正常的工作下去;
fatal() { echo "\033[5;31m$@\033[0m"; }     # fatal, 相当严重，可以肯定这种错误已经无法修复，并且如果系统继续运行下去的话后果严重。

# -------------------- Global Variables --------------------
current_dir_path=`pwd`
current_date=`date "+%Y%m%d%H%M%S"`
current_git_bra_name=`git symbolic-ref --short HEAD`

# -------------------- End --------------------

# 解析参数
file_list_str=$1
message=$2

# 构建变量
backup_dir_path="/Users/$USER/Documents/BackupFiles"
backup_files=(${file_list_str//,/ })
backup_file_name="${backup_files[0]}$([ -z $current_git_bra_name ] && echo "" || echo "_$current_git_bra_name")$([ -z $message ] && echo "" || echo "_$message")"
backup_zip_name="${current_date}_${backup_file_name}.zip"
backup_zip_path="$backup_dir_path/$backup_zip_name"

# 按需创建备份目录
if [[ ! -d "$backup_dir_path" ]]; then
    mkdir -p "$backup_dir_path"
    warn "备份目录不存，已重新创建：$backup_dir_path"
fi

# 压缩指定文件 到 备份目录
info "开始备份文件（共${#backup_files[*]}个）：${backup_files[*]}";
zip -q -r $backup_zip_path ${backup_files[*]} || ! fatal "文件压缩失败($?)" || exit 1
success; success "备份成功：$backup_zip_path\n";

# 将结果写入剪贴板
echo "$backup_zip_path" | pbcopy;
