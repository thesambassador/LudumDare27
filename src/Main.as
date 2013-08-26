package
{
	import org.flixel.*; 
	[SWF(width="800", height="600", backgroundColor="#444444")] //Set the size and color of the Flash file

	public class Main extends FlxGame
	{
		public function Main()
		{
			super(CC.WINDOWWIDTH / CC.WINDOWSCALE, CC.WINDOWHEIGHT / CC.WINDOWSCALE, PlayState, CC.WINDOWSCALE, 60,60); //Create a new FlxGame object and load "PlayState"
			this.forceDebugger = true;
			//this.useSystemCursor = true;
		}
	}
}
