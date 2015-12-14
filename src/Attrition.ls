package
{
	import loom.Application;
	import loom.gameframework.TimeManager;
	import loom.sound.Sound;
	import loom2d.display.StageScaleMode;
	import loom2d.display.Image;
	import loom2d.textures.Texture;
	import loom2d.textures.TextureSmoothing;
	import loom2d.ui.SimpleLabel;
	import loom2d.events.Touch;
	import loom2d.events.TouchEvent;
	import loom2d.events.TouchPhase;
	import loom.sound.SimpleAudioEngine;
	import loom2d.events.KeyboardEvent;
	import loom.platform.LoomKey;
	import system.platform.Platform;

	public class Attrition extends Application
	{
		private var environment:Environment;

		[Inject]
		private var time:TimeManager;

		private var audio:SimpleAudioEngine;

		private var music:Vector.<String> = new Vector.<String>
		[
			"assets/music/dark-shrine.ogg",
			"assets/music/meditation.ogg",
			"assets/music/this-used-to-be-a-city.ogg",
		];

		var musicIndex = 0;
		var skipMusic = false;

		override public function run():void
		{
			stage.scaleMode = StageScaleMode.LETTERBOX;

			environment = new Environment(stage);
			audio = SimpleAudioEngine.sharedEngine();


			for each (var i in music)
				audio.preloadBackgroundMusic(i);

			audio.playBackgroundMusic(music[musicIndex], false);

			stage.addEventListener(TouchEvent.TOUCH, touchEvent);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardEvent);
		}

		var lastTickTime = 0;

		override public function onTick()
		{
			var t = Platform.getTime();
			var dt = t - lastTickTime;
			lastTickTime = t;

			environment.tick(dt / 1000);
			if (!audio.isBackgroundMusicPlaying() || skipMusic)
			{
				musicIndex++;
				musicIndex = musicIndex % music.length;
				audio.playBackgroundMusic(music[musicIndex], false);
				skipMusic = false;
			}

			return super.onTick();
		}

		override public function onFrame()
		{
			environment.render();
			return super.onFrame();
		}

		private function keyboardEvent(e:KeyboardEvent)
		{
			if (e.keyCode == LoomKey.F12)
			{
				skipMusic = true;
			}
		}

		private function touchEvent(e:TouchEvent)
		{
			if (environment.gameOver)
			{
				stage.removeChildren(0, stage.numChildren -1, true);
				environment = new Environment(stage);
				skipMusic = true;
				return;
			}

			var touch:Touch = e.getTouch(stage, TouchPhase.ENDED);
			if (touch == null)
				touch = e.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				if (environment.isTargeting())
				{
					trace("brodcasting touch to map");
					Environment.instance().iso.touchable = true;
					Environment.instance().iso.broadcastEvent(new TouchEvent(e.type, e.touches, e.shiftKey, e.ctrlKey, false));
					Environment.instance().iso.touchable = false;
				}
			}
		}
	}
}