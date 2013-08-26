package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxU;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class EnemyFactory 
	{
		public var entities : FlxGroup;
		public var projectiles : FlxGroup;
		public var player : Player;
		public var level : Level;
		
		public function EnemyFactory(playerRef : Player, entitygroup : FlxGroup, levelRef : Level, projectileRef : FlxGroup) 
		{
			player = playerRef;
			entities = entitygroup;
			level = levelRef;
			projectiles = projectileRef;
		}
		
		public function addRandomEnemy(time : Number = 0,  x:int = -1, y:int = -1) {
			var potentialFunctions : Array = new Array(addZombie);
			
			if (time > 15) {
				potentialFunctions.push(addShooter);
			}
			if(time > 25)
				potentialFunctions.push(addCharger);
			
			var toUse : Function = FlxG.getRandom(potentialFunctions) as Function;
			toUse(x, y);
			
		}
		
		public function addZombie(x:int = -1, y:int = -1, number : int = 1) : void {
			if (number > 0) {
				var added : Enemy = new Enemy(player);
				added.health = 4;
				added.makeGraphic(20, 20, 0xff00ff00);
				added.behavior = ZombieBehavior;
				
				var point : FlxPoint = new FlxPoint(x, y);
				
				if (x == -1 && y == -1) {
					point = findValidSpawnLocation();
				}
				
				added.x = point.x;
				added.y = point.y;
				
				entities.add(added);
				//addZombie(-1,-1,number-1)
			}
		}
		
		public function addShooter(x:int = -1, y:int = -1) : void{
			var added : Enemy = new Enemy(player);
			added.health = 3;
			added.makeGraphic(20, 20, 0xff0000ff);
			added.behavior = ShooterBehavior;
			added.attackCooldown = .75;
			added.currentCooldown = .75;
			
			var point : FlxPoint = new FlxPoint(x, y);
			
			if (x == -1 && y == -1) {
				point = findValidSpawnLocation();
			}
			
			added.x = point.x;
			added.y = point.y;
			
			entities.add(added);
		}
		
		public function addCharger(x:int = -1, y:int = -1) : void{
			var added : Enemy = new Enemy(player);
			added.health = 5;
			added.makeGraphic(20, 20, 0xffff0000);
			added.behavior = ChargerBehavior;
			added.attackCooldown = .5;
			added.currentCooldown = .5;
			added.state = "seeking";
			
			var point : FlxPoint = new FlxPoint(x, y);
			
			if (x == -1 && y == -1) {
				point = findValidSpawnLocation();
			}
			
			added.x = point.x;
			added.y = point.y;
			
			entities.add(added);
		}
		
		public function findValidSpawnLocation(playerDist : int = 200) : FlxPoint {
			var point : FlxPoint = randomPoint();
			while (FlxU.getDistance(point, player.getMidpoint()) < playerDist && !level.overlapsPoint(point)) {
				point = randomPoint();
			}
			return point;
		}
		
		public function randomPoint() : FlxPoint {
			var point : FlxPoint = new FlxPoint();
			
			point.x = CC.getRandom(100, CC.WINDOWWIDTH - 100);
			point.y = CC.getRandom(100, CC.WINDOWHEIGHT - 100);
			return point;
		}
		
		public static function ZombieBehavior(enemy : Enemy, player : Player) {
			var speed : Number = 100;
			enemy.moveTowardsPlayer(speed);
			enemy.angle = FlxU.getAngle(enemy.getMidpoint(), player.getMidpoint());
		}
		
		public static function ShooterBehavior(enemy : Enemy, player : Player) {
			enemy.currentCooldown -= FlxG.elapsed;
			enemy.angle = FlxU.getAngle(enemy.getMidpoint(), player.getMidpoint());
			var speed : Number = 150;
			
			if (enemy.playerDist > 200) {
				enemy.moveTowardsPlayer(speed);
			}
			else if (enemy.playerDist < 100) {
				enemy.moveTowardsPlayer(-.5 * speed);
			}
			else {
				if (enemy.currentCooldown <= 0) {
					var bulletSpeed : int = 300;
					
					enemy.currentCooldown = enemy.attackCooldown;
					var bullet : Projectile = new Projectile();
					bullet.damage = 1;
					bullet.fromPlayer = false;
					
					var center : FlxPoint = enemy.getMidpoint();
					bullet.x = center.x;
					bullet.y = center.y;
					
					var velVector : FlxPoint = enemy.getPlayerVector();
					velVector = CC.normalizeVector(velVector);
					velVector.x *= bulletSpeed;
					velVector.y *= bulletSpeed;
					
					bullet.velocity.x = velVector.x;
					bullet.velocity.y = velVector.y;
					
					FlxG.play(Resources.sounds["pistol"]);
					enemy.fireWeapon(bullet);
				}
			}
			
			
		}
		
		public static function ChargerBehavior(enemy : Enemy, player : Player) {
			var speed : Number = 150;
			var chargeDist : Number = 150;
			
			if (enemy.state == "seeking") {
				enemy.angle = FlxU.getAngle(enemy.getMidpoint(), player.getMidpoint());
				if (enemy.playerDist < chargeDist) {
					enemy.targetPoint = player.getMidpoint();
					enemy.state = "charging";
				}	
				else {
					enemy.targetPoint = null;
					enemy.currentCooldown = enemy.attackCooldown;	
					enemy.moveTowardsPlayer(100);
				}
			}
			else if (enemy.state == "charging") {
				enemy.angle = FlxU.getAngle(enemy.getMidpoint(), enemy.targetPoint);
				enemy.currentCooldown -= FlxG.elapsed;
				if (FlxU.getDistance(enemy.getMidpoint(), enemy.targetPoint) < 50) {
					enemy.state = "pausing";
					enemy.currentCooldown = 2 * enemy.attackCooldown;
				}
				else if (enemy.currentCooldown <= 0) {
					enemy.moveTowardsPoint(enemy.targetPoint, speed * 3);
				}
			}
			else if (enemy.state = "pausing") {
				enemy.currentCooldown -= FlxG.elapsed;
				if (enemy.currentCooldown <= 0) {
					enemy.state = "seeking";
					enemy.currentCooldown = enemy.attackCooldown;
				}
			}
			
			
			
		}
	}
}