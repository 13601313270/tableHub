<?php
/**
 * Created by PhpStorm.
 * User: wanghaoran
 * Date: 2019-01-24
 * Time: 02:35
 */
header('Access-Control-Allow-Origin: *');
if ($_GET['action'] === 'begin') {
    require_once('../sunweiPush/index.php');
} else if ($_GET['action'] === 'check') {
    require_once('../sunweiPush/httpCheck.php');
}