function onCreate()
    setProperty('camGame.y', 1000)
    -- setProperty('skipCountdown', true)
    makeLuaSprite('opening', 'stages/alley/opening', 0, 0)
    addLuaSprite('opening', true)
    setObjectCamera('opening', 'other')
    doTweenAlpha('logo', 'opening', 0, 0.1, 'circOut')
    runTimer('logoappear', 3)
end

function onTimerCompleted(tag, asdf)
    if tag == 'logoappear' then
        doTweenAlpha('logo', 'opening', 1, 6, 'circOut')
        doTweenY('camGame', 'camGame', 0, 10, 'circOut')
    end
end

function onBeatHit()
    if curBeat == 12 then
        doTweenAlpha('logo', 'opening', 0, 3, 'circOut')
    elseif curBeat == 288 then
        doTweenY('camGame', 'camGame', 1000, 10, 'circOut')
    end
end


function onCreatePost()
	luaDebugMode = true
    setProperty('healthBar.visible', false)
    setProperty('healthBarBG.visible', false)
    setProperty('iconP2.visible', false)
    setProperty('iconP1.visible', false)

	initLuaShader("bloom")
	makeLuaSprite("bloom")
	makeGraphic("bloom", screenWidth, screenHeight)
	setSpriteShader("bloom", "bloom")

	addHaxeLibrary("ShaderFilter", "openfl.filters")
	runHaxeCode([[
		game.camGame.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)/*, new ShaderFilter(game.getLuaObject("radialblur").shader)*/]);
		game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("bloom").shader)]);
	]])
end

local cameras = {'camGame', 'camHUD'}

function onUpdatePost(dt)
	for _,camera in ipairs(cameras) do
		setProperty(camera .. ".flashSprite.scaleX", 2)
		setProperty(camera .. ".flashSprite.scaleY", 2)

		local scale = getProperty(camera .. ".zoom") / 2
		callMethod(camera .. ".setScale", {scale, scale})
	end
end