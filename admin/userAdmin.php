<?php

include_once("../include.php");
/**
* 表user操作后台
*
* User: metaPHP
* Date: 2017/07/09
* Time: 11:53
*/

class userAdmin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new user();
    }
    protected $smartyTpl = 'userAdmin.tpl';
    protected $dbColumn = array(
        'id' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'id',
            'AUTO_INCREMENT' => true
        ),
        'email' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'email',
            'unique' => true
        ),
        'password'=>array(
            'dataType' => 'varchar',
            'maxLength' => 127,
            'title' => 'email',
            'unique' => true
        ),
        'state' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'state',
            'default' => '1'
        )
    );
    public function main(){
        //state 1正常用户
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new userAdmin();
$adminObj->run();
