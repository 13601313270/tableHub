<?php

/**
* 表user操作接口
*
* User: metaPHP
* Date: 2017/07/09
* Time: 11:53
*/

class userInfo extends kod_db_mysqlSingle{
    protected $tableName = 'user_info';
    protected $key = 'id';
    protected $keyDataType = 'int';
    public $foreignKey = array('id' => 'user');
    public function insert($params, $mysql_insert_id = true)
    {
        $params['register_token'] = substr(md5(time()+rand(0,1000)),0,16);
        $params['password'] = md5($params['password'].$params['register_token']);
        return parent::insert($params, $mysql_insert_id);
    }
}

