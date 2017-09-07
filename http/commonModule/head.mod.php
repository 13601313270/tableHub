<?php
/**
 *
 * User: 王浩然
 * Date: 2017/04/25
 * Time: 00:37
 */
include_once(dirname(webDIR).'/include/user.php');
include_once(dirname(webDIR).'/include/userInfo.php');
class kodMod_commonModule_head extends kod_web_smartyModController{
    public $title='通用头部';
    public function init($type){
        $this->assign('headTitle','tablehub.cn');
        $userLoginInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
        if($userLoginInfo!==false){
            $userInfo = userInfo::create()->getByKey($userLoginInfo['id']);
            if($userInfo){
                $this->assign('userInfo',array(
                    'userName'=>$userInfo['user_name']
                ));
            }else{
                $this->assign('userInfo',array(
                    'userName'=>$userLoginInfo['email']
                ));
            }
        }
    }
    public function finish()
    {
    }
}