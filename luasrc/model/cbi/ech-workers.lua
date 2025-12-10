-- LuCI Tuple ECH Worker CBI Model
-- Copyright (C) 2024

local m, s, o
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor()

-- 检查服务运行状态
local function is_running()
    return sys.call("pgrep -f '/usr/bin/ech-workers' >/dev/null") == 0
end

m = Map("ech-workers", translate("Tuple ECH Worker"),
    translate("Tuple ECH Worker 是一个支持 Encrypted Client Hello (ECH) 的代理客户端，支持 SOCKS5 和 HTTP 代理协议。"))

m:append(Template("ech-workers/status"))

-- 基本设置
s = m:section(NamedSection, "config", "ech-workers", translate("基本设置"))
s.anonymous = true
s.addremove = false

-- 启用开关
o = s:option(Flag, "enabled", translate("启用"))
o.default = 0
o.rmempty = false

-- 服务器地址
o = s:option(Value, "server_addr", translate("服务器地址"))
o.placeholder = "your-worker.workers.dev:443"
o.rmempty = false
o.datatype = "string"
o.description = translate("Cloudflare Workers 服务端地址，格式: 域名:端口")

-- 监听地址
o = s:option(Value, "listen_addr", translate("监听地址"))
o.placeholder = "0.0.0.0:30001"
o.default = "0.0.0.0:30001"
o.rmempty = false
o.datatype = "string"
o.description = translate("本地代理监听地址，格式: IP:端口")

-- 身份令牌
o = s:option(Value, "token", translate("身份令牌"))
o.password = true
o.placeholder = "可选"
o.rmempty = true
o.description = translate("服务端身份验证令牌（可选）")

-- 高级设置
s = m:section(NamedSection, "config", "ech-workers", translate("高级设置"))
s.anonymous = true
s.addremove = false

-- 优选 IP
o = s:option(Value, "best_ip", translate("优选 IP/域名"))
o.placeholder = "cf.090227.xyz"
o.default = "cf.090227.xyz"
o.rmempty = true
o.description = translate("Cloudflare 优选 IP 或域名，用于优化连接速度")

-- DoH 服务器
o = s:option(Value, "dns", translate("DoH 服务器"))
o.placeholder = "dns.alidns.com/dns-query"
o.default = "dns.alidns.com/dns-query"
o.rmempty = true
o.description = translate("DNS over HTTPS 服务器地址，用于查询 ECH 配置")

-- ECH 域名
o = s:option(Value, "ech_domain", translate("ECH 域名"))
o.placeholder = "cloudflare-ech.com"
o.default = "cloudflare-ech.com"
o.rmempty = true
o.description = translate("用于获取 ECH 配置的域名")

-- 分流设置
s = m:section(NamedSection, "config", "ech-workers", translate("分流设置"))
s.anonymous = true
s.addremove = false

-- 分流模式
o = s:option(ListValue, "routing", translate("分流模式"))
o:value("global", translate("全局代理 - 所有流量走代理"))
o:value("bypass_cn", translate("跳过中国大陆 - 国内IP直连"))
o:value("none", translate("不改变代理 - 所有流量直连"))
o.default = "global"
o.rmempty = false
o.description = translate("选择代理分流策略")

-- 透明代理设置
s = m:section(NamedSection, "config", "ech-workers", translate("透明代理"))
s.anonymous = true
s.addremove = false

-- 透明代理开关
o = s:option(Flag, "transparent_proxy", translate("启用透明代理"))
o.default = 0
o.rmempty = false
o.description = translate("启用后，LAN 设备无需配置代理即可自动翻墙。首次启用会自动安装 redsocks。")

-- 服务控制
s = m:section(TypedSection, "ech-workers", translate("服务控制"))
s.anonymous = true
s.addremove = false
s.template = "ech-workers/control"

return m
