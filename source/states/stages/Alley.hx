package states.stages;

import states.stages.objects.*;

class Alley extends BaseStage
{
	var painter:BGSprite;

	override function create()
	{
		var bg:BGSprite = new BGSprite('stages/alley/wall', 0, 0);
		add(bg);

		add(gfGroup);
		add(dadGroup);
		add(boyfriendGroup);

		painter = new BGSprite('painter', -50, 150, ['painter']);
		painter.frames = Paths.getSparrowAtlas('stages/alley/painter');
		painter.animation.addByPrefix('painter', "painter", 24);
		painter.scale.set(1.25, 1.25,);
		painter.updateHitbox();
		add(painter);
	}

	override function beatHit()
	{
		painter.animation.play('painter');
	}

}

