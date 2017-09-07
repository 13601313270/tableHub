<?php

include_once("../include.php");
/**
* 表test操作后台
*
* User: metaPHP
* Date: 2017/04/30
* Time: 21:49
*/

class testAdmin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new test();
    }
    protected $smartyTpl = 'testAdmin.tpl';
    protected $dbColumn = array(
        'mddid' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'mddid'
        ),
        'name' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '名字'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new testAdmin();
$adminObj->run();
