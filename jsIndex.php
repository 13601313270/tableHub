<?php
/**
 * Created by PhpStorm.
 * User: mfw
 * Date: 2017/11/2
 * Time: 下午3:37
 */

header('Content-type: text/javascript');
$file = './js/tablePlugins/function.MIN.js';
$last_modified_time = filemtime($file);
$etag = md5_file($file);
// always send headers
//header("Last-Modified: ".gmdate("D, d M Y H:i:s", $last_modified_time)." GMT");
//header("Etag: $etag");
// exit if not modified
if (false && @strtotime($_SERVER['HTTP_IF_MODIFIED_SINCE']) == $last_modified_time ||
    @trim($_SERVER['HTTP_IF_NONE_MATCH']) == $etag) {
    header("HTTP/1.1 304 Not Modified");
    exit;
}else{
    foreach(array('./js/tablePlugins/','./js/allCharts/') as $path){
        foreach(scandir($path) as $v){
            if(!in_array($v,array('.','..'))){
                echo file_get_contents($path.$v)."\n";
            }
        }
    }

    /*
    $tableInfo = excel::create()->getByKey(intval($_GET['fileId']));
    //所有用户自定义插件
    foreach(scandir('../userPlugins/'.$tableInfo['author'].'/') as $v){
        if(!in_array($v,array('.','..'))){
            $allUserFunc[] = $tableInfo['author'].'/'.$v;
        }
    }
    */
}