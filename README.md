# ZZZ Console

维护者：**zzz**  
整合版本：**1.0.0**  
X-Panel 基线：**v26.4.25**

ZZZ Console 不是缩水重写版。它以 X-Panel 为运行底座，保留原有 Xray、入站、订阅、流量、Telegram、域名、证书、面板设置和安装管理能力，并把 Kejilion Linux 工具箱完整打包进同一项目。

## 保留的功能

### X-Panel 全部核心能力

- Xray Core 与入站管理
- VLESS、VMess、Trojan、Shadowsocks、WireGuard 等协议
- 客户端、流量、限额、到期和订阅管理
- 路由、DNS、出站、反向代理和 Xray 高级设置
- Telegram Bot、服务器状态、日志和备份
- 面板域名、SSL 证书、访问路径和安全设置
- 防火墙、BBR、Geo 数据、Speedtest、订阅转换
- Docker、systemd 和多架构发布流程

### 完整 Kejilion 工具箱

- LNMP、建站、证书、反向代理、迁移和备份
- Docker、系统维护、网络优化、安全和常用应用
- 原始脚本及其多语言版本完整保存在 `tools/kejilion/`
- 安装后执行 `x-ui tools` 进入完整交互菜单
- 面板侧边栏新增“服务器工具”入口

## 安装

发布 GitHub Release 后执行：

```bash
bash <(curl -Ls https://raw.githubusercontent.com/onlythezzz5-spec/zzz-console/main/install.sh)
```

安装完成后：

```bash
x-ui
```

域名和 HTTPS：进入 `x-ui` 菜单，选择 **18. SSL 证书管理**，输入已经解析到服务器的域名。签发完成后，脚本会输出 HTTPS 登录地址。

服务器工具箱：

```bash
x-ui tools
```

## 开发与发布

```bash
go build -o x-ui main.go
python tests/zzz_integration_test.py
bash -n x-ui.sh
bash -n install.sh
```

GitHub Actions 会构建 Linux 和 Windows 多架构安装包。发布前必须确认 Release 中包含 `tools/kejilion/`，否则 `x-ui tools` 不可用。

## 代码与署名

- ZZZ Console 的整合、品牌层和新增代码由 **zzz** 维护。
- X-Panel 原始代码版权归其贡献者，采用 GPL-3.0。
- Kejilion 工具箱原始代码版权归其贡献者，采用 Apache-2.0。
- 整体发行遵循 GPL-3.0；完整来源见 `NOTICE.md`。
- 原 X-Panel 文档保存在 `docs/UPSTREAM_XPANEL_README.md`。
- Kejilion 原文档保存在 `tools/kejilion/README.md`。
