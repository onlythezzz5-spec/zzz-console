# ZZZ Console 安装与域名配置

## 1. 准备服务器

推荐配置：

- 1 核 CPU
- 512 MB 以上内存
- 5 GB 以上可用磁盘
- 公网 IPv4 或 IPv6
- `root` SSH 权限

支持的主要系统：

- Ubuntu 20.04+
- Debian 11+
- CentOS 8+
- Rocky Linux 9+
- AlmaLinux 9+
- Oracle Linux 8+
- Fedora 36+
- Arch Linux、Manjaro、Armbian、Alpine、OpenSUSE Tumbleweed

支持的架构：

- amd64
- arm64
- armv5 / armv6 / armv7
- 386
- s390x

## 2. 安装

以 `root` 登录服务器后执行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/onlythezzz5-spec/zzz-console/main/install.sh)
```

安装脚本自动完成：

1. 识别系统和 CPU 架构
2. 安装 `curl`、`wget`、`tar` 等基础依赖
3. 获取最新正式版本
4. 下载对应架构的发布包
5. 安装到 `/usr/local/x-ui/`
6. 注册并启动 `x-ui.service`
7. 引导设置用户名、密码、端口和访问路径

安装完成后立即保存终端输出的登录信息。

## 3. 查看登录信息

```bash
x-ui settings
```

或：

```bash
x-ui
```

选择 `10. 查看面板设置`。

## 4. 没有域名时登录

为了避免直接暴露未加密的管理面板，可以使用 SSH 本地转发。

在 Windows 的 CMD 或 PowerShell 执行：

```powershell
ssh -L 15208:127.0.0.1:面板端口 root@服务器IP
```

保持窗口不要关闭，在浏览器访问：

```text
http://127.0.0.1:15208/访问路径/
```

## 5. 配置域名

在域名服务商添加：

| 类型 | 主机记录 | 值 |
|---|---|---|
| A | panel | 服务器公网 IPv4 |

例如域名是 `example.com`，最终使用：

```text
panel.example.com
```

等待 DNS 生效后验证：

```bash
ping panel.example.com
```

返回的 IP 必须是当前服务器 IP。

## 6. 配置 HTTPS

执行：

```bash
x-ui
```

进入 `18. SSL 证书管理`：

1. 选择 `1. 获取 SSL 证书`
2. 输入已经解析到服务器的域名
3. 签发成功后选择 `7. 为面板设置证书路径`
4. 重启面板

登录地址：

```text
https://panel.example.com:面板端口/访问路径/
```

如果使用 Cloudflare：

- 普通 HTTP 验证签发时先关闭代理云朵
- 或使用菜单 `19. CF SSL 证书` 通过 DNS API 签发
- Cloudflare SSL/TLS 模式建议使用 `Full (strict)`

## 7. 放行端口

执行：

```bash
x-ui
```

进入 `21. 防火墙管理`，放行：

- SSH 端口
- 面板端口
- 每个入站使用的端口
- 订阅转换需要的 `8000` 和 `15268`，仅在使用该模块时开放

## 8. 创建第一个入站

1. 登录面板
2. 打开 **入站列表**
3. 点击 **添加入站** 或 **一键配置**
4. 设置协议、端口、客户端和传输方式
5. 保存
6. 点击二维码或导出链接
7. 把链接导入客户端

保存后若无法连接，先检查：

```bash
x-ui status
x-ui log
ss -lntup
ufw status
```

## 9. 更新

```bash
x-ui update
```

更新前先从面板首页导出数据库，或备份：

```text
/etc/x-ui/x-ui.db
```

## 10. 卸载

```bash
x-ui uninstall
```

卸载前必须先导出数据库。卸载会移除程序和 systemd 服务。
