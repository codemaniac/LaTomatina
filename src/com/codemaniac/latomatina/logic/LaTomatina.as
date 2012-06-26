package com.codemaniac.latomatina.logic
{
	import com.codemaniac.latomatina.util.CameraClass;
	import com.codemaniac.latomatina.util.Loader2D;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Video;
	import flash.utils.Timer;
	
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	
	import mx.core.FlexGlobals;	
		
	public class LaTomatina extends Sprite
	{	
		private var sceneWidth:int;
		private var sceneHeight:int;
		private var webcam:CameraClass;
		private var video:Video;
		private var bmpdFromVideo:BitmapData;						
		private var detector:ObjectDetector;		
		private var detectionMap:BitmapData;
		private var drawMatrix:Matrix;
		private var scaleFactor:int = 4;
		private var headPosition:Point;		
		private var tomatoManager:LaTomatinaManager
		private var errorMsg:Loader2D;
		private var gameTimer:Timer;
		public var gameOn:Boolean = false;
		
		public function LaTomatina()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		private function onAdded (evt:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			gameTimer = new Timer(1);
			gameTimer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				FlexGlobals.topLevelApplication.time += 5; 
			});
			errorMsg = new Loader2D("assets/error-msg.png", 253, 26);
			initFaceDetection();			
			addEventListener(Event.ENTER_FRAME, gameLoop);
		}
		
		private function initFaceDetection():void
		{
			sceneWidth = 800;
			sceneHeight = 600;
			headPosition = new Point();
			webcam = new CameraClass(sceneWidth, sceneHeight);
			video = webcam.camVideo;
			
			if(video == null) 
			{
				trace("NO WEBCAM!!");
			}
			else 
			{
				video.addEventListener(Event.ACTIVATE, initWebcam);
				video.x = video.y = 0;
				addChild(video);
				
				bmpdFromVideo = new BitmapData(video.width, video.height, false);
				detectionMap = new BitmapData(sceneWidth/scaleFactor, sceneHeight/scaleFactor, false, 0);
				drawMatrix = new Matrix(1/scaleFactor, 0, 0, 1/scaleFactor);
				initDetector();				
			}
		}
		
		private function initDetector():void 
		{
			detector = new ObjectDetector();
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size  = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void 
		{
			if( e.rects )
			{
				if(e.rects.length == 0)
				{
					errorMsg.visible = true;
					headPosition.x = -150;
					headPosition.y = -150;
					gameTimer.stop();
				}
				else 
				{	
					if(!gameTimer.running)
						gameTimer.start();
					errorMsg.visible = false;
					e.rects.forEach(function( r:Rectangle, idx :int, arr :Array ):void 
					{
						headPosition.x = sceneWidth-(r.width / 2  + r.x) * scaleFactor;
						headPosition.y = (r.height / 2 + r.y) * scaleFactor;
					});
				}
			}			
		}
		
		private function initWebcam(e:Event):void 
		{
			video.removeEventListener(Event.ACTIVATE, initWebcam);
			webcam.camera.addEventListener(StatusEvent.STATUS, cameraStatusListener);
			var ma:Matrix = video.transform.matrix;
			ma.a = -1;
			ma.tx = video.width+video.x;
			video.transform.matrix = ma;
		}
		
		private function cameraStatusListener(evt:StatusEvent):void {	
			switch (evt.code) 
			{
				case "Camera.Muted":
					// do nothing
					break;
				case "Camera.Unmuted":					
					initTomatoManager();
					gameOn = true;		
					FlexGlobals.topLevelApplication.scoreBoardBox.visible = true;
					gameTimer.start();
					break;
			}
		}
		
		private function getAndDetectCamImage():void 
		{
			bmpdFromVideo.draw(video);
			detectionMap.draw(bmpdFromVideo,drawMatrix,null,"normal",null,true);
			detector.detect(detectionMap);
		}
		
		private function initTomatoManager():void 
		{
			tomatoManager = LaTomatinaManager.getInstance();
			addChild(tomatoManager);

			errorMsg.x = 400;
			errorMsg.y = 75;
			errorMsg.visible = false;
			addChild(errorMsg);
		}
		
		private function gameLoop(evt:Event):void 
		{
			getAndDetectCamImage();			
			if(gameOn) 
			{
				tomatoManager.update(headPosition);				
			}
		}
	}
}