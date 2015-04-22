package {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.system.Capabilities;

	internal class AudioObject extends EventDispatcher {
		
		private static var _canPlaySound:Boolean = Capabilities.hasAudio;
		
		public var name:String;
		public var sound:Sound;
		public var channel:SoundChannel;
		
		protected var _transform:SoundTransform;
		protected var _playing:Boolean = false;
		protected var _muted:Boolean = false;
		protected var _paused:Boolean = false;
		protected var _pauseTime:Number;
		protected var _loops:uint;
		protected var _offset:Number;
		
		public function AudioObject(name:String, sound:Sound) {
			this.name = name;
			this.sound = sound;
		}
		
		public function play(offset:Number = 0, loops:int = 0, transform:SoundTransform = null):SoundChannel
		{
			if (_canPlaySound)
			{
				_offset = offset;
				if (loops < 0) loops = int.MAX_VALUE;
				_loops = loops;
				channel = sound.play(_offset, _loops, transform);
				if (channel == null)
				{
					_canPlaySound = false;
					return null;
				}
				channel.addEventListener(Event.SOUND_COMPLETE, complete, false, 0, true);
				_transform = channel.soundTransform;
				_playing = true;
				return channel;
			} else {
				return null;
			}
		}
		
		public function stop():void {
			if (_canPlaySound && channel != null) {
				channel.stop();
				_loops = 0;
				_playing = false;
				dispatchEvent(new AudioEngineEvent(AudioEngineEvent.SOUND_STOPPED, name));
			}
		}
		
		protected function complete(e:Event):void {
			if (_canPlaySound && channel != null)
			{
				_playing = false;
				dispatchEvent(new AudioEngineEvent(AudioEngineEvent.SOUND_COMPLETE, name));
			}
		}
		
		public function get playing():Boolean {
			return _playing;
		}
		
		public function get volume():Number {
			if (_canPlaySound && channel != null) {
				return channel.soundTransform.volume;
			} else {
				return 0;
			}
		}
		
		public function set volume(value:Number):void {
			if (_canPlaySound && channel != null) {
				var tf:SoundTransform = _transform;
				tf.volume = value;
				_transform = tf;
				if (!_muted) channel.soundTransform = _transform;
			}
		}
		
		public function get pan():Number {
			if (_canPlaySound && channel != null) {
				return channel.soundTransform.pan;
			} else {
				return 0;
			}
		}
		
		public function set pan(value:Number):void {
			if (_canPlaySound && channel != null) {
				var tf:SoundTransform = _transform;
				tf.pan = value;
				_transform = tf;
				if (!_muted) channel.soundTransform = _transform;
			}
		}
		
		public function get transform():SoundTransform {
			if (_canPlaySound && channel != null) {
				return channel.soundTransform;
			} else {
				return null;
			}
		}
		
		public function set transform(value:SoundTransform):void {
			if (_canPlaySound && channel != null) {
				_transform = value;
				if (!_muted) channel.soundTransform = _transform;
			}
		}
		
		public function mute():void {
			if (_canPlaySound && channel != null) {
				if (_muted) {
					channel.soundTransform = _transform;
				} else {
					channel.soundTransform = new SoundTransform(0, 0);
				}
			}
			_muted = !_muted;
		}
		public function turnMuteOn () : void {
			if (_canPlaySound && channel != null) {
				channel.soundTransform = new SoundTransform(0, 0);
			}
			_muted = true;
		}
		public function turnMuteOff () : void {
			if (_canPlaySound && channel != null) {
				channel.soundTransform = _transform;
			}
			_muted = false;
		}
		
		public function get isMuted():Boolean {
			return _muted;
		}
		
		public function pause():void {
			if (_canPlaySound && channel != null) {
				if (_paused) {
					var normalOffset:Number = _offset;
					play(_pauseTime, _loops, _transform);
					_offset = normalOffset;
				} else {
					_pauseTime = channel.position;
					channel.stop();
				}
			}
			_paused = !_paused;
		}
			
		public function get isPaused():Boolean {
			return _paused;
		}
		
	}
}