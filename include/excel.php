<?php

/**
* 表user操作接口
*
* User: metaPHP
* Date: 2017/07/09
* Time: 11:53
*/

class excel extends kod_db_mysqlSingle{
    protected $tableName = 'excel';
    protected $key = 'id';
    protected $keyDataType = 'int';
    public function getListByUserId($uid){
        return $this->getList(array(
            'author'=>intval($uid)
        ));
    }
    public function getInfoById($id){
        $return = $this->getByKey($id);
        $return['data'] = json_decode($return['data']);
        return $return;
    }
}

