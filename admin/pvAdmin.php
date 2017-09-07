<?php

include_once("../include.php");
/**
* 表pv操作后台
*
* User: metaPHP
* Date: 2017/05/01
* Time: 11:02
*/

class pvAdmin extends kod_web_mysqlAdmin{
    public function getMysqlDbHandle(){
        return new pv();
    }
    protected $smartyTpl = 'pvAdmin.tpl';
    protected $dbColumn = array(
        'id' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'id',
            'AUTO_INCREMENT' => true
        ),
        'project' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'project'
        ),
        'action' => array(
            'dataType' => 'varchar',
            'maxLength' => 255,
            'notNull' => true,
            'title' => 'action'
        ),
        'value' => array(
            'dataType' => 'int',
            'maxLength' => 11,
            'notNull' => true,
            'title' => 'value'
        )
    );
    public function main(){
        $adminHtml=$this->getAdminHtml($this->dbColumn);
        $this->assign('adminHtml',$adminHtml);
    }
}

$adminObj=new pvAdmin();
$adminObj->run();
