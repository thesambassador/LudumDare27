package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class PlayerLoadout 
	{
		public var playerRef : Player;
		
		public var weaponCooldown : Number = 0;
		public var currentCooldown : Number = 0;
		public var name : String;
		
		public function PlayerLoadout(player : Player) 
		{
			playerRef = player;
		}
		
		public function update() : void{
			if (FlxG.mouse.justPressed()) {
				onClick();
			}
			if (FlxG.mouse.pressed()) {
				onMouseDown();
			}
			currentCooldown -= FlxG.elapsed;
		}
		
		public function onClick() {
			
		}
		
		public function onMouseDown() {
			
		}
		
		public function fireWeapon(projectile : FlxSprite, sound : Class = null ) {
			(FlxG.state as PlayState).projectiles.add(projectile);
			if (sound != null) {
				FlxG.play(sound);
			}
		}
		
		//gets the vector from the player and the mouse
		public function getMouseAngle() : Number {
			return FlxU.getAngle(new FlxPoint(playerRef.x, playerRef.y), new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY));
		}
		
		public function getMouseVector() : FlxPoint {
			var center : FlxPoint = playerRef.getMidpoint();
			return new FlxPoint(FlxG.mouse.screenX - center.x, FlxG.mouse.screenY - center.y);
		}
		
	}

}