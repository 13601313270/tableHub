<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
//国内
//header('HTTP/1.1 301 Moved Permanently');
//header('Location: http://47.254.19.157/gdCallbackGetToken.html?' . $_SERVER['QUERY_STRING']);


$ch = curl_init();
// 设置URL和相应的选项
curl_setopt($ch, CURLOPT_HEADER, 0);
$url = 'http://47.254.19.157/gdCallbackGetToken.html?' . $_SERVER['QUERY_STRING'];

$sentData = array(
    'code' => $_GET['code'],
    'client_id' => '590141428668-nibaa0dtep92f89umnepae9cv9b68goa.apps.googleusercontent.com',
    'access_type' => 'offline',
    'client_secret' => 'fiSVQWVLsqTPQM_xfo6xF-nQ',
    'redirect_uri' => 'http://www.tablehub.cn/gdCallback.html',
    'grant_type' => 'authorization_code'
);
curl_setopt_array($ch, [
    CURLOPT_URL => $url,
]);

$data = curl_exec($ch);
curl_close($ch);
var_dump($data);
exit;