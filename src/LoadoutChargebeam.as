package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class LoadoutChargebeam extends PlayerLoadout
	{
		var bulletVelocity = 1000;
		public function LoadoutChargebeam(player : Player)
		{
			super(player);
			weaponCooldown = 2;
			name = "Beam";
		}
		
		override public function onClick() {
			if(currentCooldown <= 0){
				var cb : Chargebeam = new Chargebeam(playerRef);
				fireWeapon(cb);
				
				
				currentCooldown = weaponCooldown;
			}
		}
		
		
		
	}

}