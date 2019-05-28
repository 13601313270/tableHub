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
        CURLOPT_URL => 'https://www.googleapis.com/drive/v3/files?q=mimeType+%3d+%27text/csv%27%20or%20mimeType+%3d+%27application/vnd.google-apps.spreadsheet%27&access_token=' . $_GET['token']
    ]);
    $str = curl_exec($ch);
    curl_close($ch);
    echo $str;
    exit;
    //$result = file_get_contents('https://www.googleapis.com/drive/v3/files?access_token=' . $_GET['token']);
} else {
    // 获取文件信息
    $url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '?access_token=' . $_GET['token'];
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt_array($ch, [
        CURLOPT_URL => $url
    ]);
    $info = curl_exec($ch);
    $result = json_decode($info, true);
    if (isset($result['error']) && $result['error']['code'] === 401) {
        echo $info;
        exit;
    }

    // 获取下载文件地址
    if ($result['mimeType'] === 'text/csv') {
        $url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '?access_token=' . $_GET['token'] . "&alt=media";
    } else if ($result['mimeType'] === 'application/vnd.google-apps.spreadsheet') {
        $url = 'https://www.googleapis.com/drive/v3/files/' . $_GET['file'] . '/export?access_token=' . $_GET['token'] . '&mimeType=text/csv';
    }
    curl_close($ch);

    // 下载文件
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, true);
    curl_setopt_array($ch, [
        CURLOPT_URL => $url
    ]);
    $info = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    $headerSize = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
    curl_close($ch);

    if ($code === 307) {
        $info = substr($info, 0, $headerSize);
        if (preg_match('/Location: (\S+)/', $info, $match)) {
            $info = file_get_contents($match[1]);
            echo $info;
        }
        exit;
    } else {
        $info = substr($info, $headerSize);
    }
    echo $info;
}
echo $result;
