<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/8/31
 * Time: 上午10:25
 */
include_once('../include.php');
include_once('../include/saveFile.php');
header('Access-Control-Allow-Methods:OPTIONS, GET, POST, PUT, DELETE');
if (in_array($_SERVER['HTTP_ORIGIN'], array(
    'http://dev.tablehub.cn:8080', 'http://dev.tablehub.cn:8081'
))) {
    header('Access-Control-Allow-Origin:' . $_SERVER['HTTP_ORIGIN']);
}

header('Access-Control-Allow-Credentials:true');

$userInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
/*
| appFile | CREATE TABLE `appFile` (
`id` int(11) NOT NULL AUTO_INCREMENT,
  `app_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `ctime` datetime NOT NULL,
  `utime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `data` mediumtext NOT NULL,
  `author` int(11) NOT NULL,
)
*/
$method = $_SERVER['REQUEST_METHOD'];
if ($method === 'GET') {
    if ($_GET['id']) {
        echo json_encode(current(appFileApi::create()->getList(array(
            'id' => intval($_GET['id']),
            'author' => $userInfo['id']
        ))));
    } else {
        echo json_encode(appFileApi::create()->getList(array(
            'app_id' => intval($_GET['appType']),
            'author' => $userInfo['id']
        )));
    }
} else if ($method === 'POST') {
    $result = appFileApi::create()->insert(array(
        'app_id' => intval($_POST['appType']),
        'title' => $_POST['title'],
        'ctime' => date('Y-m-d H:i:s'),
        'file_data' => '{}',
        'var_data' => '{}',
        'widget_id_to_var' => '{}',
        'author' => $userInfo['id']
    ));
    echo $result;
} else if ($method === 'PUT') {
    $_PUT = array();
    parse_str(file_get_contents('php://input'), $_PUT);
    echo json_encode(appFileApi::create()->update(array(
        'id' => intval($_PUT['id']),
        'author' => $userInfo['id']
    ), array(
        'file_data' => $_PUT['file_data'],
        'var_data' => $_PUT['allVar'],
        'widget_id_to_var' => $_PUT['widgetIdToVar']
    )));
} else if ($method === 'DELETE') {
    $_DELETE = array();
    parse_str(file_get_contents('php://input'), $_DELETE);
    echo json_encode(appFileApi::create()->delete(array(
        'id' => intval($_DELETE['id']),
        'author' => intval($userInfo['id'])
    )));
}
exit;

var_dump($result);
if ($result) {
    echo '1';
} else {
    echo '-1';
}
exit;