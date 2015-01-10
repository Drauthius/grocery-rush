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

local sti = require("lib.sti");
local Object = require("src.object");
local Cashier = require("src.cashier");
local Container = require("src.container");
local Player = require("src.player");
local debugWorldDraw = require("debugWorldDraw");
require("lib.math");

local World = Class("World");

local MAX_FORCE, MAX_TORQUE = 50, 1;
local function createFrictionJoint(surface, body, x, y)
	local joint = love.physics.newFrictionJoint(surface, body, x, y, true);
	joint:setMaxForce(body:getMass() * MAX_FORCE);
	joint:setMaxTorque(body:getInertia() * MAX_TORQUE);

	return joint;
end;

function World:initialize(map, timeout)
	self.world = love.physics.newWorld();
	self.surfaceBody = love.physics.newBody(self.world);

	self.map = sti.new(map);
	love.graphics.setBackgroundColor(self.map.backgroundcolor);
	self.collision = self.map:initWorldCollision(self.world);

	self.objects = {};
	self.frictions = {};

	local img = love.graphics.newImage("gfx/floor.png");

	do -- Shelves
		self.map.layers["Shelves"].visible = false;
		for _,obj in ipairs(self.map.layers["Shelves"].objects) do
			-- We need the middle of the shelf.
			local angle = math.rad(obj.rotation);
			local rotX, rotY = math.rotationpoint(obj.width/2, obj.height/2, angle);

			local shelf = Container:new(obj.width, obj.height, obj.type);

			local body = self:addObject(shelf, obj.x + rotX, obj.y + rotY);
			body:setMass(25);
			body:setAngle(angle);
		end
	end

	do -- Cashiers
		self.map.layers["Cashiers"].visible = false;
		for _,obj in ipairs(self.map.layers["Cashiers"].objects) do
			-- We need the middle of the cashier.
			local angle = math.rad(obj.rotation);
			local rotX, rotY = math.rotationpoint(obj.width/2, obj.height/2, angle);

			local cashier = Cashier:new(obj.width, obj.height);
			cashier:setDrawOpts(love.graphics.newImage("gfx/counter.png"));

			-- Cashiers can't be pushed around.
			local body = self:addObject(cashier, obj.x + rotX, obj.y + rotY, "static");
			body:setAngle(angle);
		end
	end

	do -- Doors
		self.doors = { };
		self.map.layers["Entry"].visible = false;
		for _,obj in ipairs(self.map.layers["Entry"].objects) do
			obj.img = img;
			if obj.type == "leftDoor" then
				obj.rotation = -90;
				self.doors.left = obj;
			elseif obj.type == "rightDoor" then
				obj.rotation = 90;
				self.doors.right = obj;
			else
				assert(nil, "Wrong entry type: "..(obj.type or "nil"));
			end
		end
		assert(self.doors.left, "Missing left entry door.");
		assert(self.doors.right, "Missing right entry door.");
	end

	do -- Player
		self.player = Player:new(60, 120);
		local straight = love.graphics.newImage("gfx/cartstraight.png");
		self.player:setFrames({
			love.graphics.newImage("gfx/cartleft.png"),
			straight,
			love.graphics.newImage("gfx/cartright.png"),
			straight
		});
		self.player:createShoppingList(Container.getAllGoods());

		local x = self.doors.left.x + (self.doors.right.x + 64 - self.doors.left.x)/2;
		local y = self.doors.left.y;

		local body = self:addObject(self.player, x, y);
		body:applyLinearImpulse(0, -2500); -- BURST (in)
	end

	self.timeout = timeout;
	self.timerFont = love.graphics.newFont("ttf/homespun.ttf", 50);
	self.infoTitleFont = self.timerFont;
	self.infoFont = love.graphics.newFont("ttf/homespun.ttf", 24);

	self.logo = love.graphics.newImage("gfx/logo.png");
	self.rightChoice = love.graphics.newImage("gfx/right.png");
	self.wrongChoice = love.graphics.newImage("gfx/wrong.png");

	do -- Sound effects
		self.backgroundMusic = love.audio.newSource("sfx/557605_Shopping-Theme-Remi.mp3");
		self.backgroundMusic:setVolume(0.2);
		self.backgroundMusic:play();

		self.clockSound = love.audio.newSource("sfx/clock_tick_002.mp3");
		self.clockSound:setLooping(true);

		self.timeoutSound = love.audio.newSource("sfx/ouch1_1.mp3");

		-- Crashing into things.
		self.crashSound = love.audio.newSource("sfx/shopping_cart_crash_into_object.mp3");
		self.world:setCallbacks(nil, nil, nil, (function(fixture1, fixture2, _, _, tangentImpulse1, _, tangentImpulse2)
			local fixture = self.player:getBody():getFixtureList()[1];
			if fixture == fixture1 or fixture == fixture2 then
				tangentImpulse1 = tangentImpulse1 or 0;
				tangentImpulse2 = tangentImpulse2 or 0;

				--TODO: Not that great.
				if math.abs(tangentImpulse1) > 50 or math.abs(tangentImpulse2) > 50 then
					self.crashSound:play();
				end
			end
		end));
	end
