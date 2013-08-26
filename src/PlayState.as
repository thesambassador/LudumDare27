package
{

	import adobe.utils.CustomActions;
	import flash.errors.InvalidSWFError;
	import org.flixel.*;
	import org.flixel.system.FlxDebugger;

	public class PlayState extends FlxState {
		
		public var player : Player;
		public var entities : FlxGroup;
		public var projectiles : FlxGroup;
		public var level : Level;
		public var newLevel : Level;
		
		public var totalTime : Number = 0;
		
		public var levelTimer : Number = 10;
		public var levelTimerText : FlxText;
		
		public var scoreCountText : FlxText;
		
		public var loadoutText : FlxText;
		
		public var nextLevel : Number = 30;
		public var nextLevelDelay : Number = 30;
		
		public var enemyFactory : EnemyFactory;
		
		public var addEnemyDelay : Number = 2;
		public var addEnemyCurrent : Number = addEnemyDelay;
		
		public var loadouts : Array;
		
		public var levelState : String = "game";
		
		public var maxEnemies : int = 6;
		public var minEnemies : int = 3;
		
		public var totalEnemies : int = 0;
		
		
		public function PlayState() {
			super();

		}
		
		override public function create() : void {
			Resources.init();
			
			loadouts = new Array();
			//FlxG.bgColor = FlxG.WHITE;
			FlxG.mouse.show();
			//FlxG.visualDebug = true;
			
			entities = new FlxGroup();
			projectiles = new FlxGroup();
			
			player = new Player(200, 100);
			entities.add(player);
			
			level = new Level();

			add(entities);
			add(projectiles);
			add(level);
			
			loadoutText = new FlxText(0, CC.WINDOWHEIGHT - 40, CC.WINDOWWIDTH, "Pistol");
			loadoutText.alignment = "center";
			loadoutText.size = 20;
			add(loadoutText);
			
			levelTimerText = new FlxText(0, CC.WINDOWHEIGHT / 2 - 10, CC.WINDOWWIDTH, "10.00");
			levelTimerText.alignment = "center";
			levelTimerText.size = 20;
			add(levelTimerText);
			
			scoreCountText = new FlxText(0, 15, CC.WINDOWWIDTH, "0");
			scoreCountText.alignment = "center";
			scoreCountText.size = 20;
			add(scoreCountText);
			
			enemyFactory = new EnemyFactory(player, entities, level, projectiles);
			enemyFactory.addZombie(300, 200);
			
			FlxG.watch(this, "totalEnemies", "Enemies");
		}
		
		override public function update() : void {
			totalEnemies = Enemy.enemiesAlive;
			totalTime += FlxG.elapsed;
			
			
			if (!player.alive && levelState == "game") {
					levelTimerText.text = "Game Over";
					levelTimerText.size = 50;
					levelTimerText.y -= 20;
					levelState = "gameover";
					
					var text : FlxText = new FlxText(0, levelTimerText.y + 70, CC.WINDOWWIDTH, "Press R to restart");
					text.size = 20;
					text.alignment = "center";
					add(text)
			}
				
			if (levelState == "game") {
				
				if (newLevel != null) {
					if (level.fadeOutSprite.alpha <= 0) {
						var oldLevel : Level = level;
						this.remove(newLevel);
						this.replace(level, newLevel);
						
						level = newLevel;
						
						FlxG.overlap(level, entities, killUnder);
					}
				}
				
				
				if (FlxG.keys.justPressed("F")) {
					transitionLevel();
				}
				
				FlxG.collide(entities, level);
				FlxG.collide(projectiles, level, collision);
				FlxG.overlap(projectiles, entities, collision);
				FlxG.collide(entities, entities, collision);
				
				addEnemyCurrent -= FlxG.elapsed;
				if (addEnemyCurrent <= 0 && Enemy.enemiesAlive <= maxEnemies) {
					do {
						enemyFactory.addRandomEnemy(totalTime);
					}
					while (Enemy.enemiesAlive < minEnemies);
						
					addEnemyCurrent = addEnemyDelay;
					addEnemyDelay -= .1;
					if (addEnemyDelay < 1) {
						addEnemyDelay = 1;
					}
				}
				
				levelTimer -= FlxG.elapsed;
				levelTimerText.text = levelTimer.toPrecision(2);
				if (levelTimer < 0) {
					levelTimer = 10;
					maxEnemies += 2;

					changeLoadout();
				}
				
				if (totalTime > nextLevel) {
					minEnemies += 2;
					nextLevel += nextLevelDelay;
					transitionLevel();
				}
				
				scoreCountText.text = Enemy.enemiesKilled.toString();
			}
			else if (levelState == "gameover") {
				if (FlxG.keys["R"]) {
					Enemy.enemiesKilled = 0;
					Enemy.enemiesAlive = 0;
					FlxG.resetState();
				}
			}
							
			super.update();
		}
		
		public function changeLoadout() : void {
			if(loadouts.length == 0){
				loadouts.push(new LoadoutChargebeam(player));
				loadouts.push(new LoadoutMines(player));
				//loadouts.push(new LoadoutMelee(player));
				loadouts.push(new LoadoutRocket(player));
				loadouts.push(new LoadoutShockwave(player));
				loadouts.push(new LoadoutMachinegun(player));
				loadouts.push(new LoadoutPistol(player));
				loadouts.push(new LoadoutShotgun(player));
			}
			player.loadout = FlxG.getRandom(loadouts) as PlayerLoadout;
			setLoadoutText(player.loadout.name);
			var soundname : String = "loadout_" + player.loadout.name.toLowerCase();
			if (Resources.sounds[soundname] != null) {
				FlxG.play(Resources.sounds[soundname]);
			}
		}
		
		public function transitionLevel() : void {
			newLevel = new Level(Level.getRandomLayout());
			add(newLevel);
			newLevel.fadeIn();
			level.fadeOut();
			
		}
		
		public function killUnder(a:FlxObject, b:FlxObject) {
			if (a is FlxTilemap) {
				if ((a as FlxTilemap).overlaps(b)) {
					b.kill();
				}
			}
		}
		
		public function setLoadoutText(name : String) : void {
			loadoutText.text = name;
		}
		
		public function collision(a : FlxObject, b : FlxObject) {
			if (a is Projectile) {
				if(b is FlxTilemap){
					(a as Projectile).collideWall(b as FlxTilemap);
				}
				else if (b is Player) {
					var proj : Projectile = a as Projectile;
					if (!proj.fromPlayer) {
						proj.collidePlayer(b as Player);
					}
				}
				else if (b is Enemy) {
					var proj : Projectile = a as Projectile;
					proj.collideEnemy(b as Enemy);
				}
			}
			else if (a is Enemy) {
				if (b is Player) {
					(a as Enemy).collidePlayer(b as Player);
				}
			}
			else if (a is Player) {
				if (b is Enemy) {
					(b as Enemy).collidePlayer(a as Player);
				}
			}
			
		}
		
		
	}

}