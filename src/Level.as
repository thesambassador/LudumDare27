package  
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxTilemap;
	import org.flixel.system.FlxTilemapBuffer;
	import org.flixel.FlxCamera;
	import org.flixel.FlxG;
	
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Sam Tregillus
	 */
	public class Level extends FlxTilemap
	{
		[Embed(source = '../resources/autotiles.png')]private static var autotiles:Class;
		
		private var glowStrengthMax : int = 5;
		private var glowStrengthMin : int = 0;
		private var glowStrengthDelta : Number = .1;
		private var glowStrength : Number = glowStrengthMin;
		
		public var fadeLevel : int = 1;
		private var fadeDelay : Number = .2;
		
		private var fadingOut : Boolean = false;
		private var fadingIn : Boolean = false;
		
		public var fadeOutSprite : FlxSprite;
		
		public function Level(layout : Array = null)
		{
			if (layout == null) layout = LAYOUT_CENTER;
			super();
			
			x = -5;
			x = -5;
			
			loadMap(arrayToCSV(layout, 16), autotiles, 50, 50);
			
			FlxG.watch(this, "fadeLevel", "Fade Level");
		}
		
		//fade out over 5 seconds
		public function fadeOut() {
			fadeOutSprite = new FlxSprite(0,0);
			fadeOutSprite.makeGraphic(this.width, this.height, 0xffffffff);
			var buffer : FlxTilemapBuffer = new FlxTilemapBuffer(_tileWidth,_tileHeight,widthInTiles,heightInTiles,FlxG.camera);
			drawTilemap(buffer, FlxG.camera);
			fadeOutSprite.pixels = buffer.pixels;
			fadeOutSprite.alpha = 1;
			fadingOut = true;
		}
		public function fadeIn() {
			fadeOutSprite = new FlxSprite(0,0);
			fadeOutSprite.makeGraphic(this.width, this.height, 0xffffffff);
			var buffer : FlxTilemapBuffer = new FlxTilemapBuffer(_tileWidth,_tileHeight,widthInTiles,heightInTiles,FlxG.camera);
			drawTilemap(buffer, FlxG.camera);
			fadeOutSprite.pixels = buffer.pixels;
			fadeOutSprite.alpha = .2;
			fadingIn = true;
			fadeDelay = 2;
		}

		
		private function MakeEmptySectionString(width:int, height:int) : String {
			var data : Array = new Array();
			
			for (var i:int = 0; i < width * height; i++) {
				data.push("0");
			}
			return FlxTilemap.arrayToCSV(data, width);
		}
		
		override public function update() : void { 
			super.update();
			
			glowStrength += glowStrengthDelta
			
			if (glowStrength > glowStrengthMax || glowStrength < glowStrengthMin ) {
				glowStrengthDelta *= -1;
			}
			
			if (fadingOut && fadeOutSprite.alpha > 0) {
				fadeDelay -= FlxG.elapsed;
				if (fadeDelay < 0) {
					fadeOutSprite.alpha -= .005;
				}
			}
			else {
				fadingOut = false;
			}
			
			if (fadingIn && fadeOutSprite.alpha < 1) {
				fadeDelay -= FlxG.elapsed;
				if (fadeDelay < 0) {
					fadeOutSprite.alpha += .01;
				}
			}
			else {
				fadingIn = false;
			}
			
			
		}
		
		override public function draw() : void {
			if (fadingOut || fadingIn) {
				if (fadeOutSprite != null) {
					fadeOutSprite.draw();
				}
			}
			else{
				super.draw();
			}
			
			
		}
		
		public function setAllTiles(toTile : int) {
			var tiles : Array = getTileInstances(fadeLevel);
			for each(var tile : uint in tiles) {
				setTileByIndex(tile, toTile);
			}
			fadeLevel = toTile;
		}
		
		public function applyFilter() : void {
			
			var filter:GlowFilter = new GlowFilter();
				
			filter.color = 0xFF004A7F;
			filter.blurX = 10;
			filter.blurY = 10;
			filter.strength = glowStrength;
			
			
			for (var i:int = 0; i < _buffers.length; i ++)
			{
				if (_buffers[i] != null)
				{
					_buffers[i].pixels.applyFilter(_buffers[i].pixels, _buffers[i].pixels.generateFilterRect(_buffers[i].pixels.rect, filter), new Point(0,0), filter);
				}
			}
		}
		
		override protected function drawTilemap(Buffer:FlxTilemapBuffer, Camera:FlxCamera):void
		{
			super.drawTilemap(Buffer, Camera);
			
			
			applyFilter();
		}
		
		public static function getRandomLayout() : Array {
			var potential : Array = new Array(LAYOUT_CENTER, LAYOUT_DIAMOND, LAYOUT_ROOMS, LAYOUT_COVER, LAYOUT_STUFF);
			return FlxG.getRandom(potential) as Array;
		}
		
		public static var LAYOUT_CENTER : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			 
		public static var LAYOUT_BLANK : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			 
		public static var LAYOUT_ROOMS : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
			 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			 
		public static var LAYOUT_DIAMOND : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
			 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
			 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1,
			 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1,
			 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1,
			 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1,
			 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1,
			 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
		public static var LAYOUT_COVER : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
			 
		public static var LAYOUT_STUFF : Array = new Array(
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1,
			 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1,
			 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1,
			 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1,
			 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1,
			 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
			 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1);
	}

}