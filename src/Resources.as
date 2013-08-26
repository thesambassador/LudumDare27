package  
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Resources 
	{
		[Embed(source = '../resources/sound/loadout_beam.mp3')]private static var loadoutBeam:Class;
		[Embed(source = '../resources/sound/loadout_mine.mp3')]private static var loadoutMine:Class;
		[Embed(source = '../resources/sound/loadout_pistol.mp3')]private static var loadoutPistol:Class;
		[Embed(source = '../resources/sound/loadout_repeater.mp3')]private static var loadoutRepeater:Class;
		[Embed(source = '../resources/sound/loadout_rocket.mp3')]private static var loadoutRocket:Class;
		[Embed(source = '../resources/sound/loadout_sawblade.mp3')]private static var loadoutSawblade:Class;
		[Embed(source = '../resources/sound/loadout_shockwave.mp3')]private static var loadoutShockwave:Class;
		[Embed(source = '../resources/sound/loadout_shotgun.mp3')]private static var loadoutShotgun:Class;
		
		[Embed(source = '../resources/sound/explosion.mp3')]private static var explosion:Class;
		[Embed(source = '../resources/sound/mine.mp3')]private static var mine:Class;
		[Embed(source = '../resources/sound/pistol.mp3')]private static var pistol:Class;
		[Embed(source = '../resources/sound/repeater.mp3')]private static var repeater:Class;
		[Embed(source = '../resources/sound/rocket.mp3')]private static var rocket:Class;
		[Embed(source = '../resources/sound/shotgun.mp3')]private static var shotgun:Class;
		[Embed(source = '../resources/sound/laserCharge.mp3')]private static var laserCharge:Class;
		[Embed(source = '../resources/sound/laserShoot.mp3')]private static var laserShoot:Class;
		
		public static var sounds : Dictionary;
		
		public function Resources() 
		{
			
		}
		
		public static function init() {
			sounds = new Dictionary();
			
			Resources.sounds = new Dictionary();
			
			Resources.sounds["loadout_beam"] = loadoutBeam;
			Resources.sounds["loadout_mine"] = loadoutMine;
			Resources.sounds["loadout_pistol"] = loadoutPistol;
			Resources.sounds["loadout_repeater"] = loadoutRepeater;
			Resources.sounds["loadout_rocket"] = loadoutRocket;
			Resources.sounds["loadout_sawblade"] = loadoutSawblade;
			Resources.sounds["loadout_shockwave"] = loadoutShockwave;
			Resources.sounds["loadout_shotgun"] = loadoutShotgun;
			
			Resources.sounds["explosion"] = explosion;
			Resources.sounds["mine"] = mine;
			Resources.sounds["pistol"] = pistol;
			Resources.sounds["rocket"] = rocket;
			Resources.sounds["repeater"] = repeater;
			Resources.sounds["shotgun"] = shotgun;
			Resources.sounds["laserCharge"] = laserCharge;
			Resources.sounds["laserShoot"] = laserShoot;
			
			
		}
		
	}

}