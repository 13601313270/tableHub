<?php

/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/25
 * Time: 10:34 AM
 */
class datasource_gd implements datasourceInterface
{
    static public $column = array(
        array(
            'title' => 'google授权',
            'name' => 'token',
            'type' => 'token',
            'tokenUrl' => 'https://accounts.google.com/o/oauth2/v2/auth?' .
                'scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.metadata.readonly%20https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&' .
                'access_type=offline&' .
                'state=state_parameter_passthrough_value&' .
                'redirect_uri=http%3A%2F%2Fwww.tablehub.cn%2FgdCallback.html&' .
                'response_type=code&' .
                'prompt=consent&' .
                'client_id=590141428668-nibaa0dtep92f89umnepae9cv9b68goa.apps.googleusercontent.com'
        )
    );
    private $config = array();
    private $id = null;

    function __construct($insertInfo, $id = 0)
    {
        $this->config = $insertInfo;
        $this->id = $id;
    }

    public function beforeSave($insertData, $post)
    {
        return $insertData;
    }

    public function check()
    {
        return true;
    }

    public function updateAccessTokenByRefreshToken()
    {
        $content = file_get_contents('http://47.254.19.157/gdCallbackGetToken.html?refresh_token=' . $this->config['refresh_token'] . "&grant_type=refresh_token");
        $result = json_decode($content, true);
        connection::create()->update(array(
            'id' => intval($this->id)
        ), array(
            'info' => json_encode(array(
                'access_token' => $result['access_token'],
                'refresh_token' => $this->config['refresh_token'],
            ))
        ));
        $this->config['access_token'] = $result['access_token'];
    }

    public function showTables()
    {
        $content = file_get_contents('http://47.254.19.157/restForGD.html?type=list&token=' . $this->config['access_token']);
        $result = json_decode($content, true);
        if (isset($result['files'])) {
            return $result['files'];
        } else if (isset($result['error']) && $result['error']['code'] === 401) {
            $this->updateAccessTokenByRefreshToken();
            $content = file_get_contents('http://47.254.19.157/restForGD.html?type=list&token=' . $this->config['access_token']);
            $result = json_decode($content, true);
            return $result['files'];
        }
        print_r($result);
    }

    public function showCreateTable()
    {
        $content = file_get_contents('http://47.254.19.157/restForGD.html?type=file&file=' . $_POST['table'] . '&token=' . $this->config['access_token']);
        var_dump($content);
        $result = json_decode($content, true);
        print_r($result);
        return $result;
        $result = array();
        $dataTypeInfo = json_decode($this->config['file']['dataTypeInfo']);
        foreach ($this->config['file']['column'] as $k => $v) {
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
        return $result;
    }

    // 执行查询
    public function run($sql)
    {
        $manager = new MongoDB\Driver\Manager("mongodb://root:2h2o==2h2+o2@dds-m5e1e332182fc054-pub.mongodb.rds.aliyuncs.com:3717/admin");
        $group = array(
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
                if ($match[1] === 'count') {
                    $group[$v] = ['$' . $funcName => 1];
                } else {
                    $ss[$v] = ['$' . $funcName => '$' . $match[2]];
                }
            }
        }
        $cmd = new \MongoDB\Driver\Command([
            'aggregate' => $this->config['file']['fileKey'],
            'pipeline' => [
                array(
                    '$group' => $group
                )
            ]
        ]);
        $rows = $manager->executeCommand('csv', $cmd);
        foreach ($rows as $r) {
            if ($r->ok) {
                $returnData = array();
                foreach ($r->result as $dataItem) {
                    $item = array();
                    $group = $_POST['sql']['groupBy'];
                    $item[$group] = $dataItem->_id->Name;
                    foreach ($_POST['sql']['select'] as $select) {
                        if ($select !== $group) {
                            $item[$select] = $dataItem->$select;
                        }
                    }
                    $returnData[] = $item;
                }
                echo json_encode($returnData);
                exit;
            }
        }
        exit;
    }

    public function beforeDelete()
    {
        try {
            $manager = new MongoDB\Driver\Manager("mongodb://root:2h2o==2h2+o2@dds-m5e1e332182fc054-pub.mongodb.rds.aliyuncs.com:3717/admin");
            $cmd = new \MongoDB\Driver\Command([
                'drop' => $this->config['file']['fileKey']
            ]);
            $manager->executeCommand('csv', $cmd);
        } catch (Exception $e) {

        }
    }
}