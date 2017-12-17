<?php
/**
 * Created by PhpStorm.
 * User: 王浩然
 * Date: 2017/3/20
 * Time: 下午2:08
 */
include_once('../include.php');
include_once('../phpExcel/Classes/PHPExcel.php');
$userInfo = user::create()->getBySessionToken($_COOKIE['sessionToken']);
if (empty($userInfo)) {
    header('Location:/login.html');
    exit;
    throw new Exception('请登录后进行操作');
}
if ($_POST['action'] == 'upFile') {
    function getStyleArr($styleObj)
    {
        $returnArr = array();
        //字体
        $font = $styleObj->getFont();
        $returnArr['font'] = array(
            'name' => $font->getName(), 'size' => $font->getSize(), 'bold' => $font->getBold() ? 1 : 0,
            'italic' => $font->getItalic() ? 1 : 0, 'underline' => $font->getUnderline(),
            'color' => $font->getColor()->getARGB(),
        );
        //填充
        $fill = $styleObj->getFill();
        $returnArr['fill'] = array(
            'fillType' => $fill->getFillType(), 'rotation' => $fill->getRotation(),
            'startColor' => $fill->getStartColor()->getARGB(),
            'endColor' => $fill->getEndColor()->getARGB(),
            'isSupervisor' => $fill->getIsSupervisor(),
        );
        //格式
        $numberFormat = $styleObj->getNumberFormat();
        $returnArr['numberFormat'] = array(
            'formatCode' => $numberFormat->getFormatCode(),
            'builtInFormatCode' => $numberFormat->getBuiltInFormatCode()
        );
        //排列
        $alignment = $styleObj->getAlignment();
        $returnArr['alignment'] = array(
            'horizontal' => $alignment->getHorizontal(),
            'vertical' => $alignment->getVertical(),
//            'builtInFormatCode'=>$alignment->getBuiltInFormatCode()
        );
        //边框
        $border = $styleObj->getBorders();
        $borderArr = array();
        $left = $border->getLeft();
        if ($left->getBorderStyle() != 'none') {
            $borderArr['left'] = array('color' => $left->getColor()->getARGB(), 'style' => $left->getBorderStyle());
        }
        $right = $border->getRight();
        if ($right->getBorderStyle() != 'none') {
            $borderArr['right'] = array('color' => $right->getColor()->getARGB(), 'style' => $right->getBorderStyle());
        }
        $top = $border->getTop();
        if ($top->getBorderStyle() != 'none') {
            $borderArr['top'] = array('color' => $top->getColor()->getARGB(), 'style' => $top->getBorderStyle());
        }
        $bottom = $border->getBottom();
        if ($bottom->getBorderStyle() != 'none') {
            $borderArr['bottom'] = array('color' => $bottom->getColor()->getARGB(), 'style' => $bottom->getBorderStyle());
        }
        if (!empty($borderArr)) {
            $returnArr['border'] = $borderArr;
        }
        return $returnArr;
    }

    $data = array('fileName' => $_POST['fileName']);
    $data['sDate'] = date('Y-m-d');
    $file = PHPExcel_IOFactory::load($_FILES['file']['tmp_name']);
    //识别图表
    $data['getCellXfCollection'] = $file->getCellXfCollection();
    foreach ($file->getCellXfCollection() as $k => $v) {
        $data['getCellXfCollection'][$k] = getStyleArr($v);
    }
    $data['table'] = array();
    foreach ($file->getAllSheets() as $tableNum => $tablesItem) {
        $columnArr = array();
        foreach ($tablesItem->getColumnDimensions() as $k => $v) {
            $columnArr[$k] = array(
                'width' => intval($v->getWidth()),
                'autoSize' => $v->getAutoSize(),
                'visible' => $v->getVisible(),
                'outlineLevel' => $v->getOutlineLevel(),
                'collapsed' => $v->getCollapsed(),
            );
        }
        $rowArr = array();
        foreach ($tablesItem->getRowDimensions() as $k => $v) {
            $rowArr[$k] = array(
                'height' => intval($v->getRowHeight() * 1.5),
                'visible' => $v->getVisible(),
                'outlineLevel' => $v->getOutlineLevel(),
                'collapsed' => $v->getCollapsed(),
            );
        }
        $tablesKeys = $tablesItem->getCellCacheController()->getCellList();
        //数据
        $tableValue = array();
        foreach ($tablesKeys as $key) {
            //限制不能无限大
            if (preg_match('/^([A-Z]){1,2}(\d{1,3})$/', $key, $match)) {
                $cell = $tablesItem->getCell($key);
                $value = $cell->getValue();
                if (gettype($value) !== 'object') {
                    $value = $cell->getValue();
                    $xIndex = $cell->getXfIndex();
                    if (empty($value)) {
                        $style = $data['getCellXfCollection'][$xIndex];
                        if ($style['fill']['startColor'] == 'FF000000' && $style['fill']['endColor'] == 'FF000000' && !isset($style['border'])) {
                            continue;
                        }
                    } else {
                        $tableValue[$key] = array('value' => $value, 'xfIndex' => $xIndex);
                    }
                }
            }
        }
        $data['table'][$tableNum]['title'] = $tablesItem->getTitle();
        $data['table'][$tableNum]['row'] = $rowArr;//列头
        $data['table'][$tableNum]['column'] = $columnArr;//表头
        $data['table'][$tableNum]['tableValue'] = $tableValue;//表格内容
        $data['table'][$tableNum]['mergeCells'] = $tablesItem->getMergeCells();//单元格合并
    }
    //保存服务器
    $id = excel::create()->insert(array(
        'ctime' => $data['sDate'],
        'title' => $data['fileName'],
        'style' => json_encode($data['getCellXfCollection']),
        'data' => json_encode($data['table']),
        'author' => $userInfo['id']
    ));
    var_dump($id);
    exit;
} elseif ($_POST['action'] == 'createEmpty') {
    $id = excel::create()->insert(array(
        'ctime' => date('Y-m-d'),
        'title' => $_POST['fileName'],
        'style' => '[{"font":{"name":"\u5b8b\u4f53","size":12,"bold":0,"italic":0,"underline":"none","color":"FF000000"},"fill":{"fillType":"none","rotation":0,"startColor":"FF000000","endColor":"FFFFFFFF","isSupervisor":false},"numberFormat":{"formatCode":"General","builtInFormatCode":0},"alignment":{"horizontal":"general","vertical":"bottom"}}]',
        'data' => '[]',
        'author' => $userInfo['id']
    ));
    echo $id;
    exit;
} elseif ($_POST['action'] == 'login') {

} else {
    $page = new kod_web_page();
    $page->fileList = excel::create()->onlyColumn('id,title')->getListByUserId($userInfo['id']);
    $page->fetch('myList.tpl');
}