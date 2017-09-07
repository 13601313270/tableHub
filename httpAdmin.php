<?php

/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:14
 */

include_once('include.php');
$page=new kod_web_page();
$page->fileList=scandir('./http/');
$page->httpFileConfig=array(
    'index.php' => '首页',
    'index.tpl' => '首页模板',
    'test.php' => '测试页面',
    'ddd.php' => '单独的',
    'adsf.php' => '额外',
    'ww.php' => 'ww.php'
);
$page->fetch('httpAdmin.tpl');
