<?php

/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/25
 * Time: 10:34 AM
 */
class datasource_write extends datasourceInterface
{
    static public $column = array(
        array(
            'title' => '结构',
            'name' => 'column',
            // 当前类型特殊的type，代表手填结构
            'type' => 'column'
        )
    );
    private $config = array();
    private $id = 0;

    function __construct($insertInfo, $id)
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

    public function showTables()
    {
        return array(
            array(
                'id' => 'write',
                'name' => '手填数据'
            )
        );
    }

    public function showCreateTable()
    {
        $result = array();
        $column = json_decode($this->config['column'], true);
        foreach ($column as $v) {
            switch ($v['type']) {
                case 'number':
                    $dataType = 'number';
                    break;
                case 'bool':
                    $dataType = 'number';
                    break;
                default:
                    $dataType = 'varchar';
                    break;
            }
            $result[$v['name']] = array(
                'dataType' => $dataType,
                'title' => $v['name']
            );
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
            'aggregate' => $this->id,
            'pipeline' => [
                array(
                    '$group' => $group
                )
            ]
        ]);
        $rows = $manager->executeCommand('write', $cmd);
        foreach ($rows as $r) {
            if ($r->ok) {
                $returnData = array();
                foreach ($r->result as $dataItem) {
                    $item = array();
                    $group = $_POST['sql']['groupBy'];
                    $item[$group] = $dataItem->_id->$group;
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
                'drop' => $this->id
            ]);
            $manager->executeCommand('csv', $cmd);
        } catch (Exception $e) {

        }
    }
}