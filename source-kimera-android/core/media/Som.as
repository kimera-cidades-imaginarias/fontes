
package core.media
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;	
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	public class Som
	{	
		private var som		: Sound			 = null;
		private var sc 		: SoundChannel	 = null;
		private var st 		: SoundTransform = null;
		private var playing_: Boolean;
		private var volume	: Number;
		private var pausePoint: Number;
	
		public function Som(pSom: Sound, pVolume: Number = 0.6)
		{
			som 		= pSom;
			volume		= pVolume;
			playing_	= false;
		}
		
		public function Play(startTime		: Number = 0,
							 loops			: int	 = 0,
							 sndTransform	: SoundTransform = null)
		{
			if (playing_) return ;
			st = new SoundTransform();
			st.volume = volume;			
			sc = som.play(startTime, loops, st);
			sc.addEventListener(Event.SOUND_COMPLETE, SoundCompleteHandler);

			playing_ = true;
			return sc;
		}
		
		public function Pausar()
		{
			if(sc)
			{
				pausePoint = sc.position;
				sc.stop();
				playing_ = false;
			}
		}
		
		public function Retornar(loops)
		{
			st = new SoundTransform();
			st.volume = volume;			
			sc = som.play(pausePoint, loops, st);
			playing_ = true;
		}
		
		public function Stop()
		{
			playing_ = false;
			if (sc)
			{
				sc.stop();
				sc = null;
			}
		}
		
		private function SoundCompleteHandler(evt)
		{
			playing_ = false;
		}
		
		public function IsTocando()
		{
			return playing_;
		}
		
		public function SetVolume(vol: Number)
		{
			st = new SoundTransform();
			st.volume = vol;
			volume = vol;
			if(sc != null) sc.soundTransform = st;
		}
		
		public function SetPan(pan)
		{
			st.pan = pan;
			if(sc != null) sc.soundTransform = st;
		}
	}
}