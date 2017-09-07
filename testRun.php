<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/1/19
 * Time: 下午6:13
 */
include_once 'metaPHP/classAction.php';
include_once 'include.php';

$parentClass = classAction::createClass('tempParentClass','','','autoLoadClass');
$parentClass->save();

$class = classAction::createClass('classTestClass','tempParentClass','','autoLoadClass');
$class->save();
exit;



//print_r($class->testFunction());exit;
//var_dump($class->getParentClass());
//print_r($class->getInterfaces());
//var_dump($class->getStartLine());
//var_dump($class->getEndLine());




foreach($class->getMethods() as $item){
    if($item->class==$class->getName()){


		$item->isAbstract(true)->save();
        $item->isFinal(true)->save();
//        $item->isDeprecated();
//        exit;
//		print_r($item->getModifiers());
//		var_dump($item->getStartLine());
//		var_dump($item->getEndLine());
//		var_dump($item->getShortName());
//		var_dump($item->getName());
//		echo $class->getMethodsCode($item->getName());
    }
}
print_r($class->getMethods());
exit;
