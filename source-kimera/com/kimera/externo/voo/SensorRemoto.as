package com.kimera.externo.voo
{
	import as3isolib.display.IsoSprite;
	
	import core.FaseRender;
	import core.Simulador;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.display.DisplayObject;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import gs.TweenLite;
		
	public class SensorRemoto extends MovieClip
	{
		public static var COR_FILTRO_MAR 		= 0x5BA6DF;
		public static var COR_FILTRO_TERRENO 	= 0x9C6B4A;
		public static var COR_FILTRO_VEGETACAO	= 0x6B8442;
		public static var COR_FILTRO_CONSTRUCAO	= 0xF8CE17;

		public function SensorRemoto()
		{
			
		}
		
		/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

		public function adicionaSensorAgua (evt = null) 
		{
			for (var i:int = 0; i < Game.getInstance().dataLoader.getPosicaoElementosMar().length; ++i) 
			{ 
				if(i % 4 == 0){
					Game.getInstance().IniciarFiltroMar(Game.getInstance().dataLoader.getPosicaoElementosMar()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosMar()[i].pY, COR_FILTRO_MAR);
				}
			}
		}

		public function adicionaRandonSensorAgua (evt = null) 
		{
			var i:int = Math.floor(Math.random() * (Game.getInstance().dataLoader.getPosicaoElementosMar().length - 0 + 1)) + 0

			Game.getInstance().IniciarFiltroMarRandom(Game.getInstance().dataLoader.getPosicaoElementosMar()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosMar()[i].pY, COR_FILTRO_MAR);
		}
		
		/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

		public function adicionaSensorTerreno (evt = null) 
		{
			for (var i:int = 0; i < Game.getInstance().dataLoader.getPosicaoElementosTerreno().length; ++i) 
			{ 
				if(i % 4 == 0){
					Game.getInstance().IniciarFiltroTerreno(Game.getInstance().dataLoader.getPosicaoElementosTerreno()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosTerreno()[i].pY, COR_FILTRO_TERRENO);
				}
			}
		}

		public function adicionaRandonSensorTerreno (evt = null) 
		{
			var i:int = Math.floor(Math.random() * (Game.getInstance().dataLoader.getPosicaoElementosTerreno().length - 0 + 1)) + 0

			Game.getInstance().IniciarFiltroTerrenoRandom(Game.getInstance().dataLoader.getPosicaoElementosTerreno()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosTerreno()[i].pY, COR_FILTRO_TERRENO);
		}
		
		/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */

		public function adicionaSensorVegetacao (evt = null) 
		{
			for (var i:int = 0; i < Game.getInstance().dataLoader.getPosicaoElementosVegetacao().length; ++i) 
			{ 
				if(i % 4 == 0){
					Game.getInstance().IniciarFiltroVegetacao(Game.getInstance().dataLoader.getPosicaoElementosVegetacao()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosVegetacao()[i].pY, COR_FILTRO_VEGETACAO);
				}
			}
		}

		public function adicionaRandonSensorVegetacao (evt = null) 
		{
			var i:int = Math.floor(Math.random() * (Game.getInstance().dataLoader.getPosicaoElementosVegetacao().length - 0 + 1)) + 0

			Game.getInstance().IniciarFiltroVegetacaoRandom(Game.getInstance().dataLoader.getPosicaoElementosVegetacao()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosVegetacao()[i].pY, COR_FILTRO_VEGETACAO);
		}

		/* -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- */
		
		public function adicionaSensorConstrucao (evt = null) 
		{
			for (var i:int = 0; i < Game.getInstance().dataLoader.getPosicaoElementosConstrucao().length; ++i) 
			{ 
				if(i % 4 == 0){
					Game.getInstance().IniciarFiltroConstrucao(Game.getInstance().dataLoader.getPosicaoElementosConstrucao()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosConstrucao()[i].pY, COR_FILTRO_CONSTRUCAO);
				}
			}
		}

		public function adicionaRandonSensorConstrucao (evt = null) 
		{
			var i:int = Math.floor(Math.random() * (Game.getInstance().dataLoader.getPosicaoElementosConstrucao().length - 0 + 1)) + 0

			Game.getInstance().IniciarFiltroConstrucaoRandom(Game.getInstance().dataLoader.getPosicaoElementosConstrucao()[i].pX, Game.getInstance().dataLoader.getPosicaoElementosConstrucao()[i].pY, COR_FILTRO_CONSTRUCAO);
		}
	}
}