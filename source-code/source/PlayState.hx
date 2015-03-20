package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.FlxObject;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	/**
	 * Function that is called up when to state is created to set it up.
	 */

	var player:Player;

	override public function create():Void
	{
		super.create();

		var grass = addSprite('assets/images/grass-tile.png');
		var tilesWide:Int = Math.ceil(FlxG.width / grass.width);
		var tilesHigh:Int = Math.ceil(FlxG.height / grass.height);
		trace("Game is " + FlxG.width + "x" + FlxG.height);
		trace("Tiles are " + grass.width + "x" + grass.height);
		trace("Map is " + tilesWide + "x" + tilesHigh + " tiles.");

		// Assume they're the same size. #derp?
		for (y in 0 ... tilesHigh) {
			for (x in 0 ... tilesWide) {
				var fileName = (x == 0 || y == 0 || x == tilesWide - 1 || y == tilesHigh - 1) ?
					'assets/images/wall-tile.png' : 'assets/images/grass-tile.png';
				var s = addSprite(fileName);
				s.x = x * grass.width;
				s.y = y * grass.height;
			}
		}

		add(new Player(200, 100));		
	}

	/**
	 * Function that is called when this state is destroyed - you might want to
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}

	public function addSprite(fileName:String) : FlxSprite
	{
		var s = new FlxSprite();
		s.loadGraphic(fileName);
		add(s);
		return s;
	}
}
