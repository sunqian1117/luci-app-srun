-- Copyright (C) 2024 OpenWrt.org

local m, s, o
local util = require "luci.util"

m = Map("srun", translate("Srun 校园网认证"), 
    translate("深澜（Srun）校园网Portal认证客户端，支持自动登录和断线重连"))

-- Basic Settings Section
s = m:section(TypedSection, "basic", translate("基本设置"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enabled", translate("启用"))
o.default = o.disabled
o.rmempty = false

o = s:option(Value, "server", translate("认证服务器"))
o.placeholder = "http://your-srun-server.edu.cn"
o.datatype = "string"
o.rmempty = false

o = s:option(Value, "username", translate("用户名"))
o.placeholder = "学号或用户名"
o.datatype = "string"
o.rmempty = false

o = s:option(Value, "password", translate("密码"))
o.password = true
o.rmempty = false

o = s:option(Value, "interface", translate("网络接口"))
o.default = "wan"
o.datatype = "string"
o:value("wan", "WAN")
o:value("eth0", "eth0")
o:value("eth1", "eth1")

o = s:option(Value, "acid", translate("AC ID"))
o.default = "1"
o.datatype = "uinteger"
o.placeholder = "1"

o = s:option(Flag, "auto_login", translate("自动登录"))
o.default = o.enabled
o.rmempty = false
o.description = translate("开机和网络连接时自动进行认证")

-- Status Section
s = m:section(TypedSection, "status", translate("认证状态"))
s.anonymous = true
s.template = "srun/status"

return m
