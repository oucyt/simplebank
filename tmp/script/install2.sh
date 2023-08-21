#!/bin/bash
# 安装protoc
if [ ! -f /usr/local/protoc/bin/docker ]; then
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