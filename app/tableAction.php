<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/11/1
 * Time: 下午6:18
 */
include_once('../include.php');
include_once('../phpExcel/Classes/PHPExcel.php');
header('Access-Control-Allow-Origin:http://dev.tablehub.cn:8080');
//header('Access-Control-Allow-Origin: *');

header('Access-Control-Allow-Credentials:true');
//header('Access-Control-Allow-Methods:OPTIONS, GET, POST'); // 允许option，get，post请求
//header('Access-Control-Allow-Headers:x-requested-with'); // 允许x-requested-with请求头
//header('Access-Control-Max-Age:86400'); // 允许访问的有效期


$userInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
function getNumByWord($word){
    $word = str_split($word);
    $returnNum = 0;
    for($i=0;$i<count($word);$i++){
        $returnNum += (ord($word[$i])-64)*pow(26,count($word)-$i-1);
    }
    return $returnNum;
}
function getWordByNum($num){
    $result = '';
    do{
        $append = chr($num%26+64);
        if($append=='@'){
            $append = 'Z';
            $num -=26;
        }
        $result = $append.$result;
        $num = intval($num/26);
    }while($num>0);
    return $result;
}
if($_POST['function']==='tableInfo'){
    $tableInfo = excel::create()->getByKey(intval($_POST['fileId']));
    $tableInfo['style'] = json_decode($tableInfo['style']);
    $tableInfo['data'] = json_decode($tableInfo['data']);

    $userInfo = user::create()->onlyColumn('id')->getBySessionToken($_COOKIE['sessionToken']);
    if(!empty($userInfo) && intval($userInfo['id'])===intval($tableInfo['author'])){
        $tableInfo['isMyTable'] = true;
    }else{
        $tableInfo['isMyTable'] = false;
    }
    echo json_encode($tableInfo);exit;
}else{
    if(empty($userInfo)){
        header('Location:/login.html');exit;
        throw new Exception('请登录后进行操作');
    }
}
if($_POST['function']==='updateTdValue'){
    $insertStr = $_POST['value'];
    if(preg_match('/^\d+$/',$insertStr,$match)){
        $insertStr = intval($insertStr);
    }
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $pos = $_POST['pos'];
    if(isset($tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos)){
        if($insertStr===''){
            unset($tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos);
        }else{
            $tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos->value = $insertStr;
        }
    }else{
        $tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos = array(
            'value'=>$insertStr
        );
    }
    $result = excel::create()->update('id='.intval($_POST['fileId']),array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='updateChartsValue'){
    $fileId = intval($_POST['fileId']);
    $tableNum = $_POST['tableNum'];
    $chartsIndex = $_POST['chartsIndex'];
    $value = $_POST['value'];

    $tableInfo = excel::create()->getInfoById($fileId);
    if($tableInfo['data'][$tableNum]->charts==null){
        $tableInfo['data'][$tableNum]->charts = array();
    }
    $oldValue = $tableInfo['data'][$tableNum]->charts[$chartsIndex];
    $tableInfo['data'][$tableNum]->charts[$chartsIndex] = array(
        'position'=>$oldValue->position,
        'size'=>$oldValue->size,
        'value'=>$value
    );
    $result = excel::create()->update('id='.$fileId,array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='insertChartsValue'){
    $fileId = intval($_POST['fileId']);
    $tableNum = $_POST['tableNum'];
    $chartsIndex = $_POST['chartsIndex'];
    $value = $_POST['value'];

    $tableInfo = excel::create()->getInfoById($fileId);
    if($tableInfo['data'][$tableNum]->charts==null){
        $tableInfo['data'][$tableNum]->charts = array();
    }
    $tableInfo['data'][$tableNum]->charts[$chartsIndex] = array(
        'position'=>$_POST['position'][0].','.$_POST['position'][1],
        'size'=>$_POST['size'][0].','.$_POST['size'][1],
        'value'=>$value
    );
    $result = excel::create()->update('id='.$fileId,array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='deleteChart'){
    $fileId = intval($_POST['fileId']);
    $tableNum = $_POST['tableNum'];
    $chartsIndex = $_POST['chartsIndex'];

    $tableInfo = excel::create()->getInfoById($fileId);
    if($tableInfo['data'][$tableNum]->charts==null){
        echo -1;
    }
    $allCharts = $tableInfo['data'][$tableNum]->charts;
    array_splice($allCharts,$chartsIndex,1);
    $tableInfo['data'][$tableNum]->charts = $allCharts;
    $result = excel::create()->update('id='.$fileId,array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='updateChartsPos'){
    $fileId = intval($_POST['fileId']);
    $tableNum = $_POST['tableNum'];
    $chartsIndex = $_POST['chartsIndex'];
    $top = intval($_POST['top']);
    $left = intval($_POST['left']);
    $width = intval($_POST['width']);
    $height = intval($_POST['height']);
    $value = $_POST['value'];

    $tableInfo = excel::create()->getInfoById($fileId);
    if($tableInfo['data'][$tableNum]->charts==null){
        $tableInfo['data'][$tableNum]->charts = array();
    }
    $oldValue = $tableInfo['data'][$tableNum]->charts[$chartsIndex];
    $tableInfo['data'][$tableNum]->charts[$chartsIndex] = array(
        'position'=>$top.','.$left,
        'size'=>$width.','.$height,
        'value'=>$oldValue->value
    );
    $result = excel::create()->update('id='.$fileId,array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='updateWidth'){
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $lienum = $_POST['lienum'];
    if(is_array($tableInfo['data'][intval($_POST['tableNum'])]->column) && count($tableInfo['data'][intval($_POST['tableNum'])]->column)==0){
        $tableInfo['data'][intval($_POST['tableNum'])]->column = json_decode('{}');
    }
    if(isset($tableInfo['data'][intval($_POST['tableNum'])]->column->$lienum)){
        $tableInfo['data'][intval($_POST['tableNum'])]->column->$lienum->width = $_POST['width'];
    }else{
        $tableInfo['data'][intval($_POST['tableNum'])]->column->$lienum = json_decode('{"width":'.$_POST['width'].'}');
    }
    $result = excel::create()->update('id='.intval($_POST['fileId']),array(
        'data'=>json_encode($tableInfo['data'])
    ));
    var_dump($result);exit;
}
elseif($_POST['function']==='updateTdXf'){
    $insertStr = $_POST['value'];
    foreach(array('bold','italic') as $v){
        $insertStr['font'][$v] = ($insertStr['font'][$v]=='1'?1:0);
    }
    foreach(array('size') as $v){
        $insertStr['font'][$v] = intval($insertStr['font'][$v]);
    }
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $pos = $_POST['pos'];
    $xfIndex = $_POST['xfIndex'];
    $rewriteStyle = false;
    if($xfIndex===null){
        $allStyle = json_decode($tableInfo['style']);
        $allStyle[] = $insertStr;
        $rewriteStyle = true;
        $xfIndex = count($allStyle)-1;
    }else{
        $xfIndex = intval($xfIndex);
    }
    if(isset($tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos)){
        $tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos->xfIndex = $xfIndex;
    }else{
        $tableInfo['data'][intval($_POST['tableNum'])]->tableValue->$pos = array(
            'value'=>'',
            'xfIndex'=>$xfIndex
        );
    }
    if($rewriteStyle){
        $result = excel::create()->update('id='.intval($_POST['fileId']),array(
            'style'=>json_encode($allStyle),
            'data'=>json_encode($tableInfo['data'])
        ));
    }else{
        $result = excel::create()->update('id='.intval($_POST['fileId']),array(
            'data'=>json_encode($tableInfo['data'])
        ));
    }
    if($result){
        echo $xfIndex;
    }else{
        echo '-1';
    }
    exit;
}
elseif($_POST['function']==='mergeCancel'){
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $mergeCells = $tableInfo['data'][intval($_POST['tableNum'])]->mergeCells;
    foreach($mergeCells as $k=>$v){
        $key = explode(':',$k);
        if($key[0]==$_POST['pos']){
            unset($mergeCells->$k);
        }
    }
    $tableInfo['data'][intval($_POST['tableNum'])]->mergeCells = $mergeCells;
    $result = excel::create()->update('id='.intval($_POST['fileId']),array(
        'data'=>json_encode($tableInfo['data'])
    ));
    if($result){
        echo 1;
    }else{
        echo 0;
    }
    exit;
}
elseif($_POST['function']==='mergeAdd'){
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $mergeCells = $tableInfo['data'][intval($_POST['tableNum'])]->mergeCells;
    $data = $tableInfo['data'][intval($_POST['tableNum'])]->tableValue;
    //是否和要合并的冲突
    foreach($mergeCells as $k=>$v){
        $isTouch = true;
        list($topLeft,$rightBottom) = explode(':',$k);
        preg_match('/^([A-Z]+)(\d+)$/',$topLeft,$topLeft);
        preg_match('/^([A-Z]+)(\d+)$/',$rightBottom,$rightBottom);
        if(intval($_POST['right'])<getNumByWord($topLeft[1])){
            continue;
        }
        if(intval($_POST['left'])>getNumByWord($rightBottom[1])){
            continue;
        }
        if(intval($_POST['bottom'])<intval($topLeft[2])){
            continue;
        }
        if(intval($_POST['top'])>intval($rightBottom[2])){
            continue;
        }
//        unset($mergeCells->$k);
//        print_r(array($topLeft,$rightBottom,getNumByWord($topLeft[1])));
        var_dump('冲突');exit;
    }
    foreach($data as $k=>$v){
        list($topLeft,$rightBottom) = explode(':',$k);
        preg_match('/^([A-Z]+)(\d+)$/',$k,$key2);
        $key2[1] = getNumByWord($key2[1]);
        $key2[2] = intval($key2[2]);
        if( $key2[1]>=intval($_POST['left']) && $key2[1]<=intval($_POST['right']) && $key2[2]>=intval($_POST['top'])  && $key2[2]<=intval($_POST['bottom']) ){
            if($key2[1]==intval($_POST['left']) && $key2[2]==intval($_POST['top'])){
            }else{
                unset($data->$k);
            }
        }
    }
    $tableInfo['data'][intval($_POST['tableNum'])]->tableValue = $data;
    //添加新的合并配置
    $mergeStr = getWordByNum(intval($_POST['left'])).intval($_POST['top']).":".getWordByNum(intval($_POST['right'])).intval($_POST['bottom']);
    if(is_array($mergeCells) && empty($mergeCells)){
        $mergeCells[$mergeStr] = $mergeStr;
    }else{
        $mergeCells->$mergeStr = $mergeStr;
    }
    $tableInfo['data'][intval($_POST['tableNum'])]->mergeCells = $mergeCells;
    $result = excel::create()->update('id='.intval($_POST['fileId']),array(
        'data'=>json_encode($tableInfo['data']),
    ));
    if($result){
        echo 1;
    }else{
        echo 0;
    }
    exit;
}
elseif($_POST['function']==='tableAdd'){
    $insertStr = $_POST['value'];
    $tableInfo = excel::create()->getInfoById(intval($_POST['fileId']));
    $data = $tableInfo['data'];
    foreach($data as $v){
        if($v->title==$_POST['title']){
            echo '-2';exit;
        }
    }
    $data[] = array(
        'title'=>$_POST['title'],
        'row'=>array(),
        'column'=>array(),
        'tableValue'=>array(
            "A1"=>array(
                'value'=>'',
                'xfIndex'=>0,
            ),
        ),
        "mergeCells"=>array(),
    );
    $result = excel::create()->update('id='.intval($_POST['fileId']),array(
        'data'=>json_encode($data)
    ));
    if($result){
        echo '1';
    }else{
        echo '-1';
    }
    exit;
}