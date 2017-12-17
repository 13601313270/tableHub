<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:08
 */
include_once('../include.php');
if ($_GET['action'] == 'getVerify') {
    $temp = new kod_tool_imageVerifyCode();
    $chars_array = array(
        "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k",
        "l", "m", "n", "o", "p", "q", "r", "s", "t",
        "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G",
        "H", "I", "J", "K", "L", "M", "N", "P", "Q", "R",
        "S", "T", "U", "V", "W", "X", "Y", "Z",
    );
    $charsLen = count($chars_array) - 1;
    $world = "";
    for ($i = 0; $i < 4; $i++) {
        $world .= $chars_array[mt_rand(0, $charsLen)];
    }
    kod_db_memcache::set('loginVerify:' . $_GET['user'], $world, 60 * 5);
    $temp->getImage($world, 200, 100, 10);
    exit;
} elseif ($_GET['action'] == 'getRegisterToken') {
    $saveWorld = kod_db_memcache::get('loginVerify:' . $_GET['email']);
    if ($saveWorld !== false) {
        if (strtolower($saveWorld) == strtolower($_GET['verify'])) {
            $token = user::create()->getLoginToken($_GET['email']);
            if ($token !== false) {
                kod_db_memcache::set('loginVerify:' . $_GET['email'], false);
                echo json_encode($token);
                exit;
            }
        } else {
            echo json_encode(array(
                'error' => '1',
            ));
            exit;
        }
    }
} elseif ($_GET['logout'] === 'true') {
    $userLoginInfo = user::create()->unLoginBySessionToken($_COOKIE['sessionToken']);
    unset($_COOKIE['sessionToken']);
    header('Location:/login.html');
    exit;
} elseif ($_POST['action'] == 'login') {
    $result = true;
    if (!preg_match('/^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.([a-zA-Z0-9_-])+)+$/', $_POST['email'])) {
        $result = false;
    }
    if ($_POST['password'] == '') {
        $result = false;
    }
    $sessionToken = user::create()->getSessionTokenSafe($_POST['email'], $_POST['password']);
    echo $sessionToken;
    exit;
} else {
    $page = new kod_web_page();
    $page->fetch('login.tpl');
}