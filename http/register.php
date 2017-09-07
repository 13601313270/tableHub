<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:08
 */
include_once('../include.php');
if($_GET['action']=='getVerify'){
    $temp = new kod_tool_imageVerifyCode();
    $worle = 'WORLD';
    $temp->getImage($worle,200,100,10);exit;
}elseif($_POST['action']=='regist'){
    $result = true;
    if(!preg_match('/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-])+)+$/',$_POST['email'])){
        $result = false;
    }
    if($_POST['password']==''){
        $result = false;
    }
    if(strlen($_POST['password'])<8){
        $result = false;
    }
    $result = user::create()->insert(array(
        'email' => $_POST['email'],
        'state' => 1,
        'password'=>$_POST['password']
    ));
    if($result!==false){
        //注册成功,用户id是$result
    }else{
        $page=new kod_web_page();
        $page->msgWrong = '注册失败,请重新输入信息';
        $page->fetch('register.tpl');
        //注册失败,请重新输入信息
    }
}else{
    $page=new kod_web_page();
    $page->fetch('register.tpl');
}