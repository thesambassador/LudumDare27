package  
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxU;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Enemy extends FlxSprite
	{
		public static var enemiesAlive : int = 0;
		public static var enemiesKilled : int = 0;
		
		public var behavior : Function;
		public var player : Player;
		public var state : String;
		
		public var attackCooldown : Number;
		public var currentCooldown : Number;
		
		public var damp : Number = .95;
		
		public var targetPoint : FlxPoint;
		
		public var lastHit : FlxPoint;
		
		public function Enemy(playerRef : Player) 
		{
			player = playerRef;
			enemiesAlive += 1;
			super();
			mass = 2;
		}
		
		public function fireWeapon(projectile : FlxSprite) {
			(FlxG.state as PlayState).projectiles.add(projectile);
			currentCooldown = attackCooldown;
		}
		
		override public function update() : void{
			super.update();
			
			velocity.x *= damp;
			velocity.y *= damp;
			
			if(behavior != null)
				behavior(this, player);
			
			if (health <= 0) {
				this.kill();
			}
		}
		
		override public function kill() : void {
			if(alive){
				enemiesAlive -= 1;
				enemiesKilled += 1;
				
				var particleSize : int = 4;
				
				var emitter:FlxEmitter = new FlxEmitter(x,y); 
				var particles:int = (this.width / particleSize) * (this.width / particleSize);
				var color :uint = framePixels.getPixel(1, 1);
				
				emitter.setSize(1, 1);
				if (lastHit == null) lastHit = new FlxPoint( -20, 20);
				else {
					lastHit.y *= .2;
					lastHit.x *= .2;
				}
				emitter.setXSpeed(lastHit.x - 50, lastHit.x + 50);
				emitter.setYSpeed(lastHit.y - 50, lastHit.y + 50);
				emitter.lifespan = 1;
				
				for(var i:int = 0; i < particles; i++)
				{
					var particle:FlxParticle = new FlxParticle();
					particle.makeGraphic(particleSize, particleSize, 0xff000000 + color);
					particle.exists = false;
					particle.lifespan = 1;
					emitter.add(particle);
				}
				 
				FlxG.state.add(emitter);
				
				for(var i:int = 0; i < particles; i++)
				{
					emitter.emitParticle();
					emitter.x = x + (i % (width / particleSize)) * particleSize;
					emitter.y = y + int(i / (width / particleSize)) * particleSize;
					
				}

				super.kill();
			}
		}
		
		public function getPlayerVector() : FlxPoint {
			var returned : FlxPoint = new FlxPoint();
			
			returned.x = player.x - this.x;
			returned.y = player.y - this.y;
			
			return returned;
		}
		
		public function moveTowardsPlayer(speed : Number) : void {
			moveTowardsPoint(player.getMidpoint(), speed);
		}	
		public function moveTowardsPoint(point : FlxPoint, speed : Number) : void {
			var distanceVect : FlxPoint = CC.getDistanceVector(getMidpoint(), point);
			distanceVect = CC.normalizeVector(distanceVect);
			distanceVect.x *= speed;
			distanceVect.y *= speed;
			velocity.x = distanceVect.x;
			velocity.y = distanceVect.y;
		}
		
		public function get playerDist() : Number {
			return FlxU.getDistance(getMidpoint(), player.getMidpoint());
		}
		
		public function collidePlayer(player : Player) : void {
			if (player.invuln > 0) {
				this.kill();
			}
			else {
				player.hurt(1);
			}
		}
		
		public function projectileHit(damage : int = 1, velocityVector : FlxPoint = null) {
			health -= damage;// hurt(damage);
			lastHit = velocityVector;
		}
	}

}