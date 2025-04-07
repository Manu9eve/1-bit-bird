function rect(x, y, w, h)
	local r = {}

	r.x = x
	r.y = y
	r.width = w
	r.height = h
	return r
end

function collide(r1,r2)
	local horizontal_overlap = (r1.x + r1.width >= r2.x and r1.x <= r2.x + r2.width)
	local vertical_overlap = (r1.y + r1.height >= r2.y and r1.y <= r2.y + r2.height)

	return horizontal_overlap and vertical_overlap
end
