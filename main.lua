-- waf入口文件

require 'config'
require 'lib'
require 'init'

function main()
    if wafStatus == "on" then
        if not checkIfIsProtectedDomain(ngx.var.server_name) then
            return true
        end

	    -- writeLog("this is a test.")
        if checkIfIpInBlackRoom() then
            return denyResponse()
        elseif checkIfIsCCAttack() then
            return htmlResponse("Access deny.", ngx.HTTP_FORBIDDEN)
            -- return redirectResponse("https://cn.bing.com/?mkt=zh-CN")
        else
            return true
        end
    end
end

main()
