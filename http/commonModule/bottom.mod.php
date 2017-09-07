<?php
/**
 *
 * User: 王浩然
 * Date: 2017/04/25
 * Time: 00:37
 */
class kodMod_commonModule_bottom extends kod_web_smartyModController{
    public function init(){
        $this->assign('fiendLinks',array(
            array('bootstrap','http://v3.bootcss.com/'),
            array('kod框架','https://github.com/13601313270/kod'),
            array('metaPHP','https://github.com/13601313270/metaPHP'),
            array('Glyphicons','http://glyphicons.com/'),
        ));
    }
    public function finish()
    {
    }
}