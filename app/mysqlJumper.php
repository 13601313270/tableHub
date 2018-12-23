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
    foreach ($datasourceTypeList as $k => $v) {
        if (intval($v['id']) === intval($_PUT['type'])) {
            $insertInfo = array();
            $fileKey = randStr(16);
            $dataTypeInfo = json_decode($_PUT['dataTypeInfo']);
            foreach ($v['column'] as $column) {
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
            $insert = array(
                'name' => $_PUT['name'],
                'type' => intval($_PUT['type']),
                'uid' => intval($userInfo['id']),
                'info' => $insertInfo
            );
            // 不同数据源类型判断逻辑
            if (intval($_PUT['type']) == 2) {
                try {
                    // 检查是否可以连接
                    $pdo = new PDO("mysql:host=" . $insert['info']['host'] . ";port=" . $insert['info']['info']['port'] . ";dbname=" . $insert['info']['db'], $insert['info']['username'], $insert['info']['password'], array());
                } catch (Exception $e) {
                    echo '密码不对';
                    exit;
                }
            } else if (intval($_PUT['type']) == 3) {
                $insert['info']['file']['dataTypeInfo'] = $_PUT['dataTypeInfo'];
            }
            $insert['info'] = json_encode($insert['info']);
            $result = connection::create()->insert($insert);
            echo json_encode($result);
            exit;
        }
    }
    exit;
} else if ($_SERVER['REQUEST_METHOD'] === 'DELETE') {
    parse_str(file_get_contents('php://input'), $_DELETE);
    $result = connection::create()->deleteById($_DELETE['id']);
    echo json_encode($result);
    exit;
}
$isFindConnection = false;
foreach ($allConnection as $k => $v) {
    if (intval($v['id']) === intval($_POST['connection'])) {
        $isFindConnection = true;
        $allConnection = $allConnection[$k];
        break;
    }
}
if ($isFindConnection && $allConnection['type'] === '2') {
    $allConnection = json_decode($allConnection['info']);
    // 端口
    try {
        $con = new PDO("mysql:host=" . $allConnection->host . ";dbname=" . $allConnection->db, $allConnection->username, $allConnection->password, array(
            PDO::MYSQL_ATTR_INIT_COMMAND => "set names " . KOD_COMMENT_MYSQLDB_CHARSET
        ));
    } catch (Exception $e) {
        exit;
    }

    $mysqlDBApi = new kod_db_mysqlDB($allConnection->db);

    class showCreateTable extends kod_db_mysqlSingle
    {
        function __construct()
        {
            $this->tableName = $_POST['table'];
            parent::__construct();
        }
    }

    $returnData = '';
    if ($_POST['type'] === 'showTables') {
        $dbHandle = new kod_db_mysqlDB();
        $returnData = $dbHandle->runsql('show tables', 'default', $con);
        $result = array();
        foreach ($returnData as $k => $v) {
            $result[] = array(
                'name' => current($v)
            );
        }
        echo json_encode($result);
        exit;
    } else if ($_POST['type'] === 'showCreateTable') {
        $returnData = showCreateTable::create()->showCreateTable();
    } else if ($_POST['type'] === 'run') {
        $returnData = showCreateTable::create()->sql()->getList($_POST['sql']);
        $returnData = $mysqlDBApi->runsql($returnData, $con);
        foreach ($returnData as $k => $dataItem) {
            foreach ($dataItem as $key => $v) {
                if (preg_match('/[count|sum]\(/', $key, $match)) {
                    $returnData[$k][$key] = intval($returnData[$k][$key]);
                }
            }
        }
    }
    echo json_encode($returnData);
    exit;
} elseif ($isFindConnection && $allConnection['type'] === '3') {
    if ($_POST['type'] === 'showTables') {
        echo json_encode(array(
            array('name' => '文件')
        ));
        exit;
    } else if ($_POST['type'] === 'showCreateTable') {
        $allConnection = json_decode($allConnection['info']);
        $result = array();
        $dataTypeInfo = json_decode($allConnection->file->dataTypeInfo);
        foreach ($allConnection->file->column as $k => $v) {
            if ($dataTypeInfo->$v) {
                $result[$v] = array(
                    'dataType' => $dataTypeInfo->$v,
                    'title' => $v
                );
            } else {
                $result[$v] = array(
                    'dataType' => 'varchar',
                    'title' => $v
                );
            }
        }
        echo json_encode($result);
        exit;
    } else if ($_POST['type'] === 'run') {
        $manager = new MongoDB\Driver\Manager("mongodb://root:2h2o==2h2+o2@dds-m5e1e332182fc054-pub.mongodb.rds.aliyuncs.com:3717/admin");
        $info = json_decode($allConnection['info']);

        $ss = array(
            '_id' => array($_POST['sql']['groupBy'] => '$' . $_POST['sql']['groupBy'])
        );
        foreach ($_POST['sql']['select'] as $k => $v) {
            if (preg_match('/(count|sum)\((\S+)\)/', $v, $match)) {
                $funcName = array(
                    'count' => 'sum'
                )[$match[1]];
                if ($funcName === null) {
                    $funcName = $match[1];
                }
                $ss[$v] = ['$' . $funcName => '$' . $match[2]];
            }
        }
        $cmd = new \MongoDB\Driver\Command([
            'aggregate' => $info->file->fileKey,
            'pipeline' => [
                array(
                    '$group' => $ss
                )
            ]
        ]);
        $rows = $manager->executeCommand('csv', $cmd);
        foreach ($rows as $r) {
            if ($r->ok) {
                print_r($r->result);
                exit;
            }
        }
        exit;
    }
}