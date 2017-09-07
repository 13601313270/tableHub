<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/4/14
 * Time: 下午4:02
 */
$hook_log = json_decode(file_get_contents('php://input'));
echo "得到请求\n";


print_r($hook_log);

//收到的事件,比如push
$event = $hook_log->events;
var_dump($event);

//项目名称
$repositoryName = $hook_log->repository->name;
var_dump($repositoryName);
