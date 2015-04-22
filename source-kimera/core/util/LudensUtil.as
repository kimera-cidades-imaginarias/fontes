package core.util
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.URLRequestMethod;
	
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;

	import core.util.EventoLudens;
	import core.sistema.air.Arquivo;
	
	import com.adobe.serialization.json.JSON;

	import com.kimera.KimeraGame;
	
	public class LudensUtil extends EventDispatcher
	{
		const MAX_TENTATIVAS = 3;
		
		private var codigoJogo = '';
		private var url	= '';
		private var metodoAutenticacao = '';
		private var session_id = '';
		
		private var metodoRegistro ;
		private var arquivoRegistro; 
		
		private var filaRegistros;
		
		public function LudensUtil(pCodigoJogo, pMetodoRegistro = 'site')
		{
			trace('-> ludens: ' + pCodigoJogo + ' ' + pMetodoRegistro);

			codigoJogo	   = pCodigoJogo;
			metodoRegistro = pMetodoRegistro;
			arquivoRegistro= Arquivo.GetPastaAplicacao() + 'ludens.dat';
			
			
			if (metodoRegistro == 'site')
			{
				filaRegistros = new Array();
			}
			else
			{
				if (!Arquivo.ExisteArquivo(arquivoRegistro))
				{
					Arquivo.EscreverArquivo( arquivoRegistro, '$CODIGO::KIMERA' + Arquivo.GetQuebraLinha() );
				}
			}
		}
		
		public function Conectar(url, 
								 metodoAutenticacao, 
								 usuario, 
								 senha)
		{
			trace('[LudensUtil] Conectando: ' + codigoJogo + ', ' + url + ', ' + metodoAutenticacao +  ', ' + usuario + ', ' + senha);
			
			this.codigoJogo 		= codigoJogo;
			this.url 				= url;
			this.metodoAutenticacao = metodoAutenticacao;

			if (this.metodoAutenticacao == 'email')	Post({action: 'login', email: usuario, senha: senha}	, ConeccaoSucesso, ConeccaoFalha);
			else Post({action: 'login', matricula: usuario, senha: senha}, ConeccaoSucesso, ConeccaoFalha);
		}
		
		public function ConeccaoSucesso(evt)
		{
			var texto 	= evt.target.data;
			var obj 	= texto; //remover essa linha para ludens
			//var obj 	= JSON.decode(texto);
	
			if (obj.erro == '1')
			{
				trace('[LudensUtil] Usuário/senha inválidos.');
				dispatchEvent( new EventoLudens(EventoLudens.FALHA_LOGIN, {msg: 'Usuário/senha inválidos.'}) );

				Game.getInstance().menu_mc.shacke();
			}
			else
			{
				trace('[LudensUtil] Conexão realizada com sucesso.');

				this.session_id = "" + obj.id + "";
				dispatchEvent( new EventoLudens(EventoLudens.SUCESSO_LOGIN, {msg: 'Conexão realizada com sucesso.', id: this.session_id}) );

				KimeraGame.getInstance().iniciarJogo(evt);
				Game.getInstance().menu_mc.ocultarLoader();
				Game.getInstance().menu_mc.ocultarLogin();
			}
		}
		
		public function ConeccaoFalha(evt)
		{
			trace('[LudensUtil] Não foi possível conectar ao servidor.');
			dispatchEvent( new EventoLudens(EventoLudens.FALHA_LOGIN, {msg: 'Não foi possível conectar ao servidor.'}) );
		}
		
		//-----------------------------------------------------------------------------
		public function Registrar(indicador, valor)
		{
			if (!IsConectado())
			{
				trace('[LudensUtil] Atenção: tentando registrar um indicador sem estar conectado!');
			}
			else
			{
				trace('[LudensUtil] Registrando ' + indicador + ' ' + valor + ' (' + this.session_id + ', ' + this.codigoJogo + ').');
				
				Post( {	action		: 'indicador', 
						id			: this.session_id, 
						codigo_jogo	: this.codigoJogo, 
						codigo_indicador: indicador,
						valor			: valor },
					  Sucesso,
					  Falha);
			}
		}
		
		public function Sucesso(evt)
		{
			var loader = evt.target;
			var i 	   = GetLoader(loader);

			trace('[LudensUtil] indicador enviado.');

			var parametros = filaRegistros[i].parametros;
			dispatchEvent( new EventoLudens(EventoLudens.SUCESSO_REGISTRO, {indicador: parametros.codigo_indicador, valor: parametros.valor}) );
			filaRegistros.splice(i, 1);
		}
		
		public function Falha(evt)
		{
			var loader = evt.target;
			var i 	   = GetLoader(loader);
			filaRegistros[i].tentativas++;

			trace('[LudensUtil] falha indicador enviado.');
			
			var parametros = filaRegistros[i].parametros;
			if (filaRegistros[i].tentativas < MAX_TENTATIVAS)
			{
				// Tenta novamente.
				loader.load(filaRegistros[i].request);
			}
			else
			{
				// Remove da fila.
				filaRegistros.splice(i, 1);
				dispatchEvent( new EventoLudens(EventoLudens.FALHA_REGISTRO, {indicador: parametros.codigo_indicador, valor: parametros.valor}) );				
			}
		}
		
		public function GetLoader(loader)
		{
			for (var i = 0; i < filaRegistros.length; i++)
			{
				if (filaRegistros[i].loader == loader) return i;
			}
			return -1;
		}
		
		//-----------------------------------------------------------------------------
		public function Desconectar()
		{
			trace('[LudensUtil] Desconectando...');
			if (!IsConectado())
			{
				trace('[LudensUtil] Atenção: tentando desconectar sem estar conectado!');
			}
			else
			{
				Post({action: 'logout', id: this.session_id});
				this.session_id = '';
			}
		}
		
		public function IsConectado()
		{
			return (this.session_id != '' || metodoRegistro == 'arquivo');
		}
		
		//-----------------------------------------------------------------------------
		
		function Post(parametros, callBackSucesso = null, callBackFalha = null)
		{
			if (metodoRegistro == 'site')
			{
				trace('[LudensUtil] Posting to ' + this.url);
				var variables 		= new URLVariables();
				for (var i in parametros) variables[i] = parametros[i];
				
				var request 	= new URLRequest(this.url);
				request.data 	= variables;
				request.method 	= URLRequestMethod.POST;
			
				var loader = new URLLoader();
				if (callBackSucesso != null) loader.addEventListener(Event.COMPLETE			, callBackSucesso);
				if (callBackFalha != null) 
				{
					loader.addEventListener(IOErrorEvent.IO_ERROR				, callBackFalha);
					loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR	, callBackFalha);
				}
				filaRegistros.push({parametros: parametros, loader: loader, request: request, tentativas: 0});
				loader.load(request);
			}
			else
			{
				trace('[LudensUtil] Saving to file ' + parametros.action);
				var linha;
				if (parametros.action == 'login')
				{
					linha = '';
					if (parametros.email != undefined) linha = '$ID::email::' + parametros.email + Arquivo.GetQuebraLinha();
					else linha = '$ID::matricula::' + parametros.matricula + Arquivo.GetQuebraLinha();
					
					Arquivo.EscreverArquivo( arquivoRegistro, linha);
					dispatchEvent( new EventoLudens(EventoLudens.SUCESSO_LOGIN, {msg: 'Conexão realizada com sucesso.', id: this.session_id}) );					
				}
				else if (parametros.action == 'indicador')
				{
					linha = parametros.codigo_indicador + '::' + parametros.valor + Arquivo.GetQuebraLinha();
					
					Arquivo.EscreverArquivo( arquivoRegistro, linha );					
					dispatchEvent( new EventoLudens(EventoLudens.SUCESSO_REGISTRO, {indicador: parametros.codigo_indicador, valor: parametros.valor}) );
				}
			}
		}
	}
}