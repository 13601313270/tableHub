<?php

/**
 * Created by PhpStorm.
 * User: mfw
 * Date: 2017/1/22
 * Time: 上午1:39
 */

ini_set('display_errors',1);
error_reporting(E_ALL^E_NOTICE);
date_default_timezone_set('PRC');
/*
*设置kod环境变量
*/

define("webDIR",dirname(__FILE__)."/http/");
//网站根目录
define("KOD_SMARTY_TEMPLATE_DIR",dirname(__FILE__)."/http/");
define("KOD_REWRITE_HTML_LINK",true);
define('KOD_SMARTY_COMPILR_DIR',dirname(__FILE__).'/smarty_cache');
define('KOD_MYSQL_SERVER','118.190.95.219');
define('KOD_MYSQL_USER','root');
define('KOD_MYSQL_PASSWORD','1082322$%&whr309568486');
define('KOD_COMMENT_MYSQLDB','tablehub');
/*
 * 设置memcache
 * */

define('KOD_MEMCACHE_TYPE_MEMCACHE',1);
define('KOD_MEMCACHE_TYPE_MEMCACHED',2);
define('KOD_MEMCACHE_OPEN',true);
define('KOD_MEMCACHE_TYPE',KOD_MEMCACHE_TYPE_MEMCACHED);
//KOD_MEMCACHE_TYPE_MEMCACHE,KOD_MEMCACHE_TYPE_MEMCACHED,二选一
define('KOD_MEMCACHE_HOST','localhost');
//默认值是localhost
define('KOD_MEMCACHE_PORT','11211');
//默认值是11211
define("KOD_SMARTY_CSS_DIR",dirname(__FILE__)."/cssCreate/");
define('KOD_SMARTY_CSS_HOST','//www.tablehub.cn/cssCreate/');
define('KOD_METAPHP_OPEN',false);
//控制器层的自动加载函数,自动启环节执行完毕后将释放这个函数,防止模板层拥有全部权限.进行权限控制
function kod_ControlAutoLoad($model){
    $classAutoLoad=array(
        //'projectClass' => 'include/project.php',
    );
    if(isset($classAutoLoad[$model])){
        include_once($classAutoLoad[$model]);
    }
    elseif($model=='Memcache'){
        throw new Exception('环境不支持memcache');
    }
    elseif(strpos($model,'kod_')===false&&strpos($model,'Smarty_')===false){
        include_once('include/'.$model.'.php');
    }
}
/*
*加载kod框架
*/

include_once(dirname(__FILE__).'/kod/include.php');
//kod_smarty_smarty::$test = false;
include_once('metaPHP/include.php');
