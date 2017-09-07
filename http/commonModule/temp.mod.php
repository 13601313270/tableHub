<?php
/**
 *
 * User: 王浩然
 * Date: 2017/04/25
 * Time: 00:37
 */
class kodMod_commonModule_temp extends kod_web_smartyModController{
    public function init($iImg='http://v3.bootcss.com/assets/img/devices.png'){
        $this->assign('img',$iImg);
    }
    public function finish($aData)
    {
    }
}