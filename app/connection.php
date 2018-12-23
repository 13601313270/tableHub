<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/3/27
 * Time: 下午5:59
 */
include_once('../include.php');
include_once('datasourceTypeList.php');
header('Access-Control-Allow-Methods:OPTIONS, GET, POST, PUT, DELETE');
// 指定允许其他域名访问
if (in_array($_SERVER['HTTP_ORIGIN'], array(
    'http://dev.tablehub.cn:8080', 'http://dev.tablehub.cn:8081'
))) {
    header('Access-Control-Allow-Origin:' . $_SERVER['HTTP_ORIGIN']);
}
header("Access-Control-Allow-Credentials: true");
header("access-control-expose-headers: Authorization");


$userInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
$allConnection = connection::create()->getList(array(
    'uid' => intval($userInfo['id'])
));

if ($_POST['type'] === 'getConnections') {
    foreach ($allConnection as $k => $v) {
        $allConnection[$k]['info'] = json_decode($allConnection[$k]['info']);
        unset($allConnection[$k]['info']->password);
    }
    echo json_encode(array(
        'dataSource' => $datasourceTypeList,
        'connection' => $allConnection
    ));
    exit;
} else if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    parse_str(file_get_contents('php://input'), $_PUT);
    $insert = array(
        'name' => $_PUT['name'],
        'type' => $_PUT['type'],
        'uid' => intval($userInfo['id']),
        'info' => array(
            'host' => $_PUT['host'],
            'port' => intval($_PUT['port']),
            'username' => $_PUT['username'],
            'password' => $_PUT['password'],
            'db' => $_PUT['db']
        )
    );
    try {
        // 检查是否可以连接
        $pdo = new PDO("mysql:host=" . $insert['info']['host'] . ";port=" . $insert['info']['info']['port'] . ";dbname=" . $insert['info']['db'], $insert['info']['username'], $insert['info']['password'], array());
        // 保存
        $insert['info'] = json_encode($insert['info']);
        $result = connection::create()->insert($insert);
        echo json_encode($result);
        exit;
    } catch (Exception $e) {
        echo '密码不对';
        exit;
    }

    exit;
} else if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $insert = array(
        'name' => $_POST['data']['name'],
        'type' => $_POST['data']['type'],
        'uid' => intval($userInfo['id']),
        'info' => array(
            'host' => $_POST['data']['host'],
            'port' => intval($_POST['data']['port']),
            'username' => $_POST['data']['username'],
            'password' => $_POST['data']['password'],
            'db' => $_POST['data']['db']
        )
    );
    // print_r($insert);exit;
    try {
        // 检查是否可以连接
        $pdo = new PDO("mysql:host=" . $insert['info']['host'] . ";port=" . $insert['info']['info']['port'] . ";dbname=" . $insert['info']['db'], $insert['info']['username'], $insert['info']['password'], array());
        // 保存
        $insert['info'] = json_encode($insert['info']);
        $result = connection::create()->update('id=' . intval($_POST['id']), $insert);
        echo json_encode($result);
        exit;
    } catch (Exception $e) {
        echo '密码不对';
        exit;
    }

    exit;
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    parse_str(file_get_contents('php://input'), $_DELETE);
    $result = connection::create()->deleteById($_DELETE['id']);
    echo json_encode($result);
    exit;
}
