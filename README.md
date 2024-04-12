nginx配置文件
```
# waf
lua_shared_dict wafBlackList 100m;
lua_shared_dict wafCCPool 100m;
lua_package_path "/www/server/nginx/script/lua/waf/?.lua";
init_by_lua_file  /www/server/nginx/script/lua/waf/init.lua;
access_by_lua_file /www/server/nginx/script/lua/waf/main.lua;
```
