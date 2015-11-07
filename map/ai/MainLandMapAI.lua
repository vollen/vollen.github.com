-----------------------------------------------
-- [FILE] MainLandMapAI.lua
-- [DATE] 2015-07-15
-- [CODE] BY ghgame
-- [MARK] NONE
-----------------------------------------------

module("MainLandMapAI", package.seeall)
defclass("MainLandMapAI", MainLandMapAI, SafeMapAI)

function init(self, cfg)
	super.init(self, cfg)
end

function onInit (self)
	super.onInit(self)

	MainCtl:init()
end
