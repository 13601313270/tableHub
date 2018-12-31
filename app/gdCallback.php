<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
print_r($_GET);

require_once '../include/google-api-php-client-2.2.2/vendor/autoload.php';
//session_start();

$client = new Google_Client();
//$client->setAuthConfigFile('client_secrets.json');
//$client->setRedirectUri('http://' . $_SERVER['HTTP_HOST'] . '/oauth2callback.php');
$client->addScope(Google_Service_Drive::DRIVE_METADATA_READONLY);


$client->authenticate($_GET['code']);
var_dump($client->getAccessToken());
//    $_SESSION['access_token'] = $client->getAccessToken();
//    $redirect_uri = 'http://' . $_SERVER['HTTP_HOST'] . '/';
//    header('Location: ' . filter_var($redirect_uri, FILTER_SANITIZE_URL));