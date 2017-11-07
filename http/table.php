<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:08
 */
include_once('../include.php');


$page=new kod_web_page();
$tableInfo = excel::create()->getByKey(intval($_GET['fileId']));
//所有系统插件
$allFunc = array();
foreach(scandir('../js/tablePlugins/') as $v){
    if(!in_array($v,array('.','..'))){
        $allFunc[] = $v;
    }
}
$page->allFunc = $allFunc;
//所有图表插件
$allCharts = array();
foreach(scandir('../js/allCharts/') as $v){
    if(!in_array($v,array('.','..'))){
        $allCharts[] = $v;
    }
}
$page->allCharts = $allCharts;
//所有用户自定义插件
$allUserFunc = array();
foreach(scandir('../userPlugins/'.$tableInfo['author'].'/') as $v){
    if(!in_array($v,array('.','..'))){
        $allUserFunc[] = $tableInfo['author'].'/'.$v;
    }
}
$page->allUserFunc = $allUserFunc;

$page->fetch('table.tpl');exit;