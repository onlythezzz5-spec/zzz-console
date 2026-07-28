# ZZZ Console 功能说明

## 仪表盘

- CPU、核心数、主频、内存、Swap、磁盘使用率
- 系统负载、TCP/UDP 连接数
- 实时上传下载速度和累计流量
- 公网 IPv4/IPv6
- 系统和 Xray 运行时间
- Xray 状态、版本、日志、停止、重启和版本切换
- 数据库导入与导出
- 当前运行配置查看

## 入站管理

- 创建、编辑、克隆、启停和删除入站
- 导入、导出全部入站
- 单个和批量重置流量
- 清理已耗尽客户端
- 自动刷新、搜索和状态筛选
- 二维码、分享链接和订阅链接

支持的主要协议：

- VLESS
- VMess
- Trojan
- Shadowsocks
- WireGuard
- Dokodemo-door
- HTTP、SOCKS 等 Xray 支持的入站

支持的主要传输和安全方式：

- TCP
- WebSocket
- gRPC
- HTTPUpgrade
- XHTTP
- Reality
- TLS
- XTLS Vision

## 一键配置

Web 控制台可以快速生成：

- VLESS + TCP + Reality + Vision
- VLESS + XHTTP + Reality
- VLESS Encryption + XHTTP + TLS

生成过程会：

1. 创建 UUID 和密钥
2. 随机选择可用端口
3. 写入入站数据库
4. 生成客户端链接和二维码
5. 保存最近生成记录

## 客户端管理

- 单个添加和批量添加
- 启停、编辑和删除
- 独立流量统计与限额
- 到期时间和重置周期
- 在线状态与最后在线时间
- 设备/IP 数量限制
- 客户端备注和订阅 ID
- 导出单个或全部客户端链接

## Xray 配置

- 路由规则
- DNS
- 入站和出站
- 策略、日志和 API
- Freedom、Blackhole、WireGuard 等出站
- WARP 路由
- 自定义 JSON
- 配置测试与结果查看
- 出站流量统计和重置

## 面板设置

- 管理员账号和密码
- 监听地址、端口和访问路径
- HTTPS 证书与私钥
- 会话有效期
- 两步验证
- 时区和语言
- 订阅服务
- Telegram Bot
- 流量与到期提醒
- IP/设备限制
- 外部通知
- Xray 模板和高级设置

## Telegram Bot

- 查看服务器状态
- 查看用户和入站流量
- 查询在线状态
- 重启 Xray 和面板
- 发送数据库备份
- 一键创建 Reality、XHTTP Reality 或 TLS 入站并返回二维码与链接
- 订阅转换安装入口
- 管理员与普通用户权限区分

## 订阅

- 普通订阅
- JSON 订阅
- 自定义订阅标题和路径
- 客户端订阅 ID
- 批量导出订阅
- 独立订阅转换服务

## 安全与运维

- UFW 防火墙
- Fail2ban
- IP/设备限制
- SSH 本地转发登录
- ACME 证书签发与续期
- Cloudflare DNS 证书
- BBR
- Geo 数据更新
- Speedtest
- systemd 服务
- 数据库备份与恢复
- 日志查看

## Linux 服务器工具箱

通过以下命令进入：

```bash
x-ui tools
```

覆盖：

- 系统信息、更新、清理和性能调优
- Docker 管理和常用应用部署
- Nginx、PHP、MariaDB/MySQL、Redis
- 网站、反向代理、证书和域名
- 站点迁移、备份和恢复
- 网络、端口、防火墙和安全检查
- 磁盘、Swap、时区、主机名和 SSH

需要修改系统的命令始终在 SSH 终端中执行，避免浏览器后台直接获得无限制 shell 权限。
