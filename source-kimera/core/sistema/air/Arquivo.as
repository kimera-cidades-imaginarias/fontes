package core.sistema.air
{
	import flash.filesystem.File;
	import flash.filesystem.*;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;

	public class Arquivo
	{
		public static function GetSeparador()
		{
			return File.separator;
		}

		public static function GetQuebraLinha() : String
		{
			if(Capabilities.os == "Linux") return "\n";
			else if(Capabilities.os == "MacOS") return "\r";
			else return "\r\n";
		}
		
		public static function LerConteudoArquivo(path: String, local: Boolean = true) : String
		{
			
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var arquivo			: File = pastaAplicacao.resolvePath(path);
			
			var stream:FileStream 	= new FileStream();
			stream.open(arquivo, FileMode.READ);
			var r = stream.readUTFBytes(stream.bytesAvailable); 
			stream.close();
			
			return r;
		}
		
		public static function EscreverArquivo(path: String, conteudo: String, local: Boolean = true)
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var arquivo			: File = pastaAplicacao.resolvePath(path);
			
			var stream:FileStream 	= new FileStream();
			stream.open(arquivo, FileMode.WRITE);
			stream.writeUTFBytes(conteudo);
			//stream.writeMultiByte(conteudo, "utf-8");
			stream.close();
		}

		public static function EscreverArquivoBytes(path: String, conteudo: ByteArray, local: Boolean = true)
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var arquivo			: File = pastaAplicacao.resolvePath(path);
			
			var stream:FileStream 	= new FileStream();
			
			stream.open(arquivo, FileMode.WRITE);
			stream.writeBytes(conteudo);
			stream.close();
		}

		public static function DeletarArquivo(path: String, local: Boolean = true)
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var arquivo			: File = pastaAplicacao.resolvePath(path);

			arquivo.deleteFile(); 
		}
		
		public static function GetPastaAplicacao(local: Boolean = true) : String
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			return pastaAplicacao.nativePath + GetSeparador();
		}
		
		public static function GetArquivosPasta(path: String, exts: Array, local: Boolean = true) : Array
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var pasta 			: File = pastaAplicacao.resolvePath(path);
			
			var resultado = new Array();

			if (pasta.exists)
			{
				var arquivos = pasta.getDirectoryListing();
				for (var i = 0; i < arquivos.length; i++)
				{
					for (var i2 = 0; i2 < exts.length; i2++)
					{
						if (arquivos[i].extension &&
							arquivos[i].extension.toLowerCase() == exts[i2].toLowerCase())
						{
							resultado.push(arquivos[i].name);
							break;
						}
					}
				}
			}

			return resultado;
		}
		
		public static function GetPastasPasta(path: String, local: Boolean = true)
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var pasta 			: File = pastaAplicacao.resolvePath(path);
			var resultado = new Array();
			
			if (pasta.exists)
			{
				var arquivos = pasta.getDirectoryListing();
				for (var i = 0; i < arquivos.length; i++)
				{
					if ( arquivos[i].isDirectory )
					{
						resultado.push(arquivos[i].name);
					}
				}
			}
			return resultado;			
		}
		
		public static function ExistePasta(path: String, local: Boolean = true) : Boolean
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var pasta 			: File = pastaAplicacao.resolvePath(path);
			
			return pasta.exists;
		}
		
		public static function ExisteArquivo(path: String, local: Boolean = true) : Boolean
		{
			if(local) { var pastaAplicacao	: File = File.applicationDirectory; } else { var pastaAplicacao	: File = File.documentsDirectory; }

			var arquivo 		: File = pastaAplicacao.resolvePath(path);
			
			return arquivo.exists;	
		}
	}
}