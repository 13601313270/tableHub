<?php
/**
 * Created by PhpStorm.
 * User: mfw
 * Date: 2017/11/2
 * Time: 下午3:37
 */
header('Content-type: text/javascript');
echo file_get_contents('./js'.$_SERVER['SCRIPT_NAME']);
print_r($_SERVER['SCRIPT_NAME']);