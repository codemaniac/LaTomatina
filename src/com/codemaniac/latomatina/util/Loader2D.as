package com.codemaniac.latomatina.util {
	import __AS3__.vec.Vector;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.net.URLRequest;
	
	public class Loader2D extends Sprite {
		
		private var w:Number;
		private var h:Number;
		
		public function Loader2D (path:String="", width:Number=600, height:Number=600) {
			if (path != "") {
				this.w = width;
				this.h = height;
				this.load(path);
			}
		}
		
		public function load (path:String) :void {
			var loader:Loader = new Loader();
			loader.load(new URLRequest(path));
			loader.contentLoaderInfo.addEventListener(ErrorEvent.ERROR, this.onLoadError);
			loader.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaded);
		}
		
		private function onLoadError (evt:ErrorEvent) :void {
			trace("error loading image...");
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			if (!loaderInfo) { return; }
			
			loaderInfo.removeEventListener(ErrorEvent.ERROR, this.onLoadError);
			loaderInfo.removeEventListener(Event.INIT, this.onLoaded);
		}
		
		private function onLoaded (evt:Event) :void {
			var loaderInfo:LoaderInfo = evt.target as LoaderInfo;
			if (!loaderInfo) { return; }
			
			loaderInfo.removeEventListener(ErrorEvent.ERROR, this.onLoadError);
			loaderInfo.removeEventListener(Event.INIT, this.onLoaded);
			
			var loader:Loader = loaderInfo.loader;

			loader.width = this.w;
			loader.height = this.h;
			loader.x = -0.5 * loader.width;
			loader.y = -0.5 * loader.height;
			
			this.addChild(loader);
		}
	}
}