<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:17
 */
include_once('include.php');
final class kod_web_rewrite extends kod_tool_config{
    public static function getArrByStr($str){
        $splitStr = '/';
        $arr = explode($splitStr,$str);
        return $arr;
    }
    public static function getPageContent($confPath)
    {
        $file = fopen($confPath, "r") or exit("Unable to open file!");
        $lineList = array();
        $before = array();
        while(!feof($file)) {
            $oneLine = fgets($file);
            $oneArr = explode(" ",$oneLine);
            $oneArr[count($oneArr)-1] = trim($oneArr[count($oneArr)-1]);
            if(count($oneArr)==1){
                if(substr($oneArr[0],0,2)=="\t\t"){
                    $before = array($before[0],$before[1],trim($oneArr[0]));
                }elseif(substr($oneArr[0],0,1)=="\t"){
                    $before = array($before[0],trim($oneArr[0]));
                }else{
                    $before = array(trim($oneArr[0]));
                }
                continue;
            }elseif(count($oneArr)==0){
                continue;
            }
            $oneArr[0] = implode('',$before).trim($oneArr[0]);
            $lineList[] = $oneArr;

        }
        fclose($file);
        return $lineList;
    }
}
kod_web_rewrite::init(dirname(__FILE__).'/rewrite.conf');
//双向获取
//$result = kod_web_rewrite::getPathByUrl($_SERVER["SCRIPT_URL"]);
$result = kod_web_rewrite::getPathByUrl(current(explode('?',$_SERVER["REQUEST_URI"])));
if(!empty($result)){
//    $new = parse_url(KOD_SMARTY_TEMPLATE_DIR.$result[1]);
    $new = parse_url($result[1]);
    parse_str($new["query"],$myArray);
    $_GET = array_merge($_GET,$myArray);//后面盖住前面
    $_SERVER["SCRIPT_URL"] = $new["path"];
    $_SERVER["SCRIPT_URI"] = $_SERVER['REQUEST_SCHEME']."://".$_SERVER["HTTP_HOST"].'/'.$new["path"];
    if(!empty($new["query"])){
        $_SERVER["REQUEST_URI"] = $new["path"]."?".$new["query"];
    }else{
        $_SERVER["REQUEST_URI"] = $new["path"];
    }
    $_SERVER["SCRIPT_FILENAME"] = $new["path"];
    $_SERVER["SCRIPT_NAME"] = $new["path"];
    $_SERVER["PHP_SELF"] = $new["path"];
    unset($result);
    unset($new);

    chdir('./http/');
    if(substr($_SERVER["SCRIPT_FILENAME"],strlen($_SERVER["SCRIPT_FILENAME"])-1,1)=="/"){
        include_once($_SERVER["SCRIPT_FILENAME"]."index.php");
    }else{
        include_once($_SERVER["SCRIPT_FILENAME"]);
    }
}else{
    header("HTTP/1.1 404 Not Found");
    var_dump('404');exit;
}