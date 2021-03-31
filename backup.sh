 #!/usr/bin/env bash

# -------------------- Copyright --------------------
# FileName: backup.sh
# Description: 通过脚本 来批量打包备份文件到指定目录
# Version: 1.0
# Date: 2021/03/31
# Author: mengxinxin
# Email: andy_m129@163.com
# 
# -------------------- Readme & Usage  --------------------
# 
#          https://github.com/AndyM129/BackupFiles
# 
# 
# -------------------- Global Variables --------------------
current_dir_path=`pwd`
current_date=`date "+%Y%m%d%H%M%S"`
current_git_bra_name=`git symbolic-ref --short HEAD`
# 
# -------------------- Global Functions --------------------
debug() { echo "\033[1;2m$@\033[0m"; }      # debug 级别最低，可以随意的使用于任何觉得有利于在调试时更详细的了解系统运行状态的东东；
info() { echo "\033[1;36m$@\033[0m"; }      # info  重要，输出信息：用来反馈系统的当前状态给最终用户的；
success() { echo "\033[1;32m$@\033[0m"; }   # success 成功，输出信息：用来反馈系统的当前状态给最终用户的；
warn() { echo "\033[1;33m$@\033[0m"; }      # warn, 可修复，系统可继续运行下去；
error() { echo "\033[1;31m$@\033[0m"; }     # error, 可修复性，但无法确定系统会正常的工作下去;
fatal() { echo "\033[5;31m$@\033[0m"; }     # fatal, 相当严重，可以肯定这种错误已经无法修复，并且如果系统继续运行下去的话后果严重。
# 
# -------------------- End --------------------

help() {
    info "usage:"
    info "\tbash $0 [-h] [-v] <file_list_str> [message]"
    info "opts:"
    info "\t-h:\t显示使用说明."
    info "\t-v:\t显示更多的执行细节."
    info "params:"
    info "\tfile_list_str:\t要备份的文件，相对于当前目录，多个文件则以','分隔，\n\t\t\t如：Pods,Podfile,Podfile.lock"
    info "\tmessage:\t备份说明（可选），会追加到备份文件名称的后面"
}

process() {
    # 解析参数
    file_list_str=${1}
    message=${2}
    info;

    # 构建变量
    backup_dir_path="/Users/$USER/Documents/BackupFiles"
    backup_files=(${file_list_str//,/ })
    backup_file_name="`basename ${backup_files[0]}`$([ -z $current_git_bra_name ] && echo "" || echo "_$current_git_bra_name")$([ -z $message ] && echo "" || echo "_$message")"
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
    exit 0;
}

sh_info() {
    debug; debug "----- date -----"
    debug "$current_date"

    debug; debug "----- command -----"
    args=("$@")
    debug "$0 $*"

    debug; debug "----- opts ($OPTIND) -----"
    debug "verbose: $verbose"

    debug; debug "----- args (${#args[@]})-----"
    for(( i=0; i<${#args[@]};i++)) do
        debug "args[$(expr $i + 1)] = ${args[i]}"
    done
    debug; debug "============================================"; debug;
}

main() {
    verbose=false

    while getopts "vh" OPT; do
        case $OPT in
            h) help; exit 0 ;;
            v) verbose=true ;;
            ?) help; exit 1 ;;
        esac
    done

    # 忽略命令选项，以修正命令参数下标
    shift $[$OPTIND-1]

    # 脚本信息
    if $verbose; then
        sh_info $@    
    fi
    
    # 开始处理
    process $@
}

main $@
