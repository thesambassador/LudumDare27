package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutMelee extends PlayerLoadout
	{
		var bulletVelocity : int = 1000;
		var pelletCount : int = 6;
		
		var increasedVelocity : int = 500;
		var originalVelocity : int = 300;
		
		public function LoadoutMelee(player : Player)
		{
			super(player);
			weaponCooldown = 3;
			name = "Sawblade";
		}
		
		override public function update() : void
		{
			super.update();
			if (currentCooldown <= 1) {
				playerRef.maxVelocity.x = originalVelocity;
				playerRef.maxVelocity.y = originalVelocity;
			}
		}
		
		override public function onClick() {
			if (currentCooldown <= 0) {
				playerRef.invuln = 2;
				playerRef.maxVelocity.x = increasedVelocity;
				playerRef.maxVelocity.y = increasedVelocity;
				currentCooldown = weaponCooldown;
			}
		}
		
		
		
	}

}