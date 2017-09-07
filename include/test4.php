<?php

/**
* 表test4操作接口
*
* User: metaPHP
* Date: 2017/05/07
* Time: 00:13
*/

class test4 extends kod_db_mysqlSingle{
    protected $tableName = 'test4';
    protected $key = 'id';
    protected $keyDataType = 'int';
    public $foreignKey = array();
}

