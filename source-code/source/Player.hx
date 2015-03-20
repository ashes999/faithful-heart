package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.FlxG;

class Player extends FlxSprite
{

	public var speed:Float = 0;

	public function new(x:Float=0, y:Float=0)
	{
		super(x, y);
		// Load player stats from JSON
		var data = haxe.Json.parse(openfl.Assets.getText('assets/data/test.json'));
		var cWidth = Std.parseInt(data.character.width);
		var cHeight = Std.parseInt(data.character.height);
		var fps = Std.parseInt(data.character.fps);
		this.speed = Std.parseInt(data.character.speed);
		trace("Character is " + cWidth + "x" + cHeight);

		loadGraphic("assets/images/player.png", true, cWidth, cHeight);
		// allow auto-flipping
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);
		//animation.add("d", [0, 1, 0, 2], fps, false);
		animation.add("lr", [0, 1, 2, 3], fps, false);
		//animation.add("u", [6, 7, 6, 8], fps, false);
	}

	override public function draw():Void
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
			switch(facing)
			{
				case FlxObject.LEFT, FlxObject.RIGHT:
					animation.play("lr");

				case FlxObject.UP:
					//animation.play("u");

				case FlxObject.DOWN:
					//animation.play("d");
			}
		}

		super.draw();
	}

	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		_up = FlxG.keys.anyPressed(["UP", "W"]);
		_down = FlxG.keys.anyPressed(["DOWN", "S"]);
		_left = FlxG.keys.anyPressed(["LEFT", "A"]);
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]);

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		if ( _up || _down || _left || _right)
		{
			var mA:Float = 0;
			if (_up)
			{
				mA = -90;
				if (_left)
					mA -= 45;
				else if (_right)
					mA += 45;

				facing = FlxObject.UP;
			}
			else if (_down)
			{
				mA = 90;
				if (_left)
					mA += 45;
				else if (_right)
					mA -= 45;

				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				mA = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				mA = 0;
				facing = FlxObject.RIGHT;
			}

			FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity);
		}
	}

	override public function update():Void
	{
		movement();
		super.update();
	}

}
