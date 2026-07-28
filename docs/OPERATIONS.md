# ZZZ Console 日常运维

## 服务命令

```bash
x-ui start
x-ui stop
x-ui restart
x-ui status
x-ui log
```

systemd 原生命令：

```bash
systemctl status x-ui
journalctl -u x-ui -n 200 --no-pager
systemctl restart x-ui
```

## 查看和修改设置

```bash
x-ui settings
x-ui
```

终端菜单可以：

- 重置用户名和密码
- 修改访问路径
- 修改面板端口
- 重置面板设置
- 启用或禁用开机启动

## 备份

面板首页点击 **备份 → 导出数据库**。

命令行备份：

```bash
install -d -m 700 /root/zzz-console-backup
cp -a /etc/x-ui/x-ui.db /root/zzz-console-backup/x-ui-$(date +%F-%H%M%S).db
```

证书通常保存在：

```text
/root/cert/
```

完整迁移至少备份：

```text
/etc/x-ui/x-ui.db
/root/cert/
```

## 恢复

优先使用面板首页 **备份 → 导入数据库**。导入后面板会重启。

手动恢复前停止服务：

```bash
systemctl stop x-ui
cp /root/zzz-console-backup/你的备份.db /etc/x-ui/x-ui.db
chown root:root /etc/x-ui/x-ui.db
chmod 600 /etc/x-ui/x-ui.db
systemctl start x-ui
```

## 更新

```bash
x-ui update
```

更新顺序：

1. 导出数据库
2. 记录当前版本与登录地址
3. 执行更新
4. 检查 `x-ui status`
5. 登录面板检查入站和订阅

## 证书续期

```bash
x-ui
```

进入 `18. SSL 证书管理`，可查看、强制更新、撤销或重新设置证书路径。

## 日志

面板日志：

```bash
x-ui log
```

systemd 日志：

```bash
journalctl -u x-ui -f
```

Xray 访问日志和错误日志也可以直接在仪表盘查看并筛选。

## 服务器工具箱

```bash
x-ui tools
```

工具箱独立于面板数据库。执行系统、建站、Docker、证书或迁移操作前，先完成对应数据备份。
