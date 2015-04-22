package com.kimera.screens
{
	import flash.display.MovieClip;
	
	public class Mensagem extends MovieClip
	{
		public static const REI_KIMERA_SEMENTE 	= "Rei Kimera Semente";
		public static const REI_KIMERA 			= "Rei Kimera";
		public static const DRIADE 				= "Dríade do Mal";
		public static const JEQUITIBA 			= "Jequitibá-Rei";
		public static const CETUS	 			= "Cetus";
		public static const KAOS	 			= "Kaos";
		
		public function Mensagem()
		{
			super();
		}
		
		public function mostrarPersonagem(personagem)
		{
			var foto = Mensagem.JEQUITIBA;
			if(personagem != null && personagem != ""){
				foto = personagem;
			}
			
			this.titulo_txt.text = foto;
			
			if(personagem == Mensagem.DRIADE){
				this.personagem_mc.gotoAndStop(4);
			} else if (personagem == Mensagem.JEQUITIBA){
				this.personagem_mc.gotoAndStop(3);
			} else if (personagem == Mensagem.REI_KIMERA_SEMENTE){
				this.personagem_mc.gotoAndStop(2);
			} else if (personagem == Mensagem.REI_KIMERA){
				this.personagem_mc.gotoAndStop(1);
			} else if (personagem == Mensagem.CETUS){
				this.personagem_mc.gotoAndStop(5);
			} else if (personagem == Mensagem.KAOS){
				this.personagem_mc.gotoAndStop(6);
			}
		}

		public function mostrarIcone(icone)
		{
			trace('valor icone: ' + icone);

			if(icone == ""){
				this.construcoes_mc.gotoAndStop(1);
			} else{
				this.construcoes_mc.gotoAndStop(Number(icone));	
			}
		
		}
	}
}