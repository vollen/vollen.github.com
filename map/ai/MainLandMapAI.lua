-----------------------------------------------
-- [FILE] MainLandMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("MainLandMapAI", package.seeall)
defclass("MainLandMapAI", MainLandMapAI, SafeMapAI)

function onInit (self)
	super.onInit(self)

	MainCtl:init()
end

function clear(self)
	super.clear(self)

	Map:leave(MAP_LEAVE_TOFIGHT)
end
