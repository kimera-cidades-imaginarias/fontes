package core
{
	import flash.display.Sprite; 
	import flash.geom.Point;
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	import flash.events.MouseEvent;
	
	import core.util.MovieClipUtil;
	
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoGrid;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.display.IsoView;	
	import as3isolib.display.primitive.IsoBox;
	import as3isolib.display.primitive.IsoPolygon;
	import as3isolib.display.primitive.IsoRectangle;
	
	import as3isolib.enum.RenderStyleType;
	import as3isolib.enum.IsoOrientation;
	
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.BitmapFill;
	import as3isolib.graphics.Stroke;
	
	import gs.TweenLite;
	
	public class FaseRender extends Sprite
	{
		private const ZOOM_FACTOR = 0.3;
		
		public static const CELL_SIZE   	 = 30; // Largura/altura da célula.	
		private static var faseRender = null;
		
		private var map     : IsoGrid;
		private var scene   : IsoScene;
		private var fase    : Fase;
		private var mapView : IsoView;
		private var zooming : Boolean = false;
		
		public var pan : Point;			
		
		//private var vetor : Array;
		//private var indice = 0;
		//public static var loadFinished		 = false;
		//public static var graficoLoaded      = null;
		//var i = 0;
		
		public static function GetInstance()
		{
			if(faseRender == null) faseRender = new FaseRender();
			return faseRender;
		}
		
		public function FaseRender()
		{			
			map 					= new IsoGrid();
			map.cellSize			= CELL_SIZE;
			map.showOrigin  		= true;     // Não exibe os eixos x,y,z na origem.
			var mapScene			= new IsoScene();
			map.container.visible 	= false;
			mapScene.addChild(map);	
						
			var sceneObj 		= new IsoScene();
			var sceneCons 		= new IsoScene();
			var sceneText 		= new IsoScene();
			mapView 		    = new IsoView();
			
			mapView.showBorder 	= true;
			mapView.setSize(1024, 768);
			mapView.addScene(sceneText);		// Ordem: primeiro texturas, depois grid e por último construções e objetos
			mapView.addScene(mapScene);
			mapView.addScene(sceneCons);
			mapView.addScene(sceneObj);
			
			mapView.currentZoom = 1;
			pan 				= new Point(0, 0);
		}
		
		//----------------------------------------------------------------
		// Exibe a fase após o seu load. É chamada pela classe Game.
		//----------------------------------------------------------------
		
		public function Exibir( pFase: Fase )
		{
			var i;
			fase 		= pFase;			
			var mapSize = new Point(fase.GetTamanho().x, fase.GetTamanho().y);
			GetGrid().setGridSize( mapSize.x, mapSize.y );	
			
			// Acrescenta as texturas da fase.
			var texturas = fase.GetTexturas();
			for (i = 0; i < texturas.length; i++) AdicionarTextura( texturas[i] );
			mapView.scenes[0].render();
			
			// Acrescenta as construções da fase.
			var construcoes = fase.GetConstrucoes();
			for (i = 0; i < construcoes.length; i++) AdicionarConstrucao( construcoes[i] );			
		}
		
		//-------------------------------------------------------------------------------------
		// Opções de criar IsoSprites, adicionar e atualizar construções e adicionar texturas.
		//-------------------------------------------------------------------------------------
		
		public function CriarSprite( movieClip, x_, y_ )
		{
			var grafico 		= new IsoSprite();
			grafico.moveTo( x_, y_,	0 );
			grafico.sprites 	= [movieClip];
			
			return grafico;
		}
		
		public function AdicionarSprite( sprite, scene )
		{
			mapView.scenes[scene].addChild( sprite );	
		}
		
		public function AtualizarCena( scene )
		{
			mapView.scenes[scene].render();
		}
		
		public function AdicionarConstrucao( c )
		{
			var mc 				= new (c.GetMovieClip());			
			var mcConstruindo	= new (c.GetMovieClipConstruindo());
			
			var grafico 		= new IsoSprite();
			
			// cálculo de width, length e height para método setSize
			
			var tamanhoEmCelulas = c.GetEstrutura().GetTamanho();
			var largura = Math.sin(60 * Math.PI/180) * tamanhoEmCelulas.x * CELL_SIZE;
			var comprimento = Math.sin(60 * Math.PI/180) * tamanhoEmCelulas.y * CELL_SIZE;
			var h1 = Math.sin(30 * Math.PI/180) * tamanhoEmCelulas.y * CELL_SIZE;
			var h2 = Math.sin(30 * Math.PI/180) * tamanhoEmCelulas.x * CELL_SIZE;
			var altura = mc.height - (h1 + h2);
			
			grafico.moveTo( c.GetPosicao().x  * CELL_SIZE, 
							c.GetPosicao().y  * CELL_SIZE, 
							0 );
						
			var progresso_mc 			= new ProgressoConstrucao();
			progresso_mc.mask_mc.scaleX = 0.001;
			progresso_mc.y 				= -30;
			progresso_mc.x 				= 0;
			
			mcConstruindo.addChild( progresso_mc );
			mcConstruindo.progresso_mc 	= progresso_mc;
			
			grafico.sprites 			= [mcConstruindo, mc];
			grafico.sprites[1].visible 	= false;
			
			grafico.container.mouseEnabled  = false;
			
			var nome = c.GetEstrutura().GetNome();
			if((nome == "Dique do tororó") || (nome == "Aeroporto") && (c is ConstrucaoDecorativa))
			{
				// Não vamos utilizar o setSize. O setSize é um método que faz os cálculos de perspectiva.
				// Por serem construções irregulares, o método não trabalha da forma devida, impedindo por exemplo
				// que outras construções sejam construídas perto deles. O ideal é que os IsoSprites ocupem retângulos.
			}
			else grafico.setSize( largura, comprimento, altura );
			
			// Essa máscara foi adicionada aos movieclips para determinar a área de click.
			SetMaskara(grafico);
			
			c.SetGrafico( grafico );
			mapView.scenes[2].addChild(grafico);
			mapView.scenes[2].render();
		}
		
		function SetMaskara( grafico )
		{
			grafico.sprites[1].mask_mc.mouseEnabled = true;
			grafico.sprites[1].mask_mc.buttonMode = true;
			grafico.sprites[1].mask_mc.grafico = grafico;
			grafico.sprites[1].mask_mc.addEventListener(MouseEvent.CLICK, Simulador.GetInstance().AtualizarConstrucao);
		}
		
		// Atualiza a IsoSprite da construção para o seu próximo nível.
		public function AtualizarConstrucao( c )
		{
			var mc 				= new (c.GetMovieClip());
			var mcConstruindo	= new (c.GetMovieClipConstruindo());
			
			var progresso_mc 			= new ProgressoConstrucao();
			progresso_mc.mask_mc.scaleX = 0.001;
			progresso_mc.y 				= -30;
			progresso_mc.x 				= 0;
			
			mcConstruindo.addChild( progresso_mc );
			mcConstruindo.progresso_mc 	= progresso_mc;
			
			var grafico = c.GetGrafico();
			grafico.sprites[1].mask_mc.removeEventListener(MouseEvent.CLICK, Simulador.GetInstance().AtualizarConstrucao);
			grafico.sprites 			= [mcConstruindo, mc];
			grafico.sprites[1].visible 	= false;
			
			SetMaskara(grafico);
			
			mapView.scenes[2].render();
		}
		
		private function AdicionarTextura( textura: Object )
		{
			var rct  			= new IsoRectangle();
			var stroke1:Stroke 	= new Stroke(0,0x000000,0);
			rct.strokes 		= new Array(stroke1, stroke1, stroke1, stroke1);
			rct.setSize(textura.tamanho.x * FaseRender.CELL_SIZE, textura.tamanho.y * FaseRender.CELL_SIZE, 0);
			
			var bf  	= new BitmapFill(textura.textura, IsoOrientation.XY);
			rct.fills 	= [bf];
			rct.x 		= (textura.posicao.x-1) * FaseRender.CELL_SIZE;
			rct.y 		= (textura.posicao.y-1) * FaseRender.CELL_SIZE;
			
			mapView.scenes[0].addChild(rct);			
		}
		
		public function GetMapView()
		{
			return mapView;
		}

		//kmaps kamplus
		public function ExibirTexturaPersonalizada( textura: Object )
		{
			var rct  			= new IsoRectangle();
			var stroke1:Stroke 	= new Stroke(0,0x000000,0);
			rct.strokes 		= new Array(stroke1, stroke1, stroke1, stroke1);
			rct.setSize(textura.tamanho.x * FaseRender.CELL_SIZE, textura.tamanho.y * FaseRender.CELL_SIZE, 0);
			
			var bf  	= new BitmapFill(textura.textura, IsoOrientation.XY);
			rct.fills 	= [bf];
			rct.x 		= (textura.posicao.x-1) * FaseRender.CELL_SIZE;
			rct.y 		= (textura.posicao.y-1) * FaseRender.CELL_SIZE;
			
			//mapView.scenes[0].removeChildAt(rct)
			mapView.scenes[0].addChild(rct);
			mapView.scenes[0].render();			
		}
		
		//------------------------------------------------
		// Opções de remoção e encerramento da cena.
		//------------------------------------------------		
		
		public function RemoverIsoSprite( grafico )
		{
			for(var i = 0; i < mapView.scenes[2].numChildren; i++)
			{
				if(mapView.scenes[2].getChildAt(i) == grafico)
				{
					mapView.scenes[2].getChildAt(i).sprites[1].mask_mc.removeEventListener(MouseEvent.CLICK, Simulador.GetInstance().AtualizarConstrucao);
					TweenLite.killTweensOf(mapView.scenes[2].getChildAt(i).container);
					mapView.scenes[2].removeChildAt(i);
					AtualizarCena( 2 );
					return;
				}
			}
		}
		
		public function RemoverEstruturas()
		{
			while (mapView.scenes[2].numChildren > 0) mapView.scenes[2].removeChildAt(0);
		}
		
		public function RemoverCarros()
		{
			var isoGrid;
			while (mapView.scenes[1].numChildren > 0)
			{
				if(mapView.scenes[1].getChildAt(0) is IsoGrid) isoGrid = mapView.scenes[1].getChildAt(0);
				mapView.scenes[1].removeChildAt(0);
			}
			mapView.scenes[1].addChild(isoGrid);
		}
		
		public function RemoverTexturas()
		{
			while (mapView.scenes[0].numChildren > 0) mapView.scenes[0].removeChildAt(0);
		}
		
		public function Encerrar()
		{
			for(var i = 0; i < mapView.scenes[2].numChildren; i++)
			{
				mapView.scenes[2].getChildAt(i).sprites[1].mask_mc.removeEventListener(MouseEvent.CLICK, Simulador.GetInstance().AtualizarConstrucao);
				TweenLite.killTweensOf(mapView.scenes[2].getChildAt(i).container);
			}
			
			RemoverCarros();
			RemoverEstruturas();
			RemoverTexturas();
		}			
		
		//-----------------------------------
		// Scroll do mapa
		//-----------------------------------
		
		public function Rolar( dx, dy )
		{	
			// Fator que faz com que quanto mais longe
			// esteja o nivel de zoom mais rapido o scroll
			// seja e vice-versa.
			
			var d = 1 + ((1 - mapView.currentZoom));
			dx *= d;
			dy *= d;
			
			pan.x += dx;
			pan.y += dy;
		
			mapView.panBy( dx, dy );
		}
		
		public function SetPan( p: Point )
		{
			mapView.panTo( p.x, p.y );
			pan = p;
		}
		
		public function GetPan()
		{
			return pan;
		}
		
		public function AtualizarPan()
		{
			this.SetPan( this.pan );
		}
		
		// -------------------------
		// Grid e seletor
		//--------------------------
		
		public function AdicionarNoGrid( objeto, atualizar:Boolean = true, indice:Number = 1 )
		{
			mapView.scenes[indice].addChild(objeto);
			
			if(atualizar == true){
				AtualizarCena( indice ); // renderiza o grid
			}
		}
		
		public function RemoverNoGrid(indice:Number = 1)
		{
			while (mapView.scenes[indice].numChildren > 0) mapView.scenes[indice].removeChildAt(0);
		}
		
		public function AtualizarNoGrid(indice:Number = 1)
		{
			AtualizarCena( indice );
		}
		
		public function RemoverSeletorGrid()
		{
			for(var i = 0; i < mapView.scenes[1].numChildren; i++)
			{
				if(mapView.scenes[1].getChildAt(i) is IsoRectangle) mapView.scenes[1].removeChildAt(i);
			}
			AtualizarCena( 1 ); // renderiza o grid
		}
		
		public function GetGrid()
		{
			for(var i = 0; i < mapView.scenes[1].numChildren; i++)
			{
				if(mapView.scenes[1].getChildAt(i) is IsoGrid) return mapView.scenes[1].getChildAt(i);
			}
		}		
		
		//-------------------------------------------------------------
		
		public function SetEdicaoConstrucoesHabilitado( b )
		{
			for (var i = 0; i < mapView.scenes[2].numChildren; i++)
			{
				var c = mapView.scenes[2].getChildAt( i );
				c.container.mouseEnabled = b;				
				c.container.alpha 		 = b ? 1 : 0.6;
				if(c.container.hasEventListener(MouseEvent.CLICK)) c.container.buttonMode	 = b;
			}
		}
		
		//--------------------------------
		// Zoom do mapa
		//--------------------------------
		
		public function GetZoom()
		{
			return mapView.currentZoom;
		}
		
		public function IsZooming()
		{
			return zooming;
		}
				
		public function ZoomIn()
		{
			zooming = true;
			TweenLite.to( mapView, 0.4, {currentZoom: mapView.currentZoom+ZOOM_FACTOR, onComplete: EndZoom});
		}
		
		public function ZoomOut()
		{
			zooming = true;
			TweenLite.to( mapView, 0.4, {currentZoom: mapView.currentZoom-ZOOM_FACTOR, onComplete: EndZoom});
		}
		
		public function SetZoom( zoom )
		{
			zooming = true;
			TweenLite.to( mapView, 0.4, {currentZoom: zoom, onComplete: EndZoom});
		}
		
		public function EndZoom()
		{
			zooming = false;
		}
		
		//-----------------------------
		// Úteis
		//-----------------------------
		
		public function CelulaParaISO( point )
		{
			var pos = new Point( point.x * FaseRender.CELL_SIZE, point.y * FaseRender.CELL_SIZE );
			return pos;
		}
	}
}