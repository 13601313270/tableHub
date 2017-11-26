<style>
    #dataFloat {
        background-color: white;
        border: solid 1px black;
        width: 500px;
        position: fixed;
        z-index: 99;
        top: 100px;
        left: 30px;
        display: none;
    }

    #dataFloat .content {
        margin: 10px;
        height: auto;
        overflow-y: auto;
        max-height: 400px;
    }

    #dataFloat .conallFunctent {
        width: 100%;
        padding-top: 10px;
        max-height: 400px;
        overflow-y: scroll
    }

    #dataFloat .head {
        width: 100%;
        height: 30px;
        background-color: #82b8ff;
    }

    #dataFloat .action {
        padding: 5px;
    }

    #dataFloat .col-sm-9 {
        padding-right: 0;
    }

    .form-group {
        margin-bottom: 0;
        border-top: solid 2px #505050;
    }

    .form-control {
        background-color: rgba(255, 255, 255, 0.82);
    }

    .form-group:first-child {

        border-top: none;
    }

    .form-group:before {
        display: table;
        content: " ";
        box-sizing: border-box;
    }

    .form-group:after {
        clear: both;
        display: table;
        content: " ";
    }

    .dataBaseItem {
        padding-left: 0;
        padding-right: 0;
        margin-left: 15px;
        margin-right: 2px;
        margin-bottom: 2px;
        border: solid 4px #2f2f2f;
        background-color: rgba(102, 184, 255, 0.41);
    }

    .dataBaseItem > .form-group > [name=dataType] {
        width: 90%;
    }

    .dataBaseItemSingle {
        border: none !important;
    }

    .dataBaseItemNoParam {
        border: none !important;
    }

    .dataBaseItemNoParam > .form-group > .form-control {
        width: 100%;
    }

    .dataBaseItemChild {
        height: 34px;
        overflow-y: hidden;
        border: none;
    }

    #dataFloat .content > .form-group:first-child > .add {
        display: none;
    }

    #dataFloat .content > .form-group:first-child > .form-control {
        width: 100%;
    }

    #dataFloat .content > .form-group > div > .add {
        display: none;
    }

    .dataBaseItem > .addMore {
        width: 100%;
        text-align: center;
        border-top: solid 2px #505050;
        background-color: #94ccfb;
        font-size: 16px;
    }

    .dataBaseItem > .addMore:hover {
        background-color: #87bae5;
    }

    #dataFloat.floatSingleValue {
        border: none;
    }

    #dataFloat.floatSingleValue .head {
        display: none;
    }

    #dataFloat.floatSingleValue > .content {
        display: none;
    }

    .floatSingleValueWrite {
        height: 1px;
        width: 1px;
        position: relative;
        margin-top: -2px;
    }

    .tableBody .allCharts {
        height: 1px;
        width: 1px;
        position: relative;
    }

    .floatSingleValueWrite .input {
        position: absolute;
        display: none;
        background-color: rgb(255, 255, 255);
        box-shadow: 0 0 30px rgba(0, 0, 0, 0.63);
    }

    .floatSingleValueWrite input:focus {
        outline: none;
    }

    .floatSingleValueWrite input {
        width: 100%;
        height: 100%;
    }

    .floatSingleValueWrite .span {
        opacity: 0;
    }
</style>
<template>
    <div id="dataFloat">
        <div class="head"></div>
        <div class="content"></div>
        <div class="contentText" style="border-top:solid 1px grey">
            <textarea style="width: 100%;"></textarea>
        </div>
        <div class="action">
            <input type="button" class="btn save" value="确定"/>
            <input type="button" class="btn copyTo" value="复制到" @click="copyTo"/>
        </div>
    </div>
