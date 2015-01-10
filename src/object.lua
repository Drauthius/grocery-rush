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

local Object = Class("Object");

require("lib.math");

function Object:initialize(w, h)
	self.w, self.h = w, h;
end

function Object:update(dt)
end

function Object:draw()
	if self.image then
		local x, y = self:getBody():getWorldCenter();
		local angle = self:getBody():getAngle();
		local topLeftX, topLeftY = -self:getWidth()/2, -self:getHeight()/2;
		local rotX, rotY = math.rotationpoint(topLeftX, topLeftY, angle);

		if self.quad then
			love.graphics.draw(self.image, self.quad, x + rotX, y + rotY, angle);
		else
			love.graphics.draw(self.image, x + rotX, y + rotY, angle);
		end
	end
end

function Object:setDrawOpts(image, quad)
	self.image, self.quad = image, quad;
end

function Object:setBody(body)
	self.body = body;
end

function Object:getBody(body)
	return self.body;
end

function Object:getX()
	return self:getBody():getWorldCenter();
end

function Object:getY()
	return select(2, self:getBody():getWorldCenter());
end

function Object:getWidth()
	return self.w;
end

function Object:getHeight()
	return self.h;
end

function Object:isInteractable()
	return false;
end

return Object;
