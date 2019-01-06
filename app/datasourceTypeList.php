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
        'title' => 'mysql',
        'id' => 2,
        'column' => datasource_mysql::$column
    ),
    array(
        'name' => 'csv',
        'title' => 'csv文件',
        'id' => 3,
        'column' => datasource_csv::$column
    ),
    array(
        'name' => 'gd',
        'title' => 'google drive',
        'id' => 4,
        'column' => datasource_gd::$column
    ),
    array(
        'name' => 'write',
        'title' => '手填结构',
        'id' => 5,
        'column' => datasource_write::$column

    )
);
