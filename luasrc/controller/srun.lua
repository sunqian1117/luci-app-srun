-- Copyright (C) 2024 OpenWrt.org

module("luci.controller.srun", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/srun") then
        return
    end

    entry({"admin", "services", "srun"}, cbi("srun"), _("Srun 认证"), 60).dependent = true
    entry({"admin", "services", "srun", "status"}, call("action_status")).leaf = true
    entry({"admin", "services", "srun", "login"}, call("action_login")).leaf = true
    entry({"admin", "services", "srun", "logout"}, call("action_logout")).leaf = true
    entry({"admin", "services", "srun", "log"}, call("action_log")).leaf = true
end

function action_status()
    local util = require "luci.util"
    local status = util.exec("/usr/bin/srun-auth status")
    luci.http.prepare_content("application/json")
    luci.http.write_json({status = status})
end

function action_login()
    local util = require "luci.util"
    local result = util.exec("/usr/bin/srun-auth login")
    luci.http.prepare_content("application/json")
    luci.http.write_json({result = result})
end

function action_logout()
    local util = require "luci.util"
    local result = util.exec("/usr/bin/srun-auth logout")
    luci.http.prepare_content("application/json")
    luci.http.write_json({result = result})
end

function action_log()
    local util = require "luci.util"
    local log = util.exec("/usr/bin/srun-auth log")
    luci.http.prepare_content("text/plain")
    luci.http.write(log)
end
