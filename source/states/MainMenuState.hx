package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.editors.MasterEditorMenu;
import flixel.util.FlxTimer;
import backend.Song;

class MainMenuState extends MusicBeatState {

    // Visuals
    var gradient:FlxSprite;
    var bars:FlxSprite;
    var stars:FlxBackdrop;
    var prevMouseX:Float;
    var prevMouseY:Float;
    var backgroundOffsetX:Float; // Added variable
    var backgroundOffsetY:Float; // Added variable

    // Portraits/Frames
    var ruby:FlxSprite; 
    var storymode:FlxSprite;
    var freeplay:FlxSprite;
    var gallery:FlxSprite;
    var credits:FlxSprite;
    var options:FlxSprite;

    // Debug
    public static var psychEngineVersion:String = '0.6.3';

    override public function create():Void {

        FlxG.mouse.visible = true;

        gradient = new FlxSprite().loadGraphic(Paths.image('menus/mainmenu/splat'));
        gradient.antialiasing = ClientPrefs.data.antialiasing;
        gradient.scrollFactor.set(1, 1);
        gradient.screenCenter();
        add(gradient);  

        bars = new FlxSprite(-100, 0).loadGraphic(Paths.image('menus/mainmenu/sidething'));
        bars.antialiasing = ClientPrefs.data.antialiasing;
        add(bars);
        bars.screenCenter();

        ruby = new FlxSprite(1280, 0).loadGraphic(Paths.image('menus/mainmenu/lady'));
        ruby.antialiasing = ClientPrefs.data.antialiasing;
        FlxTween.tween(ruby, { x: 0}, 1.8, {ease: FlxEase.circOut});
        add(ruby);

        storymode = new FlxSprite(30, 20).loadGraphic(Paths.image('menus/mainmenu/play'));
        storymode.antialiasing = ClientPrefs.data.antialiasing;
        add(storymode);

        options = new FlxSprite(20, 345).loadGraphic(Paths.image('menus/mainmenu/options'));
        options.antialiasing = ClientPrefs.data.antialiasing;
        add(options);

        credits = new FlxSprite(845, 5).loadGraphic(Paths.image('menus/mainmenu/credits'));
        credits.antialiasing = ClientPrefs.data.antialiasing;
        add(credits);

        // Initialize mouse position
        prevMouseX = FlxG.mouse.x;
        prevMouseY = FlxG.mouse.y;

        // Initialize background offsets
        backgroundOffsetX = 50;
        backgroundOffsetY = 50;

        super.create();
        CustomFadeTransition.nextCamera = FlxG.cameras.list[FlxG.cameras.list.length - 1];   
    }
    

    override public function update(elapsed:Float):Void {
        super.update(elapsed);

        // Calculate mouse speed based on position changes
        var mouseXSpeed:Float = FlxG.mouse.x - prevMouseX;
        var mouseYSpeed:Float = FlxG.mouse.y - prevMouseY;

        // Adjust background offset based on mouse movement
        backgroundOffsetX += mouseXSpeed * elapsed;
        backgroundOffsetY += mouseYSpeed * elapsed;

        // Update stars position
        ruby.x -= mouseXSpeed * elapsed;
        ruby.y -= mouseYSpeed * elapsed;
      
        gradient.x -= mouseXSpeed * elapsed;
        gradient.y -= mouseYSpeed * elapsed;

        bars.x -= mouseXSpeed * elapsed;
        bars.y -= mouseYSpeed * elapsed;

        // Store current mouse position for the next frame
        prevMouseX = FlxG.mouse.x;
        prevMouseY = FlxG.mouse.y;

        if (FlxG.mouse.overlaps(storymode)) {
            // Fade in smoothly
            FlxTween.tween(storymode, { alpha: 1.0 }, 0.3, { ease: FlxEase.linear });
        } else {
            // Fade out smoothly
            FlxTween.tween(storymode, { alpha: 0.6 }, 0.3, { ease: FlxEase.linear });
        }
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(storymode)) {
            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
            PlayState.storyPlaylist = ['cassettefi'];
            PlayState.isStoryMode = false;
            PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + '-hard', PlayState.storyPlaylist[0].toLowerCase());
            PlayState.campaignScore = 0;
            PlayState.campaignMisses = 0;
            LoadingState.loadAndSwitchState(new PlayState(), true);
            FreeplayState.destroyFreeplayVocals();
            tweenToCenterAndSwitch(storymode, new PlayState());
        }

        if (FlxG.mouse.overlaps(credits)) {
            // Fade in smoothly
            FlxTween.tween(credits, { alpha: 1.0 }, 0.3, { ease: FlxEase.linear });
        } else {
            // Fade out smoothly
            FlxTween.tween(credits, { alpha: 0.6 }, 0.3, { ease: FlxEase.linear });
        }
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(credits)) {
            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
            tweenToCenterAndSwitch(credits, new CreditsState());
        }

        if (FlxG.mouse.overlaps(options)) {
            // Fade in smoothly
            FlxTween.tween(options, { alpha: 1.0 }, 0.3, { ease: FlxEase.linear });
        } else {
            // Fade out smoothly
            FlxTween.tween(options, { alpha: 0.6 }, 0.3, { ease: FlxEase.linear });
        }
        if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(options)) {
            FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
            tweenToCenterAndSwitch(options, new options.OptionsState());
        }

        if (controls.justPressed('debug_1')) {
            MusicBeatState.switchState(new MasterEditorMenu());
            FlxG.mouse.visible = false;
        }

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new TitleState());
            FlxG.mouse.visible = false;
        }
    }

    function tweenToCenterAndSwitch(sprite:FlxSprite, nextState:FlxState):Void {
        // Calculate the center of the screen
        var centerX:Float = (FlxG.width - sprite.width) / 2;
        var centerY:Float = (FlxG.height - sprite.height) / 2;
    
        // Tween the sprite to the center of the screen
        FlxTween.tween(sprite, { x: centerX, y: centerY }, 2.0, {
            ease: FlxEase.quintOut // Use desired easing function
        });
    
        FlxTween.tween(ruby, { y: 800}, 2, {ease: FlxEase.circOut});
        FlxTween.tween(FlxG.camera, { zoom: 2 }, 3, { ease: FlxEase.quartInOut });
        FlxTween.tween(sprite, { alpha: 1.0 }, 0.3, { ease: FlxEase.linear });

        new FlxTimer().start(1, function(tmr:FlxTimer) {
            MusicBeatState.switchState(nextState);
            FlxG.mouse.visible = false;
        });
    }
}
