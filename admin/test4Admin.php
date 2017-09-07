<?php

include_once("../include.php");
/**
* 表test4操作后台
*
* User: metaPHP
* Date: 2017/05/07
* Time: 00:39
*/

class test4Admin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new test4();
    }
    protected $smartyTpl = 'test4Admin.tpl';
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
            'title' => '名称'
        ),
        'content' => array(
            'dataType' => 'text',
            'title' => '正文',
            'listShowType' => 'hidden'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new test4Admin();
$adminObj->run();
