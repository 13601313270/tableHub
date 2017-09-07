<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:14
 */
//ini_set('session.auto_start', 1);
include_once('include.php');
define("webRootBase",dirname(KOD_SMARTY_TEMPLATE_DIR));
define("webRootBaseCachePath",webRootBase.'/metaPHPCacheFile');
class githubClass extends githubAction{
    public $runLocalBranch = 'develop';
    public $originBranch = 'origin/develop';
    public $webRootDir = webRootBase;
    public $cachePath = webRootBaseCachePath;
}

class control{
    private $allMysqlColType = array(
        'auto_increment'=>array('name'=>'自增数字', 'saveType'=>'auto_increment'),
        'boolean'=>array('name'=>'布尔值', 'saveType'=>'tinyint'),
        'tinyint'=>array('name'=>'tinyint', 'saveType'=>'tinyint'),
        'int'=>array('name'=>'数字', 'saveType'=>'int'),
        'bigint'=>array('name'=>'超大数字', 'saveType'=>'bigint'),
//        'real'=>array('name'=>'real', 'saveType'=>'real'),
        'double'=>array('name'=>'双精度小数', 'saveType'=>'double'),
//        'float'=>array('name'=>'小数', 'saveType'=>'float'),
        'image'=>array('name'=>'图片', 'saveType'=>'varchar'),
        'imageQiniu'=>array('name'=>'七牛图片', 'saveType'=>'varchar'),
//        'decimal'=>array('name'=>'decimal', 'saveType'=>'decimal'),
//        'numeric'=>array('name'=>'numeric', 'saveType'=>'numeric'),
        'numeric'=>array('name'=>'numeric', 'saveType'=>'numeric'),
        'varchar'=>array('name'=>'字符串', 'saveType'=>'varchar'),
        'char'=>array('name'=>'固定长度字符串', 'saveType'=>'char'),
//        'binary'=>array('name'=>'binary', 'saveType'=>'binary'),
//        'varbinary'=>array('name'=>'varbinary', 'saveType'=>'varbinary'),
        'varbinary'=>array('name'=>'varbinary', 'saveType'=>'varbinary'),
        'date'=>array('name'=>'日期', 'saveType'=>'date'),
        'time'=>array('name'=>'时间', 'saveType'=>'time'),
        'datetime'=>array('name'=>'日期+时间', 'saveType'=>'datetime'),
        'timestamp'=>array('name'=>'时间戳', 'saveType'=>'timestamp'),
        'year'=>array('name'=>'年份', 'saveType'=>'year'),
//        'tinyblob'=>array('name'=>'tiny二进制', 'saveType'=>'tinyblob'),
//        'blob'=>array('name'=>'二进制', 'saveType'=>'blob'),
//        'mediumblob'=>array('name'=>'medium二进制', 'saveType'=>'mediumblob'),
//        'longblob'=>array('name'=>'long二进制', 'saveType'=>'longblob'),
        'text'=>array('name'=>'长文本', 'saveType'=>'text'),
//        'mediumtext'=>array('name'=>'长文本', 'saveType'=>'mediumtext'),
//        'longtext'=>array('name'=>'长文本', 'saveType'=>'longtext'),
//        'mediumtext'=>array('name'=>'长文本', 'saveType'=>'mediumtext'),
//        'enum'=>array('name'=>'enum', 'saveType'=>'enum'),
        'set'=>array('name'=>'set', 'saveType'=>'set'),
    );
    private function getAllIncludeApi($folder,$classType,$classSplitColumn){
        $gitAction = new githubClass();
        $headCommit = $gitAction->exec('git rev-parse HEAD');
        $allIncludeApi = kod_db_memcache::returnCacheOrSave('allIncludeApi:'.$folder.':'.$classType.":".str_replace(' ','',$classSplitColumn),function()use($folder,$headCommit,$classType,$classSplitColumn){
            $fileList = scandir($folder);
            $allDataApi = array(
                'version'=>$headCommit,
                'data'=>array(),
            );
            if(count($fileList)>2){
                foreach($fileList as $file){
                    if(!in_array($file,array('.','..'))){
                        $phpInterpreter = new phpInterpreter(file_get_contents($folder.$file));
                        $className = $phpInterpreter->search('.class:filter([extends='.$classType.']) name')->toArray();
                        $table = $phpInterpreter->search('.class:filter([extends='.$classType.']) '.$classSplitColumn)->toArray();
                        $allDataApi['data'][] = array(
                            'fileName'=>$file,
                            'type'=>$classType,
                            'className'=>$className[0],
                            'tableName'=>$table[0],
                        );
                    }
                }
            }
            return $allDataApi;
        },0,60*60,function($data)use($headCommit){
            return false;
            return $data['version']==$headCommit;
        });
        return $allIncludeApi;
    }
    public function tables(){
        $data = kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql('show table status');
        foreach($data as $k=>$v){
            $data[$k]['database'] = KOD_COMMENT_MYSQLDB;
        }
        echo json_encode($data);
    }
    public function getDataApi(){
        $this->setSessionState(1,'验证接口类是否是在');
        $className = $_POST['name'];
        //获得include文件夹全部接口类梗概信息
        $allIncludeApi = $this->getAllIncludeApi('./include/','kod_db_mysqlSingle','.property:filter(#$tableName) value data');
        //找到这个表对应的接口类
        $metaSearchApi = new metaSearch($allIncludeApi);
        $thisTableApiInfo = $metaSearchApi->search('.kod_db_mysqlSingle:filter([tableName='.$className.'])')->toArray();
        //如果没有则创建一个
        if(empty($thisTableApiInfo)){
            $this->setSessionState(20,'准备生成接口类');
            $tableInfo = kod_db_mysqlDB::create()->runsql('show create table '.$className);
            if($tableInfo===-1||$tableInfo===false){
                $return = array();
                foreach($this->allMysqlColType as $k=>$v){
                    $return[] = array_merge(array('type'=>$k),$v);
                }
                $this->setSessionState(100,'数据库中没有此表');
                echo json_encode($return);exit;
            }else{
                $tableInfo = current($tableInfo);
                if(preg_match('/CREATE TABLE [`|"].+?[`|"]\s*\(([\S|\s]*)\)/',$tableInfo['Create Table'],$match)){
                    $this->setSessionState(30,'正在分析数据库表信息');
                    $tableInfo = explode(',',$match[1]);
                    $primaryKey = array();//主键
                    $dataType = array();
                    //查找主键
                    foreach($tableInfo as $k=>$v){
                        if(preg_match("/[`|\"](\S+)[`|\"] (int|smallint|varchar|tinyint|char|bigint)\((\d+)\)( NOT NULL| DEFAULT NULL)?( DEFAULT '(\S+)'| AUTO_INCREMENT)?( COMMENT '(\S+)')?/",$v,$match)){
                            $dataType[$match[1]] = $match[2];
                            if(!empty($match[5]) && $match[5]==" AUTO_INCREMENT"){
                                $primaryKey = array('name'=>$match[1], 'dataType'=>$match[2],);
                                break;
                            }
                        }elseif(preg_match("/[`|\"](\S+)[`|\"] (text|date)( NOT NULL| DEFAULT NULL)?( DEFAULT '(\S+)'| AUTO_INCREMENT)?( COMMENT '(\S+)')?/",$v,$match)){
                            $dataType[$match[1]] = $match[2];
                        }elseif(  preg_match("/[`|\"](\S+)[`|\"] timestamp( NOT NULL| DEFAULT NULL)( DEFAULT CURRENT_TIMESTAMP)?( ON UPDATE CURRENT_TIMESTAMP)?( COMMENT '(\S+)')?/",$v,$match)  ){
                            $dataType[$match[1]] = 'date';
                        }elseif( preg_match("/PRIMARY KEY \(\"(\S+)\"\)/",$v,$match) ){
                            $primaryKey = array(
                                'name'=>$match[1], 'dataType' => $dataType[$match[1]]
                            );
                        }
                    }
                    if(!empty($primaryKey)){
                        //创建表对应的接口类
                        $this->setSessionState(60,'正在创建接口类代码');
                        $newClass = classAction::createClass($className,'kod_db_mysqlSingle');
                        $temp = $newClass->phpInterpreter->search('.comments')->toArray();
                        $temp[0]['value'] = '*
* 表'.$className.'操作接口
*
* User: metaPHP
* Date: '.date('Y/m/d').'
* Time: '.date('H:i').'
';
                        $newClass->setProperty('tableName', array('type'=>'string','borderStr'=>"'",'data'=>$className), 'protected');
                        $newClass->setProperty('key',array('type'=>'string','borderStr'=>"'",'data'=>$primaryKey['name']), 'protected');
                        $newClass->setProperty('keyDataType',array('type'=>'string','borderStr'=>"'",'data'=>in_array($primaryKey['dataType'],array('int','bigint'))?'int':'varchar'), 'protected');
                        //提交git
//                        var_dump(  $newClass->phpInterpreter->getCode()  );exit;
                        $this->setSessionState(70,'重置服务器环境');
                        $gitAction = new githubClass();
                        $gitAction->pull();
                        $this->setSessionState(75,'覆盖代码');
                        file_put_contents('./include/'.$className.'.php',$newClass->phpInterpreter->getCode());
                        $gitAction->add('--all');
                        $gitAction->commit('增加了表'.$className.'的操作接口类');
                        $this->setSessionState(75,'正在推送到代码库');
                        $gitAction->push();
                        $gitAction->branchClean();

                        //刷新一下接口列表
                        $allIncludeApi = $this->getAllIncludeApi('./include/','kod_db_mysqlSingle','.property:filter(#$tableName) value data');
                        $metaSearchApi = new metaSearch($allIncludeApi);
                        $thisTableApiInfo = $metaSearchApi->search('.kod_db_mysqlSingle:filter([tableName='.$className.'])')->toArray();
                    }else{
                        $this->setSessionState(100,'只支持有主键的表');
                    }
                }
            }
        }
        echo json_encode($thisTableApiInfo[0]);
        $this->setSessionState(100,'');
    }
    public function showTableAdmin(){
        $this->setSessionState(1,'验证接口类是否存在');
        $return = array();
        $return['allMysqlColType'] = array();
        foreach($this->allMysqlColType as $k=>$v){
            $return['allMysqlColType'][] = array_merge(array('type'=>$k),$v);
        }
        if(!isset($_POST['class'])){
            echo json_encode($return);exit;
        }

        //获得include文件夹全部接口类梗概信息
        $allIncludeApi = $this->getAllIncludeApi('./include/','kod_db_mysqlSingle','.property:filter(#$tableName) value data');
        //找到这个表对应的接口类
        $metaSearchApi = new metaSearch($allIncludeApi);
        $thisTableApiInfo = $metaSearchApi->search('.kod_db_mysqlSingle:filter([tableName='.$_POST['class'].'])')->toArray();
        if(empty($thisTableApiInfo)){
            $this->setSessionState(100,'接口不存在');
            echo '接口不存在';exit;
        }

        $this->setSessionState(20,'验证后台是否存在');
        $thisTableApiInfo = $thisTableApiInfo[0];

        //所有后台
        $allIncludeApi = $this->getAllIncludeApi('./admin/','kod_web_mysqlAdmin','#getMysqlDbHandle child .new className');
        //找到这个表对应的后台
        $metaSearchApi = new metaSearch($allIncludeApi);
        $thisTableAdminInfo = $metaSearchApi->search('.kod_web_mysqlAdmin:filter([tableName='.$thisTableApiInfo['className'].'])')->toArray();
        //如果不存在创建一个
        if(empty($thisTableAdminInfo)){
            $this->setSessionState(30,'新建后台,生成代码');
            $adminClassName = $thisTableApiInfo['className'].'Admin';
            $newClass = classAction::createClass($adminClassName,'kod_web_mysqlAdmin');
            array_splice($newClass->phpInterpreter->codeMeta['child'],1,0,array(array(
                'type'=>'functionCall',
                'name'=>'include_once',
                'property'=>array(array('type'=>'string','data'=>'../include.php')),
            )));
            $temp = $newClass->phpInterpreter->search('.comments')->toArray();
            $temp[0]['value'] = '*
* 表'.$thisTableApiInfo['className'].'操作后台
*
* User: metaPHP
* Date: '.date('Y/m/d').'
* Time: '.date('H:i').'
';
            $class = $newClass->phpInterpreter->search('.class')->toArray();
            $class[0]['child'][] = array(
                'type'=>'function',
                'public'=>true,
                'name'=>'getMysqlDbHandle',
                'child'=>array(
                    array(
                        'type'=>'return',
                        'value'=>array('type'=>'new', 'className'=>$thisTableApiInfo['className']),
                    ),
                ),
            );
            $newClass->setProperty('smartyTpl', array('type'=>'string','borderStr'=>"'",'data'=>$adminClassName.'.tpl'), 'protected');

            $dbColumn = array('type'=>'array','child'=>array());
            $classApi = new $thisTableApiInfo['className']();
            $option = $classApi->showCreateTable();
            foreach($option as $k=>$v){
                if($v['AUTO_INCREMENT']==true){
                    unset($v['primarykey']);
                }
                //填充上只在后台有意义的字段,非mysql字段
                if(!empty($_POST['option'])){
                    $this->getStrByColumnArr($k,$_POST['option'][$k]);
                    foreach(array('title','listShowType') as $vv){
                        if(isset($_POST['option'][$k][$vv])){
                            $v[$vv] = $_POST['option'][$k][$vv];
                        }
                    }
                }
                $insert = array(
                    'type' => 'arrayValue',
                    'key'=>array('type'=>'string','borderStr'=>"'",'data'=>$k),
                    'value'=>array('type'=>'array', 'child'=>array()),
                );
                foreach($v as $kk=>$vv){
                    $insert['value']['child'][] = array(
                        'type'=>'arrayValue',
                        'key'=>array('type'=>'string','borderStr'=>"'",'data'=>$kk),
                        'value'=>array('type'=>gettype($vv),'borderStr'=>"'",'data'=>$vv)
                    );
                }
                $dbColumn['child'][] = $insert;
            }
            $newClass->setProperty('dbColumn',$dbColumn, 'protected');

            $class[0]['child'][] = array(
                'type'=>'function', 'public'=>true, 'name'=>'main',
                'child'=>array(
                    array(
                        'type'=>'=',
                        'object1'=>array('type'=>'variable','name'=>'$adminHtml'),
                        'object2'=>array(
                            'type'=>'objectFunction', 'object'=>array('type'=>'$this'), 'name'=>'getAdminHtml',
                            'property'=>array(
                                array('type'=>'objectParams', 'object'=>array('type'=>'$this'), 'name'=>'dbColumn',)
                            ),
                        ),
                    ),
                    array(
                        'type'=>'objectFunction','object'=>array('type'=>'$this'),'name'=>'assign',
                        'property'=>array(
                            array('type'=>'string','data'=>'adminHtml','borderStr'=>"'"),
                            array('type'=>'variable','name'=>'$adminHtml'),
                        ),
                    ),
                ),
            );

            $newClass->phpInterpreter->codeMeta['child'][] = array(
                'type'=>'=',
                'object1'=>array('type'=>'variable', 'name'=>'$adminObj'),
                'object2'=>array('type'=>'new', 'className'=>$adminClassName),
            );
            $newClass->phpInterpreter->codeMeta['child'][] = array(
                'type'=>'objectFunction', 'object'=>'$adminObj', 'name'=>'run',
            );
            //写入文件系统
            $this->setSessionState(40,'重置环境');
            $gitAction = new githubClass();
            $gitAction->pull();
            $this->setSessionState(50,'覆盖代码文件');
            file_put_contents('./admin/'.$adminClassName.'.php',$newClass->phpInterpreter->getCode());
            file_put_contents('./admin/'.$adminClassName.'.tpl','{include file="../adminBase.tpl"}
{block name="content"}
{$adminHtml}
{/block}');
            $gitAction->add('--all');
            $gitAction->commit('增加了表'.$thisTableApiInfo['className'].'的后台');
            $this->setSessionState(70,'推送到代码库');
            $gitAction->push();
            $gitAction->branchClean();

            $allIncludeApi = $this->getAllIncludeApi('./admin/','kod_web_mysqlAdmin','#getMysqlDbHandle child .new className');
            //找到这个表对应的后台
            $metaSearchApi = new metaSearch($allIncludeApi);
        }
        $this->setSessionState(80,'获取代码库信息');
        $thisTableAdminInfo = $metaSearchApi->search('.kod_web_mysqlAdmin:filter([tableName='.$thisTableApiInfo['className'].'])')->toArray();
        $adminFileName = $thisTableAdminInfo[0]['fileName'];
        $return['adminFileName'] = 'admin/'.$adminFileName;
        $phpInterpreter = new phpInterpreter(file_get_contents('./admin/'.$adminFileName));
        $option = $phpInterpreter->search('.class:filter([extends=kod_web_mysqlAdmin]) .property:filter(#$dbColumn) value child')->toArray();
        $return['option'] = array();
        foreach($option[0] as $item){
            $insert = array();
            foreach($item['value']['child'] as $vv){
                if($vv['value']['type']=='int'){
                    $insert[$vv['key']['data']] = intval($vv['value']['data']);
                }elseif($vv['value']['type']=='bool'){
                    $insert[$vv['key']['data']] = $vv['value']['data']=='true'?true:false;
                }else{
                    $insert[$vv['key']['data']] = $vv['value']['data'];
                }
            }
            $return['option'][$item['key']['data']] = $insert;

        }
        $this->setSessionState(100,'');
        echo json_encode($return);exit;
    }

    public function getIsExistTable(){
        $tableInfo = kod_db_mysqlDB::create()->runsql('show create table '.$_POST['name']);
        if($tableInfo===-1||$tableInfo===false){
            $return = array();
            foreach($this->allMysqlColType as $k=>$v){
                $return[] = array_merge(array('type'=>$k),$v);
            }
            echo json_encode($return);exit;
        }else{
            echo 'wrong';exit;
        }
    }
    private function getStrByColumnArr($columnName,&$arr){
        if($arr['dataType']=='auto_increment'){
            $arr['dataType'] = 'int';
            $arr['AUTO_INCREMENT'] = true;
            unset($arr['primarykey']);
        }
        if($arr['default']===''){
            unset($arr['default']);
        }
        if(in_array($arr['dataType'],array('int','bigint'))){
            unset($arr['maxLength']);
        }
        if($arr['maxLength']==='NaN'){
            if($arr['dataType']=='varchar'){
                $arr['maxLength'] = 255;
            }
        }
        $arr['unique'] = ($arr['unique']==='true'||$arr['unique']===true);
        if(isset($arr['unique']) && $arr['unique']===false){
            unset($arr['unique']);
        }
        $arr['primarykey'] = ($arr['primarykey']==='true'||$arr['primarykey']===true);
        if(isset($arr['primarykey'])){
            if($arr['primarykey']===false){
                unset($arr['primarykey']);
            }else{
                unset($arr['unique']);
            }
        }
        if($arr['listShowType']==='true'||$arr['listShowType']===true){
            $arr['listShowType'] = 'hidden';
        } elseif($arr['listShowType']==='false'||$arr['listShowType']===false){
            unset($arr['listShowType']);
        }
        $arr['notNull'] = ($arr['notNull']==='true' || $arr['notNull']===true);
        $dataType = $this->allMysqlColType[$arr['dataType']]['saveType'];
        $temp = '`'.$columnName."` ".
            $dataType.
            (isset($arr['maxLength'])?('('.$arr['maxLength'].')'):'').
            ($arr['notNull']?' NOT NULL':'').
            ($arr['default']===null?'': (' DEFAULT '.
                (   in_array($dataType,array('int','bigint'))? $arr['default'] : ('"'.$arr['default'].'"'))
            )).
            (isset($arr['AUTO_INCREMENT'])?" AUTO_INCREMENT":"");
        return $temp;
    }
    public function insertTable(){
        $sql = "CREATE TABLE ".$_POST['table']."(\n";
        $primary = '';
        $unique = array();
        $temp = array();
        foreach($_POST['option'] as $key=>$val){
            $insert = $this->getStrByColumnArr($key,$val);
            $temp[] = $insert;
            if(isset($val['AUTO_INCREMENT'])){
                $primary = $key;
            }else if(isset($val['primarykey'])){
                $primary = $key;
            }
            if(isset($val['unique']) && $val['unique']===true){
                $unique[] = $key;
            }
        }
        $sql.=implode(",\n",$temp);
        if(count($unique)>0){
            foreach($unique as $v){
                $sql.=",\nUNIQUE KEY `".$v."` (`".$v."`)";
            }
        }
        if($primary!==''){
            $sql .= ",\nPRIMARY KEY (".$primary.")";
        }
        $sql .= "\n)ENGINE=InnoDB DEFAULT CHARSET=".KOD_COMMENT_MYSQLDB_CHARSET."; ";
        $result = kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($sql);
        echo $result;exit;
    }
    public function updateTableAdmin(){
        $this->setSessionState(1,'获取参数');
        $tableName = $_POST['table'];
        $option = $_POST['option'];

        //找到这个表对应的接口类
        $this->setSessionState(5,'查询是否存在接口');
        $allIncludeApiList = $this->getAllIncludeApi('./include/','kod_db_mysqlSingle','.property:filter(#$tableName) value data');
        $metaSearchApi = new metaSearch($allIncludeApiList);
        $thisTableApiInfo = $metaSearchApi->search('.kod_db_mysqlSingle:filter([tableName='.$tableName.'])')->toArray();
        if(empty($thisTableApiInfo)){
            echo '接口不存在';exit;
        }
        $className = $thisTableApiInfo[0]['className'];

        //找到这个表对应的后台
        $this->setSessionState(10,'查询是否存在后台');
        $allAdmin = $this->getAllIncludeApi('./admin/','kod_web_mysqlAdmin','#getMysqlDbHandle child .new className');
        $metaSearchApi = new metaSearch($allAdmin);
        $thisTableAdminInfo = $metaSearchApi->search('.kod_web_mysqlAdmin:filter([tableName='.$className.'])')->toArray();
        if(empty($thisTableAdminInfo)){echo '接口不存在';exit;}
        $oldCode = file_get_contents('./admin/'.$thisTableAdminInfo[0]['fileName']);
        $phpInterpreter = new phpInterpreter($oldCode);

        $classApi = new $className();
        $showCreateTable = $classApi->showCreateTable();//数据库中存储的表结构
        //查看新增的字段,修改mysql
        $isHasNewColumn = false;
        foreach($option as $k=>$v){
            if(!isset($showCreateTable[$k])){
                unset($option[$k]['name']);
                $v['dataType'] = $this->allMysqlColType[$v['dataType']]['saveType'];
                kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($classApi->addColumnSql($v));
                $isHasNewColumn = true;
            }
        }
        if($isHasNewColumn){
            $showCreateTable = $classApi->showCreateTable();//数据库中存储的表结构
        }
        //include的api的外键字段
        $allIncludeApi = new classAction($className);
        $allIncludeApi->setProperty('foreignKey', array('type'=>'array','child'=>array()), 'public');
        $numTemp = 1;
        foreach($showCreateTable as $columnName=>$dbCanshu){
            $this->setSessionState(10+intval(40/count($showCreateTable))*$numTemp++,'处理字段'.$columnName);
            if($dbCanshu['AUTO_INCREMENT']==true){unset($dbCanshu['primarykey']);}
            if(isset($option[$columnName])){
                $isChangeMql = false;//数据库是否产生变化,必然导致后台产生变化
                $isChangeAdmin = false;//后台是否产生变化
                $sql = $this->getStrByColumnArr($columnName,$option[$columnName]);
                //增加外键字段
                if(!empty($option[$columnName]['foreignKey'])){//如果这个字段设有外键
                    $foreignKey = $allIncludeApi->phpInterpreter->search('.class #$foreignKey')->toArray();
                    $foreignKey[0]['value']['child'][] = array(
                        'type'=>'arrayValue',
                        'key'=>array('type'=>'string','borderStr'=>'\'','data'=>$columnName),
                        'value'=>array('type'=>'string','borderStr'=>'\'','data'=>$option[$columnName]['foreignKey'] ),
                    );
                }
                //查看主键和唯一键是否消失
                foreach (array_diff(array_keys($dbCanshu),array_keys($option[$columnName])) as $item) {
                    if(in_array($item,array('primarykey','unique'))){
                        $dropIndexSql = 'ALTER TABLE `'.$tableName.'` DROP '.($item=='primarykey'?'primary key':('INDEX '.$columnName) );
                        if(kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($dropIndexSql)==-1){
                            $option[$columnName][$item] = true;
                        }
                    }
                }
                foreach($option[$columnName] as $kk=>$vv){
                    if($kk=='dataType'){
                        $vv = $this->allMysqlColType[$vv]['saveType'];
                    }
                    if($kk=='dataType' && in_array($vv,array('int','bigint'))){
                        if($option[$columnName]['AUTO_INCREMENT']==true && $dbCanshu['AUTO_INCREMENT']==true  ){
                            if(!in_array($dbCanshu[$kk],array('int','bigint'))){
                                $isChangeMql = true;
                            }
                        }elseif($option[$columnName]['AUTO_INCREMENT']!==$dbCanshu['AUTO_INCREMENT']){
                            $isChangeMql = true;
                        }elseif($vv!=$dbCanshu[$kk]){
                            $isChangeMql = true;
                        }
                    }elseif($kk=='primarykey'){
                        if($vv!=$dbCanshu[$kk]){
                            $dropIndexSql = 'ALTER TABLE `'.$tableName.'` ADD PRIMARY KEY(`'.$columnName.'`)';
                            if(kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($dropIndexSql)==-1){
                                unset($option[$columnName]['primarykey']);
                            }
                        }
                    }elseif($kk=='unique'){
                        if($vv!=$dbCanshu[$kk]){
                            $dropIndexSql = 'ALTER TABLE `'.$tableName.'` ADD UNIQUE(`'.$columnName.'`)';
                            if(kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($dropIndexSql)==-1){
                                unset($option[$columnName]['unique']);
                            }
                        }
                    }else if($vv!=$dbCanshu[$kk]){
                        if(in_array($kk,array('title','listShowType','foreignKey'))){
                            $isChangeAdmin = true;
                        }else{
                            $isChangeMql = true;
                        }

                    }
                }
                if($isChangeMql||$isChangeAdmin){
                    if($isChangeMql){
                        if($option[$columnName]['AUTO_INCREMENT']===true){
                            $sql.= ',ADD PRIMARY KEY (`'.$columnName.'`)';
                        }
                        $sql = 'ALTER TABLE `'.$tableName.'` MODIFY '.$sql;
                        $mysqlResult = kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($sql);
                    }
                    if(($isChangeMql&&$mysqlResult>-1)||$isChangeAdmin){
                        $oneColumnData = $phpInterpreter->search('.class:filter([extends=kod_web_mysqlAdmin]) #$dbColumn value child key:filter([data='.$columnName.'])')->parent()->toArray();
                        if(empty($oneColumnData)){
                            $tmp = $phpInterpreter->search('.class:filter([extends=kod_web_mysqlAdmin]) #$dbColumn value child')->toArray();
                            $tmp[0][] = array(
                                'type'=>'arrayValue',
                                'key'=>array('type'=>'string','borderStr'=>'\'','data'=>$columnName),
                                'value'=>array('type'=>'array','child'=>array())
                            );
                            $oneColumnData = $phpInterpreter->search('.class:filter([extends=kod_web_mysqlAdmin]) #$dbColumn value child key:filter([data='.$columnName.'])')->parent()->toArray();
                        }
                        $tempApi = new metaSearch($oneColumnData);
                        foreach($option[$columnName] as $canshu=>$canshuVal){
                            $canshuDataArr = $tempApi->search('value child key:filter([data='.$canshu.'])')->parent()->toArray();
                            if(empty($canshuDataArr)){//新增属性
                                if($canshuVal==''){continue;}
                                if(in_array($canshu,array('notNull','AUTO_INCREMENT','unique'))){
                                    $valueType = 'bool';
                                }elseif($canshu=='maxLength'){
                                    $valueType = 'int';
                                }elseif($canshu=='default'){
                                    if($option[$columnName]['dataType']=='int'){
                                        $valueType = 'int';
                                    }elseif($option[$columnName]['dataType']=='bool'){
                                        $valueType = 'bool';
                                    }else{
                                        $valueType = 'string';
                                    }
                                }else{
                                    $valueType = 'string';
                                }
                                $oneColumnData[0]['value']['child'][] = array(
                                    'type'=>'arrayValue',
                                    'key'=>array('type'=>'string','borderStr'=>'\'','data'=>$canshu),
                                    'value'=>array(
                                        'type'=>$valueType, 'borderStr'=>'\'', 'data'=>$canshuVal
                                    ),
                                );
                            }
                            else{
                                if($canshuVal==''){
                                    $canshuDataArr[0] = null;
                                }else{
                                    if($canshuDataArr[0]['key']['data']=='dataType'){
                                        if($option[$columnName]['AUTO_INCREMENT']==true){
                                            $canshuVal = 'int';
                                            $canshuMeta = $tempApi->search('value child')->toArray();
                                            $canshuMeta[0][] = array(
                                                'type'=>'arrayValue',
                                                'key'=>array('type'=>'string','borderStr'=>'\'','data'=>'AUTO_INCREMENT'),
                                                'value'=>array(
                                                    'type'=>'bool','data'=>true
                                                ),
                                            );
                                        }else{
                                            $temp3 = $tempApi->search('value child key:filter([data=AUTO_INCREMENT])')->parent()->toArray();
                                            if(count($temp3)>0){
                                                $temp3[0] = null;
                                            }
                                        }
                                    }elseif($canshuDataArr[0]['key']['data']=='default'){
                                        if($option[$columnName]['dataType']=='int'){
                                            $canshuDataArr[0]['value']['type'] = 'int';
                                        }elseif($option[$columnName]['dataType']=='bool'){
                                            $canshuDataArr[0]['value']['type'] = 'bool';
                                        }else{
                                            $canshuDataArr[0]['value']['type'] = 'string';
                                        }
                                    }
                                    $canshuDataArr[0]['value']['data'] = $canshuVal;
                                }
                            }
                        }
                    }
                }
            }else{
                $sql = 'alter table `'.$tableName.'` drop column `'.$columnName.'`';
                if(kod_db_mysqlDB::create(KOD_COMMENT_MYSQLDB)->runsql($sql)>-1){
                    $temp = $phpInterpreter->search('.class:filter([extends=kod_web_mysqlAdmin]) #$dbColumn value child key:filter([data='.$columnName.'])')->parent()->toArray();
                    $temp[0] = null;
                }
            }
        }
        $this->setSessionState(60,'修改接口类');
//        提交git
        $gitAction = new githubClass();
        $gitAction->pull();
        $allIncludeApi->save();
        $gitAction->add('--all');
        $gitAction->commit('类'.$className.'设置了外键');
        $this->setSessionState(70,'修改后台类');
        $newCode = $phpInterpreter->getCode();
        if($oldCode!==$newCode){
            file_put_contents('./admin/'.$thisTableAdminInfo[0]['fileName'],$newCode);
        }
        $gitAction->add('--all');
        $gitAction->commit('后台'.$className.'设置了外键');
        $this->setSessionState(80,'push代码到代码库');
        $gitAction->push();
        $gitAction->branchClean();
        $this->setSessionState(100,'');
    }
    //保存文件并提交git
    public function pushGit($file,$code,$message){
        $gitAction = new githubClass();
        $gitAction->pull();
        file_put_contents($file,$code);
        $gitAction->add('--all');
        $gitAction->commit($message);
        $gitAction->push();
        $gitAction->branchClean();
    }
    public function __construct()
    {
        $func = $_POST['action'];
        if(false && $func!=='getSessionState'){
            session_start();
            if($_SESSION['program']['program']<100 && $_SESSION['program']['program']>0){
                echo json_encode(array(
                    'return'=>false,
                    'text'=>'有操作正在运算中,请稍后再试',
                ));exit;
            }
        }
        $this->$func();
    }
    //控制长操作进度
    private function setSessionState($program,$text){
        session_start();
        $_SESSION['program'] = array(
            'program' =>$program,
            'text' =>$text,
        );
        session_write_close();
    }
    public function getSessionState(){
        session_start();
        $webStateNow = $_POST['now'];
        $allTime = 10000000;//10秒
        $per = 100000;//轮播间隔
        for($i=0;$i<$allTime/$per;$i++){
            usleep($per);
            session_start();
            $nowProgram = $_SESSION['program'];
            session_write_close();
            if($nowProgram['program']==100){
                echo json_encode($nowProgram);exit;
            }else if($webStateNow!=$nowProgram['program']){
                echo json_encode($nowProgram);exit;
            }
        }
        echo json_encode($nowProgram);exit;
    }

    public function createPage(){
        $this->setSessionState(0,'正在生成代码逻辑');
        if(preg_match('/(.*).php/',$_POST['fileName'],$match)){
            $name = $match[1];
            $phpPath = './http/'.$name.'.php';
            $tplName = $name.'.tpl';
            $tplPath = './http/'.$tplName;
            if(file_exists($phpPath)){
                echo json_encode(array(
                    'result'=>false,'message'=>'file exist'
                ));exit;
            }else{
                $metaApi = new phpInterpreter(file_get_contents('./httpAdmin.php'));
                $search = $metaApi->search('.= object2:filter([className=kod_web_page])')->parent()->toArray();
                $kod_web_pageObj = $search[0]['object1']['name'];
                $httpFileConfig = $metaApi->search('.= object1:filter(.objectParams):filter(#httpFileConfig) object:filter(#'.$kod_web_pageObj.')')->parent()->parent()->toArray();
                $this->setSessionState(10,'正在生成代码逻辑');
                $httpFileConfig[0]['object2']['child'][] = array(
                    'type'=>'arrayValue',
                    'key'=>array(
                        'type'=>'string',
                        'borderStr'=>"'",
                        'data'=>$name.'.php',
                    ),
                    'value'=>array(
                        'type'=>'string',
                        'borderStr'=>"'",
                        'data'=>$_POST['title'],
                    ),
                );
                $this->setSessionState(30,'正在写入文件');
                file_put_contents('./httpAdmin.php',$metaApi->getCode());
                file_put_contents($phpPath,'<?php
/**
 * Created by PhpStorm.
 * User: metaPHP
 * Date: '.date('Y-m-d').'
 * Time: '.date('H-i-s').'
 */
include_once(\'../include.php\');
$page=new kod_web_page();

$page->fetch(\''.$tplName.'\');');
                file_put_contents($tplPath,'<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no,minimal-ui">
    <link href="//cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    <script type="application/javascript" src="//cdn.bootcss.com/jquery/3.2.1/jquery.js"></script>
    <script type="application/javascript" src="//cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>

</body>
</html>');
                $this->setSessionState(40,'正在进行commit');
                $gitAction = new githubClass();
                $gitAction->add('--all');
                $gitAction->commit('增加了页面:'.$name.'.php');
                $this->setSessionState(70,'正在push到远程');
                $gitAction->push();
                $gitAction->branchClean();
                $this->setSessionState(90,'正在获取最新代码');
                $gitAction->pull();
                $this->setSessionState(100,'完成');
            }
        }
    }

}
$a = new control();