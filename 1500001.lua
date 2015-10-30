
local cfg = {
    mapid = 1500001,
    name = "玄武内城",
    map_ai = MainLandMapAI,
    map_render = MapRender,
    cameraY = 40,
    width = 3200,
    height = 2000,
    mgwidth = 2400,
    mgheight = 1500,
    
    
    plist = {
        "scene/fg-h-01-chengshi01"
    },

    bg = "pic/scene/bg/h-01-chengshi/chengshi01.jpg",
    
    fg = {
        {p = "scene/fg-h-01-chengshi01/yuansu001.png", x = 3088, y = 454, z = 3, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-002.png", x = 2400, y = 467, z = 2, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-012.png", x = 2172, y = 1373, z = 8, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-010.png", x = 1056, y = 1367, z = 5, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-009.png", x = 825, y = 1561, z = 13, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-013.png", x = 2020, y = 1370, z = 7, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-003.png", x = 1904, y = 487, z = 1, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-006.png", x = 1069, y = 1434, z = 12, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-011.png", x = 1049, y = 1347, z = 11, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-015.png", x = 2859, y = 1460, z = 6, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-004.png", x = 856, y = 485, z = 4, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-014.png", x = 196, y = 1246, z = 9, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-008.png", x = 1217, y = 1438, z = 14, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/yuansu-007.png", x = 1063, y = 1492, z = 10, turn = false, rotate = 0},
        {p = "scene/fg-h-01-chengshi01/hengge-001.png", x = 1600, y = 701, z = 0, turn = false, rotate = 0}
    },

    lines = {
        {x1 = 0, y1 = 377, x2 = 3200, y2 = 377, group = 1, block = 1},
        {x1 = 1752, y1 = 583, x2 = 2069, y2 = 583, group = 2, block = 1},
        {x1 = 1579, y1 = 667, x2 = 2651, y2 = 667, group = 3, block = 1},
        {x1 = 2973, y1 = 669, x2 = 3200, y2 = 669, group = 4, block = 1},
        {x1 = 2895, y1 = 717, x2 = 2984, y2 = 717, group = 5, block = 1},
        {x1 = 2648, y1 = 717, x2 = 2735, y2 = 717, group = 6, block = 1},
        {x1 = 1674, y1 = 1392, x2 = 1766, y2 = 1392, group = 7, block = 1},
        {x1 = 1615, y1 = 1224, x2 = 1677, y2 = 1224, group = 8, block = 1},
        {x1 = 1934, y1 = 1392, x2 = 2254, y2 = 1392, group = 9, block = 1},
        {x1 = 2472, y1 = 1454, x2 = 3200, y2 = 1454, group = 10, block = 1},
        {x1 = 557, y1 = 1364, x2 = 1514, y2 = 1364, group = 11, block = 1},
        {x1 = 0, y1 = 1249, x2 = 428, y2 = 1249, group = 12, block = 1},
        {x1 = 812, y1 = 1030, x2 = 1367, y2 = 1030, group = 13, block = 1},
        {x1 = 786, y1 = 749, x2 = 1400, y2 = 749, group = 14, block = 1},
        {x1 = 254, y1 = 1011, x2 = 789, y2 = 1011, group = 15, block = 1},
        {x1 = 873, y1 = 1115, x2 = 1296, y2 = 1115, group = 16, block = 1},
        {x1 = 750, y1 = 552, x2 = 896, y2 = 552, group = 17, block = 1},
        {x1 = 896, y1 = 552, x2 = 936, y2 = 508, group = 17, block = 1},
        {x1 = 936, y1 = 508, x2 = 1015, y2 = 477, group = 17, block = 1},
        {x1 = 834, y1 = 805, x2 = 725, y2 = 913, group = 18, block = 1},
        {x1 = 725, y1 = 913, x2 = 632, y2 = 821, group = 18, block = 1},
        {x1 = 632, y1 = 821, x2 = 252, y2 = 821, group = 18, block = 1},
        {x1 = 2981, y1 = 497, x2 = 3142, y2 = 497, group = 19, block = 1},
        {x1 = 0, y1 = 662, x2 = 277, y2 = 662, group = 20, block = 1},
        {x1 = 2774, y1 = 1554, x2 = 2972, y2 = 1554, group = 21, block = 1},
        {x1 = 148, y1 = 1387, x2 = 286, y2 = 1387, group = 22, block = 1},
        {x1 = 1923, y1 = 875, x2 = 2737, y2 = 875, group = 23, block = 1},
        {x1 = 2737, y1 = 875, x2 = 2800, y2 = 852, group = 23, block = 1},
        {x1 = 2800, y1 = 852, x2 = 3200, y2 = 852, group = 23, block = 1},
        {x1 = 2010, y1 = 1112, x2 = 2674, y2 = 1112, group = 24, block = 1},
        {x1 = 2674, y1 = 1112, x2 = 2783, y2 = 1069, group = 24, block = 1},
        {x1 = 2783, y1 = 1069, x2 = 2940, y2 = 1069, group = 24, block = 1}
    },

    rects = {
        {x = 1617, y = 673, w = 53, h = 546, type = 1}
    },

    transInList = {
        {x = 264, y = 413, tag = 0, cond = 0, cond_data = 0},
        {x = 978, y = 1382, tag = 0, cond = 0, cond_data = 0},
        {x = 1911, y = 397, tag = 0, cond = 0, cond_data = 0},
        {x = 361, y = 1273, tag = 0, cond = 0, cond_data = 0},
        {x = 1081, y = 773, tag = 0, cond = 0, cond_data = 0},
        {x = 2076, y = 895, tag = 0, cond = 0, cond_data = 0}
    },

    transOutList = {
        {x = 2544, y = 1475, tag = 0, cond = 1, cond_data = 0}
    }
}

return cfg