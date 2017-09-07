<?php

include_once("../include.php");
/**
* 表project操作后台
*
* User: metaPHP
* Date: 2017/04/25
* Time: 01:45
*/

class projectAdmin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new project();
    }
    protected $smartyTpl = 'projectAdmin.tpl';
    protected $dbColumn = array(
        'id' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'id',
            'AUTO_INCREMENT' => true
        ),
        'projectName' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '项目名'
        ),
        'packName' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '包'
        ),
        'AppName' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'app名'
        ),
        'logo' => array(
            'dataType' => 'imageQiniu',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '图标'
        ),
        'tag' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '标签'
        ),
        'projectType' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => '项目类型',
            'default' => 0
        ),
        'typeInChuiZhiWeb' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => '所属垂直分类'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new projectAdmin();
$adminObj->run();
