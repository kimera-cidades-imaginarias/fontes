<?
    echo $session->flash('auth');
    echo $form->create('Administrador', array('action' => 'login'));
    echo $form->input('email'   , array('size' => 20));
    echo $form->input('password', array('size' => 20));
    echo $form->end('Login');
?>