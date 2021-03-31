# backup.sh

## Introduction

`backup.sh` 是一个文件（夹）备份的工具，

通过批量打包压缩的方式，备份指定文件到特定目录。

## Features

1. 单个或批量的打包压缩的指定文件，并备份到特定目录
2. 支持备份时 添加备份注释，以便日后查览、还原

## Usage

```shell
sh backup.sh [-h] [-v] <file_list_str> [message]
```

![](https://raw.githubusercontent.com/AndyM129/ImageHosting/master/images/20210331220322.png)

### Example 1：备份单个文件夹

```sh
sh backup.sh Examples
```

![image-20210331220530336](https://raw.githubusercontent.com/AndyM129/ImageHosting/master/images/20210331220532.png)

### Example 2：备份多个文件，并添加注释

```shell
sh backup.sh Examples/Pods,Examples/Podfile,Examples/Podfile.lock 注释信息
```

![](https://raw.githubusercontent.com/AndyM129/ImageHosting/master/images/20210331220724.png)

### Example 3：备份Git项目下的文件，并添加注释

```shell
sh backup.sh Examples/Pods,Examples/Podfile,Examples/Podfile.lock 注释信息
```

![](https://raw.githubusercontent.com/AndyM129/ImageHosting/master/images/20210331221048.png)

## Install （⭐️ Recommended）

> 注：以下内容为针对 MacOS 进行的配置&说明。

以上，是脚本的基础用法，但是更推荐直接安装到本地，即可 像执行系统命令一样的进行备份，具体方法如下。

1. 打开`~/.bashrc`文件，并追加如下代码

  ```shell
  ##############################【Backup】#################################
  alias backup='sh ~/.bash_files/BackupFiles/backup.sh'
  alias backup.install='install_path="/Users/$USER/.bash_files/BackupFiles"; git_url="https://github.com/AndyM129/BackupFiles.git"; rm -rf "$install_path"; git clone $git_url $install_path; echo "backup.sh install success: $install_path"; open $install_path;'
  alias backup.opendir='open /Users/$USER/Documents/BackupFiles'
  alias o.bak='backup.opendir'
  ```

2. 执行如下命令，以便让修改生效

	```shell
	source ~/.bashrc # 可在任意目录下执行
	```

3. 安装

	```shell
	backup.install # 可在任意目录下执行
	```

4. 可以使用了

	```shell
	前面的示例，可以简化为：
	
	# 查看使用说明
	backup -h
	
	# 备份单个文件夹
	backup Examples
	
	# 备份多个文件，并添加注释
	backup Examples/Pods,Examples/Podfile,Examples/Podfile.lock 注释信息
	
	# 打开备份的目录
	backup.opendir
	```

	

## History

* 1.0.0
	* 完成主体功能的开发
	* 添加 `Examples.zip` 文件，解压后，可配合示例进行功能演示

## Author

AndyMeng, andy_m129@163.com

If you have any question with using it, you can email to me. 

## Collaboration

Feel free to collaborate with ideas, issues and/or pull requests.

## License

AMKCategories is available under the MIT license. See the LICENSE file for more info.




