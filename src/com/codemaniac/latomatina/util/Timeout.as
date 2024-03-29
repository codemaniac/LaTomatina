package com.codemaniac.latomatina.util {
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * Calls a function one time, after a specified delay.
	 * Accepts optional parameters to the specified method.
	 * (Wraps a simple Timer implementation.)
	 * All active timeouts can be cleared via a static method. 
	 */
	public class Timeout {
		private static var activeTimeouts:Array;
		
		private var timer:Timer;
		private var func:Function;
		private var params:Array;
		
		/**
		 * Cancel all currently-active Timeouts.
		 */ 
		public static function cancelAllTimeouts () :void {
			var i:int = Timeout.activeTimeouts.length;
			while (i--) {
				var timeout:Timeout = Timeout(Timeout.activeTimeouts[i]);
				timeout.cancel();
			}
		}
		
		/**
		 * Constructor.
		 * @param	func	A Function to be called after a specified delay.
		 * 					This Function must be public for the Timeout to be able to execute the call.
		 * @param	delay	Time (in msec) after which the Function will be called.
		 * @param	params	Parameters passed to the Function.
		 */
		public function Timeout (func:Function, delay:Number, ...params:Array) {
			if (!Timeout.activeTimeouts) {
				Timeout.activeTimeouts = new Array();
			}
			Timeout.activeTimeouts.push(this);
			
			this.func = func;
			this.params = params;
			
			this.timer = new Timer(delay, 1);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
			this.timer.start();
		}
		
		/**
		 * Cancel the Timeout and remove all references to the Function and optional parameters,
		 * freeing up this Timeout for garbage collection.
		 */
		public function cancel () :void {
			if (!this.timer) { return; }
			
			this.timer.stop();
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
			this.destroy();
		}
		
		private function onTimerComplete (evt:TimerEvent=null) :void {
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onTimerComplete);
			if (this.params.length) { this.func(this.params); }
			else { this.func(); }
			this.destroy();
		}
		
		private function destroy () :void {
			Timeout.activeTimeouts.splice(Timeout.activeTimeouts.indexOf(this), 1);
			this.timer = null;
			this.func = null;
			this.params = null;
		}
	}
}