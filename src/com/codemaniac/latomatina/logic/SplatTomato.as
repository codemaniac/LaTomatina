package com.codemaniac.latomatina.logic
{
	import com.codemaniac.latomatina.util.Loader2D;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SplatTomato extends Sprite
	{		
		public function SplatTomato(x:Number, y:Number)
		{
			addChild(new Loader2D("assets/Tomato-splat.png", 64, 64));
			this.x = x;
			this.y = y;
			
			var fadeTimer:Timer = new Timer(250, 40);
			fadeTimer.addEventListener(TimerEvent.TIMER, fadeTomato);
			fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, removeTomato);
			fadeTimer.start();
		}
		
		private function fadeTomato(evt:TimerEvent):void 
		{
			alpha -= 0.025; 
		}
		
		private function removeTomato(evt:TimerEvent):void 
		{
			LaTomatinaManager.getInstance().removeSplatTomato(this);
		}
	}
}