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

local Object = require("src.object");

require("lib.string");

local Player = Class("Player", Object);

local MOVE_SPEED = 300;
local REVERSE_SPEED = 220;
local ROTATION_SPEED = 9;

-- Squared distance in number of pixels.
local INTERACTION_DISTANCE = 80^2;

local function addItem(list, item)
	for _,v in ipairs(list) do
		if v.name == item then
			v.quantity = v.quantity + 1;
			return;
		end
	end

	if item ~= nil then
		table.insert(list, { name = item, quantity = 1 });
	end
end

function Player:initialize(w, h)
	Object.initialize(self, w, h);
	self.list = {
		image = love.graphics.newImage("gfx/shoppinglist.png"),
		font = love.graphics.newFont("ttf/angelina.TTF", 30),
		fontBig = love.graphics.newFont("ttf/angelina.TTF", 44),
		items = { },
	};
	self.inventory = {};
	self.inventorySet = {};

	self.pickupSound = love.audio.newSource("sfx/metal_impact.mp3");
	self.paySound = love.audio.newSource("sfx/money_multiple_coins_drop_on_hard_surface_001.mp3");
end

function Player:update(dt)
	local body = self:getBody();

	if self:isInteracting() then
		local x, y = body:getWorldCenter();
		local obj = self.interacting;
		if math.distancesquared(x, y, obj:getBody():getWorldCenter()) > INTERACTION_DISTANCE then
			self.interacting = nil;
		end
	else
		do -- Force
			local forceX, forceY = 0, 0;
			local movementX = body:getMass() * math.sin(-body:getAngle());
			local movementY = body:getMass() * math.cos(-body:getAngle());
			if love.keyboard.isDown("up") then
				forceX = -MOVE_SPEED * movementX;
				forceY = -MOVE_SPEED * movementY;
			end
			if love.keyboard.isDown("down") then
				forceX = forceX + REVERSE_SPEED * movementX;
				forceY = forceY + REVERSE_SPEED * movementY;
			end
			body:applyForce(forceX, forceY);
		end

		do -- Torque
			local torque = 0;
			if love.keyboard.isDown("left") then
				torque = -ROTATION_SPEED * body:getInertia();
			end
			if love.keyboard.isDown("right") then
				torque = torque + ROTATION_SPEED * body:getInertia();
			end
			body:applyTorque(torque);
		end
	end

	if self.animate then
		local sx, sy = body:getLinearVelocity();
		local movement = math.abs(sx) + math.abs(sy);
		self.animate.moved = self.animate.moved - movement;
		if self.animate.moved <= 0 then
			self.animate.currFrame = (self.animate.currFrame % #self.animate.frames) + 1;
			self.animate.moved = self.animate.distanceSwitch;
		end
	end
end

function Player:draw()
	do -- Draw the player's shopping list.
		local listX = love.window.getWidth() - self.list.image:getWidth() - 10;
		local listY = love.window.getHeight() - self.list.image:getHeight() - 10;

		love.graphics.draw(self.list.image, listX, listY);

		love.graphics.setFont(self.list.fontBig);
		love.graphics.setColor(50, 50, 150, 255);
		love.graphics.print("Shopping List", listX + 10, listY + 10);
		love.graphics.setFont(self.list.font);

		for i=1,#self.list.items do
			local x = listX + 30;
			local y = listY + 56 + (i-1) * 34;

			local text = string.humanize(self.list.items[i].name);
			if self.list.items[i].quantity > 1 then
				text = text .. " x" .. self.list.items[i].quantity;
			end
			love.graphics.print(text, x, y);

			for _,item in ipairs(self.inventory) do
				if item.name == self.list.items[i].name then
					if item.quantity >= self.list.items[i].quantity then
						y = y + self.list.font:getHeight()/2 + 4;
						love.graphics.setLineWidth(2);
						love.graphics.line(x - 3, y, x + 3 + self.list.font:getWidth(text), y);
					end
					break;
				end
			end
		end
		love.graphics.setColor(255, 255, 255, 255);
	end

	do -- Draw the player.
		if self.animate then
			self:setDrawOpts(self.animate.frames[self.animate.currFrame]);
		end
		Object.draw(self);
	end

	do -- Draw the cart inventory.
		love.graphics.push();

		love.graphics.translate(self:getBody():getWorldCenter());
		love.graphics.rotate(self:getBody():getAngle());

		-- TODO: LOL... not optimal.
		-- Does not account for overlap (bigger goods).
		-- Looks funny with overflow.
		local x, y = -25, 3;
		for i,item in ipairs(self.inventorySet) do
			love.graphics.draw(item.img, x, y);
			x = x + 14;
			if x == 31 then
				x = -25;
				if y > -50 then
					y = y - 20;
				else
					y = 10;
				end
			end
		end

		love.graphics.pop();
	end

	--if self:isInteracting() then
		--love.graphics.rectangle("fill", 100, 100, 440, 440);
	--end
	--love.graphics.setPointSize(10);
	--love.graphics.point(self:getBody():getWorldPoint(0, 20));
end

function Player:isInteracting()
	return self.interacting ~= nil;
end

function Player:createShoppingList(items)
	local numItems = love.math.random(6, 10);
	local maxItems = #items;

	for i=1,numItems do
		addItem(self.list.items, items[love.math.random(1, maxItems)]);
	end
end

function Player:setFrames(frames)
	assert(#frames > 0);
	self.animate = {
		frames = frames,
		currFrame = 1,
		distanceSwitch = 1000,
		moved = 1000
	};
end

function Player:withinInteractionRange(obj)
	-- The point is a bit closer to where the man is standing.
	local x, y = self:getBody():getWorldPoint(0, 20);
	return math.distancesquared(x, y, obj:getBody():getWorldCenter()) <= INTERACTION_DISTANCE;
end

function Player:interact(obj)
	if obj.goods then
		self.pickupSound:play();
		addItem(self.inventory, obj.goods);
		table.insert(self.inventorySet, { name = obj.goods, img = obj:getGoodImage() });
	elseif obj.cashier then
		self.paySound:play();
		love.event.push('finished');
	end
end

return Player;
