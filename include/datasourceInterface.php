<?php

/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/25
 * Time: 10:34 AM
 */
abstract class datasourceInterface
{
    const column = array();

    //新建操作，在保存到库之前的最后操作
    abstract public function beforeSave($insertData, $post);

    // 查询操作之前，检查是否有权限
    abstract public function check();

    abstract public function showTables();

    abstract public function showCreateTable();

    // 用户选择了某个table
    public function selectTable()
    {
        return array(
            'result' => 1
        );
    }

    // 执行查询
    abstract public function run($sql);

    abstract public function beforeDelete();
}
