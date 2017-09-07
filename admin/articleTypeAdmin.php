<?php

include_once("../include.php");
/**
* 表articleType操作后台
*
* User: metaPHP
* Date: 2017/05/03
* Time: 08:04
*/

class articleTypeAdmin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new articleType();
    }
    protected $smartyTpl = 'articleTypeAdmin.tpl';
    protected $dbColumn = array(
        'id' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'id',
            'AUTO_INCREMENT' => true,
            'AUTO_INCREMENT' => true,
            'auto_increment' => '1'
        ),
        'title' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'title'
        ),
        'orderNum' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'orderNum'
        ),
        'projectId' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'projectId'
        ),
        'icon' => array(
            'dataType' => 'imageQiniu',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'icon'
        ),
        'keyWord' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'keyWord'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new articleTypeAdmin();
$adminObj->run();
