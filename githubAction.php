<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/1/23
 * Time: 下午2:56
 *
 * $a = array();
 */




ini_set('display_errors', 1);
error_reporting(E_ALL ^ E_NOTICE);
set_time_limit(60);
include_once('./include.php');
include_once('./metaPHP/githubAction.php');
include_once('./metaPHP/classAction.php');
include_once('./metaPHP/phpInterpreter.php');

$content = implode('',file('./metaPHP/phpInterpreter2.php'));
//phpInterpreter类是一个php解析器,把代码解析成一个数组的类型,这时代码被数据化
$daoFileMetaCode = new phpInterpreter($content);

$result = &$daoFileMetaCode->search('[extends]');
$result = 1;
print_r($daoFileMetaCode->codeMeta);exit;
print_r($result);exit;


$result = array_search_re('bar 3', $foo);
print_r($daoFileMetaCode->getCode());exit;



$content = implode('',@file('./metaPHP/classAction.php'));

//$classActionClass = new classAction('classAction');
$classActionClass = classAction::createClass('ss');
$classActionClass->setProperty('key','value','private');
var_dump($classActionClass->phpInterpreter->getCode());
exit;

//判断返回回来的数据是否是一样的
print_r($array);exit;

class temp extends githubAction{
    public $runLocalBranch = 'develop';
    public $webRootDir = '/var/www/html/metaPHPTest';
    public $cachePath = '/var/www/html/metaPHPTest/metaPHPCacheFile';

    public function main(){
        $newBranchName = '父类操作分支';
        $this->createBranch($newBranchName);
        $tempParentClass = new classAction('parentTempClass');
//        $tempParentClass->getProperties()
        $tempParentClass->remove();
        $this->commit('删除了parentTempClass');
        $this->checkout($this->runLocalBranch);
        $this->mergeBranch($newBranchName);
        $this->commit('合并分支:'.$newBranchName.'到'.$this->runLocalBranch);
        $this->deleteBranch($newBranchName);
        $this->push();
    }
    public function run()
    {
        $input = file_get_contents('php://input');
        if(empty($input)){
            //第二次被命令行触发,进入这里
            $this->checkout($this->runLocalBranch);
            $this->branchClean();
            try{
                $this->main();
            }catch (Exception $e){
                print_r($e);
            }
            $this->branchClean();
            $this->checkout($this->runLocalBranch);
        }else{
            //第一次触发,进入这里,拉取代码,然后重新跳转到自己,执行新加载的代码
            $response = json_decode($input);
            if(!in_array($response->ref,array(
                'refs/heads/master',
                'refs/heads/develop'
            ))){
                exit;
            }
            if(count($response->commits)==0 || $response->commits[0]->author->name=='metaPHPRobot'){
                exit;
            }
            $this->checkout($this->runLocalBranch);
            $this->branchClean();
            parent::pull();
            exec('cd ' .dirname(__FILE__) . ';php '.__FILE__);
        }
    }
}
$a = new temp();
$a->run();