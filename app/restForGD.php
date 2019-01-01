<?php
/**
 * Created by PhpStorm.
 * User: ptmind
 * Date: 2018/12/27
 * Time: 1:43 PM
 */
// 创建一个新cURL资源
if ($_GET['type'] === 'list') {
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt_array($ch, [
        CURLOPT_URL => 'https://www.googleapis.com/drive/v3/files?access_token=' . $_GET['token']
    ]);
    $str = curl_exec($ch);
    curl_close($ch);
    echo $str;
    exit;
    //$result = file_get_contents('https://www.googleapis.com/drive/v3/files?access_token=' . $_GET['token']);
} else {
    //$url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '/export?access_token=' . $_GET['token'] . '&mimeType=text/csv';
    $url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '?access_token=' . $_GET['token'] . "&alt=media";
    $url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '?access_token=' . $_GET['token'] . "&alt=media";
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt_array($ch, [
        CURLOPT_URL => $url
    ]);
    $str = curl_exec($ch);
    curl_close($ch);
    echo $str;
    //alt=media
}
echo $result;
