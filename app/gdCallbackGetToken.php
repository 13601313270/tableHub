<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
// 创建一个新cURL资源
$ch = curl_init();

// 设置URL和相应的选项
curl_setopt($ch, CURLOPT_HEADER, 0);
$url = 'https://www.googleapis.com/oauth2/v4/token';

if ($_GET['grant_type'] === 'authorization_code') {
    $sentData = array(
        'code' => $_GET['code'],
        'client_id' => '590141428668-nibaa0dtep92f89umnepae9cv9b68goa.apps.googleusercontent.com',
        'access_type' => 'offline',
        'client_secret' => 'fiSVQWVLsqTPQM_xfo6xF-nQ',
        'redirect_uri' => 'http://www.tablehub.cn/gdCallback.html',
        'grant_type' => $_GET['grant_type']
    );
} else if ($_GET['grant_type'] === 'refresh_token') {
    $sentData = array(
        'client_id' => '590141428668-nibaa0dtep92f89umnepae9cv9b68goa.apps.googleusercontent.com',
        'client_secret' => 'fiSVQWVLsqTPQM_xfo6xF-nQ',
        'refresh_token' => $_GET['refresh_token'],
        'grant_type' => $_GET['grant_type']
    );
}

curl_setopt_array($ch, [
    CURLOPT_CUSTOMREQUEST => 'POST',
    CURLOPT_URL => $url,
    CURLOPT_HTTPHEADER => array(//"Content-type: application/x-www-form-urlencoded"
    ),
    CURLOPT_POST => true,
    CURLOPT_POSTFIELDS => $sentData
]);

curl_exec($ch);
curl_close($ch);
exit;