<?php

include_once("../include.php");
/**
* 表test3操作后台
*
* User: metaPHP
* Date: 2017/05/07
* Time: 00:03
*/

class test3Admin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new test3();
    }
    protected $smartyTpl = 'test3Admin.tpl';
    protected $dbColumn = array(
        'id' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'id',
            'AUTO_INCREMENT' => true
        ),
        'name' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'name'
        ),
        'content' => array(
            'dataType' => 'text',
            'title' => 'content',
            'listShowType' => 'hidden'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new test3Admin();
$adminObj->run();
