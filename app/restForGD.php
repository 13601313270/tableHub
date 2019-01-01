<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
// 创建一个新cURL资源
if ($_GET['type'] === 'list') {
    $result = file_get_contents('https://www.googleapis.com/drive/v3/files?access_token=' . $_GET['token']);
} else {
    $result = file_get_contents('https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '?access_token=' . $_GET['token']);
}
echo $result;