end

function World:getSize()
	return self.map.width * self.map.tilewidth, self.map.height * self.map.tileheight;
end

function World:addObject(obj, x, y, collType)
	table.insert(self.objects, obj);

	local body = love.physics.newBody(self.world, x, y, collType or "dynamic");
	local shape = love.physics.newRectangleShape(obj:getWidth(), obj:getHeight());
	local fixture = love.physics.newFixture(body, shape);

	obj:setBody(body);

	return body;
end

function World:update(dt)
	if self.gameOver then
		self.gameOverTime = self.gameOverTime + dt;
		return;
	end

	self.timeout = self.timeout - dt;

	if self.timeout < 0 then
		self.gameOver = "time";
		self.gameOverTime = 0;
		self.clockSound:stop();
		self.timeoutSound:play();
	elseif self.timeout < 10 then
		self.clockSound:play();
	end

	if self.doors then
		--self.player:getBody():applyForce(0, -3000);

		self.doors.left.rotation = self.doors.left.rotation + dt * 50;
		self.doors.right.rotation = self.doors.right.rotation - dt * 50;
		if self.doors.left.rotation > 0 then
			for _,door in pairs(self.doors) do
				local obj = Object:new(64, 64);
				obj:setDrawOpts(door.img, self.map.tiles[door.gid].quad);
				self:addObject(obj, door.x + 32, door.y - 32, "static");
			end
			self.doors = nil;
		end
	end

	-- Destroy all the friction joints.
	-- They need to be recreated because they cannot be modified.
	for _,friction in ipairs(self.frictions) do
		friction:destroy();
	end
	self.frictions = {};

	for _,obj in ipairs(self.objects) do
		--if self.doors and obj ~= self.player then
			obj:update(dt);
		--end

		do -- Add friction points
			local body = obj:getBody();
			local angleS = math.sin(body:getAngle());
			local angleC = math.cos(body:getAngle());

			local topLeftX, topLeftY = math.rotationpointx(-obj:getWidth()/2, -obj:getHeight()/2, angleS, angleC);
			local topRightX, topRightY = math.rotationpointx(obj:getWidth()/2, -obj:getHeight()/2, angleS, angleC);
			local bottomLeftX, bottomLeftY = math.rotationpointx(-obj:getWidth()/2, obj:getHeight()/2, angleS, angleC);
			local bottomRightX, bottomRightY = math.rotationpointx(obj:getWidth()/2, obj:getHeight()/2, angleS, angleC);

			local x, y = body:getWorldCenter();
			table.insert(self.frictions, createFrictionJoint(self.surfaceBody, body, x + topLeftX, y + topLeftY));
			table.insert(self.frictions, createFrictionJoint(self.surfaceBody, body, x + topRightX, y + topRightY));
			table.insert(self.frictions, createFrictionJoint(self.surfaceBody, body, x + bottomLeftX, y + bottomLeftY));
			table.insert(self.frictions, createFrictionJoint(self.surfaceBody, body, x + bottomRightX, y + bottomRightY));
		end
	end

	self.map:update(dt);
	self.world:update(dt);
end

