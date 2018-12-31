<?php

/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/25
 * Time: 10:34 AM
 */
interface datasourceInterface
{
    const column = array();

    //新建操作，在保存到库之前的最后操作
    public function beforeSave($insertData, $post);

    // 查询操作之前，检查是否有权限
    public function check();

    public function showTables();

    public function showCreateTable();

    // 执行查询
    public function run($sql);

    public function beforeDelete();
}