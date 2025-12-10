# LuCI App for Tuple ECH Worker

[![GitHub](https://img.shields.io/badge/GitHub-ECH--Workers-blue?logo=github)](https://github.com/byJoey/ech-wk)
[![License](https://img.shields.io/badge/License-GPL--3.0-green.svg)](LICENSE)
[![OpenWrt](https://img.shields.io/badge/OpenWrt-LuCI-blue.svg)](https://openwrt.org/)

OpenWrt LuCI 图形界面配置应用，用于管理 [ECH Workers](https://github.com/byJoey/ech-wk) 代理服务。

> 🙏 **致谢**: 本项目基于 [byJoey/ech-wk](https://github.com/byJoey/ech-wk) 开发，感谢原作者的出色工作！

---

## ✨ 功能特性

- 🔒 **ECH 加密**: 支持 Encrypted Client Hello (TLS 1.3)，隐藏真实 SNI
- 🌐 **多协议代理**: 同时支持 SOCKS5 和 HTTP/HTTPS 代理协议
- 🇨🇳 **智能分流**: 全局代理 / 跳过中国大陆 / 直连三种模式
- 🔍 **透明代理**: LAN 设备无需配置即可自动翻墙
- 📊 **Web 管理**: LuCI 图形界面，配置简单直观
- 🔄 **服务管理**: 支持启动/停止/重启，实时查看运行状态和日志
- 🚀 **自动重启**: 基于 procd 的进程管理，服务崩溃自动恢复

---

## 📸 界面截图

### 配置界面

![配置界面](doc/index.png)

### 日志查看

![日志查看](doc/log.png)

---

## 📦 安装方法

### 下载

从 [Releases](../../releases) 页面下载 `luci-app-ech-workers_x.x.x_all.ipk`

> 💡 **提示**: 安装 ipk 后会**自动检测路由器架构并下载**对应的 `ech-workers` 二进制文件，无需手动安装！

### 安装步骤

1. **上传到路由器**

   ```bash
   scp luci-app-ech-workers_*.ipk root@192.168.1.1:/tmp/
   ```

2. **SSH 登录安装**

   ```bash
   ssh root@192.168.1.1
   opkg install /tmp/luci-app-ech-workers_*.ipk
   ```

3. **访问界面**

   打开浏览器访问路由器管理页面，导航到 **服务 → Tuple ECH Worker**

> ⚠️ **注意**: 自动下载需要路由器能访问 GitHub。如果下载失败，可手动下载对应架构的二进制文件到 `/usr/bin/ech-workers`

---

## ⚙️ 配置说明

### 基本设置

| 配置项 | 说明 | 示例值 |
|--------|------|--------|
| **启用** | 开启/关闭服务 | ✓ |
| **服务器地址** | Workers 服务端地址 | `your-worker.workers.dev:443` |
| **监听地址** | 本地代理监听端口 | `0.0.0.0:30001` |
| **身份令牌** | 服务端验证密钥 | 可选 |

### 高级设置

| 配置项 | 说明 | 默认值 |
|--------|------|--------|
| **优选 IP/域名** | Cloudflare CDN 优选地址 | `cf.090227.xyz` |
| **DoH 服务器** | DNS over HTTPS 服务器 | `dns.alidns.com/dns-query` |
| **ECH 域名** | 用于获取 ECH 配置 | `cloudflare-ech.com` |

### 透明代理

启用后，LAN 上所有设备**无需配置代理**即可自动翻墙！

- 首次启用会自动安装 `redsocks` 依赖
- 使用 iptables 将 LAN 流量重定向到代理
- 停止服务时自动清理规则

---

## 🔧 客户端配置

### 方式一：透明代理（推荐）

启用透明代理后，LAN 设备无需任何配置，直接联网即可翻墙。

### 方式二：手动配置代理

如果不使用透明代理，可在设备上手动配置：

| 协议 | 地址 | 端口 |
|------|------|------|
| SOCKS5 | 路由器 IP | 30001（默认） |
| HTTP | 路由器 IP | 30001（默认） |

**配置示例：**

- **Windows**: 系统设置 → 网络和 Internet → 代理
- **macOS**: 系统偏好设置 → 网络 → 高级 → 代理
- **iOS/Android**: WiFi 设置 → 配置代理 → 手动
- **浏览器插件**: SwitchyOmega、FoxyProxy 等

---

## 🐛 故障排除

### 查看服务状态

```bash
/etc/init.d/ech-workers status
```

### 查看运行日志

```bash
logread -e ech-workers | tail -n 50
```

### 手动测试运行

```bash
/usr/bin/ech-workers -f your-worker.workers.dev:443 -l 0.0.0.0:30001
```

### 常见问题

| 问题 | 解决方案 |
|------|----------|
| 服务无法启动 | 检查服务器地址是否正确，确保二进制文件有执行权限 |
| 无法连接代理 | 检查防火墙设置，确保监听端口未被占用 |
| 速度慢 | 尝试更换优选 IP 或 DoH 服务器 |

---

## 📁 目录结构

```text
luci-app-ech-workers/
├── Makefile                 # OpenWrt SDK 构建配置
├── README.md                # 说明文档
├── luasrc/
│   ├── controller/          # LuCI 控制器
│   ├── model/cbi/           # CBI 配置模型
│   └── view/ech-workers/    # 视图模板
├── po/                      # 国际化翻译
└── root/                    # 系统配置文件
    └── etc/
        ├── config/          # UCI 默认配置
        ├── init.d/          # procd 服务脚本
        └── uci-defaults/    # 首次安装脚本
```

---

## 📄 许可证

本项目采用 [GPL-3.0](LICENSE) 许可证。

---

## 🔗 相关链接

- **ECH Workers 核心项目**: [byJoey/ech-wk](https://github.com/byJoey/ech-wk)
- **OpenWrt 官网**: [openwrt.org](https://openwrt.org/)
- **LuCI 文档**: [LuCI Wiki](https://openwrt.org/docs/guide-developer/luci)

---

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！