function World:draw()
	self.map:draw();

	if self.doors then
		local left, right = self.doors.left, self.doors.right;
		love.graphics.draw(left.img, self.map.tiles[left.gid].quad, left.x+5, left.y-64+5, math.rad(left.rotation), 1, 1, 5, 5);
		love.graphics.draw(right.img, self.map.tiles[right.gid].quad, right.x+60, right.y-64+5, math.rad(right.rotation), 1, 1, 60, 5);
	end

	for _,obj in ipairs(self.objects) do
		obj:draw();
		-- Outline interactable objects within range.
		if obj ~= self.player and obj:isInteractable() and self.player:withinInteractionRange(obj) then
			local body = obj:getBody();

			love.graphics.push();
			love.graphics.translate(body:getWorldCenter());
			love.graphics.rotate(body:getAngle());

			love.graphics.setColor(50, 200, 50, 255);
			love.graphics.setLineWidth(3);
			love.graphics.rectangle("line", -obj:getWidth()/2, -obj:getHeight()/2, obj:getWidth(), obj:getHeight());
			love.graphics.setColor(255, 255, 255, 255);

			love.graphics.pop();
		end
	end

	do -- Draw logo & timer.
		love.graphics.draw(self.logo, love.window.getWidth() - self.logo:getWidth() - 5, 5);
		love.graphics.setFont(self.timerFont);
		local timeout;
		if self.timeout > 0 then
			timeout = ("%02d:%02d"):format(math.floor(self.timeout) / 60, math.floor(self.timeout) % 60);
		else
			timeout = "00:00";
		end
		if self.timeout < 10 then
			love.graphics.setColor(255, 0, 0, 255);
		end
		love.graphics.printf(timeout, love.window.getWidth() - panelWidth - 48, 110, panelWidth + 32, "center");
		love.graphics.setColor(255, 255, 255, 255);
	end

	if debug then
		debugWorldDraw(self.world);

		love.graphics.setColor(255, 0, 0, 255);
		self.map:drawWorldCollision(self.collision);
		love.graphics.setColor(255, 255, 255, 255);

		love.graphics.setFont(self.infoFont);
		love.graphics.print("FPS: "..love.timer.getFPS(), 10, 10);
	end

	-- DAMN this thing is ugly.
	-- Would probably have been a lot nicer if it was split up in different
	-- states and using some more sophisticated timers.
	if self.gameOver then
		love.graphics.setColor(0, 0, 0, 175);
		love.graphics.rectangle("fill", 0, 0, love.window.getDimensions());
		love.graphics.setColor(255, 255, 255, 255);

		local lineSpacing = self.infoFont:getHeight() * 1.5;
		local windowWidth = love.window.getWidth();

		if self.gameOver == "time" then
			love.graphics.setFont(self.infoTitleFont);
			love.graphics.printf("Game over", 0, 200, windowWidth, "center");

			love.graphics.setFont(self.infoFont);
			if self.gameOverTime > 0.5 then
				love.graphics.printf("You didn't make it back in time.", 0, 300, windowWidth, "center");
				if self.gameOverTime > 1.5 then
					love.graphics.printf("You'll be sleeping on the couch tonight.", 0, 300 + lineSpacing, windowWidth, "center");
				end
			end
		elseif self.gameOver == "finished" then
			local y = 150;

			love.graphics.setFont(self.infoTitleFont);
			love.graphics.printf("Finished", 0, y, windowWidth, "center");

			love.graphics.setFont(self.infoFont);

			local startDesc = windowWidth/2 - 200;
			local stopDesc = windowWidth/2 - 10 - startDesc;
			local startItems = windowWidth/2 + 10;

			local score = 0;

			if self.gameOverTime > 0.5 then
				local shoppingList = {};
				for k,v in ipairs(self.player.list.items) do
					shoppingList[v.name] = v.quantity;
				end

				y = y + 75;
				love.graphics.printf("Bought items", startDesc, y, stopDesc, "right");
				for i=1,#self.player.inventorySet do
					if i * 0.6 > self.gameOverTime - 0.5 then
						break;
					else
						love.graphics.draw(self.player.inventorySet[i].img, startItems + (i-1) * 30, y);

						local item = self.player.inventorySet[i].name;
						if shoppingList[item] ~= nil and shoppingList[item] > 0 then
							shoppingList[item] = shoppingList[item] - 1;
							score = score + 200;
							love.graphics.draw(self.rightChoice, startItems + (i-1) * 30, y);
						else
							score = score - 100;
							love.graphics.draw(self.wrongChoice, startItems + (i-1) * 30, y);
						end
					end
				end

				local timeForMissing = 0.5 + 0.5 + 0.6 * #self.player.inventorySet;
				local missing = {};
				if self.gameOverTime > timeForMissing then
					y = y + lineSpacing;

					-- We want to show them in the same order as they
					-- appear on the shopping list.
					for i,item in ipairs(self.player.list.items) do
						for j=1,shoppingList[item.name] do
							table.insert(missing, Container.static.goods[item.name].single);
						end
					end

					love.graphics.printf("Missed items", startDesc, y, stopDesc, "right");

					for i=1,#missing do
						if i * 0.6 > self.gameOverTime - timeForMissing then
							break;
						else
							love.graphics.draw(missing[i], startItems + (i-1) * 30, y);
							score = score - 400;
						end
					end
				end

				local timeForBonus = timeForMissing + 0.5 + 0.6 * #missing;
				if self.gameOverTime > timeForBonus then
					y = y + lineSpacing;

					love.graphics.printf("Time bonus", startDesc, y, stopDesc, "right");

					local bonus = math.floor(self.timeout) * 100;
					score = score + bonus;
					love.graphics.print("+"..bonus, startItems, y);
				end

				if self.gameOverTime > timeForBonus + 0.5 then
					y = y + lineSpacing;

					love.graphics.printf("Grade", startDesc, y, stopDesc, "right");
					local grade, text;
					if #missing > 0 or score < 0 then
						grade = "F";
						text = "You're a disgrace.";
					elseif score < 500 then
						grade = "E";
						text = "Unacceptable.";
					elseif score < 1000 then
						grade = "D";
						text = "My sister was right about you.";
					elseif score < 2500 then
						grade = "C";
						text = "Took you long enough.";
					elseif score < 4000 then
						grade = "B";
						text = "Took you long enough.";
					else
						grade = "A";
						text = "Took you long enough.";
					end
					love.graphics.print(grade, startItems, y);

					y = y + lineSpacing;
					love.graphics.printf('"'..text..'" - Your wife', 0, y, windowWidth, "center");
					if grade == "A" then
						y = y + lineSpacing;
						love.graphics.printf("(There is no winning with her.)", 0, y, windowWidth, "center");
					end
				end
			end

			love.graphics.printf("Score", startDesc, 500, stopDesc, "right");
			love.graphics.printf(score, startItems, 500, love.graphics.getFont():getWidth("10000"), "right");
		elseif self.gameOver == "credits" then
			local y = 50;

			love.graphics.setFont(self.infoTitleFont);
			love.graphics.printf("Credits", 0, y, windowWidth, "center");

			local startDesc = windowWidth/2 - 200;
			local stopDesc = windowWidth/2 - 10 - startDesc;
			local startName = windowWidth/2 + 10;
			love.graphics.setFont(self.infoFont);

			y = y + 75;
			love.graphics.printf("Programmer", startDesc, y, stopDesc, "right");
			love.graphics.print("Albert Diserholt", startName, y);

			y = y + lineSpacing;
			love.graphics.printf("Graphics", startDesc, y, stopDesc, "right");
			love.graphics.print("Sunisa Thongdaengdee", startName, y);

			y = y + 75;
			love.graphics.printf("Music", startDesc, y, stopDesc, "right");
			love.graphics.print("Djjaner @ www.newgrounds.com", startName, y);

			y = y + lineSpacing;
			love.graphics.printf("Sound effects", startDesc, y, stopDesc, "right");
			love.graphics.print("http://www.freesfx.co.uk", startName, y);
			y = y + lineSpacing;
			love.graphics.print("http://opengameart.org", startName, y);

			y = y + 75;
			love.graphics.printf("Special thanks to", 0, y, windowWidth, "center");
			y = y + lineSpacing;
			love.graphics.printf("Azhukar (Physics code)", 0, y, windowWidth, "center");
		end
	end
end

function World:keypressed(key)
	if key == ' ' then
		if self.gameOver then
			if self.gameOver ~= "credits" then
				self.gameOver = "credits";
			else
				love.event.push("restart");
			end
		elseif not self.player:isInteracting() then
			for _,obj in ipairs(self.objects) do
				if obj:isInteractable() and self.player:withinInteractionRange(obj) then
					self.player:interact(obj);
					return;
				end
			end
		end
	end
end

function World:finish()
	self.gameOver = "finished";
	self.gameOverTime = 0;
	self.clockSound:stop();
end

function World:destroy()
	self.world:destroy();
	self.backgroundMusic:stop();
end

return World;
