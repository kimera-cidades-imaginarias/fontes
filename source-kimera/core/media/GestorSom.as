
package core.media
{
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import gs.TweenLite;

	public class GestorSom
	{
		public static var instance = null;
		
		public static var CLICK 			= 1;
		public static var CLICK_CONSTRUCAO 	= 2;
		public static var POPUP				= 3;		
		
		private var sons;
		private var grupos;
		
		public static function GetInstance()
		{
			if (instance == null)
			{
				instance = new GestorSom();
			}
			return instance;
		}
		
		public function GestorSom()
		{
			sons 	= new Array();
			grupos	= new Array();
		}
		
		public function CarregarSomBiblioteca( identificador, classe, grupo = 'padrao' )
		{
			sons.push({id: identificador, grupo: grupo, instancia: new classe, sc: null, playing: false, loops: 0});
		}
		
		public function CarregarSomArquivo( identificador, arquivo, grupo = '' )
		{
			var sound = new Sound();
			
			sound.addEventListener( Event.COMPLETE, FimCarregarSom );
			sound.load( new URLRequest(arquivo) );
			
			sons.push({id: identificador, grupo: grupo, instancia: sound, sc: null, playing: false, loops: 0});
		}
		
		public function FimCarregarSom(evt)
		{
			var target = evt.target;
			for (var i = 0; i < sons.length; i++)
			{
				if (sons[i].instancia == target)
				{
					if (sons[i].playing) Reproduzir( sons[i].id, sons[i].loops );
					break;
				}
			}
		}
		
		
		public function Reproduzir( identificador, loops = 0, tween = false)
		{
			var som = GetSom( identificador );
			
			if(som)
			{
				if(som.playing) som.sc.stop();
				var grupo = GetGrupo( som.grupo );
				
				var st = new SoundTransform();
				st.volume = grupo.volume;		
				som.playing = true;
				som.loops 	= loops;
				
				if(tween)
				{
					var vol  = {valor: 0};
					TweenLite.to(vol, 3, {valor: grupo.volume, onUpdate: TweenVolume, onUpdateParams: [som, vol]});
				}
				
				som.sc = som.instancia.play(0, loops, st);
				som.sc.addEventListener(Event.SOUND_COMPLETE, TerminouReproducao);
			}
		}
		
		public function TweenVolume(som, vol)
		{
			if(som.sc)
			{
				var st = new SoundTransform()
				st.volume = vol.valor;
				som.sc.soundTransform = st;
			}
		}
		
		public function TerminouReproducao(evt)
		{
			var som = ProcurarSom(evt.currentTarget);
			//trace("Terminou reprod " + som.id);
			if(som) som.playing = false;
		}
		
		public function ProcurarSom(sc) // procura um som a partir do sound channel
		{
			for (var i = 0; i < sons.length; i++)
				if (sons[i].sc != null)
				{
					if(sons[i].sc.valueOf() == sc.valueOf()) return sons[i];
				}
			return null;
		}
		
		public function Parar( identificador, tween = false)
		{
			var som = GetSom( identificador );
			if (som.playing)
			{
				som.playing = false;
				if (som && som.sc)
				{
					if(tween)
					{
						var grupo = GetGrupo( som.grupo );
						var vol  = {valor: grupo.volume};
						TweenLite.to(vol, 1, {valor: 0, onUpdate: TweenVolume, onUpdateParams: [som, vol],
																   onComplete: Stop, onCompleteParams: [som.sc]});
					}
					else Stop(som.sc);
				}
			}
		}
		
		public function Pausar( identificador )
		{
			var som = GetSom( identificador );
			if (som.playing)
			{
				if (som && som.sc)
				{
					som.playing = false;
					som.pausePoint = som.sc.position;
					som.sc.stop();
				}
			}
		}
		
		public function Retornar( identificador, loops )
		{
			var som = GetSom( identificador );
			if (som && som.sc)
			{
				var grupo = GetGrupo( som.grupo );
				var st = new SoundTransform();
				st.volume = grupo.volume;
				
				som.sc = som.instancia.play(som.pausePoint, loops, st);
				som.playing = true;
			}
		}
		
		public function Stop(soundChannel)
		{
			soundChannel.stop();
		}
		
		public function PararTudo()
		{
			for (var i = 0; i < sons.length; i++) Parar( sons[i].id );
		}
		
		public function GetSom( identificador )
		{
			for (var i = 0; i < sons.length; i++)
				if (sons[i].id == identificador)
					return sons[i];
			
			return null;
		}
		
		public function EstaTocando( identificador ) : Boolean
		{
			var som = GetSom( identificador );
			return som.playing;
		}
		
		//--------------------------------------------------
		public function SetVolumeGrupo( id, volume )
		{
			var grupo = GetGrupo( id );
			grupo.volume = volume;

			var st = new SoundTransform();
			st.volume = grupo.volume;			
			
			for (var i = 0; i < sons.length; i++)
				if (sons[i].sc && sons[i].grupo == id) /*sons[i].playing &&*/
					sons[i].sc.soundTransform = st;

		}
				
		public function GetGrupo( id )
		{
			for (var i = 0; i < grupos.length; i++)
				if (grupos[i].id == id)
					return grupos[i];
			
			var grupo = {id: id, volume: 1};
			grupos.push(grupo);
			return grupo;
		}
	}
}