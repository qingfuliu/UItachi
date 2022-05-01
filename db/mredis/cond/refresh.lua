---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by lqf.
--- DateTime: 2022/5/1 12:12
---

--ARGV 		  1			  2
--			zet key     unique id               limiterKey=ARGV[2]+"_limiter"
--KEYS         1                2
--          expireTime      now

local limiterKey = KEYS[1].."_limiter"

local limiter = tonumber(redis.call("get", limiterKey))


if (limiter == nil) then
    limiter = 100
    redis.call("set", limiterKey, limiter, "nx")
end

redis.call("zRemRangeByScore", KEYS[1], "-inf", ARGV[1])

local rs=tonumber(redis.call("zRank",KEYS[1],KEYS[2]))

if (rs==nil) then
    return "FAILED"
end

rs = tonumber(redis.call("zAdd",KEYS[1],"CH","XX",ARGV[2], KEYS[2]))

if (rs ~= 1) then
    return "FAILED"
end

return "OK"