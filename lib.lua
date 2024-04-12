-- waf lib

-- 获取客户端IP
function getClientIP()
    CLIENT_IP = ngx.req.get_headers()["X_real_ip"]
    if CLIENT_IP == nil then
        CLIENT_IP = ngx.req.get_headers()["X_Forwarded_For"]
    end
    if CLIENT_IP == nil then
        CLIENT_IP  = ngx.var.remote_addr
    end
    if CLIENT_IP == nil then
        CLIENT_IP  = "unknown"
    end
    return CLIENT_IP
end

function getUserAgent()
    USER_AGENT = ngx.var.http_user_agent
    if USER_AGENT == nil then
       USER_AGENT = "unknown"
    end
    return USER_AGENT
end

-- 写日志
function writeLog(msg)
    local cjson = require("cjson")
    local io = require("io")

    local raw = {
                 client_ip = getClientIP(),
                 local_time = ngx.localtime(),
                 server_name = ngx.var.server_name,
                 user_agent = getUserAgent(),
                 request_uri = ngx.var.request_uri,
                 msg = msg,
    }

    local content = cjson.encode(raw)
    local logFile = wafLogPath..'/waf.log'
    local file = io.open(logFile,"a")
    if file == nil then
        return
    end
    file:write(content.."\n")
    file:flush()
    file:close()
end

-- deny响应
function denyResponse()
    ngx.header["Content-Type"] = ""
    ngx.status = ngx.HTTP_FORBIDDEN
    -- ngx.header["X-XSS-Protection"] = "1; mode=block;"
    -- ngx.header["X-Content-Type-Options"] = "nosniff"
    -- to cause quit the whole request rather than the current phase handler
    ngx.exit(ngx.HTTP_OK)
    
    return true
end

-- 跳转响应
function redirectResponse(redirectUrl, status)
    if status == nil then
        status = ngx.HTTP_SEE_OTHER
    end

    ngx.redirect(redirectUrl, status)

    return true
end

-- HTML响应
function htmlResponse(msg, status)
    if status == nil then
        status = ngx.HTTP_OK
    end

    ngx.header.content_type = "text/html"
    ngx.status = status
    ngx.say([[
<html>
<head>
<title>]]..msg..[[</title>
</head>
<body>
<p>]]..msg..[[</p>
</body>
</html>
]])
    ngx.exit(status)
    
    return true
end
