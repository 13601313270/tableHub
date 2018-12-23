<?php

/**
* 表user操作接口
*
* User: metaPHP
* Date: 2017/07/09
* Time: 11:53
*/

class connection extends kod_db_mysqlSingle{
    protected $tableName = 'connection';
    protected $key = 'id';
    protected $keyDataType = 'int';
}