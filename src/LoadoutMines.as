package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutMines extends PlayerLoadout
	{
		var bulletVelocity = 1000;
		public function LoadoutMines(player : Player)
		{
			super(player);
			weaponCooldown = 1;
			name = "Mine";
		}
		
		override public function onClick() {
			if(currentCooldown <= 0){
				var mine : Mine = new Mine(playerRef.getMidpoint());
				mine.fromPlayer = true;
				fireWeapon(mine, Resources.sounds['mine']);
				currentCooldown = weaponCooldown;
			}
		}
		
		
		
	}

}