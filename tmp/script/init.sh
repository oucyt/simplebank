#!/bin/bash

# 1. 配置yum源
# 花括号扩展
# https://www.onitroad.com/jc/linux/explain-brace-expansion-in-cp-mv-bash-shell-commands.html
# mv aaa{.bak} 等同于 mv aaa aaa.bak.
if [ ! -f /etc/yum.repos.d/CentOS-Base.repo.bak ]; then
    mv /etc/yum.repos.d/CentOS-Base.repo{,.bak}
    wget http://mirrors.aliyun.com/repo/Centos-7.repo -O /etc/yum.repos.d/CentOS-Base.repo
    
fi
echo "yum源已配置"

#2.安装wget等常用工具
# yum -y install wget sed tar unzip lrzsz sudo
yum -y install wget vim
sleep 3

#9.设置UTF-8
#centos7将文件改为 vi /etc/locale.conf
if cat /etc/locale.conf |awk -F: '{print $1}'|grep 'en_US.UTF-8'  2>&1 >/dev/null
then
    echo -e "Lang has been \e[0;32m\033[1madded\e[m."
else
    sed -i s/LANG=.*$/LANG=\"en_US.UTF-8\"/  /etc/locale.conf
    echo -e "Set LANG en_US.UTF-8 ${DONE}."
fi

yum_install(){
    local name=$1
    # 使用rpm命令查询软件包信息
    # rpm_query=$(rpm -q $centos_release_scl)
    rpm_query=$(yum list installed | grep $name)
    
    # 检查查询结果是否为空
    if [ ! -n "$rpm_query" ]; then
        yum -y install $name
        if [[ $name == "rh-"* ]]; then
            echo "source /opt/rh/$name/enable" >> ~/.bashrc
            source ~/.bashrc
        fi
    fi
    
    echo "$name 已通过yum工具完成安装"
}


#######################################
# 下载tar安装包，并解压到指定目录
# Globals:
#
# Arguments:
#   url 下载链接
#   extra_to 最终的解压路径
# Returns:
#   None
#######################################
download(){
    # 下载链接
    local url=$1
    # /usr/local
    local extra_to=$2
    
    read -p "start download the file via link $url? (y/n): "  choice
    if [[ "$choice" != "y" ]]; then
        return
    fi
    
    local tmp_dir=$(mktemp -d)
    # local compressed_file="/tmp/tmp.ZJYDSSCUwS/go1.21.0.linux-amd64.tar.gz"
    local compressed_file="${tmp_dir}/$(basename $url)"
    wget $url -O $compressed_file
    if [ $? -ne 0 ]; then
        echo "下载失败"
        return
    fi
    # 判断是否下载成功
    if [ ! -f "$compressed_file" ]; then
        echo "the file ${compressed_file} is not exist!"
        return
    fi
    
    # 判断是否为压缩文件
    if [ $(file $compressed_file | grep -oE '.*\.tar(\..*)?$' | wc -l) -ne 1 ]; then
        echo "The file is not a tar file"
        return
    fi
    
    # 判断下载的压缩文件是否为空
    if [ $(tar tvf $compressed_file | wc -l) -eq 1 ]; then
        echo "The zip file is empty"
        return
    fi
    # # 判断压缩文件中的一级字目录（文件）的数量
    
    local tmp_dir2=$(mktemp -d)
    tar -xf $compressed_file -C $tmp_dir2
    
    # 统计一级子目录和子文件的个数
    local c1=$(find $tmp_dir2 -mindepth 1 -maxdepth 1 -type d | wc -l)
    local c2=$(find $tmp_dir2 -mindepth 1 -maxdepth 1 -type f | wc -l)
    if [ $c1 -gt 2 ] || [ $c2 -gt 0 ]; then
        echo "subfiles and subdirs exist at the same time, This script is not suitable for it."
        return
    fi
    echo "c1=$c1, c2=$c2"
    # 压缩文件中的唯一子目录名称
    local name=$(basename $(find $tmp_dir2 -mindepth 1 -maxdepth 1 -type d))
    rm -rf $tmp_dir2
    
    local path="$extra_to/$name"
    
    if [ -d "$path" ]; then
        read -p "$path already exists, overwrite or not?(y/n): "  choice
        if [[ "$choice" != "y" ]]; then
            exit
        fi
    fi
    rm -rf $path
    tar -C $extra_to -xzf $compressed_file
    
    local path_bin="$path/bin"
    if [ -d "$path_bin" ]; then
        # 检查环境变量是否已存在
        if [[ ":$PATH:" != *":$path_bin:"* ]]; then
            # 将二进制文件目录添加到PATH环境变量中
            echo "export PATH=\$PATH:$path_bin" >> ~/.bash_profile
            # 添加第三方可执行文件添加到环境变量
            echo "export PATH=\$PATH:$(go env GOPATH)/bin" >> ~/.bash_profile
            source ~/.bash_profile

            echo "${path_bin}已添加至环境变量"
        fi
        echo $PATH
    else
        echo "${path_bin}不存在"
        return
    fi
}

# 禁用防火墙
systemctl stop firewalld.service
# 禁止防火墙开机自启
systemctl disable firewalld.service
# 查看防火墙状态
firewall-cmd --state  

yum_install centos-release-scl
yum_install rh-git218
#17.安装yum-fastestmirror
# yum -y install yum-fastestmirror
yum_install yum-fastestmirror

download https://dl.google.com/go/go1.21.0.linux-amd64.tar.gz /usr/local
go env -w GOPROXY=https://goproxy.cn,direct
mkdir -p ~/project/go



# 安装protoc
if [ ! -f /usr/local/protoc/bin/protoc ]; then
    protoc_location="/usr/local/protoc"
    protoc_bin_location="/usr/local/protoc/bin"
    mkdir -p $protoc_location
    protoc_url="https://github.com/protocolbuffers/protobuf/releases/download/v24.0/protoc-24.0-linux-x86_64.zip"

    # 创建缓存文件夹
    tmp_dir=$(mktemp -d)
    zip_file="${tmp_dir}/$(basename $protoc_url)"
    echo $zip_file
    # 下载
    curl -o $zip_file -LO $protoc_url
    # 解压
    unzip $zip_file -d $protoc_location
    # 移除缓存
    rm -rf $tmp_dir

    echo "export PATH=\$PATH:$protoc_bin_location" >> ~/.bash_profile
    source ~/.bash_profile
    echo $PATH
fi

# 检查Docker是否已安装
if [ ! -f /usr/bin/docker ]; then
    # 安装docker
    curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
    mkdir -p /etc/docker
    tee /etc/docker/daemon.json <<-'EOF'
    {
        "registry-mirrors": ["https://6tli7k56.mirror.aliyuncs.com"]
    }
    EOF
    systemctl daemon-reload
    systemctl restart docker
    # 设置开机自启
    systemctl enable docker
    # 启动docker
    systemctl start docker
fi

# 使用source xxx.sh 在当前shell中执行脚本，而不是在字shell中执行。这样，在脚本中对环境变量的修改将直接应用到当前的shell中。

