package core.pathfinding.astar {
	
	//A* specific imports
	import core.pathfinding.astar.Astar;
	import core.pathfinding.astar.INode;
	import core.pathfinding.astar.ISearchable;
	import core.pathfinding.astar.SearchResults;
	import core.pathfinding.astar.Path;
	
	//other
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Grid implements ISearchable
	{
		private var nodes	: Array;
		private var cols	: int;
		private var rows	: int;
		private var costs	: Object;

		public function Grid() 
		{
			nodes = new Array();
			costs = new Object();
			
			costs["walkable_walkable"] 			= 1;
			costs["walkable_notwalkable"] 		= Number.MAX_VALUE;
			costs["notwalkable_notwalkable"] 	= Number.MAX_VALUE;			
			costs["notwalkable_walkable"] 		= Number.MAX_VALUE;						
			
			/*
			costs["waterfire"] = Number.MAX_VALUE;
			costs["wallfire"] = Number.MAX_VALUE;
			costs["grassfire"] = Number.MAX_VALUE;
			costs["bridgefire"] = Number.MAX_VALUE;
			*/
		}

		public function loadGrid(costsMatrix: Array)
		{
			for (var i:int=0; i < costsMatrix.length; i++) {
				
				var line = costsMatrix[i];
				nodes[i] = new Array();
				
				for (var j:int=0; j<line.length; j++) {
					var n 		= new Node(i, j);
					//if (line[j]) n.setNodeType("notwalkable");
					//else		 n.setNodeType("walkable");
					if (line[j] == 2) n.setNodeType("walkable");
					else n.setNodeType("notwalkable");
					
					n.setNodeId(i + "_" + j);
					
					nodes[i][j] = n;
				}
			}
		}

		public function getNodeTransitionCost(n1:INode, n2:INode):Number 
		{
			var cost:Number;
			if (costs[n1.getNodeType() + "_" +  n2.getNodeType()] != null) {
				cost = costs[n1.getNodeType() + "_" + n2.getNodeType()];
			} else {
				trace("Error: transition cost not found for " + n1.getNodeType() + " to " + n2.getNodeType());
				cost = Number.MAX_VALUE;
			}
			return cost;
		}
		
		public function search(from	: Point,
							   to	: Point):Array {
			
			var startDate:Date 	= new Date();
			var astar:Astar 	= new Astar(this);
			var startTile		= nodes[from.x][from.y];
			var goalTile		= nodes[to.x][to.y];			
			
			var results:SearchResults = astar.search(INode(startTile), INode(goalTile));
			var resultPoints = new Array();
			
			if (results.getIsSuccess()) {
				//trace("success");
				var path:Path = results.getPath();
				for (var i:int=0;i<path.getNodes().length;++i) {
					var node = path.getNodes()[i];
					resultPoints.push( new Point(node.getCol(), node.getRow()));
					//trace(node.getCol() + ", " + node.getRow() + "\n");
				}
			}
			
			var endDate		:Date 	= new Date();
			var totalTime	:Number = endDate.valueOf()-startDate.valueOf();
			return resultPoints;
			//return results;
		}
		
		public function getNode(col:int, row:int):INode {
			return nodes[col][row];
		}

		public function getCols():int {
			return nodes.length;
		}
		public function getRows():int {
			return nodes[0].length;
		}
	}
	
}
