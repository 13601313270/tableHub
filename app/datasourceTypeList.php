<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/20
 * Time: 5:28 PM
 */

$datasourceTypeList = array(
    array(
        'name' => 'mysql',
        'id' => 2,
        'column' => array(
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
        )
    ),
    array(
        'name' => 'csv',
        'id' => 3,
        'column' => array(
            array(
                'title' => '文件',
                'name' => 'file',
                'type' => 'File'
            )
        )
    )
);
