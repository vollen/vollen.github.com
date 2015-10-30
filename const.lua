-----------------------------------------------
-- [FILE] const.lua
-- [DATE] 2014-05-27
-- [MARK] UNCHECKED	@ver-1.0
-- [CODE] BY ghgame	@05-27
-----------------------------------------------

-- GameState
STATE_INIT      = 0
STATE_LOGIN     = 1
STATE_MAIN      = 2
STATE_LOAD      = 3
STATE_GAME      = 4
STATE_FINISH    = 5


SEX_MALE        = 1 --男
SEX_FEMALE      = 2 --女

MONEY_SILVER    = 1 --银币
MONEY_GOLD      = 2 --金币

--speed
PLAYER_SPEED    = 250
MON_SPEED       = 200

--GameId Type
GAME_ID_ROLE	= 1
GAME_ID_UNIT    = 2

-- Line
LINE_DOWN       = 1
LINE_UP         = 2

-- Rect
RECT_LADDER     = 1 --梯子
RECT_OBSTACLE   = 2 --障碍
RECT_HINDER     = 3 --只阻挡箱子的障碍

-- 伤害类型
FIGHT_MISS = 0--闪避
FIGHT_HURT = 1--伤害
FIGHT_CRIT = 2--暴击
FIGHT_CURE = 3--恢复


-- RoleAction
ACTION_IDLE     = 0
ACTION_STAND    = 1
ACTION_WALK     = 2
ACTION_CLIMB    = 3
ACTION_SIT      = 4
ACTION_ATTACK   = 5
ACTION_BEHIT    = 6
ACTION_JUMP     = 7
ACTION_DIE      = 8


RES_ACTION_HERO =
{
    [ACTION_STAND]    = "/stand",
    [ACTION_WALK]     = "/walk",
    [ACTION_CLIMB]    = "/climb",
    [ACTION_SIT]      = "/xiulian",
    [ACTION_ATTACK]   = "/attack",
    [ACTION_BEHIT]    = "/injured",
    [ACTION_JUMP]     = "/jump",
    [ACTION_DIE]      = "/death",
}

RES_ACTION_HERO_FLY =
{
    [ACTION_STAND]    = "/fly",
    [ACTION_WALK]     = "/fly",
    [ACTION_CLIMB]    = "/fly",
    [ACTION_SIT]      = "/xiulian",
    [ACTION_ATTACK]   = "/attack",
    [ACTION_BEHIT]    = "/injured",
    [ACTION_JUMP]     = "/fly",
    [ACTION_DIE]      = "/death",
}

RES_ACTION_MON =
{
    [ACTION_STAND]    = "/stand",
    [ACTION_WALK]     = "/walk",
    [ACTION_CLIMB]    = "/stand",
    [ACTION_SIT]      = "/stand",
    [ACTION_ATTACK]   = "/attack",
    [ACTION_BEHIT]    = "/injured",
    [ACTION_JUMP]     = "/stand",
    [ACTION_DIE]      = "/death",
}

RES_ACTION_WEAPON =
{
    [ACTION_STAND]    = "/stand",
    [ACTION_WALK]     = "/walk",
    [ACTION_CLIMB]    = nil,
    [ACTION_SIT]      = nil,
    [ACTION_ATTACK]   = nil,
    [ACTION_BEHIT]    = "/injured",
    [ACTION_JUMP]     = "/jump",
    [ACTION_DIE]      = nil,
}

RES_ACTION_WEAPON_FLY =
{
    [ACTION_STAND]    = "/fly",
    [ACTION_WALK]     = "/fly",
    [ACTION_CLIMB]    = nil,
    [ACTION_SIT]      = nil,
    [ACTION_ATTACK]   = nil,
    [ACTION_BEHIT]    = "/injured",
    [ACTION_JUMP]     = "/fly",
    [ACTION_DIE]      = nil,
}

