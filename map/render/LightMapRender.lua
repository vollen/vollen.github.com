module("LightMapRender", package.seeall)
defclass("LightMapRender", LightMapRender, MapRender)


SOUND_LIST = {"leisheng01", "leisheng02", "leisheng03"}

function init(self, cfg)
    self.light = as3d.AsLight:create(true, false)
    self.sound = nil
    self.lList = {}
    
    super.init(self, cfg)
end

function update(self, dt)
    super.update(self, dt)
    
    if self.light and self.lList then
        local p1 = self.lList[1]
        local p2 = self.lList[2]
        if p1 and p2 then
            if gameTime > p2.t then
                table.remove(self.lList, 1)
            elseif gameTime > p1.t and p1.k ~= p2.k then
                self:setlight(p1.k + (p2.k - p1.k)*(gameTime - p1.t)/(p2.t - p1.t))
            end
        else
            self:newlight()
            self.sound = gameTime + 1 + math.random() * 2
        end
        
        if self.sound and gameTime > self.sound then
            self.sound = nil
            Audio:playSound(SOUND_LIST[math.random(#SOUND_LIST)])
        end
    end
end

function newlight(self)
    self.lList = {}
    local p = {t = gameTime, k = 0}
    local k = 1
    local n = math.random(3)
    for i = 1, n do
        k = 0.8 + math.random() * (k - 0.8)
        local at = p.t + 0.1 + math.random() * 0.9 --+时间    
        local bt = at  + 0.2 + math.random() * 0.2 --=时间
        local ct = bt  + 0.5 + math.random() * 0.5 ---时间
        local nt
        
        if i == n then
            nt = p.t + 99
        else
            nt = p.t + 0.5 + math.random() * 0.5 --时间
        end
        
        if nt < at then
            p = {t = nt, k = 0}
            table.insert(self.lList, p)
        else
            p = {t = at, k = k}
            table.insert(self.lList, p)
            if nt < bt then
                p = {t = nt, k = k}
                table.insert(self.lList, p)
            else
                p = {t = bt, k = k}
                table.insert(self.lList, p)
                if nt < ct then
                    p = {t = nt, k = 0}
                    table.insert(self.lList, p)
                else
                    p = {t = ct, k = 0}
                    table.insert(self.lList, p)
                end
            end
        end
    end
    p = {t = p.t + 3 + math.random() * 5, k = 0}
    table.insert(self.lList, p)
end

function setlight(self, k)
    local lightK = k * 3
    self.light:setColor(lightK, lightK, lightK, 0)
    
    local roleK = 1 + k * 0.5
    if Role.hero then
        Role.hero:setColor(cc.c4f(roleK, roleK, roleK, 1))
    end
end

