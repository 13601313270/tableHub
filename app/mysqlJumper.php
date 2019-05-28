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
if ($userInfo === false) {
    exit;
}
function getObjByFormData($content)
{
    $content = str_replace("\r\n", "\n", $content);
    preg_match('/(------(.+))\n/', $content, $key);
    $key = $key[1];
    $content = str_replace($key . '--', $key, $content);
    $PUT = explode($key, $content);
    array_shift($PUT);
    array_pop($PUT);
    $_PUT = array();
    foreach ($PUT as $k => $v) {
        preg_match('/^\\n((.+?\\n)+)\\n([\s|\S]*?)\\n$/', $v, $matchName);
        preg_match('/ name=\"(.*?)\"/', $matchName[1], $key);
        $_PUT[$key[1]] = $matchName[3];
    }
    return $_PUT;
}

function randStr($len)
{
    $chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    $string = time();
    for (; $len >= 1; $len--) {
        $position = rand() % strlen($chars);
        $position2 = rand() % strlen($string);
        $string = substr_replace($string, substr($chars, $position, 1), $position2, 0);
    }
    return $string;
}
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    $content = file_get_contents('php://input');
    $_PUT = getObjByFormData($content);

    $isFindConnection = false;
    foreach ($allConnection as $k => $v) {
        if (intval($v['id']) === intval($_PUT['id'])) {
            $isFindConnection = true;
            $allConnection = $allConnection[$k];
            break;
        }
    }
    $allConnection = json_decode($allConnection['info'], true);
    foreach ($datasourceTypeList as $k => $v) {
        if (intval($v['id']) === intval($_PUT['type'])) {
            $insertInfo = array();
            $fileKey = randStr(16);
            $dataTypeInfo = json_decode($_PUT['dataTypeInfo']);
            $class = 'datasource_' . $v['name'];
            foreach ($class::$column as $column) {
                if ($column['type'] === 'File') {
                    $step = $_PUT[$column['name']];
                    $step = explode("\n", $step);
                    $split = ',';
                    $fileColumn = explode($split, $step[0]);//字段
                    for ($i = count($fileColumn) - 1; $i >= 0; $i--) {
                        if ($fileColumn[$i] === '') {
                            unset($fileColumn[$i]);
                        }
                    }
                    array_shift($step);
                    $bulk = new MongoDB\Driver\BulkWrite;
                    foreach ($step as $kk => $vv) {
                        $stepItem = explode(",", $vv);
                        $insert = array();
                        foreach ($fileColumn as $kkk => $vvv) {
                            if ($dataTypeInfo->$vvv === 'number') {
                                $insert[$vvv] = floatval($stepItem[$kkk]);
                            } else {
                                $insert[$vvv] = strval($stepItem[$kkk]);
                            }
                        }
                        $bulk->insert($insert);
                    }
                    $manager = new MongoDB\Driver\Manager("mongodb://root:2h2o==2h2+o2@dds-m5e1e332182fc054-pub.mongodb.rds.aliyuncs.com:3717/admin");
                    $manager->executeBulkWrite('csv.' . $fileKey, $bulk);
                    $step = array(
                        'column' => $fileColumn,
                        'fileKey' => $fileKey
                    );
                } else if ($column['type'] === 'Number') {
                    $step = intval($_PUT[$column['name']]);
                } else {
                    $step = $_PUT[$column['name']];
                }
                $insertInfo[$column['name']] = $step;
            }
            if($_PUT['action'] === 'insertData'){
                $manager = new MongoDB\Driver\Manager("mongodb://root:2h2o==2h2+o2@dds-m5e1e332182fc054-pub.mongodb.rds.aliyuncs.com:3717/admin");
                $bulk = new MongoDB\Driver\BulkWrite;
                $bulk->insert(json_decode($_PUT['data'], true));
                $writeConcern = new MongoDB\Driver\WriteConcern(MongoDB\Driver\WriteConcern::MAJORITY, 1000);//可选，修改确认
                $res = $manager->executeBulkWrite($v['name'] . '.' . intval($_PUT['id']), $bulk, $writeConcern);
                echo $res->getInsertedCount();
            } else {
                $insert = array(
                    'name' => $_PUT['name'],
                    'type' => intval($_PUT['type']),
                    'uid' => intval($userInfo['id']),
                    'info' => $insertInfo
                );
                $sourceObj = new $class($allConnection,$_PUT['id']);
                $insert['info'] = $sourceObj->beforeSave($insert['info'], $_PUT);
                $insert['info'] = json_encode($insert['info']);
                $result = connection::create()->insert($insert);
                echo json_encode($result);
            }
            exit;
        }
    }
    exit;
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    parse_str(file_get_contents('php://input'), $_DELETE);
    $result = connection::create()->getByKey($_DELETE['id']);
    $connecctionInfo = json_decode($result['info'], true);

    $type = intval($result['type']);
    foreach ($datasourceTypeList as $k => $v) {
        if ($v['id'] === $type) {
            $class = 'datasource_' . $v['name'];
        }
    }
    $sourceObj = new $class($connecctionInfo);
    $sourceObj->beforeDelete();
    $result = connection::create()->deleteById($_DELETE['id']);
    echo json_encode($result);
    exit;
}
$type = intval($allConnection['type']);
foreach ($datasourceTypeList as $k => $v) {
    if ($v['id'] === $type) {
        $class = 'datasource_' . $v['name'];
    }
}
$sourceObj = new $class($allConnection);
if ($sourceObj->check($allConnection)) {
    $returnData = '';
    if ($_POST['type'] === 'showTables') {
        $returnData = $sourceObj->showTables();
    } else if ($_POST['type'] === 'showCreateTable') {
        $returnData = $sourceObj->showCreateTable();
//            [dataType] => int
//            [maxLength] => 11
//            [notNull] => 1
//            [title] => id
//            [AUTO_INCREMENT] => 1
//            [primarykey] => 1
    } else if ($_POST['type'] === 'run') {
        $returnData = $sourceObj->run($_POST['sql']);
    }
    echo json_encode($returnData);
    exit;
} else {
    exit;
}
