#!/bin/bash

# ==========================================================
# ZZZ Console 统一安装脚本
# 整合维护: zzz
# ==========================================================

red='\033[0;31m'
green='\033[0;32m'
blue='\033[0;34m'
yellow='\033[0;33m'
plain='\033[0m'

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}致命错误: ${plain} 请使用 root 权限运行此脚本\n" && exit 1

# ----------------------------------------------------------
# ZZZ Console 安装逻辑
# ----------------------------------------------------------
install_free_version() {
    echo ""
    echo -e "${green}开始安装【ZZZ Console】${plain}"
    echo ""
    echo -e "${green}即将开始执行标准安装流程...${plain}"
    sleep 2

    cur_dir=$(pwd)

    # Check OS and set release variable
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        release=$ID
    elif [[ -f /usr/lib/os-release ]]; then
        source /usr/lib/os-release
        release=$ID
    else
        echo ""
        echo -e "${red}检查服务器操作系统失败，请联系作者!${plain}" >&2
        exit 1
    fi
    echo ""
    echo -e "${green}---------->>>>>目前服务器的操作系统为: $release${plain}"

    arch() {
        case "$(uname -m)" in
            x86_64 | x64 | amd64 ) echo 'amd64' ;;
            i*86 | x86 ) echo '386' ;;
            armv8* | armv8 | arm64 | aarch64 ) echo 'arm64' ;;
            armv7* | armv7 | arm ) echo 'armv7' ;;
            armv6* | armv6 ) echo 'armv6' ;;
            armv5* | armv5 ) echo 'armv5' ;;
            s390x) echo 's390x' ;;
            *) echo -e "${green}不支持的CPU架构! ${plain}" && rm -f install.sh && exit 1 ;;
        esac
    }

    echo ""
    # check_glibc_version() {
    #    glibc_version=$(ldd --version | head -n1 | awk '{print $NF}')

    #    required_version="2.32"
    #    if [[ "$(printf '%s\n' "$required_version" "$glibc_version" | sort -V | head -n1)" != "$required_version" ]]; then
    #        echo -e "${red}------>>>GLIBC版本 $glibc_version 太旧了！ 要求2.32或以上版本${plain}"
    #        echo -e "${green}-------->>>>请升级到较新版本的操作系统以便获取更高版本的GLIBC${plain}"
    #        exit 1
    #    fi
    #        echo -e "${green}-------->>>>GLIBC版本： $glibc_version（符合高于2.32的要求）${plain}"
    # }
    # check_glibc_version

    # echo ""
    echo -e "${yellow}---------->>>>>当前系统的架构为: $(arch)${plain}"
    echo ""
    last_version=$(curl -Ls "https://api.github.com/repos/onlythezzz5-spec/zzz-console/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    # 同时识别当前 ZZZ Console 和旧版安装，便于原地升级。
    current_binary=""
    if [[ -x /usr/local/zzz/zzz ]]; then
        current_binary="/usr/local/zzz/zzz"
    elif [[ -x /usr/local/x-ui/x-ui ]]; then
        current_binary="/usr/local/x-ui/x-ui"
    fi
    zzz_version=$([[ -n "$current_binary" ]] && "$current_binary" -v 2>/dev/null)

    if [[ -z "$zzz_version" ]]; then
        echo ""
        echo -e "${red}------>>>当前服务器没有安装 ZZZ Console${plain}"
        echo ""
        echo -e "${green}-------->>>>片刻之后脚本将会自动引导安装〔ZZZ Console〕${plain}"
    else
        # 检查版本号中是否包含冒号
        if [[ "$zzz_version" == *:* ]]; then
            echo -e "${green}---------->>>>>检测到可迁移的旧版面板${plain}"
            echo ""
            echo -e "${green}-------->>>>片刻之后脚本将会自动引导安装〔ZZZ Console〕${plain}"
        else
            echo -e "${green}---------->>>>>当前代理面板的版本为: ${red}〔ZZZ Console〕v${zzz_version}${plain}"
        fi
    fi
    echo ""
    echo -e "${yellow}---------------------->>>>>〔ZZZ Console〕最新版为：${last_version}${plain}"
    sleep 4

    os_version=$(grep -i version_id /etc/os-release | cut -d \" -f2 | cut -d . -f1)

    if [[ "${release}" == "arch" ]]; then
        echo "您的操作系统是 ArchLinux"
    elif [[ "${release}" == "manjaro" ]]; then
        echo "您的操作系统是 Manjaro"
    elif [[ "${release}" == "armbian" ]]; then
        echo "您的操作系统是 Armbian"
    elif [[ "${release}" == "alpine" ]]; then
        echo "您的操作系统是 Alpine Linux"
    elif [[ "${release}" == "opensuse-tumbleweed" ]]; then
        echo "您的操作系统是 OpenSUSE Tumbleweed"
    elif [[ "${release}" == "centos" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red} 请使用 CentOS 8 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "ubuntu" ]]; then
        if [[ ${os_version} -lt 20 ]]; then
            echo -e "${red} 请使用 Ubuntu 20 或更高版本!${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "fedora" ]]; then
        if [[ ${os_version} -lt 36 ]]; then
            echo -e "${red} 请使用 Fedora 36 或更高版本!${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "debian" ]]; then
        if [[ ${os_version} -lt 11 ]]; then
            echo -e "${red} 请使用 Debian 11 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "almalinux" ]]; then
        if [[ ${os_version} -lt 9 ]]; then
            echo -e "${red} 请使用 AlmaLinux 9 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "rocky" ]]; then
        if [[ ${os_version} -lt 9 ]]; then
            echo -e "${red} 请使用 RockyLinux 9 或更高版本 ${plain}\n" && exit 1
        fi
    elif [[ "${release}" == "oracle" ]]; then
        if [[ ${os_version} -lt 8 ]]; then
            echo -e "${red} 请使用 Oracle Linux 8 或更高版本 ${plain}\n" && exit 1
        fi
    else
        echo -e "${red}此脚本不支持您的操作系统。${plain}\n"
        echo "请确保您使用的是以下受支持的操作系统之一："
        echo "- Ubuntu 20.04+"
        echo "- Debian 11+"
        echo "- CentOS 8+"
        echo "- Fedora 36+"
        echo "- Arch Linux"
        echo "- Manjaro"
        echo "- Armbian"
        echo "- Alpine Linux"
        echo "- AlmaLinux 9+"
        echo "- Rocky Linux 9+"
        echo "- Oracle Linux 8+"
        echo "- OpenSUSE Tumbleweed"
        exit 1

    fi

    install_base() {
        case "${release}" in
        ubuntu | debian | armbian)
            apt-get update && apt-get install -y -q wget curl sudo tar tzdata
            ;;
        centos | rhel | almalinux | rocky | ol)
            yum -y --exclude=kernel* update && yum install -y -q wget curl sudo tar tzdata
            ;;
        fedora | amzn | virtuozzo)
            dnf -y --exclude=kernel* update && dnf install -y -q wget curl sudo tar tzdata
            ;;
        arch | manjaro | parch)
            pacman -Sy && pacman -S --noconfirm wget curl sudo tar tzdata
            ;;
        alpine)
            apk update && apk add --no-cache wget curl sudo tar tzdata
            ;;
        opensuse-tumbleweed)
            zypper refresh && zypper -q install -y wget curl sudo tar timezone
            ;;
        *)
            apt-get update && apt-get install -y -q wget curl sudo tar tzdata
            ;;
        esac
    }

    gen_random_string() {
        local length="$1"
        local random_string=$(LC_ALL=C tr -dc 'a-zA-Z0-9' </dev/urandom | fold -w "$length" | head -n 1)
        echo "$random_string"
    }

    # This function will be called when user installed zzz out of security
    config_after_install() {
        echo -e "${yellow}安装/更新完成！ 为了您的面板安全，建议修改面板设置 ${plain}"
        echo ""
        read -p "$(echo -e "${green}想继续修改吗？${red}选择“n”以保留旧设置${plain} [y/n]？--->>请输入：")" config_confirm
        if [[ "${config_confirm}" == "y" || "${config_confirm}" == "Y" ]]; then
            read -p "请设置您的用户名: " config_account
            echo -e "${yellow}您的用户名将是: ${config_account}${plain}"
            read -p "请设置您的密码: " config_password
            echo -e "${yellow}您的密码将是: ${config_password}${plain}"
            read -p "请设置面板端口: " config_port
            echo -e "${yellow}您的面板端口号为: ${config_port}${plain}"
            read -p "请设置面板登录访问路径: " config_webBasePath
            echo -e "${yellow}您的面板访问路径为: ${config_webBasePath}${plain}"
            echo -e "${yellow}正在初始化，请稍候...${plain}"
            /usr/local/zzz/zzz setting -username ${config_account} -password ${config_password}
            echo -e "${yellow}用户名和密码设置成功!${plain}"
            /usr/local/zzz/zzz setting -port ${config_port}
            echo -e "${yellow}面板端口号设置成功!${plain}"
            /usr/local/zzz/zzz setting -webBasePath ${config_webBasePath}
            echo -e "${yellow}面板登录访问路径设置成功!${plain}"
            echo ""
        else
            echo ""
            sleep 1
            echo -e "${red}--------------->>>>Cancel...--------------->>>>>>>取消修改...${plain}"
            echo ""
            if [[ ! -f "/etc/zzz/zzz.db" ]]; then
                local usernameTemp=$(head -c 10 /dev/urandom | base64)
                local passwordTemp=$(head -c 10 /dev/urandom | base64)
                local webBasePathTemp=$(gen_random_string 15)
                /usr/local/zzz/zzz setting -username ${usernameTemp} -password ${passwordTemp} -webBasePath ${webBasePathTemp}
                echo ""
                echo -e "${yellow}检测到为全新安装，出于安全考虑将生成随机登录信息:${plain}"
                echo -e "###############################################"
                echo -e "${green}用户名: ${usernameTemp}${plain}"
                echo -e "${green}密  码: ${passwordTemp}${plain}"
                echo -e "${green}访问路径: ${webBasePathTemp}${plain}"
                echo -e "###############################################"
                echo -e "${green}如果您忘记了登录信息，可以在安装后通过 zzz 命令然后输入${red}数字 10 选项${green}进行查看${plain}"
            else
                echo -e "${green}此次操作属于版本升级，保留之前旧设置项，登录方式保持不变${plain}"
                echo ""
                echo -e "${green}如果您忘记了登录信息，您可以通过 zzz 命令然后输入${red}数字 10 选项${green}进行查看${plain}"
                echo ""
                echo ""
            fi
        fi
        sleep 1
        echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ""
        /usr/local/zzz/zzz migrate
    }

    echo ""
    install_zzz() {
        cd /usr/local/

        # Download resources
        if [ $# == 0 ]; then
            last_version=$(curl -Ls "https://api.github.com/repos/onlythezzz5-spec/zzz-console/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
            if [[ ! -n "$last_version" ]]; then
                echo -e "${red}获取 ZZZ Console 版本失败，可能是 Github API 限制，请稍后再试${plain}"
                exit 1
            fi
            echo ""
            echo -e "-----------------------------------------------------"
            echo -e "${green}--------->>获取 ZZZ Console 最新版本：${yellow}${last_version}${plain}${green}，开始安装...${plain}"
            echo -e "-----------------------------------------------------"
            echo ""
            sleep 2
            echo -e "${green}---------------->>>>>>>>>安装进度50%${plain}"
            sleep 3
            echo ""
            echo -e "${green}---------------->>>>>>>>>>>>>>>>>>>>>安装进度100%${plain}"
            echo ""
            sleep 2
            wget -N --no-check-certificate -O /usr/local/zzz-linux-$(arch).tar.gz https://github.com/onlythezzz5-spec/zzz-console/releases/download/${last_version}/zzz-linux-$(arch).tar.gz
            if [[ $? -ne 0 ]]; then
                echo -e "${red}下载 ZZZ Console 失败, 请检查服务器是否可以连接至 GitHub？ ${plain}"
                exit 1
            fi
        else
            last_version=$1
            url="https://github.com/onlythezzz5-spec/zzz-console/releases/download/${last_version}/zzz-linux-$(arch).tar.gz"
            echo ""
            echo -e "--------------------------------------------"
            echo -e "${green}---------------->>>>开始安装 ZZZ Console$1${plain}"
            echo -e "--------------------------------------------"
            echo ""
            sleep 2
            echo -e "${green}---------------->>>>>>>>>安装进度50%${plain}"
            sleep 3
            echo ""
            echo -e "${green}---------------->>>>>>>>>>>>>>>>>>>>>安装进度100%${plain}"
            echo ""
            sleep 2
            wget -N --no-check-certificate -O /usr/local/zzz-linux-$(arch).tar.gz ${url}
            if [[ $? -ne 0 ]]; then
                echo -e "${red}下载 ZZZ Console $1 失败, 请检查此版本是否存在 ${plain}"
                exit 1
            fi
        fi
        wget -O /usr/bin/zzz-temp https://raw.githubusercontent.com/onlythezzz5-spec/zzz-console/main/zzz.sh

        # 停止新旧服务并迁移旧数据库；原数据库保留不删除。
        systemctl stop zzz >/dev/null 2>&1 || true
        systemctl stop x-ui >/dev/null 2>&1 || true
        mkdir -p /etc/zzz
        chmod 750 /etc/zzz
        if [[ ! -f /etc/zzz/zzz.db && -f /etc/x-ui/x-ui.db ]]; then
            cp -a /etc/x-ui/x-ui.db /etc/zzz/zzz.db
            chmod 600 /etc/zzz/zzz.db
            echo -e "${green}已将旧版数据库迁移到 /etc/zzz/zzz.db${plain}"
        fi
        rm -rf /usr/local/zzz

        sleep 3
        echo -e "${green}------->>>>>>>>>>>检查并保存安装目录${plain}"
        echo ""
        tar zxvf zzz-linux-$(arch).tar.gz
        rm zzz-linux-$(arch).tar.gz -f

        cd zzz
        chmod +x zzz
        chmod +x zzz.sh
        if [[ -f tools/kejilion/kejilion.sh ]]; then
            chmod +x tools/kejilion/kejilion.sh
        fi

        # Check the system's architecture and rename the file accordingly
        if [[ $(arch) == "armv5" || $(arch) == "armv6" || $(arch) == "armv7" ]]; then
            mv bin/xray-linux-$(arch) bin/xray-linux-arm
            chmod +x bin/xray-linux-arm
        fi
        chmod +x zzz bin/xray-linux-$(arch)

        # Update zzz cli and se set permission
        mv -f /usr/bin/zzz-temp /usr/bin/zzz
        chmod +x /usr/bin/zzz
        # 仅保留旧命令兼容入口；所有文档和新操作统一使用 zzz。
        ln -sfn /usr/bin/zzz /usr/bin/x-ui
        sleep 2
        echo -e "${green}------->>>>>>>>>>>保存成功${plain}"
        sleep 2
        echo ""
        config_after_install

    ssh_forwarding() {
        # 获取 IPv4 和 IPv6 地址
        v4=$(curl -s4m8 http://ip.sb -k)
        v6=$(curl -s6m8 http://ip.sb -k)
        local existing_webBasePath=$(/usr/local/zzz/zzz setting -show true | grep -Eo 'webBasePath（访问路径）: .+' | awk '{print $2}')
        local existing_port=$(/usr/local/zzz/zzz setting -show true | grep -Eo 'port（端口号）: .+' | awk '{print $2}')
        local existing_cert=$(/usr/local/zzz/zzz setting -getCert true | grep -Eo 'cert: .+' | awk '{print $2}')
        local existing_key=$(/usr/local/zzz/zzz setting -getCert true | grep -Eo 'key: .+' | awk '{print $2}')

        if [[ -n "$existing_cert" && -n "$existing_key" ]]; then
            echo -e "${green}面板已安装证书采用SSL保护${plain}"
            echo ""
            local existing_cert=$(/usr/local/zzz/zzz setting -getCert true | grep -Eo 'cert: .+' | awk '{print $2}')
            domain=$(basename "$(dirname "$existing_cert")")
            echo -e "${green}登录访问面板URL: https://${domain}:${existing_port}${green}${existing_webBasePath}${plain}"
        fi
        echo ""
        if [[ -z "$existing_cert" && -z "$existing_key" ]]; then
            echo -e "${red}警告：未找到证书和密钥，面板不安全！${plain}"
            echo ""
            echo -e "${green}------->>>>请按照下述方法设置〔ssh转发〕<<<<-------${plain}"
            echo ""

            # 检查 IP 并输出相应的 SSH 和浏览器访问信息
            if [[ -z $v4 ]]; then
                echo -e "${green}1、本地电脑客户端转发命令：${plain} ${blue}ssh  -L [::]:15208:127.0.0.1:${existing_port}${blue} root@[$v6]${plain}"
                echo ""
                echo -e "${green}2、请通过快捷键【Win + R】调出运行窗口，在里面输入【cmd】打开本地终端服务${plain}"
                echo ""
                echo -e "${green}3、请在终端中成功输入服务器的〔root密码〕，注意区分大小写，用以上命令进行转发${plain}"
                echo ""
                echo -e "${green}4、请在浏览器地址栏复制${plain} ${blue}[::1]:15208${existing_webBasePath}${plain} ${green}进入〔ZZZ Console〕登录界面"
                echo ""
                echo -e "${red}注意：若不使用〔ssh转发〕请为ZZZ Console配置安装证书再行登录管理后台${plain}"
            elif [[ -n $v4 && -n $v6 ]]; then
                echo -e "${green}1、本地电脑客户端转发命令：${plain} ${blue}ssh -L 15208:127.0.0.1:${existing_port}${blue} root@$v4${plain} ${yellow}或者 ${blue}ssh  -L [::]:15208:127.0.0.1:${existing_port}${blue} root@[$v6]${plain}"
                echo ""
                echo -e "${green}2、请通过快捷键【Win + R】调出运行窗口，在里面输入【cmd】打开本地终端服务${plain}"
                echo ""
                echo -e "${green}3、请在终端中成功输入服务器的〔root密码〕，注意区分大小写，用以上命令进行转发${plain}"
                echo ""
                echo -e "${green}4、请在浏览器地址栏复制${plain} ${blue}127.0.0.1:15208${existing_webBasePath}${plain} ${yellow}或者${plain} ${blue}[::1]:15208${existing_webBasePath}${plain} ${green}进入〔ZZZ Console〕登录界面"
                echo ""
                echo -e "${red}注意：若不使用〔ssh转发〕请为ZZZ Console配置安装证书再行登录管理后台${plain}"
            else
                echo -e "${green}1、本地电脑客户端转发命令：${plain} ${blue}ssh -L 15208:127.0.0.1:${existing_port}${blue} root@$v4${plain}"
                echo ""
                echo -e "${green}2、请通过快捷键【Win + R】调出运行窗口，在里面输入【cmd】打开本地终端服务${plain}"
                echo ""
                echo -e "${green}3、请在终端中成功输入服务器的〔root密码〕，注意区分大小写，用以上命令进行转发${plain}"
                echo ""
                echo -e "${green}4、请在浏览器地址栏复制${plain} ${blue}127.0.0.1:15208${existing_webBasePath}${plain} ${green}进入〔ZZZ Console〕登录界面"
                echo ""
                echo -e "${red}注意：若不使用〔ssh转发〕请为ZZZ Console配置安装证书再行登录管理后台${plain}"
                echo ""
            fi
        fi
    }
    # 执行ssh端口转发
    ssh_forwarding

        cp -f zzz.service /etc/systemd/system/
        systemctl disable x-ui >/dev/null 2>&1 || true
        rm -f /etc/systemd/system/x-ui.service
        systemctl daemon-reload
        systemctl enable zzz
        systemctl start zzz
        rm -rf /usr/local/x-ui
        systemctl stop warp-go >/dev/null 2>&1
        wg-quick down wgcf >/dev/null 2>&1
        ipv4=$(curl -s4m8 ip.p3terx.com -k | sed -n 1p)
        ipv6=$(curl -s6m8 ip.p3terx.com -k | sed -n 1p)
        systemctl start warp-go >/dev/null 2>&1
        wg-quick up wgcf >/dev/null 2A>&1

        echo ""
        echo -e "------->>>>${green}ZZZ Console ${last_version}${plain}<<<<安装成功，正在启动..."
        sleep 1
        echo ""
        echo -e "         ---------------------"
        echo -e "         |${green}ZZZ Console 控制菜单用法 ${plain}|${plain}"
        echo -e "         |  ${yellow}一个更好的面板   ${plain}|${plain}"
        echo -e "         | ${yellow}基于Xray Core构建 ${plain}|${plain}"
        echo -e "--------------------------------------------"
        echo -e "zzz              - 进入管理脚本"
        echo -e "zzz start        - 启动 ZZZ Console"
        echo -e "zzz stop         - 关闭 ZZZ Console"
        echo -e "zzz restart      - 重启 ZZZ Console"
        echo -e "zzz status       - 查看 ZZZ Console 状态"
        echo -e "zzz settings     - 查看当前设置信息"
        echo -e "zzz enable       - 启用 ZZZ Console 开机启动"
        echo -e "zzz disable      - 禁用 ZZZ Console 开机启动"
        echo -e "zzz log          - 查看 ZZZ Console 运行日志"
        echo -e "zzz banlog       - 检查 Fail2ban 禁止日志"
        echo -e "zzz update       - 更新 ZZZ Console"
        echo -e "zzz custom       - 自定义 ZZZ Console 版本"
        echo -e "zzz install      - 安装 ZZZ Console"
        echo -e "zzz uninstall    - 卸载 ZZZ Console"
        echo -e "--------------------------------------------"
        echo ""
        # if [[ -n $ipv4 ]]; then
        #    echo -e "${yellow}面板 IPv4 访问地址为：${green}http://$ipv4:${config_port}/${config_webBasePath}${plain}"
        # fi
        # if [[ -n $ipv6 ]]; then
        #    echo -e "${yellow}面板 IPv6 访问地址为：${green}http://[$ipv6]:${config_port}/${config_webBasePath}${plain}"
        # fi
        #    echo -e "请自行确保此端口没有被其他程序占用，${yellow}并且确保${red} ${config_port} ${yellow}端口已放行${plain}"
        sleep 3
        echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
        echo ""
        echo -e "${yellow}----->>>ZZZ Console和Xray启动成功<<<-----${plain}"
    }

    # 设置VPS中的时区/时间为【上海时间】
    sudo timedatectl set-timezone Asia/Shanghai

    install_base
    install_zzz $1
    echo ""
    echo -e "----------------------------------------------"
    sleep 4
    info=$(/usr/local/zzz/zzz setting -show true)
    echo -e "${info}${plain}"
    echo ""
    echo -e "若您忘记了上述面板信息，后期可通过zzz命令进入脚本${red}输入数字〔10〕选项获取${plain}"
    echo ""
    echo -e "----------------------------------------------"
    echo ""
    sleep 2
    echo -e "${green}ZZZ Console 安装/更新完成${plain}"
    echo -e "${green}〔ZZZ Console〕项目地址：${yellow}https://github.com/onlythezzz5-spec/zzz-console${plain}"
    echo ""
    echo -e "${green}服务器工具箱：${yellow}zzz tools${plain}"
    echo ""
    echo -e "----------------------------------------------"
    echo ""
}

# 免费版安装逻辑函数 (install_free_version) 结束

# ----------------------------------------------------------
# 脚本主菜单
# ----------------------------------------------------------
# ?????????????? ZZZ Console
# ----------------------------------------------------------
clear
echo -e "${green}======================================================${plain}"
echo -e "       ${yellow}ZZZ Console${plain} ????"
echo -e "${green}======================================================${plain}"
install_free_version "$@"
