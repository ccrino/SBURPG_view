HC = require 'HC'
local utf8 = require("utf8")

Field = {col = nil, xt = 0, yt = 0, ft = nil, xv = 0, yv = 0, fv = nil, name = "", vali = "", c = nil, prs = "", pos = ""}
Button = {col = nil, xt = 0, yt = 0, ft = nil, title = "", func = nil, c = nil}

function love.load()
	
	
	
	bg = {17/255,13/255,38/255}
	bl = {34/255,26/255,76/255}
	a  = {153/255, 0, 38/255}
	ap = {255/255, 0, 76/255}
	p  = {214/255,152/255,0}
	pl = {1,238/255,0}
	d  = {155/255, 0, 226/255}
	dl = {1,0,1}
	w  = {1,1,1}
	lg = {191/255, 191/255, 191/255}
	li = {0, 227/255, 113/255}
	mg = {1, 6/255, 124/255}
	love.graphics.setBackgroundColor(bg)
	love.graphics.setDefaultFilter("nearest","nearest",0)
	font = love.graphics.newImageFont("sburpg_FontImage.png",
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789,.!?@#$%^&*()_+-=[]{};:'\"\\|<>/", -1)
	symbols = love.graphics.newImageFont("sburpg_FontSymbol.png", "dpyn")
	font270rot = love.graphics.newImageFont("sburpg_FontImage270rot.png", " abcdefghijklmnopqrstuvwxyz", -1)
	love.graphics.setFont(font)
	love.graphics.setColor(a)
	worldspace = HC.new(100)
	Layers = { back = {}, fore = {}, text = {}}
	planetImage = nil
	focus = nil
	fbefore = nil
	
	--temporary starts sheet as new on startup
	InitSheet()
	standardColors = { focus = ap, hover = a, field = bl, title = w, value = w}
	radioButtonColor = { focus = 0, hover = ap, field = ap, title = 0, value = 0 }
	simpleButtonColor = { focus = 0, hover = lg, field = w, title = 0, value = 0 }
	prospitColors = { focus = {0,0,0}, hover = pl, field = p, title = w, value = w}
	derseColors = { focus = {0,0,0}, hover = dl, field = d, title = w, value = w}
	
	-- field colliders	:newHexField( collider, x, y, name, savename, standardColors)
	Fields = {}
	Fields.Placronym	= Field:new( HC.rectangle(10,36,300,50),     10, 36,   10, -29, lTitle,   0, 15, lTitle, "PLACRONYM", "Placronym", standardColors)
	Fields.Class		= Field:new( HC.rectangle(330,36,155,50),   330, 36,   10, -29, lTitle,   5, 15, lTitle, "CLASSPECT", "Class", standardColors)
	Fields.Aspect		= Field:new( HC.rectangle(485,36,155,50),   485, 36,    0,   0, lTitle, -14, 15, lTitle,   "",    "Aspect",   standardColors, "OF ")
	Fields.Feel			= Field:new( HC.rectangle(160,136,255,50),  160, 136, 120, -28, lTitle,   5, 17, lTitle,   "FEEL",  "Feel",   standardColors, "LAND OF ")
	Fields.Quest		= Field:new( HC.rectangle(415,136,225,50),  415, 136,  55, -28, lTitle,   5, 17, lTitle,   "QUEST","Quest",   standardColors, "AND ")
	Fields.Know			= Field:new( makeHexCollider( 50, 263, 40),  50, 263,  -1,   0, hexTitle, 0, 20, hexValue, "KNOW",  "Know",   standardColors)
	Fields.Make			= Field:new( makeHexCollider(130, 263, 40), 130, 263,  -1,   0, hexTitle, 0, 20, hexValue, "MAKE",  "Make",   standardColors)
	Fields.Take			= Field:new( makeHexCollider( 10, 333, 40),  10, 333,  -1,   0, hexTitle, 0, 20, hexValue, "TAKE",  "Take",   standardColors)
	Fields.Be			= Field:new( makeHexCollider( 90, 333, 40),  90, 333,  -1,   0, hexTitle, 0, 20, hexValue, "BE",    "Be",     standardColors)
	Fields.Use			= Field:new( makeHexCollider(170, 333, 40), 170, 333,  -1,   0, hexTitle, 0, 20, hexValue, "USE",   "Use",    standardColors)
	Fields.Mar			= Field:new( makeHexCollider( 50, 403, 40),  50, 403,  -1,   0, hexTitle, 0, 20, hexValue, "MAR",   "Mar",    standardColors)
	Fields.Shift		= Field:new( makeHexCollider(130, 403, 40), 130, 403,  -1,   0, hexTitle, 0, 20, hexValue, "SHIFT", "Shift",  standardColors)
	Fields.Bond1		= Field:new( HC.rectangle(250,253,300,80),  250, 253,   0, -30, lTitle,  10,  1, lPara,    "BOND",  "Bond1",  standardColors)
	Fields.Bond2		= Field:new( HC.rectangle(250,338,300,80),  250, 338,   0,   0, lTitle,  10,  1, lPara,    "",      "Bond2",  standardColors)
	Fields.Bond3		= Field:new( HC.rectangle(250,423,300,80),  250, 423,   0,   0, lTitle,  10,  1, lPara,    "",      "Bond3",  standardColors)
	Fields.Vitcur		= Field:new( makeHexCollider( 10, 475, 40),  10, 475,  80,  15, lTitle, 0, 20, hexValue, "VITALITY","Vitcur", standardColors)
	Fields.Vitmax		= Field:new( makeHexCollider( 50, 545, 40),  50, 545,  -1,   0, hexTitle, 0, 20, hexValue, "",      "Vitmax", standardColors)
	Fields.Shade		= Field:new( makeHexCollider(130, 545, 40), 130, 545,  -1,   0, hexTitle, 0, 20, hexValue, "SHADE", "Shade",  standardColors)
	Fields.Skill		= Field:new( makeHexCollider(210, 545, 40), 210, 545,  -1,   0, hexTitle, 0, 20, hexValue, "SKILL", "Skill",  standardColors)
	Fields.HClass		= Field:new( makeHexCollider(290, 545, 40), 290, 545,  -1,   0, hexTitle, 0, 20, hexValue, "HORDE", "HClass", standardColors)
	Fields.HRank		= Field:new( makeHexCollider(250, 615, 40), 250, 615,  -1,   0, hexTitle, 0, 20, hexValue, "RANK",  "HRank",  standardColors)
	Fields.BoonD		= Field:new( HC.rectangle(570,583,270,50), 570, 583, 0, -30, lTitle, 0, 0, rDollar, "BOON DOLLARS", "BoonD", standardColors)
	Fields.Moon			= Field:new( makePentField(440,575,50), 440, 575, 0, 0, lTitle, 20, 25, symbolPrint, "", "Moon", standardColors)
	Fields.Awake		= Button:new( makePentField(365,616,35), 365, 616, 10, 5, symbolPrint, "n", awakePress, standardColors)
	Fields.SaveGame		= Button:new( HC.rectangle(1170,10,100,50), 1170, 10, 20, 10, lTitle, "SAVE", saveToFile, standardColors)
	Fields.Awake.col:rotate(math.pi)
	Fields.Kind			= Field:new( HC.rectangle(580,463,250,60), 580, 463, -5, -240, lTitle, 0, 20, rKind, "STRIFE SPACIBUS", "Kind", standardColors, "", "kind")
	Fields.Rung			= Field:new( HC.rectangle(850,583,300,50), 850, 583, 10, -29, lTitle, 5, 15, lTitle, "RUNG", "Rung", standardColors)
	Fields.Exp			= Field:new( HC.rectangle(1160,558,100,100),1160,558, 0,   0, lTitle, 15, 25, hexValue, "", "Exp", standardColors)
	Fields.ExpUp		= Button:new( makeTriCollider(1185,503,50), 1185,503, 0,   0, lTitle, "", expUpPress, simpleButtonColor)
	Fields.ExpDown		= Button:new( makeTriCollider(1185,653,50), 1185,653, 0,   0, lTitle, "", expDownPress, simpleButtonColor)
	Fields.ExpDown.col:rotate(math.pi)
	Fields.Captcha		= Field:new( HC.rectangle(880,223, 200,300), 880,223,240,300, captchalogTitle, 0, 0, lParaC, "captchalogue", "Captcha1", standardColors )
	Fields.Captcha1		= Button:new(HC.rectangle(1085,293, 30,30), 1085,293, 0,0, lTitle, "", captcha1Press, radioButtonColor)
	Fields.Captcha2		= Button:new(HC.rectangle(1085,343, 30,30), 1085,343, 0,0, lTitle, "", captcha2Press, standardColors)
	Fields.Captcha3		= Button:new(HC.rectangle(1085,393, 30,30), 1085,393, 0,0, lTitle, "", captcha3Press, standardColors)
	Fields.Captcha4		= Button:new(HC.rectangle(1085,443, 30,30), 1085,443, 0,0, lTitle, "", captcha4Press, standardColors)
	Fields.Captcha5		= Button:new(HC.rectangle(1085,493, 30,30), 1085,493, 0,0, lTitle, "", captcha5Press, standardColors)
	
	
	if save.Awake then
		Fields.Awake.title = 'y'
	end
	if save.Moon == "p" then
		Fields.Moon:recolor( prospitColors )
		Fields.Awake:recolor( prospitColors )
	elseif save.Moon == "d" then
		Fields.Moon:recolor( derseColors )
		Fields.Awake:recolor( derseColors )
	end
	
	-- mouse collider
	mouse			  = HC.point(0,0)
	
end


function love.draw()
	love.graphics.setColor(li)
	love.graphics.polygon('fill',570,213, 780,213, 850,293, 850,533, 570,533)
	love.graphics.setColor(mg)
	love.graphics.polygon('fill',870,213, 1080,213, 1150,293, 1150,533, 870,533)
	love.graphics.setColor(w)
	love.graphics.polygon('fill',630,253, 760,253, 830,333, 830,453, 630,453)
	love.graphics.rectangle('fill',580,253,40,40)
	love.graphics.rectangle('fill',580,306,40,40)
	love.graphics.rectangle('fill',580,360,40,40)
	love.graphics.rectangle('fill',580,413,40,40)
	
	
	
	
	
	love.graphics.setColor(lg)
	love.graphics.rectangle('fill',1185,546,50,8)
	love.graphics.polygon('fill',1185,668, 1185,676, 1210,719, 1235,676, 1235,668)
	
	love.graphics.setColor(bl)
	
	--Planet Viewer Field
	love.graphics.stencil( function () love.graphics.circle('fill', 80,163,70) end, "replace", 1)
	love.graphics.setStencilTest("greater", 0)
	if planetImage then 
		love.graphics.setColor(w)
		love.graphics.draw( planetImage, 10,93)
	else
		love.graphics.circle('fill', 80,163,70)
	end
	love.graphics.setStencilTest()
	
	if not focus or not ( focus.vali == "Vitcur" or focus.vali == "Vitmax" ) then
		love.graphics.setColor(a)
		love.graphics.arc('fill',"pie", 85,585,80,math.pi/6,(1/6 + tonumber(save.Vitcur)/tonumber(save.Vitmax))*math.pi)
		love.graphics.setColor(bg)
		love.graphics.arc('fill',"pie", 85,585,60,math.pi/6,(1/6 + tonumber(save.Vitcur)/tonumber(save.Vitmax))*math.pi)
	end
	

	--color FIELDS if moused over
	for i, field in pairs(Fields) do
		if field.__index == Field then
			field:drawField()
		elseif field.__index == Button then
			field:drawButton()
		end
	end

	for i, f in pairs(Layers.back) do
		f()
	end
	Layers.back = {}
	for i, f in pairs(Layers.fore) do
		f()
	end
	Layers.fore = {}
	for i, f in pairs(Layers.text) do
		f()
	end
	Layers.text = {}
end

function love.update(dt)
	mouse:moveTo(love.mouse.getPosition())
	Fields.Moon.col:rotate(dt/4)
	Fields.Awake.col:rotate(dt/4, Fields.Moon.col:center())
end

function love.mousepressed(x,y,button,istouch)
	for i, shape in pairs(Fields) do
		if shape.col:contains(x,y) then
			if shape.__index == Button then
				shape.func()
			elseif i == "Moon" then
				if save[shape.vali] == "" then
					save[shape.vali] = "p"
					shape:recolor( prospitColors )
					Fields.Awake:recolor( prospitColors )
				elseif save[shape.vali] == "p" then
					save[shape.vali] = "d"
					shape:recolor( derseColors )
					Fields.Awake:recolor( derseColors )
				else
					save[shape.vali] = "p"
					shape:recolor( prospitColors )
					Fields.Awake:recolor( prospitColors )
				end
			else
				if focus then
					save[focus.vali] = fbefore
				end			
				focus = shape
				fbefore = save[shape.vali]
			end
			break
		end
	end
	
end

function love.textinput(t)
	if focus then
		save[focus.vali] = save[focus.vali] .. t
	end
end

function love.keypressed( key )
	if key == "backspace" and focus then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(save[focus.vali], -1)
 
        if byteoffset then
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            save[focus.vali] = string.sub(save[focus.vali], 1, byteoffset - 1)
        end
    elseif key == "return" and focus then
		if focus.vali == "Vitmax" or focus.vali == "Vitcur"
		or focus.vali == "HRank"  or focus.vali == "Skill"
		or focus.vali == "BoonD" then
			if tonumber(save[focus.vali]) then 
				focus = nil
			else 
				save[focus.vali] = fbefore
				focus = nil
			end
		else
			focus = nil
		end
		
	elseif key == "escape" and focus then
		save[focus.vali] = fbefore
		focus = nil
	end
	
end

function love.filedropped( file )
	if string.sub( file:getFilename(), -7, -1 ) == ".sburpg" then
		dofile( file:getFilename() )
		if save.Awake then
			Fields.Awake.title = 'y'
		else
			Fields.Awake.title = 'n'
		end
	
		if save.Moon == "p" then
			Fields.Moon:recolor( prospitColors )
			Fields.Awake:recolor( prospitColors )
		elseif save.Moon == "d" then
			Fields.Moon:recolor( derseColors )
			Fields.Awake:recolor( derseColors )
		else
			Fields.Moon:recolor( standardColors )
			Fields.Awake:recolor( standardColors )
		end
		
		if save.Planet.s then
			--[[
			local fileData =  love.filesystem.newFileData( save.Planet.s, save.Planet.n )
			print( fileData:getExtension(), fileData:getFilename( fileData) )
			ok, em = love.filesystem.write(save.Planet.n, fileData, fileData:getSize())
			if not ok then
				print( em )
			end
			--local planetImageData = love.image.newCompressedData( fileData )
			--planetImage = love.graphics.newImage( planetImageData )
			--]]
			local planetImageData = love.image.newImageData( save.Planet.w, save.Planet.h, save.Planet.f, save.Planet.s)
			planetImage = love.graphics.newImage( planetImageData )
			
			
		end
		
	elseif string.sub( file:getFilename(), -4, -1 ) == ".png" then
		print( file:getSize() )
		local fileContents = file:read( file:getSize() )
		local fileData = love.filesystem.newFileData( fileContents, file:getFilename() )
		local planetImageData = love.image.newImageData( fileData )
		planetImage = love.graphics.newImage( planetImageData )
		local canvas = love.graphics.newCanvas(140,140)
		love.graphics.setCanvas(canvas)
			love.graphics.setColor(w)
			love.graphics.setDefaultFilter("nearest","nearest",0)
			love.graphics.draw( planetImage, 0,0,0, 140 / planetImage:getWidth(), 140 / planetImage:getHeight() )
		love.graphics.setCanvas()
		planetImageData = canvas:newImageData()
		planetImage = love.graphics.newImage( planetImageData )
		
		save.Planet = { w = planetImageData:getWidth(), h = planetImageData:getHeight(), f = planetImageData:getFormat(), s = planetImageData:getString() }
		--[[
		local fileData = planetImageData:encode("png", "planetImage.png")
		save.Planet = { n = fileData:getFilename(), s = fileData:getString() }
		--]]
	end
end

function InitSheet()
	save = {}
	save.Placronym 	= ""
	save.Feel 		= ""
	save.Quest 		= ""
	save.Class 		= ""
	save.Aspect 	= ""
	save.Make 		= ""
	save.Know 		= ""
	save.Use 		= ""
	save.Be 		= ""
	save.Take 		= ""
	save.Shift 		= ""
	save.Mar 		= ""
	save.Bond1		= ""
	save.Bond2		= ""
	save.Bond3		= ""
	save.Kind 		= ""
	save.Vitmax		= 13
	save.Vitcur 	= 13
	save.HClass 	= "F"
	save.HRank		= 0
	save.Shade		= "B"
	save.Skill		= 0
	save.BoonD		= 11
	save.Planet		= { w = nil, h = nil, f = nil, s = nil}
	save.Moon		= ''
	save.Awake		= false
	save.Rung		= ""
	save.Exp		= 0
	save.Captcha1	= ""
	save.Captcha2	= ""
	save.Captcha3	= ""
	save.Captcha4	= ""
	save.Captcha5	= ""
end

function makePentField( x, y, d)
	return HC.polygon( x+(d*math.cos(math.pi/5)), y,
				x+(d*math.cos(math.pi/5)*2), y+d*math.sin(math.pi/5),
				x+(d*(1+math.cos(math.pi*2/5))), y+d*(math.sin(math.pi/5) + math.sin(math.pi*2/5)),
				x+(d*(math.cos(math.pi*2/5))), y+d*(math.sin(math.pi/5) + math.sin(math.pi*2/5)),
				x, y+d*math.sin(math.pi/5))
end

function makeHexCollider( x, y, d)
	return HC.polygon( x+(d*math.sqrt(3)/2), y,
				x+(d*math.sqrt(3)), y+d/2,
				x+(d*math.sqrt(3)), y+d*3/2,
				x+(d*math.sqrt(3)/2), y+2*d,
				x, y+d*3/2,
				x, y+d/2 )
end

function makeTriCollider( x, y, d)
	return HC.polygon( x + d/2, y,
				x + d, y+d*math.sqrt(3)/2,
				x , y + d*math.sqrt(3)/2 )
end

function Field:new (collider, x, y, xt, yt, ft, xv, yv, fv, name, savename, colors, prs, pos)
	prs = prs or ""
	pos = pos or ""
	local cx, cy = collider:center()
	o = {col = collider, xt = xt + x - cx, yt = yt + y - cy, ft = ft, xv = xv + x - cx, yv = yv + y - cy, fv = fv, name = name, vali = savename, c = colors, prs = prs, pos = pos}
	setmetatable(o, self)
	self.__index = self
	return o    
end

function Button:new (collider, x, y, xt, yt, ft, title, func, colors)
	local cx, cy = collider:center()
	o = {col = collider, xt = x + xt - cx, yt = y + yt - cy, ft = ft, title = title, func = func, c = colors}
	setmetatable(o, self)
	self.__index = self
	return o
end

function hexTitle( s, x, y)
	return function () love.graphics.printf(s, x, y, 36,"center",0,2,2) end
end

function hexValue( s, x, y)
	return function () love.graphics.printf(s, x, y, 16,"center",0,4,4) end
end

function lTitle( s, x, y)
	return function () love.graphics.printf(s, x, y, 300,"left",0,2,2) end
end

function lPara( s, x, y)
	return function () love.graphics.printf(s, x, y, 145,"left",0,2,2) end
end

function lParaC( s, x, y)
	return function () love.graphics.printf(s, x, y, 100,"left",0,2,2) end
end

function rDollar( s, x, y)
	return function () love.graphics.printf(s, x, y, 65, "right",0,4,4) end
end

function rKind( s, x, y)
	return function () love.graphics.printf(s, x, y, 300,"left",0,2,2) end
end

function captchalogTitle( s, x, y)
	return function () 
		love.graphics.setFont(font270rot)
		love.graphics.printf(s, x, y, 150,"left",math.pi*3/2,2,2)
		love.graphics.setFont(font)
	end
end

function symbolPrint( s, x, y)
	return function ()
		love.graphics.setFont(symbols)
		love.graphics.printf(s, x, y, 38,"center",0,1,1)
		love.graphics.setFont(font)
	end
end

function Field:drawField()
	local c = nil
	if focus == self then
		c = self.c.focus
	elseif self.col:collidesWith(mouse) then
		c = self.c.hover
	else
		c = self.c.field
	end
	Layers.fore[1 + #Layers.fore] = function () love.graphics.setColor(c); self.col:draw('fill') end
	local cx, cy = self.col:center()
	Layers.text[1 + #Layers.text] = function () love.graphics.setColor(self.c.title); self.ft( self.name, cx + self.xt, cy + self.yt)() end
	Layers.text[1 + #Layers.text] = function () love.graphics.setColor(self.c.value); self.fv( self.prs .. save[self.vali] .. self.pos, cx + self.xv, cy + self.yv)() end
end

function Field:recolor( c )
	self.c = c
end
function Button:recolor( c )
	self.c = c
end
function Field:moveTo( x, y)
	self.col:moveTo(x, y)
end
function Field:move( dx, dy )
	self.col:move( dx, dy )
end
function Button:moveTo( x, y)
	self.col:moveTo(x, y)
end
function Button:move( dx, dy )
	self.col:move( dx, dy )
end
function Button:drawButton()
local c = nil
	if focus == self then
		c = self.c.focus
	elseif self.col:collidesWith(mouse) then
		c = self.c.hover
	else
		c = self.c.field
	end
	local cx, cy = self.col:center()
	Layers.fore[1 + #Layers.fore] = function () love.graphics.setColor(c); self.col:draw('fill') end
	if self.title and not ( self.title == "" ) then
		Layers.text[1 + #Layers.text] = function () love.graphics.setColor(self.c.title) end
		Layers.text[1 + #Layers.text] = self.ft( self.title, cx + self.xt, cy + self.yt)
	end
end

function saveToFile()
	local path = love.filesystem.getSourceBaseDirectory( )
	local f = assert( io.open( path .. "/" .. save.Placronym .. ".sburpg", "w" ) )
	f:write(
		"save = {}\n",
		"save = { \n",
		"\tPlacronym = \"" , save.Placronym , "\",\n",
		"\tFeel = \"" , save.Feel , "\",\n",
		"\tQuest = \"" , save.Quest , "\",\n",
		"\tClass = \"" , save.Class , "\",\n",
		"\tAspect = \"" , save.Aspect , "\",\n" ,
		"\tMake = \"" , save.Make , "\",\n" ,
		"\tKnow = \"" , save.Know , "\",\n" ,
		"\tUse = \"" , save.Use , "\",\n" ,
		"\tBe = \"" , save.Be , "\",\n" ,
		"\tTake = \"" , save.Take , "\",\n" ,
		"\tShift = \"" , save.Shift , "\",\n" ,
		"\tMar = \"" , save.Mar , "\",\n" ,
		"\tBond1 = \"" , save.Bond1 , "\",\n" ,
		"\tBond2 = \"" , save.Bond2 , "\",\n" ,
		"\tBond3 = \"" , save.Bond3 , "\",\n" ,
		"\tKind = \"" , save.Kind , "\",\n" ,
		"\tVitmax = " , save.Vitmax , ",\n" ,
		"\tVitcur = " , save.Vitcur , ",\n" ,
		"\tHClass = \"" , save.HClass , "\",\n" ,
		"\tHRank = " , save.HRank , ",\n" ,
		"\tShade = \"" , save.Shade , "\",\n" ,
		"\tSkill = " , save.Skill , ",\n" ,
		"\tBoonD = " , save.BoonD , ",\n" ,
		"\tPlanet = { \n" ,
		"\t\tw = " , tostring( save.Planet.w ) , ",\n" ,
		"\t\th = " , tostring( save.Planet.h ) , ",\n" ,
		"\t\tf = \"" , tostring( save.Planet.f ) , "\",\n" ,
		"\t\ts = [[" , tostring( save.Planet.s ) , "]]\n" ,
		"\t},\n" ,
		"\tMoon = \"" , save.Moon , "\",\n" ,
		"\tAwake = " , tostring( save.Awake ) , ",\n" ,
		"\tRung = \"" , save.Rung , "\",\n" ,
		"\tExp = " , save.Exp , ",\n" ,
		"\tCaptcha1 = \"" , save.Captcha1 , "\",\n" ,
		"\tCaptcha2 = \"" , save.Captcha2 , "\",\n" ,
		"\tCaptcha3 = \"" , save.Captcha3 , "\",\n" ,
		"\tCaptcha4 = \"" , save.Captcha4 , "\",\n" ,
		"\tCaptcha5 = \"" , save.Captcha5 , "\"\n" ,
		"}"
	)
	f:close()
end

--[[
"\tPlanet = { \n" ,
		"\t\tn = \"" , save.Planet.n , "\",\n" ,
		"\t\ts = [" , save.Planet.s , "]\n" ,
		"\t},\n" ,
--]]


function awakePress()
	save.Awake = not save.Awake
	if save.Awake then
		Fields.Awake.title = 'y'
	else
		Fields.Awake.title = 'n'
	end
end

function expUpPress()
	save.Exp = save.Exp + 1
	local n = math.floor( math.sqrt(2*save.Exp) )
	if n*(n + 1) == 2*save.Exp then
		save.Vitmax = save.Vitmax + 4
		save.Vitcur = save.Vitcur + 4
		save.Skill = save.Skill + 1
		save.Rung = ""
	end
	save.BoonD = save.BoonD + save.Exp
end

function expDownPress()
	local n = math.floor( math.sqrt(2*save.Exp) )
	if n*(n + 1) == 2*save.Exp then
		save.Vitmax = save.Vitmax - 4
		save.Vitcur = save.Vitcur - 4
		save.Skill = save.Skill - 1
		save.Rung = ""
	end
	save.BoonD = save.BoonD - save.Exp
	save.Exp = save.Exp - 1
end

for i = 1, 5 do
	f = loadstring( "function captcha" .. i .. "Press()\n\t" .. 
					"Fields.Captcha.vali = \"Captcha" .. i .. "\"\n" .. 
					"for i = 1, 5 do\n\t" .. 
						"Fields[\"Captcha\" .. i]:recolor(standardColors)\n" ..
					"end\n" ..
					"Fields[\"Captcha\" .. " .. i .. "]:recolor(radioButtonColor)\n" ..
					"end" )
	f()
end
