<?php
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of jogos_controller
 *
 * @author Administrador
 */
class ContatosController extends AppController {
    var $name       = 'Contatos';
    var $helpers    = array('Html', 'Session');
    var $components = array('Email');

    function index()
    {
        $this->layout = 'site';
        $this->set('title_for_layout', 'Ludens - Cadastre-se e use gratuitamente!');
                 
        $this->set('current_page', 'contato');
        $this->set('noticias', $this->get_posts());

        if (!empty($this->data['Contato']))
        {
            $this->Contato->create($this->data);
            if ($this->Contato->validates()) {
                $this->Email->from    = $this->data['Contato']['nome'] . 
                                        ' <' . $this->data['Contato']['email'] . '>';
                $this->Email->to      = 'Comunidades Virtuais <contato@comunidadesvirtuais.pro.br>';
                $this->Email->subject = '[Ludens] Mensagem de ' . $this->data['Contato']['nome'];
                
                if ($this->Email->send($this->data['Contato']['mensagem']))
                {
                    $this->Session->setFlash('Mensagem enviada com sucesso.');
                }
                else
                {
                    $this->Session->setFlash('Ocorreu um erro ao enviar a mensagem. Tente novamente mais tarde ou entre em contato direto pelo endereço contato@comunidadesvirtuais.pro.br.');
                }
            }
        }
    }
}
?>
