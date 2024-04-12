-- waf init
require 'config'
require 'lib'

-- check if ip in black room
function checkIfIpInBlackRoom()
    local ip = getClientIP()
    local exists,_ = ngx.shared.wafBlackList:get(ip)
    if not exists then
        return false
    end

    return true
end

-- deny CC attack
function checkIfIsCCAttack()
    local ip = getClientIP()
    local requestUri = ngx.var.request_uri
    local ccToken = ngx.md5(ip..requestUri)
    local ccPool = ngx.shared.wafCCPool
    
    local ccCount = tonumber(string.match(wafCCRate,'(.*)/'))
    local ccSecond = tonumber(string.match(wafCCRate,'/(.*)'))
    
    local ccRequestCount, _ = ccPool:get(ccToken)
    if ccRequestCount then
        if ccRequestCount > ccCount then
            writeLog('捕获到异常请求!在'..ccSecond..'秒内请求超过'..ccCount..'次,此IP即将被关进小黑屋'..wafBlackRoomTime..'秒')
	    ngx.shared.wafBlackList:set(ip,1,wafBlackRoomTime)
            return true
        else
            ccPool:incr(ccToken,1)
        end
    else
        ccPool:set(ccToken,1,ccSecond)
    end
    
    return false
end

-- 检查是否是受保护的域名
function checkIfIsProtectedDomain(search)
    if next(wafProtectedDomainList) ~= nil then
        for _,domain in pairs(wafProtectedDomainList) do
            if search == domain then
                return true
            end
        end
    end

    return false
end
