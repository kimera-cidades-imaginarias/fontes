<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of genres_controller
 *
 * @author Administrador
 */
class BannersController extends AppController {
    var $name       = 'Banners';
    var $scaffold   = 'admin';
   
    function admin_add()
    {
        if(!empty($this->data))
        {
            if ($this->Banner->save($this->data))
            {
                $this->Session->setFlash('Banner gravado com sucesso.');
                $this->redirect(array('controller' => 'banners', 'action' => 'index'));
            }
        }
    }

    function admin_edit($id = null)
    {
        $this->Banner->id = $id;
	if (empty($this->data)) {            
            $this->data             = $this->Banner->read();
	} else {
            if ($this->Banner->save($this->data))
            {   
                $this->Session->setFlash('Banner gravado com sucesso.');
                $this->redirect(array('controller' => 'banners', 'action' => 'index'));
            }
	}
    }

    function admin_delete($id)
    {
        $banner = $this->Banner->findById($id);

        unlink($banner['Banner']['arquivo']);
        $this->Banner->delete($id);

        $this->Session->setFlash('Banner removido com sucesso.');
        $this->redirect(array('controller' => 'banners', 'action' => 'index'));
    }
   
    //--------------------------------------------------------------------------

    function listar()
    {
        $this->layout = 'ajax';
        $this->set( 'banners',
                    $this->Banner->find('all',
                                        array('conditions' => array('ativo' => '1'),
                                              'order' => array('ordem'))));
    }
}
?>
