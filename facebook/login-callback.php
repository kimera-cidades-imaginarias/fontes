<?php
  
  //error_reporting(E_ALL);
  //ini_set("display_errors", 1);

  session_start();

  require_once('facebook-php-sdk-v4-5.0-dev/src/Facebook/autoload.php');

  $fb = new Facebook\Facebook([
    'app_id' => '649094798460813',
    'app_secret' => '3fed1ccadef808154d441d4c13055af0',
    'default_graph_version' => 'v2.4',
  ]);
  
  $helper = $fb->getRedirectLoginHelper();

  try {
    $accessToken = $helper->getAccessToken();
  } catch(Facebook\Exceptions\FacebookResponseException $e) {
    // When Graph returns an error
    var_dump($helper->getError());
    echo 'Graph returned an error: ' . $e->getMessage();
    exit;
  } catch(Facebook\Exceptions\FacebookSDKException $e) {
    // When validation fails or other local issues
   echo 'Facebook SDK returned an error: ' . $e->getMessage();
   exit;
  }

  if (isset($accessToken)) 
  {
    $_SESSION['facebook_access_token'] = (string) $accessToken;

    // Now you can redirect to another page and use the
    // access token from $_SESSION['facebook_access_token']

    header('Location: index.php');
  }