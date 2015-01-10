--[[
Copyright (C) 2015  Albert Diserholt

This file is part of Grocery Rush.

Grocery Rush is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Grocery Rush is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Grocery Rush.  If not, see <http://www.gnu.org/licenses/>.
--]]

require("lib.math");
local Object = require("src.object");

local Container = Class("Container", Object);

Container.static.shelves = {};
Container.static.goods = {};

function Container:initialize(w, h, goods)
	Object.initialize(self, w, h);

	local cols = math.ceil(h / 64);
	self.cols = cols;

	-- Load the different shelf graphics (1, 2 & 3 grids long).
	if Container.static.shelves[cols] == nil then
		Container.static.shelves[cols] = love.graphics.newImage(("gfx/shelf%d.png"):format(cols));
	end
	self:setDrawOpts(Container.static.shelves[cols]);

	if goods then
		if Container.static.goods[goods] == nil then
			Container.static.goods[goods] = {
				-- Single good.
				single = love.graphics.newImage("gfx/"..goods.."1.png"),
				-- Package containing 64x64.
				quad = love.graphics.newImage("gfx/"..goods..".png");
			};
		end
	end
	self.goods = goods;
end

function Container:draw()
	Object.draw(self);

	if self.goods then
		local img = Container.static.goods[self.goods].quad;

		love.graphics.push();
		love.graphics.translate(self:getX(), self:getY());
		love.graphics.rotate(self:getBody():getAngle());

		for i=1,self.cols do
			love.graphics.draw(img, -self:getWidth()/2, -self:getHeight()/2 + (i-1) * img:getHeight());
		end

		love.graphics.pop();
	end
end

function Container:isInteractable()
	return true;
end

function Container:getGoodImage()
	return Container.static.goods[self.goods].single;
end

-- Static function.
function Container.getAllGoods()
	local goods = {};
	for good,_ in pairs(Container.static.goods) do
		table.insert(goods, good);
	end
	return goods;
end

return Container;
