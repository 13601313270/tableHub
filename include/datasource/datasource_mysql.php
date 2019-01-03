<?php

/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/24
 * Time: 5:09 PM
 */
class showCreateTable2 extends kod_db_mysqlSingle
{
    function __construct()
    {
        $this->tableName = $_POST['table'];
        parent::__construct();
    }
}

class datasource_mysql extends datasourceInterface
{
    private $con;
    private $config = array();

    function __construct($insertInfo)
    {
        $this->config = $insertInfo;
    }

    static public $column = array(
        // 下属工作要自己确认,jmeter
        array(
            'title' => 'host',
            'name' => 'host'
        ),
        array(
            'title' => '端口',
            'name' => 'port',
            'type' => 'Number',
            'default' => 3306
        ),
        array(
            'title' => '用户名',
            'name' => 'username'
        ),
        array(
            'title' => '密码',
            'name' => 'password'
        ),
        array(
            'title' => '数据库',
            'name' => 'db'
        )
    );

    //新建操作，在保存到库之前的最后操作
    function beforeSave($insertData, $post)
    {
        try {
            // 检查是否可以连接
            $pdo = new PDO("mysql:host=" . $this->config['host'] . ";port=" . $this->config['port'] . ";dbname=" . $this->config['db'], $this->config['username'], $this->config['password'], array());
        } catch (Exception $e) {
            echo '密码不对';
            exit;
        }
        return $insertData;
    }

    // 查询操作之前，检查是否有权限
    function check()
    {
        try {
            $this->con = new PDO("mysql:host=" . $this->config['host'] . ";prot=" . $this->config['port'] . ";dbname=" . $this->config['db'], $this->config['username'], $this->config['password'], array(
                PDO::MYSQL_ATTR_INIT_COMMAND => "set names " . KOD_COMMENT_MYSQLDB_CHARSET
            ));
            return true;
        } catch (Exception $e) {
            return false;
        }
    }

    function showTables()
    {
        $con = new PDO("mysql:host=" . $this->config['host'] . ";prot=" . $this->config['port'] . ";dbname=" . $this->config['db'], $this->config['username'], $this->config['password'], array(
            PDO::MYSQL_ATTR_INIT_COMMAND => "set names " . KOD_COMMENT_MYSQLDB_CHARSET
        ));
        $dbHandle = new kod_db_mysqlDB();
        $returnData = $dbHandle->runsql('show tables', 'default', $con);
        $result = array();
        foreach ($returnData as $k => $v) {
            $result[] = array(
                'id' => current($v),
                'name' => current($v)
            );
        }
        return $result;
    }

    function showCreateTable()
    {
        $returnData = showCreateTable2::create()->showCreateTable();
        return $returnData;
    }

    function run($sql)
    {
        $mysqlDBApi = new kod_db_mysqlDB($this->config['db']);
        $returnData = showCreateTable2::create()->sql()->getList($sql);
        $returnData = $mysqlDBApi->runsql($returnData);
        foreach ($returnData as $k => $dataItem) {
            foreach ($dataItem as $key => $v) {
                if (preg_match('/[count|sum]\(/', $key, $match)) {
                    $returnData[$k][$key] = intval($returnData[$k][$key]);
                }
            }
        }
        return $returnData;
    }

    function beforeDelete()
    {

    }
}