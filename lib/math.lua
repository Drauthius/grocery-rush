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

-- Rotate a point according to an angle.
function math.rotationpoint(x, y, angle)
	local s = math.sin(angle);
	local c = math.cos(angle);
	return math.rotationpointx(x, y, s, c);
end

-- Rotate a point according to a pre-calculated angle.
function math.rotationpointx(x, y, s, c)
	return x * c - y * s, x * s + y * c;
end

-- Distance between two points.
function math.distance(x1, y1, x2, y2)
	return math.distancesquared(x1, y1, x2, y2)^0.5;
end

-- Squared distance between two points.
function math.distancesquared(x1, y1, x2, y2)
	return ((x1-x2)^2 + (y1-y2)^2);
end
