# ZZZ Console

**zzz 维护的一体化 Xray 管理面板与 Linux 服务器工具箱。**

[![Release](https://img.shields.io/github/v/release/onlythezzz5-spec/zzz-console?style=flat-square)](https://github.com/onlythezzz5-spec/zzz-console/releases/latest)
[![Build](https://img.shields.io/github/actions/workflow/status/onlythezzz5-spec/zzz-console/release.yml?style=flat-square&label=build)](https://github.com/onlythezzz5-spec/zzz-console/actions/workflows/release.yml)
[![License](https://img.shields.io/github/license/onlythezzz5-spec/zzz-console?style=flat-square)](LICENSE)

ZZZ Console 把代理面板、入站与用户管理、订阅、流量统计、证书、防火墙、备份、Telegram 管理和 Linux 建站工具放进同一套部署中。安装后既可以在浏览器管理，也可以通过 `x-ui` 终端菜单维护服务器。

## 一键安装

### 服务器要求

- 一台具有公网 IP 的 VPS
- `root` 用户
- Ubuntu 20.04+、Debian 11+、Rocky/AlmaLinux 9+ 等受支持系统
- 建议提前准备一个已解析到服务器 IP 的域名

### 执行安装

```bash
bash <(curl -Ls https://raw.githubusercontent.com/onlythezzz5-spec/zzz-console/main/install.sh)
```

脚本会自动识别系统和 CPU 架构，下载对应安装包，安装 systemd 服务，并引导设置：

1. 管理员用户名
2. 管理员密码
3. 面板端口
4. 随机访问路径

安装结束会打印登录信息。忘记信息时执行：

```bash
x-ui settings
```

## 第一次使用

### 1. 先打开面板端口

```bash
x-ui
```

选择：

```text
21. 防火墙管理
```

放行面板端口和后续创建的入站端口。

### 2. 配置域名和 HTTPS

先把域名的 `A` 记录指向服务器公网 IPv4，然后执行：

```bash
x-ui
```

选择：

```text
18. SSL 证书管理
1. 获取 SSL 证书
7. 为面板设置证书路径
```

之后使用：

```text
https://你的域名:面板端口/访问路径/
```

没有域名时，先使用安装脚本输出的 SSH 本地转发方式登录。

### 3. 创建第一个入站

进入 **入站列表 → 添加入站**：

1. 选择协议，例如 `VLESS`
2. 设置端口
3. 添加客户端
4. 配置传输与安全方式
5. 保存后复制链接或二维码
6. 确认防火墙已放行该端口

也可以点击 **一键配置**，快速生成常用的 Reality 或 TLS 组合。

## 功能总览

### 面板与 Xray

- CPU、内存、磁盘、网络、连接数和运行时间监控
- Xray 启停、重启、版本切换、运行日志和访问日志
- GeoIP、GeoSite 及地区规则文件更新
- 自定义 Xray 路由、DNS、入站、出站和策略配置

### 入站与用户

- VLESS、VMess、Trojan、Shadowsocks、WireGuard、Dokodemo-door 等协议
- TCP、WebSocket、gRPC、HTTPUpgrade、XHTTP、Reality、TLS 等组合
- 单用户、多用户、批量用户、二维码和分享链接
- 用户流量、到期时间、限额、重置周期、在线状态和最后在线时间
- 入站克隆、导入、导出、批量重置和失效用户清理
- 一键配置常用协议组合

### 订阅与通知

- 客户端订阅和 JSON 订阅
- 订阅链接生成与订阅转换部署
- Telegram Bot 状态查询、流量查询、备份、服务管理和一键创建节点
- 流量、到期、设备超限和运行状态通知

### 运维与安全

- 随机登录路径、HTTPS、两步验证和会话设置
- UFW 防火墙、Fail2ban、IP/设备限制
- 数据库导入、导出和配置备份
- BBR、Speedtest、证书签发、Cloudflare DNS 证书
- systemd 开机启动、日志、更新、回滚与卸载

### 服务器工具箱

```bash
x-ui tools
```

包含：

- LNMP、Nginx、PHP、数据库和建站
- 域名、证书、反向代理和站点迁移
- Docker、应用部署、备份与恢复
- 系统更新、磁盘、网络、安全和常用诊断

面板中的 **服务器工具** 页面会给出入口和运行状态；需要修改系统的操作在 SSH 终端中确认执行。

## 常用命令

```bash
x-ui                 # 打开管理菜单
x-ui start           # 启动
x-ui stop            # 停止
x-ui restart         # 重启
x-ui status          # 查看状态
x-ui settings        # 查看登录信息
x-ui log             # 查看日志
x-ui update          # 更新
x-ui tools           # 服务器工具箱
x-ui uninstall       # 卸载
```

## 文档

- [完整安装与域名配置](docs/INSTALLATION.md)
- [全部功能说明](docs/FEATURES.md)
- [备份、更新与日常运维](docs/OPERATIONS.md)
- [故障排查](docs/TROUBLESHOOTING.md)
- [版本下载](https://github.com/onlythezzz5-spec/zzz-console/releases/latest)

## 维护与许可

- 项目维护者：**zzz**
- 项目地址：<https://github.com/onlythezzz5-spec/zzz-console>
- 软件按 [GPL-3.0](LICENSE) 发布
- 第三方代码的许可与版权信息见 [NOTICE.md](NOTICE.md)