-- Group
GROUP_MON       = 0
GROUP_PLAYER    = 1
GROUP_NONE      = 2

-- Layer
LAYER_MAP_BG        = 1
LAYER_MAP_BGEFFECT  = 2
LAYER_MAP_FG        = 3
LAYER_MAP_FGUNIT    = 4
LAYER_MAP_FGEFFECT  = 5
LAYER_MAP_ROLE      = 6
LAYER_MAP_UNITFRONT = 7
LAYER_MAP_ROLEEFFECT= 8

-- Unit
UNIT_ACTION_NORMAL = 1
UNIT_ACTION_ACTIVE = 2
UNIT_ACTION_ATTACK = 3
UNIT_ACTION_BORN   = 4
UNIT_ACTION_DIE    = 5


-- Time
REGAIN_VIGOUR_TIME = 300

-- Map
MAP_QUAD_W  = 400
MAP_QUAD_H  = 300

MAP_RANGE_W = 810
MAP_RANGE_H = 610


--活动状态1 准备中， 2 正在进行中 3 活动完成 4活动结束
ACTIVITY_STATE_PREPARE  = 1
ACTIVITY_STATE_RUNNING  = 2
ACTIVITY_STATE_FINISH   = 3
ACTIVITY_STATE_STOPED   = 4

--关卡0成功 1失败 2退出 3重来 4时间到
VENTURE_WIN        = 0
VENTURE_LOSE       = 1
VENTURE_EXIT       = 2
VENTURE_AGAIN      = 3
VENTURE_TIMEUP     = 4
VENTURE_SELECT     = 5

--主城id
VENTURE_ID_MAINLAND         = 800001
VENTURE_ID_MAINLAND_MINI    = 800002

--广告牌类型
AD_MIANLAND         = 1
AD_MIANLAND_MINI    = 2

--关卡类型
VENTURE_MAIN     = 1 --主线
VENTURE_TREASURE = 2 --寻宝（精英）
VENTURE_SECRET   = 3 --隐藏
VENTURE_ACTIVITY = 4 --活动
VENTURE_TOWER    = 5 --封神塔
VENTURE_CONVOY   = 6 --护送
VENTURE_TEAM     = 7 --组队
VENTURE_BTE      = 8 --一战到底
VENTURE_FOREST   = 10 --帮会秘境
--活动类关卡 子类型
VENTURE_SUB_BATTLE = 1
VENTURE_SUB_WORLD  = 2
VENTURE_SUB_FRIEND = 3
VENTURE_SUB_PVP = 4
VENTURE_SUB_FAC_PREPARE = 5
VENTURE_SUB_FAC_FIGHT = 6
VENTURE_SUB_FORT = 7
VENTURE_SUB_TVT = 8
--Tips
TIP_W = 222
TIP_H = 270

TIPS_EQUIP_W = 310
TIPS_EQUIP_H = 506


MINUTE_SECS = 60
HOUR_SECS   = 3600
DAY_SECS    = 86400
WEEK_SECS   = 604800

BUTTON_POSITION = {{200,36},{330,36},{70,31},{460,31}}

HERO_AUDIO_TAB = 
{
    "hero_jianke_click", 
    "hero_gongshou_click", 
    "hero_cike_click", 
    "hero_fashi_click",
    "hero_shenmi_click"
}

EQUIP_AUDIO_TAB =
{
    [1] = "bag_wuqi_succeed",
    [2] = "bag_yifu_succeed",
    [3] = "bag_shiping_succeed",
    [4] = "bag_yifu_succeed",
    [5] = "bag_shiping_succeed",
    [6] = "bag_yifu_succeed"
}

ATTR_TAG_LIST = 
{
    "att",
    "def",
        
    "hit",
    "dodge",
    "ten",
    "crit",
    "critMultiple",
    
    
    "attAddPer",
    "hitDecPer",

    "hpFull",
    "hp",
    
    "speed",  
}
