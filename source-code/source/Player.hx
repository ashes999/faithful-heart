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
import flixel.util.FlxPoint;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.input.gamepad.OUYAButtonID;
import flixel.input.gamepad.OUYAButtonID;

class Player extends FlxSprite
{

	public var speed:Float = 0;
	private static var ZERO_VELOCITY:FlxPoint = new FlxPoint(0, 0);

	// TODO: replace with ECS
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
		//animation.add("d", [0, 1, 0, 2], fps, true);
		animation.add("lr", [0, 1, 2, 3], fps, true);
		//animation.add("u", [6, 7, 6, 8], fps, true);
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

	public function move():Void
	{
		var gamePad = FlxG.gamepads.lastActive;
		var gamePadX:Float = 0;
		var gamePadY:Float = 0;

		if (gamePad == null)
		{
			#if (OUYA)
				// TODO: freeze/notify that the gamepad is off.
				return;
			#end
		} else {
			// TODO: turns into LEFT_ANALOG_STICK
			var xAxisValue = gamePad.getXAxis(OUYAButtonID.LEFT_ANALOGUE_X);
			var yAxisValue = gamePad.getYAxis(OUYAButtonID.LEFT_ANALOGUE_Y);
      var angle:Float;

      if (xAxisValue != 0 || yAxisValue != 0)
			{
				angle = Math.atan2(yAxisValue, xAxisValue);
				gamePadX = Math.cos(angle);
				gamePadY = Math.sin(angle);
			}
		}

		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;

		_up = FlxG.keys.anyPressed(["UP", "W"]) || gamePadY < 0;
		_down = FlxG.keys.anyPressed(["DOWN", "S"]) || gamePadY > 0;
		_left = FlxG.keys.anyPressed(["LEFT", "A"]) || gamePadX < 0;
		_right = FlxG.keys.anyPressed(["RIGHT", "D"]) || gamePadX > 0;

		if (_up && _down)
			_up = _down = false;
		if (_left && _right)
			_left = _right = false;

		var mA:Float = 0; // our temporary angle
		if (_up)  // the player is pressing UP
		{
		    mA = -90; // set our angle to -90 (12 o'clock)
		    if (_left)
		        mA -= 45; // if the player is also pressing LEFT, subtract 45 degrees from our angle - we're moving up and left
		    else if (_right)
		        mA += 45; // similarly, if the player is pressing RIGHT, add 45 degrees (up and right)
		    facing = FlxObject.UP; // the sprite should be facing UP
		}
		else if (_down) // the player is pressing DOWN
		{
		    mA = 90; // set our angle to 90 (6 o'clock)
		    if (_left)
		        mA += 45; // add 45 degrees if the player is also pressing LEFT
		    else if (_right)
		        mA -= 45; // or subtract 45 if they are pressing RIGHT
		    facing = FlxObject.DOWN; // the sprite is facing DOWN
		}
		else if (_left) // if the player is not pressing UP or DOWN, but they are pressing LEFT
		{
		    mA = 180; // set our angle to 180 (9 o'clock)
		    facing = FlxObject.LEFT; // the sprite should be facing LEFT
		}
		else if (_right) // the player is not pressing UP, DOWN, or LEFT, and they ARE pressing RIGHT
		{
		    mA = 0; // set our angle to 0 (3 o'clock)
		    facing = FlxObject.RIGHT; // set the sprite's facing to RIGHT
		}
		FlxAngle.rotatePoint(speed, 0, 0, 0, mA, velocity); // determine our velocity based on angle and speed
		if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE) // if the player is moving (velocity is not 0 for either axis), we need to change the animation to match their facing
		{
		    switch(facing)
		    {
		        case FlxObject.LEFT, FlxObject.RIGHT:
		            animation.play("lr");
		        case FlxObject.UP:
		            animation.play("u");
		        case FlxObject.DOWN:
		            animation.play("d");
		    }
		}

		if (!_up && !_down && !_right && !_left) {
				// don't move if no keys are down
				FlxAngle.rotatePoint(0, 0, 0, 0, 0, velocity);
				if (this.animation.curAnim != null) {
					this.animation.curAnim.curFrame = 0;
					this.animation.curAnim.stop();
				}
		}
	}


	override public function update():Void
	{
		move();
		super.update();
	}

}
