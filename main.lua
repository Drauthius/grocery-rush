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

-- Global library object.
Class = require("lib.middleclass");
-- Global debug variable.
debug = false;
-- Global variable determining the width of the right panel.
panelWidth = 150;

-- Classes.
local World = require("src.world");

-- Objects.
local world;

function love.load()
	world = World:new("supermarket2", 40);
	local w, h = world:getSize();

	w = w + panelWidth;

	love.window.setMode(w, h);
	love.resize(w, h); -- Meh
end

function love.update(dt)
	world:update(dt);
end

function love.draw()
	world:draw();
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit();
	elseif key == ' ' then
		world:keypressed(key);
	elseif key == 'tab' then
		debug = not debug;
	end
end

function love.resize(w, h)
	world.map:resize(w, h);
end

-- Restart game.
function love.handlers.restart()
	world:destroy();
	love.load();
end

-- Player paid.
function love.handlers.finished()
	world:finish();
end
