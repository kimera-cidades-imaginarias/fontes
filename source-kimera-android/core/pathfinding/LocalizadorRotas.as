
package core.pathfinding
{
	import core.pathfinding.astar.Grid;
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class LocalizadorRotas
	{
		private var granularidade;		
		private var grid: Grid;
		private var mapaColisao_mc;
		private var matrizColisao;
		private static var localizadorRotas = null;
		
		private var dx;
		private var dy;		
				
		public function LocalizadorRotas(pMatriz)
		{
			this.matrizColisao 	= pMatriz;
			this.grid 			= new Grid();
			grid.loadGrid( this.matrizColisao );
		}
								
		public function GetRota(origem: Point, destino: Point)
		{
			var path = grid.search(origem, destino);
			return path;
		}
						
		private function ImprimirArray(array: Array)
		{
			for (var i = 0; i < array.length; i++) trace(array[i]);
		}
	}
}