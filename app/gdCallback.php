<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
//国内;
header('Access-Control-Allow-Methods:OPTIONS, GET, POST, PUT, DELETE');
// 指定允许其他域名访问
header('Access-Control-Allow-Origin: *');
header("Access-Control-Allow-Credentials: true");
header("access-control-expose-headers: Authorization");

$token = json_decode(file_get_contents('http://47.254.19.157/gdCallbackGetToken.html?' . $_SERVER['QUERY_STRING']), true);
if ($token['access_token']) {
    $userInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
    $insertInfo = array(
        'access_token' => $token['access_token'],
        'refresh_token' => $token['refresh_token'],
    );
    $sourceObj = new datasource_gd($insertInfo);
    $insert = array(
        'name' => 'gd的名称',
        'type' => 4,
        'uid' => intval($userInfo['id']),
        'info' => $insertInfo
    );
    $insert['info'] = $sourceObj->beforeSave($insert['info'], array());
    $insert['info'] = json_encode($insert['info']);
    $result = connection::create()->insert($insert);
    echo json_encode($result);
} else {
    // 随便定了格式
    echo json_encode(array('err' => true));
}
exit;
