# ZZZ Console 故障排查

## 安装脚本无法下载

先测试：

```bash
curl -I https://github.com
curl -I https://raw.githubusercontent.com
```

如果服务器无法直连 GitHub，可在能够联网的电脑下载 Release 中对应架构的安装包，再上传到服务器。

## 面板打不开

依次执行：

```bash
zzz status
zzz settings
systemctl status zzz --no-pager
journalctl -u zzz -n 100 --no-pager
ss -lntp
ufw status
```

重点确认：

- 服务是否运行
- 面板端口是否监听
- 访问路径是否完整
- 防火墙是否放行
- 域名是否解析到当前服务器
- HTTPS 证书路径是否正确

## 忘记用户名、密码或访问路径

```bash
zzz settings
```

需要重置时：

```bash
zzz
```

使用菜单 `6`、`7`、`9`。

## HTTPS 证书签发失败

确认：

```bash
dig +short 你的域名
ss -lntp | grep -E ':80|:443'
ufw status
```

- 域名必须指向当前服务器
- 80 端口不能被错误服务占用
- Cloudflare 普通验证时先关闭代理
- DNS 验证必须提供正确 API 凭据

## 入站已创建但客户端连不上

检查：

1. 入站是否启用
2. 客户端是否启用和过期
3. 端口是否监听
4. 防火墙是否放行
5. Reality 的 SNI、公钥、Short ID 是否一致
6. 域名、证书和客户端时间是否正确

命令：

```bash
ss -lntup
ufw status
zzz log
```

同时查看面板首页的 Xray 错误日志。

## Xray 启动失败

先在面板的 **Xray 设置** 检查配置，再查看：

```bash
journalctl -u zzz -n 200 --no-pager
```

常见原因：

- JSON 配置无效
- 两个入站占用同一端口
- 证书文件不存在或权限错误
- Xray 版本与配置项不兼容

## 更新后异常

```bash
zzz status
zzz log
```

如果数据库结构或配置异常，导入更新前导出的 `zzz.db`。恢复前先备份当前故障数据库，避免覆盖唯一证据。
