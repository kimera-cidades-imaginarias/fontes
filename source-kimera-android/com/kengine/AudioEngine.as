package {
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
		
	public class AudioEngine extends EventDispatcher {
		
		//LIST OF SOUND OBJECTS THAT HAVE ALREADY BEEN CREATED
		protected var _soundList:Object;
		//FLAG SETTING WHETHER ALL NOT ALL SOUNDS ARE MUTED, SO NEW SOUNDS WILL BE MUTED AS WELL
		protected var _allMuted:Boolean = false;
		
		// FLAG THAT DECLARES WHETHER TRACES ARE DISPLAYED OR NOT
		protected static var mDebug:Boolean = false;
		
		private static var _canPlaySound:Boolean = Capabilities.hasAudio;
		
		//SINGLETON INSTANCE
		static private var _instance:AudioEngine;
		
		//CONSTRUCTOR - NOT ACCESSIBLE MORE THAN ONCE
		public function AudioEngine(validator:AudioEngineSingleton)
		{
			if (_instance) throw new Error("AudioEngine is a Singleton class. Use getInstance() to retrieve the existing instance.");
			_soundList = new Object();
		}
		
		/**
		 * Returns the instance of the AudioEngine.
		 * @return	AudioEngine
		 */
		static public function getInstance():AudioEngine
		{
			if (!_instance) _instance = new AudioEngine(new AudioEngineSingleton());
			return _instance;
		}
		
		/*SOUND ENGINE METHODS*/
		
		/**
		 * Plays the sound specified by the name parameter. Checks for the sound internally first, and then looks for it as an external file.
		 * @param	name		String			The name of the linked Sound in the library, or the URL reference to an external sound.
		 * @param	offset		Number			The number of seconds offset the sound should start.
		 * @param	loops		int				The number of times the sound should loop. Use -1 for infinite looping.
		 * @param	transform	transform		The initial sound transform to use for the sound.
         * @param   applicationDomain   ApplicationDomain   Optional ApplicationDomain ref where the sound class can be found (useful for externally loaded swf issues)
		 * @return				SoundChannel	The SoundChannel object created by playing the sound. Can also be retrieved through getChannel method.
		 */
		public function playSound(name:String, offset:Number = 0, loops:int = 0, transform:SoundTransform = null, applicationDomain:ApplicationDomain = null):SoundChannel {
			try {
				if (_canPlaySound) {
					if (!_soundList[name]) { //SOUND DOES NOT EXIST
						var sound:Sound;
						var soundClass:Class;
						try {
							soundClass = (applicationDomain != null) ? applicationDomain.getDefinition(name) as Class : getDefinitionByName(name) as Class;
						} catch (err:ReferenceError) {
							if (mDebug)
								trace("AudioEngine Message: Could not find sound object with name " + name + ".  Attempting to load external file.");
						}
						if (soundClass) { //INTERNAL REFERENCE FOUND - CREATING SOUND OBJECT
							sound = new soundClass() as Sound;
						} else { //NO INTERNAL REFERENCE FOUND - WILL ATTEMPT TO LOAD
							sound = new Sound(new URLRequest(name));
							sound.addEventListener(IOErrorEvent.IO_ERROR, ioError, false, 0, true);
						}
						_soundList[name] = new AudioObject(name, sound);
						_soundList[name].addEventListener(AudioEngineEvent.SOUND_COMPLETE, soundEvent, false, 0, true);
						_soundList[name].addEventListener(AudioEngineEvent.SOUND_STOPPED, soundEvent, false, 0, true);
					}
					var channel:SoundChannel = _soundList[name].play(offset, loops, transform);
					if (channel == null) {
						_canPlaySound = false;
						return null;
					}
					if (_allMuted) _soundList[name].turnMuteOn();
					return channel;
				} else {
					return null;
				}
			} catch (_error:Error) {
				if (mDebug)
					trace(_error);
			}
			return null;
		}
		
		protected function ioError(e:IOErrorEvent):void {
			if (mDebug)
				trace("AudioEngine Error Message: Failed to load sound: " + e.text);
			delete _soundList[e.target.url];
			dispatchEvent(new AudioEngineEvent(AudioEngineEvent.SOUND_ERROR, e.target.url));
		}
		
		protected function soundEvent(e:AudioEngineEvent):void {
			dispatchEvent(e);
		}
		
		/**
		 * Stops the specified sound.
		 * @param	name	String	The name of the sound to stop - use the same name used when calling playSound.
		 */
		public function stopSound(name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].stop();
					} else {
						//why the hell is this an error?? -JMonty
						//throw new Error("Sound " + name + " does not exist. You must play a sound before you can stop it.");
						trace( "Sound " + name + " was not found, ignoring stop command." );
					}
				} else {
					for (var i:String in _soundList) {
						_soundList[i].stop();
					}
				}
			}
		}
		
		/**
		 * Sets the volume of a specific sound, or of all sounds in the Engine.
		 * @param	value	Number	The value, from 0 to 1, to set the volume.
		 * @param	name	String	The name of the sound to change. Pass nothing to modify all sounds in the Engine.
		 */
		public function setVolume(value:Number, name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].volume = Math.max(0, Math.min(1, value));
					} else {
						throw new Error("Sound " + name + " does not exist.");
					}
				} else {
					for (var i:String in _soundList) _soundList[i].volume = Math.max(0, Math.min(1, value));
				}
			}
		}
		
		/**
		 * Returns the volume level of a given sound.
		 * @param	name	String	The name of the sound passed into playSound.
		 * @return			Number	The value of the volume of the sound.
		 */
		public function getVolume(name:String):Number {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].volume;
				} else {
					throw new Error("Sound " + name + " does not exist.");
				}
			}
			return 0;
		}
		
		/**
		 * Sets the pan of a specified sound, or of all sounds in the Engine.
		 * @param	value	Number	The value, from -1 to 1, to set the pan.
		 * @param	name	String	The name of the sound to change. Pass nothing to modify all sounds in the Engine.
		 */
		public function setPan(value:Number, name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].pan = value;
					} else {
						throw new Error("Sound " + name + " does not exist.");
					}
				} else {
					for (var i:String in _soundList) _soundList[i].pan = value;
				}
			}
		}
		
		/**
		 * Returns the pan of a given sound.
		 * @param	name	String	The name of the sound passed into playSound.
		 * @return			Number	The value of the pan of the sound.
		 */
		public function getPan(name:String):Number {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].pan;
				} else {
					throw new Error("Sound " + name + " does not exist.");
				}
			}
			return 0;
		}
		
		/**
		 * Sets the transform of a specified sound, or of all sounds in the Engine.
		 * @param	transform	SoundChannel	The sound transform to assign.
		 * @param	name		String			The name of the sound to change. Pass nothing to modify all sounds in the Engine.
		 */
		public function setTransform(transform:SoundTransform, name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].transform = transform;
					} else {
						throw new Error("Sound " + name + " does not exist.");
					}
				} else {
					for (var i:String in _soundList) _soundList[i].transform = transform;
				}
			}
		}
		
		/**
		 * Returns the transform of a given sound.
		 * @param	name	String			The name of the sound passed into playSound.
		 * @return			SoundTransform	A copy of the sound transform applied to the named sound.
		 */
		public function getTransform(name:String):SoundTransform {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].transform;
				} else {
					throw new Error("Sound " + name + " does not exist.");
				}
			}
			return null;
		}
		
		/**
		 * Returns the active channel of a given sound.
		 * @param	name	String			The name of the sound passed into playSound.
		 * @return			SoundTransform	A copy of the sound transform applied to the named sound.
		 */
		public function getChannel(name:String):SoundChannel {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].channel;
				} else {
					throw new Error("Sound " + name + " does not exist.");
				}
			}
			return null;
		}
		
		/**
		 * Mutes/unmutes the given sound, or all sounds in the Engine.
		 * @param	name	String	The name of the sound to mute/unmute. Leave out to act on all sounds in the Engine.
		 */
		public function mute(name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].mute();
						if (!_soundList[name].isMuted) _allMuted = false;
					} else {
						throw new Error("Sound " + name + " does not exist.");
					}
				} else {
					_allMuted = !_allMuted;
					if (_allMuted) {
						for each (var i:AudioObject in _soundList) {
							i.turnMuteOn();
						}
					} else {
						for each (var i:AudioObject in _soundList) {
							i.turnMuteOff();
						}
					}
				}
			}
		}
		
		public function turnAllSoundsOn () : void {
			if (_allMuted) {
				mute();
			}
		}
		
		public function turnAllSoundsOff () : void {
			if (!_allMuted) {
				mute();
			}
		}
		
		/**
		 * Pauses/resumes the given sound, or all sounds in the Engine.
		 * @param	name	String	The name of the sound to pause or resume. Leave out to act on all sounds in the Engine.
		 */
		public function pause(name:String = null):void {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						_soundList[name].pause();
					} else {
						throw new Error("Sound " + name + " does not exist.");
					}
				} else {
					for each (var i:String in _soundList) _soundList[i].pause();
				}
			}
		}
		
		/**
		 * Returns whether or not a given sound is currently playing.
		 * @param	name	String		The name of the sound to check.
		 * @return			Boolean		True if playing, false otherwise. If a sound is only paused, it will still return as playing.
		 */
		public function isPlaying(name:String):Boolean {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].playing;
				} //else throw new Error("Sound " + name + " does not exist.");
				else
					if (mDebug)
						trace("Sound " + name + " does not exist.");
			}
			return false;
		}
		
		/**
		 * Returns whether or not a given sound is currently paused.
		 * @param	name	String		The name of the sound to check.
		 * @return			Boolean		True if sound is paused, false otherwise.
		 */
		public function isPaused(name:String):Boolean {
			if (_canPlaySound) {
				if (_soundList[name]) {
					return _soundList[name].isPaused;
				} else throw new Error("Sound " + name + " does not exist.");
			}
			return false;
		}
		
		/**
		 * Returns whether or not a given sound is muted.
		 * @param	name	String		The name of the sound to check.
		 * @return			Boolean		True if muted, false otherwise.
		 */
		public function isMuted(name:String = null):Boolean {
			if (_canPlaySound) {
				if (name) {
					if (_soundList[name]) {
						return _soundList[name].isMuted;
					} else throw new Error("Sound " + name + " does not exist.");
					return false;
				} else {
					return _allMuted;
				}
			}
			return true;
		}
		
		/**
		 * Disposes of all objects and cleans up memory
		 *
		 * @param null
		 * @return void
		 */
		public function dispose():void
		{
			// Stops All Sounds
			_instance.stopSound();
			
			// Null Out All Sound Objects
			for (var i:String in _soundList)
			{
				_soundList[i] = null;
			}
			
			// Nulls Out _soundList
			_soundList = null;
			
			// Nulls Out _instance
			_instance = null;
			
		}
		
		/**
		 * activates/deactivates trace outputs
		 * @param null
		 * @return current debug status (true/false)
		 */
		public function debug(value:Boolean):void
		{
			mDebug = value;
		}
		
		/*INTERNAL METHODS*/
		internal function get soundList():Object
		{
			return _soundList;
		}
	}
	
}

class AudioEngineSingleton {}