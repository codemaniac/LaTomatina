package com.codemaniac.latomatina.logic
{
	import com.codemaniac.latomatina.util.Loader2D;
	import com.codemaniac.latomatina.util.Timeout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import mx.core.FlexGlobals;
	
	import org.as3wavsound.WavSound;
	
	public class LaTomatinaManager extends Sprite
	{
		private static var instance:LaTomatinaManager;
		
		public static function getInstance():LaTomatinaManager
		{
			if (instance == null)
				instance = new LaTomatinaManager();
			return instance;
		}
		
		private static const MIN_BASE_DELAY:Number = 250;
		private static const BASE_DELAY_RANGE:Number = 500;
		private static const MIN_DELAY_RANGE:Number = 250;
		private static const DELAY_RANGE_RANGE:Number = 1000;
		
		private var tomatoes:Vector.<Tomato>;
		private var nextTomatoTimeout:Timeout;
		private var score:Number = 0;		
		private var throwSoundEffect:WavSound;
		private var splatSounds:Vector.<WavSound>;
		
		public var hit:Number = 0;
		
		private const g:Number = 50;	
						
		public function LaTomatinaManager()
		{
			var splatSound1:WavSound = new WavSound(new LaTomatinaMedia.SplatSound1() as ByteArray);
			var splatSound2:WavSound = new WavSound(new LaTomatinaMedia.SplatSound2() as ByteArray);			
			var splatSound3:WavSound = new WavSound(new LaTomatinaMedia.SplatSound3() as ByteArray);
			var splatSound4:WavSound = new WavSound(new LaTomatinaMedia.SplatSound4() as ByteArray);
			splatSounds = new Vector.<WavSound>();
			splatSounds.push(splatSound1, splatSound2, splatSound3, splatSound4);
			
			throwSoundEffect = new WavSound(new LaTomatinaMedia.ThrowSound() as ByteArray);
			
			tomatoes = new Vector.<Tomato>();
			makeNewTomato();
		}
				
		public function update(headPosition:Point):void
		{
			if (!tomatoes.length) { return; }
			var i:uint = tomatoes.length;
			var tomato:Tomato;
			while (i--) 
			{
				tomato = tomatoes[i];
				doTomatoTrajectory(tomato);
				checkForCollision(tomato, headPosition);
			}
		}
		
		private function doTomatoTrajectory(tomato:Tomato):void
		{
			tomato.x += (tomato.orientation)*5;
			tomato.y = tomato.position.y - 
				((Math.abs(tomato.x - tomato.position.x) * Math.tan(tomato.theta)) - 
					((g * Math.pow(Math.abs(tomato.x - tomato.position.x), 2)) / 
						(2 * Math.pow(tomato.v * Math.cos(tomato.theta), 2))));
			tomato.z += 5;
						
			if(tomato.z >= 300 || tomato.y > 600 || tomato.y < 0 || tomato.x < 0 || tomato.x > 800)
				tomato.dispatchEvent(new Event(Tomato.TOMATO_AVOIDED));
		}
				
		private function makeNewTomato():void 
		{
			createTomato();
			throwSoundEffect.play(0,0);
			nextTomatoTimeout = new Timeout(makeNewTomato, calcNextTomatoDelay());
		}
		
		private function createTomato() :void 
		{
			var posChoice:uint = Math.floor(Math.random() * 4);
			var position:Point = new Point();
			var orientation:Number;
			switch (posChoice) 
			{
				case 0 :
					position.x = 0;
					orientation = Tomato.TOMATO_ORIENTATION_RIGHT;
					break;
				case 1:
					position.x = 200;
					orientation = Tomato.TOMATO_ORIENTATION_RIGHT;
					break;
				case 2:
					position.x = 600;
					orientation = Tomato.TOMATO_ORIENTATION_LEFT;
					break;
				case 3:
					position.x = 800;
					orientation = Tomato.TOMATO_ORIENTATION_LEFT;
					break;
			}
			
			position.y = 600;
			
			var angleChoice:uint = Math.floor(Math.random() * 2);			
			var angle:Number = 0;
			switch(angleChoice) 
			{
				case 0:
					angle = 45;
					break;
				case 1:
					angle = -30;
					break;
			}
			
			var velChoice:uint = Math.floor(Math.random() * 4);
			var velocity:Number = 0;
			switch(velChoice)
			{
				case 0:
					velocity = 250;
					break;
				case 1:
					velocity = 175;
					break;
				case 2:
					velocity = 200;
					break;
				case 3:
					velocity = 225;
					break;
			}
			
			var tomato:Tomato = new Tomato(position, angle, velocity, orientation);
			tomatoes.push(tomato);
			addChild(tomato);
			tomato.addEventListener(Tomato.TOMATO_AVOIDED, handleTomatoEvent, false, 0, true);
			tomato.addEventListener(Tomato.TOMATO_HIT, handleTomatoEvent, false, 0, true);	
		}
		
		private function handleTomatoEvent(evt:Event):void 
		{
			var tomato:Tomato = evt.target as Tomato;
			if (!tomato) { return; }
			
			var splatPoint:Point = new Point(tomato.x, tomato.y);
			
			tomato.removeEventListener(Tomato.TOMATO_AVOIDED, handleTomatoEvent);
			tomato.removeEventListener(Tomato.TOMATO_HIT, handleTomatoEvent);
			
			var i:uint = tomatoes.indexOf(tomato);
			tomatoes.splice(i, 1)[0];
			
			if(evt.type == Tomato.TOMATO_AVOIDED) 
			{				
				score++;
			} 
			else 
			{
				hit++;
				FlexGlobals.topLevelApplication.hitCount += 1;
				displaySplat(splatPoint);
			}
			
			removeChild(tomato);
		}
		
		private function displaySplat(splatPoint:Point):void
		{			
			//var splatTomato:Loader2D = new Loader2D("assets/Tomato-splat.png", 64, 64);
			//splatTomato.x = splatPoint.x;
			//splatTomato.y = splatPoint.y;			
			//addChild(splatTomato);
			
			addChild(new SplatTomato(splatPoint.x, splatPoint.y));
			
			var splatSoundChoice:uint = Math.floor(Math.random() * splatSounds.length);
			splatSounds[splatSoundChoice].play(0,0);
		}		
		
		private function calcNextTomatoDelay():Number 
		{
			var baseDelay:Number = MIN_BASE_DELAY + Math.pow(BASE_DELAY_RANGE, 1/(1 + 0.1*score));
			var delayRange:Number = MIN_DELAY_RANGE + DELAY_RANGE_RANGE / (1 + 0.1*score);
			var ballDelay:Number = baseDelay + Math.random() * delayRange;
			return ballDelay;
		}
		
		private function checkForCollision(tomato:Tomato, headPosition:Point):void
		{
			if((Math.abs(tomato.x - headPosition.x) < 100) && (Math.abs(tomato.y - headPosition.y) < 100)) 
			{
				tomato.dispatchEvent(new Event(Tomato.TOMATO_HIT));
			}
		}
		
		public function removeSplatTomato(splatTomato:SplatTomato):void 
		{
			removeChild(splatTomato);
		}
	}
}