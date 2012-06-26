package com.codemaniac.latomatina.logic
{
	import com.codemaniac.latomatina.util.Loader2D;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Tomato extends Sprite
	{
		public static const TOMATO_AVOIDED:String = "tomatoAvoided";
		public static const TOMATO_HIT:String = "tomatoHit";
		
		public static const TOMATO_ORIENTATION_LEFT:Number = -1;
		public static const TOMATO_ORIENTATION_RIGHT:Number = 1;
		
		public var position:Point;
		public var theta:Number;
		public var v:Number;
		public var orientation:Number;
				
		public function Tomato(initialPosition:Point, initialAngle:Number, initialVelocity:Number, initialOrientation:Number)
		{			
			addChild(new Loader2D("assets/Tomato-large.png", 32, 32));
			
			position = initialPosition;
			theta = initialAngle;
			v = initialVelocity;
			orientation = initialOrientation;
			
			x = position.x;
			y = position.y;
			z = 0;
		}
	}
}