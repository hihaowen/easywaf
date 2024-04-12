-- waf配置文件

-- 是否开启waf
wafStatus = "on"
-- waf日志保存目录
wafLogPath = "/www/wwwlogs"
-- waf cc攻击的频率: 60s内请求次数不能超过120
wafCCRate = "120/60"
-- 关进小黑屋时间,单位:秒
wafBlackRoomTime = 300
-- 受保护的域名
wafProtectedDomainList = {"www.a.cn", "www.b.cn"}
