package com.codemaniac.latomatina.util {
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.media.Camera;
	import flash.media.Video;

	public class CameraClass extends Sprite {
		public var camVideo:Video;
		public var camera:Camera;

		public function CameraClass(width:int, height:int) {
			camera = Camera.getCamera();
			if (camera != null) {
				camVideo = new Video(width, height);
				
				camVideo.attachCamera(camera);
				camVideo.smoothing=true;
				
				camera.setMode(width, height, 30); 
			} else {
				trace("Please connect a camera to the computer.");
			}
		}
	}
}