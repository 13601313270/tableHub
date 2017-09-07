<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:14
 */
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
    private $gitAction;
    public function __construct()
    {
        $this->gitAction = new githubClass();
        $func = $_POST['action'];
        $result = $this->$func();
        echo json_encode($result);
    }
    private function setSessionState($program,$text){
        session_start();
        $_SESSION['program'] = array(
            'program' =>$program,
            'text' =>$text,
        );
        session_write_close();
    }
    public function rename(){
        $this->setSessionState(1,'正在获取代码');
        if(in_array($_POST['name'],scandir('./http/'))){
            $metaApi = new phpInterpreter(file_get_contents('./httpAdmin.php'));
            $search = $metaApi->search('.= object2:filter([className=kod_web_page])')->parent()->toArray();
            $kod_web_pageObj = $search[0]['object1']['name'];
            $httpFileConfig = $metaApi->search('.= object1:filter(.objectParams):filter(#httpFileConfig) object:filter(#'.$kod_web_pageObj.')')->parent()->parent()->toArray();
            $isHasExist = new metaSearch($httpFileConfig[0]['object2']);
            $isHasExist = $isHasExist->search('child .arrayValue key:filter([data='.$_POST['name'].'])')->parent()->toArray();
            $this->setSessionState(10,'正在生成代码逻辑');
            if(count($isHasExist)>0){
                $isHasExist[0]['value']['data'] = $_POST['title'];
            }else{
                $httpFileConfig[0]['object2']['child'][] = array(
                    'type'=>'arrayValue',
                    'key'=>array(
                        'type'=>'string',
                        'borderStr'=>"'",
                        'data'=>$_POST['name'],
                    ),
                    'value'=>array(
                        'type'=>'string',
                        'borderStr'=>"'",
                        'data'=>$_POST['title'],
                    ),
                );
            }
            $this->setSessionState(30,'正在重置环境');
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->checkout($this->gitAction->runLocalBranch);
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->branchClean();
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->pull();
            echo date('Y-m-d H:i:s')."\n";
            $this->setSessionState(50,'正在修改代码');
            file_put_contents('./httpAdmin.php',$metaApi->getCode());
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->add('--all');
            $this->gitAction->commit('修改httpAdmin.php文件配置kod_web_page实例的httpFileConfig属性'.$_POST['name'].'改为'.$_POST['title']);
            echo date('Y-m-d H:i:s')."\n";
            $this->setSessionState(80,'正在推送到线上库');
            $this->gitAction->push();
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->branchClean();
            echo date('Y-m-d H:i:s')."\n";
            $this->gitAction->checkout($this->gitAction->runLocalBranch);
        }
        $this->setSessionState(100,'修改完成');
        exit;
    }
    public function getBranch(){
        $this->setSessionState(1,'正在获取分支');
        $allBranch = $this->gitAction->createBranch('-a',false);
        $this->setSessionState(100,'获取完成');
        return array(
            'branch'=>$allBranch,
            'diff'=>$this->gitAction->exec('git diff --name-status'),
            'commit'=>$this->gitAction->exec('git cherry -v'),
        );
    }
    public function checkout(){
        $this->gitAction->branchClean();
        $branchName = $_POST['sName'];
        if(preg_match('/^\S{7}$/',$branchName)){
            return $this->gitAction->checkout($branchName);
        }else{
            $allExistBranch = $this->gitAction->createBranch('-a',false);
            if(in_array('  '.$branchName,$allExistBranch)){
                $branchName = str_replace('remotes/origin/','',$branchName);
                return $this->gitAction->checkout($branchName);
            }
        }
    }
    public function updateBranch(){
        $this->setSessionState(10,'拉取最新代码');
        $this->gitAction->pull(true);
        $this->setSessionState(80,'清除编辑中的代码');
        $result = $this->gitAction->exec('git remote prune origin');
        $this->setSessionState(100,'清除编辑中的代码');
        return $result;
    }
    public function pull(){
        $this->setSessionState(10,'正在拉取');
        $result = $this->gitAction->pull(true);
        $this->setSessionState(100,'拉取完成');
        return $result;
    }
    public function commit(){
        $this->gitAction->add('.');
        return $this->gitAction->commit($_POST['message']);
    }
    public function push(){
        $this->setSessionState(1,'正在push');
        $result = $this->gitAction->push();
        $this->setSessionState(100,'push完成');
        return $result;
    }
    public function githubClean(){
        return $this->gitAction->branchClean();
    }
    public function commitlog(){
        return $this->gitAction->exec('git log --graph --pretty=format:"%h (%p) (%s) %an %ai"');
    }
}
$a = new control();