</template>
<script>
    import ajax from '@/tools/ajax.js'
    import writeTd from '@/tools/writeTd.js';
    import setTdSelectState from '@/tools/setTdSelectState.js';

    function _initFloatType(evalObj, insertDom, select) {
        if (evalObj instanceof __runObj__) {
            var type = evalObj.funcName;
            if (type === '') {
                type = '=';
            }
        } else if (evalObj instanceof obj) {
            var type = evalObj.className;
        } else if (typeof evalObj === 'object' && evalObj.name) {
            var type = evalObj.name;
        } else {
            var type = '';
        }
        insertDom.data('type', type);
//        insertDom.data('select',select);
        insertDom.data('select', select);
        insertDom.html('');
        insertDom.removeClass('dataBaseItemSingle dataBaseItemNoParam dataBaseItemChild');
        //调用普通的系统函数
        if (typeof window[type] === 'function' && window[type].config === undefined) {
            type = '=';
        }
        var isWriteSingle = (type === '=' || type === '');
        var allChartsName = [];
        for (let i = 0; i < allChartFunction.length; i++) {
            allChartsName.push(allChartFunction[i].funcName);
        }
        if (evalObj instanceof obj && allChartsName.indexOf(evalObj.className) > -1) {
            insertDom.addClass('dataBaseItem dataBaseItemChild');
            var config = window[type].config.params;
            var allFuncDom = $('<div class="form-group">' +
                '<select style="float:left;" class="form-control" name="dataType">' +
                '<option value="' + evalObj.className + '">' + evalObj.className + '</option>' +
                '</select>' +
                '</div>');
        } else {
            if (isWriteSingle && evalObj !== true && evalObj !== false) {
                insertDom.addClass('dataBaseItem dataBaseItemSingle');
                var domStr = '<div class="form-group">' +
                    '<select class="form-control" name="dataType" style="width:20%;float:left;">' +
                    '<option value="" ' + (type === '' ? 'selected' : '') + '>值</option>' +
                    '<option value="=" ' + (type === '=' ? 'selected' : '') + '>计算</option>' +
                    '</select>';
                if (select !== undefined) {
                    domStr += '<select class="form-control" style="width:80%;" name="value">';
                    for (let j in select) {
                        domStr += '<option value="' + j + '">' + select[j] + '</option>';
                    }
                    domStr += '</select>';
                } else {
                    domStr += '<input class="form-control" name="value" style="width:80%;" placeholder="值">';
                }
                domStr += '</div>';
                var allFuncDom = $(domStr);
            } else if (evalObj === true || evalObj === false || window[type].config.params == undefined) {
                insertDom.addClass('dataBaseItem dataBaseItemNoParam');
                //调用无参数函数
                var allFuncDom = $('<div class="form-group">' +
                    '<select class="form-control" name="dataType">' +
                    '<option value="">值</option>' +
                    '<option value="=">计算</option>' +
                    '</select>' +
                    '</div>');
            } else {
                insertDom.addClass('dataBaseItem dataBaseItemChild');
                var config = window[type].config.params;
                var allFuncDom = $('<div class="form-group">' +
                    '<select style="float:left;" class="form-control" name="dataType">' +
                    '<option value="">值</option>' +
                    '<option value="=">计算</option>' +
                    '</select>' +
                    '<div class="add btn btn-default" style="width: 10%"><i class="glyphicon glyphicon-chevron-down"></i></div>' +
                    '</div>');

            }
            allFuncDom.find('[name=dataType]').append('<option value="true" ' + (evalObj === true ? 'selected' : '') + '>真(true)</option>');
            allFuncDom.find('[name=dataType]').append('<option value="false" ' + (evalObj === false ? 'selected' : '') + '>假(false)</option>');
            for (var i in allFunc) {
                if (type == allFunc[i].funcName) {
                    allFuncDom.find('[name=dataType]').append('<option value="' + allFunc[i].funcName + '" selected>' + allFunc[i].title + '(' + allFunc[i].funcName + ')</option>');
                } else {
                    allFuncDom.find('[name=dataType]').append('<option value="' + allFunc[i].funcName + '">' + allFunc[i].title + '(' + allFunc[i].funcName + ')</option>');
                }
            }
        }
        insertDom.append(allFuncDom);
        (function() {
            if (isWriteSingle) {
                insertDom.find('[name=value]').val(getStrByEvalObj($('#myTabContent .active').data('tableid'), evalObj));
            } else {
                for (let i in config) {
                    if (config[i] instanceof Array) {
                        if (evalObj[i].length > 0) {
                            for (var j = 0; j < evalObj[i].length; j++) {
                                var dom = $('<div class="form-group" data-name="' + i + '[]">' +
                                    '<label class="control-label">' + config[i][0].title + '</label>' +
                                    '<div></div>' +
                                    '</div>');
                                if (config[i][0].dataType === 'bool') {
                                    config[i][0].select = {
                                        'true': '是',
                                        'false': '否'
                                    };
                                }
                                //如果配置中这个类型的dataType是个对象,则进行递归
                                _initFloatType(evalObj[i][j], dom.find('>div'), config[i][0].select);
                                insertDom.append(dom);
                            }
                        }
                        insertDom.append('<div class="addMore" data-name="' + i + '">+</div>');
                    } else {
                        let dom = $('<div class="form-group" data-name="' + i + '">' +
                            '<label class="control-label">' + config[i].title + '</label>' +
                            '<div></div>' +
                            '</div>');
                        if (config[i].dataType === 'bool') {
                            config[i].select = {
                                'true': '是',
                                'false': '否'
                            };
                        }
                        //如果配置中这个类型的dataType是个对象,则进行递归
                        _initFloatType(evalObj[i], dom.find('>div'), config[i].select);
                        insertDom.append(dom);
                    }
                }
            }
        })();
    }

    function initFloatType(tempValue, insertDom, select) {
        _initFloatType(tempValue, $('#dataFloat .content'));
        $('#dataFloat .contentText textarea').keyup(function() {
            tempValue = $(this).val();
            if (typeof tempValue === 'string' && tempValue.substr(0, 1) === '=') {
                let temp = tempValue.match(/=(.+)$/);
                let evalObj = getEvalObj($('#myTabContent .active').data('tableid'), temp[1], false);
                _initFloatType(evalObj, $('#dataFloat .content'));
            } else {
                _initFloatType(tempValue, $('#dataFloat .content'));
            }
        });
        $('#dataFloat>.content').on('keyup', 'input', function(e) {
            updateTextareaText();
        });

        $('#dataFloat>.content').on('change', '[name=value]', function() {
            updateTextareaText();
        });
        updateTextareaText();
    }

    function updateTextareaText() {
        let evalObj = getSaveObj($('#dataFloat').find('>.content')[0]);
        if (typeof evalObj === 'object') {
            let saveStr = getStrByEvalObj(tdData[$('#myTabContent .active').data('tableid')].tableTitle, evalObj);
            $('#dataFloat .contentText textarea').val('=' + saveStr);
        } else {
            $('#dataFloat .contentText textarea').val(evalObj);
        }
    }

    function getSaveObj(dom) {
        if ($(dom).is('.dataBaseItemSingle')) {
            let temp = $(dom).find('[name=value]').val();
            if (temp === null) {
                temp = '';
            }
            if ($(dom).find('[name=dataType]').val() === '=') {
                return {
                    name: '=',
                    params: [temp]
                };
            } else {
                return temp;
            }
        } else if ($(dom).is('.dataBaseItemNoParam')) {
            if ($(dom).find('[name=dataType]').val() == 'true') {
                return true;
            } else if ($(dom).find('[name=dataType]').val() == 'false') {
                return false;
            } else {
                return {
                    name: $(dom).find('[name=dataType]').val(),
                    params: [],
                };
            }
        } else {
            let result = {
                name: '',
                params: {}
            };
            $(dom).find('>.addMore').each(function() {
                result.params[$(this).data('name')] = [];
            });
            $(dom).find('>.form-group').each(function(i) {
                if (i === 0) {
                    result['name'] = $(this).find('[name=dataType]').val();
                } else {
                    let paramsName = $(this).data('name');
                    if (paramsName.match(/^\S+\[\]$/)) {
                        let match = paramsName.match(/^(\S+)\[\]$/);
                        result.params[match[1]].push(getSaveObj($(this).find('>.dataBaseItem')));
                    } else {
                        result.params[paramsName] = getSaveObj($(this).find('>.dataBaseItem'));
                    }
                }
            });
            result.params = window[result.name].config.save(result.params);
            return result;
        }
    }

    window.initFloatDom = function() {
        setTdSelectState.call(this);
        //看看当前单元格是否有合并
        var activeId = $('#myTabContent .active').data('tableid');
        $('.table tbody .idNum').removeClass('idNumOn');
        $('.table tbody .idNum').eq(parseInt($(this).attr('hang')) - 1).addClass('idNumOn');
        $('.table thead .lieNum').removeClass('lieNumOn');
        $('.table thead .lieNum').eq(parseInt($(this).attr('lie')) - 1).addClass('lieNumOn');
        var selectPos = getCellTemp2(parseInt($(this).attr('hang')), parseInt($(this).attr('lie')));
        $('#dataFloat .head').html(selectPos);
        $('#dataFloat .head').attr('action_type', 'td');
        var thisTdData = tdData[activeId].tableData[selectPos];
        $('#dataFloat').show();
        if (thisTdData == undefined) {
            thisTdData = {
                'value': '',
                xfIndex: 0,
            };
        }
        if (allTD['td:' + activeId + '!' + selectPos]) {
            var tempValue = allTD['td:' + activeId + '!' + selectPos].value_;
        } else {
            var tempValue = '';
        }
        initFloatType(tempValue, $('#dataFloat .content'));
        $('#dataFloat').attr('xfIndex', thisTdData.xfIndex);
        $('#dataFloat').removeClass('floatSingleValue');
    }
    export default {
        methods: {
            copyTo() {
                let cellId = prompt('请输入表格位置');
                if (cellId !== null) {
                    let newPos = getCellTemp(cellId);
                    $('body .edit td').removeClass('editTd');
                    $('body .edit td').removeClass('editTdtop');
                    $('body .edit td').removeClass('editTdbottom');
                    $('body .edit td').removeClass('editTdleft');
                    $('body .edit td').removeClass('editTdright');
                    dom('appMain').td(newPos[0], newPos[1]).dom.addClass('editTd');
                    dom('appMain').td(newPos[0], newPos[1]).dom.addClass('editTdtop');
                    dom('appMain').td(newPos[0], newPos[1]).dom.addClass('editTdbottom');
                    dom('appMain').td(newPos[0], newPos[1]).dom.addClass('editTdleft');
                    dom('appMain').td(newPos[0], newPos[1]).dom.addClass('editTdright');
                    $('#dataFloat>.head').html(cellId);
                }
            }
        },
        mounted() {
            $('#dataFloat').dragging({
                move: 'both', hander: '.head'
            });
            $('#myTabContent').on('click', '.active', function() {
                $('#dataFloat').hide();
            });

            $('#dataFloat').on('change', '[name=dataType]', function() {
                var func = $(this).val();
                if (['', '='].indexOf(func) > -1) {
                    if (func === '') {
                        var evalObj = '';
                    } else {
                        var evalObj = {
                            name: '=',
                            params: [''],
                        };

                    }
                } else {
                    if (['true', 'false'].indexOf(func) > -1) {
                        evalObj = func == 'true';
                    } else {
                        var configResult = {};
                        for (var i in window[func].config.params) {
                            if (window[func].config.params[i].default !== undefined) {
                                configResult[i] = window[func].config.params[i].default;
                            } else if (window[func].config.params[i] instanceof Array) {
                                configResult[i] = [''];
                            } else {
                                configResult[i] = '';
                            }
                        }
                        configResult = window[func].config.save(configResult);
                        if (func === 'td') {
                            for (let i = 0; i < tdData.length; i++) {
                                if (tdData[i].tableTitle == configResult[0]) {
                                    configResult[0] = i;
                                }
                            }
                        }
                        var applyArgs = [window].concat(configResult || []);
                        var temp = Function.prototype.bind.apply(window[func], applyArgs);
                        evalObj = new temp();
                    }
                }
                var dom = $(this).parents('.dataBaseItem').eq(0);
                var select = $(this).parents('.dataBaseItem').eq(0).data('select');
                _initFloatType(evalObj, dom, select);
                updateTextareaText();
            });
            $('#dataFloat .action .save').click(function() {
                var contentDivs = $(this).parents('#dataFloat').find('>.content');
                var xfIndex = $(this).parents('#dataFloat').attr('xfindex');
                for (let i = 0; i < contentDivs.length; i++) {
                    let input = $(contentDivs[i]).find('>div>[name]');
                    if (input.attr('name') === 'xfIndex') {
                        xfIndex = input.val();
                    }
                }
                console.log($('#dataFloat .contentText textarea').val());
                var activeType = $('#dataFloat .head').attr('action_type');
                if (activeType === 'CHARTS') {
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            'function': 'updateChartsValue',
                            fileId: fileId,
                            tableNum: $('#dataFloat .head').attr('tableId'),
                            chartsIndex: $('#dataFloat .head').attr('chartsIndex'),
                            value: $('#dataFloat .contentText textarea').val().replace(/^=/, '')
                        },
                        success: function(data) {
                            if (data === '1') {
                                var tableNum = $('#myTabContent .active').data('tableid');
                                var chartsIndex = $('#dataFloat .head').attr('chartsIndex');
                                var content = $('#dataFloat .contentText textarea').val().replace(/^=/, '');
                                var oldObj = allEcharts[tableNum][chartsIndex];
                                oldObj.myChart.clear();

                                var matchPreg = new RegExp(oldObj.className + '\\\((\\\S+)\\\)');
                                matchPreg = content.match(matchPreg)[1];
                                matchPreg = getEvalObj(tableNum, '[' + matchPreg + ']', true);
                                var allTemp = ({
                                    'PIE': ['title', 'XtdLists', 'valueTdLists'],
                                    'BAR': ['title', 'XtdLists', 'valueTdLists'],
                                    'LINE': ['title', 'XtdLists', 'valueTdLists'],
                                })[oldObj.className];
                                for (let proNum = 0; proNum < allTemp.length; proNum++) {
                                    var title = allTemp[proNum];
                                    if (oldObj[title] !== matchPreg[proNum]) {
                                        if (oldObj[title] instanceof obj) {
                                            oldObj[title].unBind(oldObj);
                                        }
                                        oldObj[title] = matchPreg[proNum];
                                        if (matchPreg[proNum] instanceof obj) {
                                            oldObj[title].bind(oldObj);
                                        }
                                    }
                                }
                                //渲染
                                oldObj.render();
                                $('#dataFloat').hide();
                            } else {
                                alert('样式服务器同步失败');
                            }
                        }
                    });
                }
                else {
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            'function': 'updateTdValue',
                            fileId: fileId,
                            tableNum: $('#myTabContent .active').data('tableid'),
                            pos: $('#dataFloat .head').html(),
                            xfIndex: xfIndex,
                            value: $('#dataFloat .contentText textarea').val()
                        },
                        success: function(data) {
                            if (data === 1) {
                                let tableNum = $('#myTabContent .active').data('tableid');
                                let pos = $('#dataFloat .head').html();
                                tdData[tableNum].tableData[pos] = {
                                    value: $('#dataFloat .contentText textarea').val(),
                                    xfIndex: xfIndex
                                };
                                writeTd(tableNum, pos, tdData[tableNum].tableData[pos].value, tdData[tableNum].tableData[pos].xfIndex);
                                $('#dataFloat').hide();
                                if (getCellTemp(pos)[0] > alldoms['appMain' + tableNum].hang) {
                                    alldoms['appMain' + tableNum].addHang();
                                }
                            } else {
                                alert('样式服务器同步失败');
                            }
                        }
                    });
                }

            });
            $('#dataFloat').on('click', '.add', function() {
                if ($(this).parents('.dataBaseItem').eq(0).is('.dataBaseItemChild')) {
                    $(this).parents('.dataBaseItem').eq(0).removeClass('dataBaseItemChild');
                    $(this).find('i').attr('class', 'glyphicon glyphicon-chevron-up');
                } else {
                    $(this).parents('.dataBaseItem').eq(0).addClass('dataBaseItemChild');
                    $(this).find('i').attr('class', 'glyphicon glyphicon-chevron-down');
                }
            });
            $('#dataFloat').on('click', '.addMore', function() {
                let title = $(this).prev().find('>label').html();
                let key = $(this).prev().attr('data-name');
                let dom = $('<div class="form-group" data-name="' + key + '">' +
                    '<label class="control-label">' + title + '</label>' +
                    '<div></div>' +
                    '</div>');
                _initFloatType('', dom.find('>div'));
                $('.addMore').before(dom);
                updateTextareaText();
            });
            $('#myTabContent').on('keydown', '.floatSingleValueWrite .input input', function(e) {
                if (['Enter'].indexOf(e.key) > -1) {    //'ArrowRight',
                    let inputDom = this;
                    let tableId = $(inputDom).attr('tableid');
                    let posId = $(inputDom).attr('pos');
                    console.log(posId);

                    function turnNewTD() {
                        if (getCellTemp(posId)[0] > alldoms['appMain' + tableId].hang) {
                            alldoms['appMain' + tableId].addHang();
                        }
                        writeTd(tableId,
                            posId,
                            $(inputDom).val(),
                            $(inputDom).attr('cell_xf'));
                        $(inputDom).removeAttr('tableid');
                        $(inputDom).removeAttr('pos');
                        $(inputDom).removeAttr('cell_xf');
                        $(inputDom).val('');
                        $(inputDom).parent().hide();
                        console.log(posId);
                        let temp = getCellTemp(posId);
                        if (e.key === 'Enter') {

                        } else {
                            if (e.key === 'ArrowRight') {
                                temp[1]++;
                            }
                            let rightDom;
                            if (allTD['td:' + tableId + '!' + getCellTemp2(temp[0], temp[1])] !== undefined) {
                                rightDom = allTD['td:' + tableId + '!' + getCellTemp2(temp[0], temp[1])].dom;
                                $(rightDom).trigger('dblclick');
                            } else {
                                rightDom = new td(tableId, getCellTemp2(temp[0], temp[1]));

                            }
                            console.log(rightDom);
                            $(rightDom).trigger('dblclick');
                        }
                    }

                    if ($(this).attr('oldValue') !== $(this).val()) {
                        ajax({
                            url: 'http://www.tablehub.cn/action/table.html',
                            type: 'POST',
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                            data: {
                                function: 'updateTdValue',
                                fileId: fileId,
                                tableNum: $(this).attr('tableid'),
                                pos: $(this).attr('pos'),
                                value: $(this).val()
                            },
                            success: function(data) {
                                if (data === 1) {
                                    turnNewTD();
                                } else {
                                    alert('样式服务器同步失败');
                                }
                            }
                        });
                    } else {
                        turnNewTD();
                    }
                }
            });
            $('body').on('dblclick', '.edit #myTabContent .allCharts>div', function() {
                let tableId = $('#myTabContent .active').data('tableid');
                let chartsIndex = $(this).attr('index');
                $('#dataFloat').show();
                $('#dataFloat .head').html('图表');

                let allChartsName = [];
                for (let i = 0; i < allChartFunction.length; i++) {
                    allChartsName.push(allChartFunction[i].funcName);
                }
                if (allEcharts[tableId][chartsIndex] instanceof obj && allChartsName.indexOf(allEcharts[tableId][chartsIndex].className) > -1) {
                    $('#dataFloat .head').attr('action_type', 'CHARTS');
                    $('#dataFloat .head').attr('tableId', tableId);
                    $('#dataFloat .head').attr('chartsIndex', chartsIndex);
                }
                initFloatType(allEcharts[tableId][chartsIndex], $('#dataFloat .content'));
            });
            $('body').on('dblclick', '.edit #myTabContent td', function() {
                setTdSelectState.call(this);
                //看看当前单元格是否有合并
                var activeId = $('#myTabContent .active').data('tableid');
                var selectPos = getCellTemp2(parseInt($(this).attr('hang')), parseInt($(this).attr('lie')));
                if (allTD['td:' + activeId + '!' + selectPos]) {
                    var tempValue = allTD['td:' + activeId + '!' + selectPos].value_;
                } else {
                    var tempValue = '';
                }
                if (typeof tempValue === 'string' || typeof tempValue === 'number') {
                    //计算宽度
                    function getTrueWidth(str, xf) {
                        var span = $('<span></span>');
                        span.attr('cell_xf', xf);
                        span.html(str);
                        $(this).parents('.tableBody').find('.floatSingleValueWrite .span').html('').append(span);
                        return span.width() + 8;
                    }

                    //计算位置
                    var tableid = $('body #myTabContent .active').data('tableid');
                    $('.tableBody').eq(tableid).scrollTop();
                    var position = $(this).position();
                    var inputTd = $(this).parents('.tableBody').find('.floatSingleValueWrite .input');
                    inputTd.show();
                    inputTd.find('input').val(tempValue);
                    inputTd.find('input').attr('cell_xf', $(this).attr('cell_xf'));
                    inputTd.find('input').attr('tableId', tableid);
                    inputTd.find('input').attr('pos', getCellTemp2($(this).attr('hang'), $(this).attr('lie')));
                    inputTd.find('input').attr('oldValue', tempValue);
                    inputTd.css('left', position.left - parseInt($(this).parents('.tableBody').css('marginLeft')) + $('.tableBody').eq(tableid).scrollLeft() - 1);
                    inputTd.css('top', position.top - parseInt($(this).parents('.tableBody').css('marginTop')) + $('.tableBody').eq(tableid).scrollTop() - 2);
                    inputTd.css('height', $(this).outerHeight() + 2);
                    inputTd.css('min-width', $(this).outerWidth() + 1);
                    inputTd.css('width', getTrueWidth.call(this, tempValue, $(this).attr('cell_xf')));
                    var this_ = this;
                    inputTd.find('input').on('input', function() {
                        inputTd.css('width', getTrueWidth.call(this_, $(this).val(), $(this_).attr('cell_xf')));
                    });
                    inputTd.find('input').click(function(event) {
                        event.stopPropagation();
                    });
                    inputTd.find('input').focus();
                } else {
                    initFloatDom.call(this);
                }
            });
        }
    }
</script>