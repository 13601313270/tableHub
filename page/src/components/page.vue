<template>
    <div>
        <div id="tablePanel" :class="{edit:isOpenEdit}" @click="selectTd_temp($event)"
             @mousedown="mousedown_temp($event)" @mouseover="mouseenter_temp($event)" @mouseup="mouseup_temp">
            <tools @stateChange="isOpenEditSet" :cellXfInfo="cellXfInfo" :title="title" :isMyTable="isMyTable"
                   :isOpenEdit="isOpenEdit" :fileId="fileId"></tools>
            <div id="myTabContentParent">
                <ul class="allTableSelect nav nav-tabs">
                    <li v-for="(item,key) in allTableTitle" v-bind:class="{active:tableNum==key}">
                        <a :href="'#table_'+key" data-toggle="tab">{{item}}</a>
                    </li>
                    <li v-if="isMyTable" @click="addTable" class="addTable">&#xe641;</li>
                </ul>
                <div id="myTabContent" class="tab-content"></div>
            </div>
        </div>
        <bottom></bottom>
        <dataFloat :fileId="this.fileId"></dataFloat>
        <wrapper></wrapper>
    </div>
</template>

<script>
    import bottom from '@/components/bottom.vue'
    import tools from '@/components/tools.vue'
    import dataFloat from '@/components/dataFloat.vue'
    import wrapper from '@/components/wrapper.vue'
    import ajax from '@/tools/ajax.js'
    import Vue from 'vue'
    import echarts from 'echarts'
    import writeTd from '@/tools/writeTd.js';
    import setTdSelectState from '@/tools/setTdSelectState.js';

    function selectTd2() {
        if (this !== window && !$(this).is('.mergeTd')) {
            //不能拆分
            console.log(1);
            $('.toolsContent [data-name=tdMerge]').removeClass('active');
            $('.toolsContent [data-name=tdMerge]').addClass('disabled');
        } else {
            console.log(2);
            let isHasMerge = false;
            let activeId = $('#myTabContent .active').data('tableid');
            for (let i in tdData[activeId].mergeCells) {
                if (i.split(":")[0] == getCellTemp2($(this).attr('hang'), $(this).attr('lie'))) {
                    isHasMerge = true;
                    break;
                }
            }
            if (isHasMerge) {
                $('.toolsContent [data-name=tdMerge]').addClass('active');
            } else {
                $('.toolsContent [data-name=tdMerge]').removeClass('active');
            }
            $('.toolsContent [data-name=tdMerge]').removeClass('disabled');
        }
    }

    echartsObj = echarts;

    //    import obj from '@/tools/obj.js'
    //    var a = new obj();
    //    var b = new obj();
    //    b.value = 'i\'m b';
    //    console.log("====1======");
    //    a.value = b;// = 100;
    //    console.log("====2======");
    //    b.value = 111;// = 100;
    //    console.log("====3======");

    function createCss(i, item) {
        var strItem = "[cell_xf=\"" + i + "\"]{\n";
        if (item.font) {
            if (item.font.color) {
                strItem += 'color:#' + item.font.color.slice(2) + ';\n';
            }
            if (item.font.bold === true || item.font.bold === 1) {
                strItem += 'font-weight:bold;\n';
            }
            if (item.font.size) {
                strItem += 'font-size:' + parseInt(item.font.size * 1.2) + 'px;\n';
            }
            if (item.font.underline === 'single') {
                strItem += 'text-decoration:underline;\n';
            }
            if (item.font.italic === true || item.font.italic === 1) {
                strItem += 'font-style: italic;\n';
            }
        }
        if (item.fill && item.fill.fillType !== 'none') {
            if (item.fill.startColor) {
                strItem += 'background-color:#' + item.fill.startColor.slice(2) + ';\n';
            }
        }
        if (item.alignment) {
            if (item.alignment.horizontal == 'left') {
                strItem += 'text-align: left!important;\n';
            } else if (item.alignment.horizontal == 'right') {
                strItem += 'text-align: right!important;\n';
            } else if (item.alignment.horizontal == 'center') {
                strItem += 'text-align: center!important;\n';
            } else if (item.alignment.horizontal == 'general') {
//                    strItem+='text-align: center;\n';
            }
        }
        strItem += "}\n";
        return strItem;
    }

    export default {
        name: 'page',
        methods: {
            isOpenEditSet(state) {
                this.isOpenEdit = state;
                let lieAddCount = 2;//增加
                if (this.isOpenEdit) {
                    if (lieAddCount > 0) {
                        $('#myTabContent .tab-pane').each(function() {
                            for (var i = 0; i < lieAddCount; i++) {
                                var lieNum = getCellTemp2(0, $(this).find('.tableThead table thead tr th').length + 1).match(/([A-Z]*)(\d+)/)[1];
                                var headTdHtml = '<th class="lieNum" lienum="' + lieNum + '" style="position: relative; overflow: hidden;">' +
                                    lieNum +
                                    '<div style="position: absolute; cursor: ew-resize;"></div>' +
                                    '</th>';
                                var bodyTheadHtml = '<th class="lieNum" lienum="' + lieNum + '"></th>';
                                $(this).find('.tableThead table thead tr').append($(headTdHtml));
                                $(this).find('.tableBody table thead tr').append($(bodyTheadHtml));
                            }
                        });
                        $('#myTabContent .tableBody table tbody tr').each(function() {
                            for (var i = 0; i < lieAddCount; i++) {
                                var newTd = $('<td></td>');
                                newTd.attr('hang', $(this).index() + 1);
                                newTd.attr('lie', $(this).find('>td').length + 1);
                                $(this).append(newTd);
                            }
                        });
                    }
                } else {
                    if (lieAddCount > 0) {
                        $('#myTabContent .tableThead table').each(function() {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('thead tr th:last').remove();
                            }
                        });
                        $('#myTabContent .tableBody table thead tr').each(function() {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('th:last').remove();
                            }
                        });
                        $('#myTabContent .tableBody table tbody tr').each(function() {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('td:last').remove();
                            }
                        });
                    }
                    $('#tablePanel').removeClass('edit');
//        location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'');
                    $('#dataFloat').hide();
                }
            },
            rewriteExcel(dataList) {
                //单元格数据
                var allFileData = dataList;

                function initMerge(tableNum, mergeData) {
                    for (let i in mergeData) {
                        let beginAndEnd = i.split(':');
                        let begin = getCellTemp(beginAndEnd[0]);
                        let end = getCellTemp(beginAndEnd[1]);

                        dom('appMain' + tableNum).td(beginAndEnd[0]).dom.attr('rowspan', end[0] - begin[0] + 1);
                        dom('appMain' + tableNum).td(getCellTemp2(begin[0], begin[1])).dom.attr('colspan', end[1] - begin[1] + 1);
                        dom('appMain' + tableNum).td(beginAndEnd[0]).dom.addClass('mergeTd');

                        for (let tr = begin[0]; tr <= end[0]; tr++) {
                            let firstTdWidth = 0;
                            for (let td = end[1]; td >= begin[1]; td--) {
                                firstTdWidth += dom('appMain' + tableNum).thead.find('thead th').eq(td - 1).outerWidth();
                                if (tr === begin[0] && td === begin[1]) {

                                } else {
                                    dom('appMain' + tableNum).td(getCellTemp2(tr, td)).dom.hide();
                                }
                            }
                        }
                    }
                }

                td.config.params.tableId.select = {};
                for (let tableNum = 0; tableNum < allFileData.length; tableNum++) {
                    var tableObj = allFileData[tableNum];
                    var tableTitle = tableObj.title;
                    this.allTableTitle.push(tableTitle);
                    td.config.params.tableId.select[tableNum.toString()] = tableTitle;
                    tdData[tableNum] = {
                        tableTitle: tableTitle,
                        tableData: tableObj.tableValue,
                        mergeCells: tableObj.mergeCells,
                    };
                    var tableItemDom = $('<div class="tab-pane fade ' + (tableNum === 0 ? 'in active' : '') + '" data-tableid="' + tableNum + '" id="table_' + tableNum + '"></div>');
                    $('#myTabContent').append(tableItemDom);
                    var tableDom = tableItemDom;
                    //获取宽高
                    var hang = 0;
                    var lie = 0;
                    for (let i in tdData[tableNum].tableData) {
                        try {
                            var tdPos = getCellTemp(i);
                        } catch (e) {
                            continue;
                        }
                        hang = Math.max(hang, tdPos[0]);
                        lie = Math.max(lie, tdPos[1]);
                    }
                    lie = Math.max(lie, 6);//至少补充到6列

                    alldoms['appMain' + tableNum] = new tableClass(tableNum, hang, lie, tableDom);
                    alldoms['appMain' + tableNum].render();
                    (function() {
                        //单元格列宽
                        var nod = document.createElement("style");
                        nod.type = "text/css";
                        $(nod).attr('td_css_list', 1);
                        var str = "";
                        var column = tableObj.column;
                        for (let i in column) {
                            var thNum = getCellTemp(i + '1')[1];
                            var strItem = "#myTabContent>.tab-pane:nth-child(" + (tableNum + 1) + ") [lie=\"" + thNum + "\"],#myTabContent>.tab-pane:nth-child(" + (tableNum + 1) + ") [lienum=\"" + i + "\"]{\n";
                            strItem += 'width:' + column[i].width * 10 + 'px;\n';
                            strItem += "}\n";
                            str += strItem;
                        }
                        if (nod.styleSheet) { //ie下
                            nod.styleSheet.cssText = str;
                        } else {
                            nod.innerHTML = str;
                        }
                        document.getElementsByTagName("head")[0].appendChild(nod);
                    })();

                    var row = tableObj.row;
                    for (let i in row) {
                        var height = row[i].height * 1.5;
                        $('.tableRow table tr').eq(i - 1).find('td').height(height);
                        alldoms['appMain' + tableNum].table.find('tbody tr').eq(i - 1).find('td:eq(0)').height(height);
                    }
                    //单元格合并
                    initMerge(tableNum, tdData[tableNum].mergeCells);

                    //绘制图表
                    allEcharts[tableNum] = [];
                    if (tableObj.charts !== undefined) {
                        for (let chartsId = 0; chartsId < tableObj.charts.length; chartsId++) {
                            let position = tableObj.charts[chartsId].position.split(',');
                            let size = tableObj.charts[chartsId].size.split(',');
                            if (tableObj.charts[chartsId].value !== null) {
                                let chartsItem = getEvalObj(tableNum, tableObj.charts[chartsId].value, true);
                                $('.allCharts:eq(' + tableNum + ')').append(chartsItem.dom);
                                chartsItem.myChart = echartsObj.init(chartsItem.dom.find('>div')[0], 'macarons');
                                chartsItem.top = parseInt(position[0]);
                                chartsItem.left = parseInt(position[1]);
                                chartsItem.width = parseInt(size[0]);
                                chartsItem.height = parseInt(size[1]);
                                chartsItem.dom.attr('index', chartsId);
                                chartsItem.index = chartsId;
                                readyObj.bind(chartsItem);
                                allEcharts[tableNum][chartsId] = chartsItem;
                            }
                        }
                    }
                }
                for (let tableNum = 0; tableNum < allFileData.length; tableNum++) {
                    for (let i in tdData[tableNum].tableData) {
                        writeTd(tableNum, i, tdData[tableNum].tableData[i].value, tdData[tableNum].tableData[i].xfIndex);
                    }
                }
            },
            addTable() {
                var name = window.prompt('请输入工作表名称');
                if (name !== '' && name !== null) {
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            function: 'tableAdd',
                            fileId: this.fileId,
                            title: name,
                        },
                        success: function(data) {
                            if (data === -2) {
                                alert('工作表名称已存在');
                            } else if (data === 1) {
                                location.href = location.href;//很多情况下无法刷新
                            }
                        }
                    });
                }
            },
            selectTd(cellXf_) {
                if (cellXf_ === undefined) {
                    $('.toolsContent [data-name=color]').css('color', '');
                    this.cellXfInfo.font.bold = false;
                    this.cellXfInfo.font.underline = false;
                    this.cellXfInfo.font.italic = false;
                    this.cellXfInfo.alignment.horizontal = 'general';
                    $('.toolsContent [data-name=size]').val('');
                    $('.toolsContent [data-name=fill]').css('backgroundColor', 'white');
                    $('.toolsContent [data-name=tdMerge]').removeClass('active');
                } else {
                    var cell_xf = getCellXfCollection[cellXf_];
                    if (cell_xf.font) {
                        if (cell_xf.font.color) {
                            $('.toolsContent [data-name=color]').css('color', '#' + cell_xf.font.color.slice(2));
                        }
                        this.cellXfInfo.font.bold = (cell_xf.font.bold === 1);
                        if (cell_xf.font.size) {
                            $('.toolsContent [data-name=size]').val(cell_xf.font.size);
                        }
                        if (cell_xf.font.underline === 'single') {
                            this.cellXfInfo.font.underline = true;
                        } else {
                            this.cellXfInfo.font.underline = false;
                        }
                        if (cell_xf.font.italic === 1) {
                            this.cellXfInfo.font.italic = true;
                        } else {
                            this.cellXfInfo.font.italic = false;
                        }
                    }
                    if (cell_xf.fill && cell_xf.fill.fillType !== 'none') {
                        $('.toolsContent [data-name=fill]').css('backgroundColor', '#' + cell_xf.fill.startColor.slice(2));
                    }
                    else {
                        $('.toolsContent [data-name=fill]').css('backgroundColor', 'white');
                    }

                    if (cell_xf.alignment) {
                        if (cell_xf.alignment.horizontal === 'left') {
                            this.cellXfInfo.alignment.horizontal = 'left';
                        } else if (cell_xf.alignment.horizontal === 'center') {
                            this.cellXfInfo.alignment.horizontal = 'center';
                        } else if (cell_xf.alignment.horizontal === 'right') {
                            this.cellXfInfo.alignment.horizontal = 'right';
                        } else if (cell_xf.alignment.horizontal === 'general') {
                            this.cellXfInfo.alignment.horizontal = 'general';
                        }
                    } else {
                        this.cellXfInfo.alignment.horizontal = 'general';
                    }
                }
            },
            selectTd_temp(event) {
                if ($(event.target).is('.edit #myTabContent td')) {
                    var eventDom = event.target;
                } else {
                    var eventDom = $(event.target).parents('.edit #myTabContent td');
                    if (eventDom.length === 0) {
                        return
                    } else {
                        eventDom = eventDom[0]
                    }
                }
                if (!$(eventDom).is('.idNum')) {
                    setTdSelectState.call(eventDom);
                    this.selectTd($(eventDom).attr('cell_xf'));
                    selectTd2.call(eventDom);
                }
            },
            mousedown_temp(event) {
                if ($(event.target).is('.edit #myTabContent td')) {
                    var eventDom = event.target;
                } else {
                    var eventDom = $(event.target).parents('.edit #myTabContent td');
                    if (eventDom.length === 0) {
                        return
                    } else {
                        eventDom = eventDom[0]
                    }
                }
                beginSelect = [$(eventDom).attr('hang'), $(eventDom).attr('lie')];
                isSelectDoms = true;
                event.preventDefault();
            },

            lastEnterTd: '',//用于记录最后一次出发的dom
            mouseenter_temp(event) {
                if (isSelectDoms) {
                    if ($(event.target).is('.edit #myTabContent td')) {
                        var eventDom = event.target;
                    } else {
                        var eventDom = $(event.target).parents('.edit #myTabContent td');
                        if (eventDom.length === 0) {
                            return
                        } else {
                            eventDom = eventDom[0]
                        }
                    }
                    // 防止重复出发
                    if (this.lastEnterTd === eventDom) {
                        return;
                    }
                    this.lastEnterTd = eventDom;


                    $('body .edit td').removeClass('editTd');
                    $('body .edit td').removeClass('editTdtop');
                    $('body .edit td').removeClass('editTdbottom');
                    $('body .edit td').removeClass('editTdleft');
                    $('body .edit td').removeClass('editTdright');
                    var top = Math.min($(eventDom).attr('hang'), beginSelect[0]);
                    var bottom = Math.max($(eventDom).attr('hang'), beginSelect[0]);
                    var left = Math.min($(eventDom).attr('lie'), beginSelect[1]);
                    var right = Math.max($(eventDom).attr('lie'), beginSelect[1]);
                    var tableid = $('body #myTabContent .active').data('tableid');
                    for (let i = top; i <= bottom; i++) {
                        for (let j = left; j <= right; j++) {
                            if (i === top) {
                                dom('appMain' + tableid).td(getCellTemp2(i, j)).dom.addClass('editTdtop');
                            }
                            if (i === bottom) {
                                dom('appMain' + tableid).td(getCellTemp2(i, j)).dom.addClass('editTdbottom');
                            }
                            if (j === left) {
                                dom('appMain' + tableid).td(getCellTemp2(i, j)).dom.addClass('editTdleft');
                            }
                            if (j === right) {
                                dom('appMain' + tableid).td(getCellTemp2(i, j)).dom.addClass('editTdright');
                            }
                            dom('appMain' + tableid).td(getCellTemp2(i, j)).dom.addClass('editTd');
                        }
                    }
                    this.selectTd(undefined);
                    selectTd2.call(window, top, right, bottom, left);
                }
            },
            mouseup_temp() {
                isSelectDoms = false;
            }
        },
        data: function() {
            return {
                title: '',
                isMyTable: true,
                isOpenEdit: false,
                tableNum: 0,//表序列
                allTableTitle: [],
                fileId: parseInt(window.location.href.match(/\/table\/(\d+)\.html/)[1]),
                cellXfInfo: {
                    font: {
                        bold: false,
                        underline:
                            false,
                        italic:
                            false,
                    }
                    ,
                    alignment: {
                        horizontal: 'general'
                    }
                }
                ,
            }
        },
        components: {
            bottom, tools, dataFloat, wrapper
        },
        created() {
            var this_ = this;
            ajax({
                url: 'http://www.tablehub.cn/action/table.html',
                type: 'POST',
                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                data: {
                    function: 'tableInfo',
                    fileId: this.fileId,
                    temp: 1,
                },
                success: function(data) {
                    this_.title = data.title;
                    this_.isMyTable = data.isMyTable;
                    var dataList = data.data;
                    window.getCellXfCollection = data.style;
                    //单元格样式
                    {
                        let nod = document.createElement("style");
                        nod.type = "text/css";
                        $(nod).attr('td_css_list', 1);
                        let str = "";
                        for (let i = 0; i < data.style.length; i++) {
                            str += createCss(i, data.style[i]);
                        }
                        if (nod.styleSheet) { //ie下
                            nod.styleSheet.cssText = str;
                        } else {
                            nod.innerHTML = str;
                        }
                        document.getElementsByTagName("head")[0].appendChild(nod);
                    }
                    this_.rewriteExcel(data.data);
                    //修改列宽度
                    $('.table>thead>tr>.lieNum>div').each(function() {
                        function setTdWidth(tableNum, thNum, width) {
                            dom('appMain' + tableNum).thead.find('thead th').eq(thNum - 1).css({
                                width: width * 10
                            });
                            dom('appMain' + tableNum).table.find('tbody tr:eq(0) td').eq(thNum - 1).css({
                                width: width * 10
                            });
                        }

                        $(this).dragging({
                            move: 'x',
                            xLimit: false,
                            yLimit: false,
                            randomPosition: false,
                            onMousemove: function(dom, pos) {
                                var tableId = dom.parents('[data-tableid]').data('tableid');
                                var thNum = getCellTemp(dom.parent().attr('lienum') + '1')[1];
                                setTdWidth(tableId, thNum, (pos.left + 5) / 10);
//                    initMerge(tableId,tdData[1].mergeCells);
                            },
                            onMouseup: function(dom) {
                                var tableId = dom.parents('[data-tableid]').data('tableid');
                                var lienum = dom.parent().attr('lienum');
                                var width = dom.parent().width();
                                ajax({
                                    url: 'http://www.tablehub.cn/action/table.html',
                                    type: 'POST',
                                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                                    data: {
                                        function: 'updateWidth',
                                        fileId: this.fileId,
                                        tableNum: tableId,
                                        lienum: lienum,
                                        width: (width / 10).toFixed(1)
                                    },
                                    success: function(data) {
                                        console.log(data);
                                    }
                                });
                            }
                        });
                    });
                    //触发表格完成
                    readyObj.set(1);
                }
            });
        }
    }
    $('body').click(function() {
        if ($('.floatSingleValueWrite .input input[pos]').length > 0) {
            $('.floatSingleValueWrite .input input[pos]').each(function() {
                var inputDom = this;

                function afterUpdate() {
                    writeTd($(inputDom).attr('tableid'),
                        $(inputDom).attr('pos'),
                        $(inputDom).val(),
                        $(inputDom).attr('cell_xf'));
                    $(inputDom).removeAttr('tableid');
                    $(inputDom).removeAttr('pos');
                    $(inputDom).removeAttr('cell_xf');
                    $(inputDom).parent().hide();
                    $(inputDom).val('');
                }

                if ($(this).attr('oldValue') !== $(this).val()) {
                    ajax({
                        url: 'http://www.tablehub.cn/action/table.html',
                        type: 'POST',
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                        data: {
                            function: 'updateTdValue',
                            fileId: this.fileId,
                            tableNum: $(this).attr('tableid'),
                            pos: $(this).attr('pos'),
                            value: $(this).val()
                        },
                        success: function(data) {
                            if (data !== '-1') {
                                if (getCellTemp($(inputDom).attr('pos'))[0] > alldoms['appMain' + $(inputDom).attr('tableid')].hang) {
                                    alldoms['appMain' + $(inputDom).attr('tableid')].addHang();
                                }
                                afterUpdate();
                            } else {
                                alert('样式服务器同步失败');
                            }
                        }
                    });
                } else {
                    afterUpdate();
                }
            });
        }
    });

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
    body {
        background-color: #e6e6e6;
    }

    .table {
        width: 0 !important;
        margin-top: 0;
        background-color: white;
        table-layout: fixed;
    }

    .table > thead > tr > th {
        width: 100px;
    }

    .table > tbody > tr > td {
        width: 100px;
        overflow: hidden;
    }

    .idNum {
        background-color: #c3c3c3;
        border-right: solid 3px #929292;
        min-width: 30px;
    }

    .tableBody {
        margin-left: 0px;
        width: 100%;
        height: 100%;
        overflow: auto;
        margin-top: 0px;
    }

    .tableBody .input-group {
        width: 98%;
        margin-left: 1%;
    }

    .edit .tableBody {
        margin-left: 80px;
        width: calc(100% - 80px);
        height: calc(100% - 39px);
        overflow: scroll;
        margin-top: 39px;
        cursor: cell;
    }

    .tableRow {
        display: none;
        position: absolute;
        left: 0;
        width: 80px;
        top: 39px;
        height: calc(100% - 39px);
        overflow: hidden;
    }

    .tableThead {
        display: none;
    }

    .edit .table {
        margin: 0 0;
    }

    .edit .tableRow {
        display: block;
    }

    .edit .tableThead {
        display: block;
    }

    #myTabContent {
        position: relative;
        height: calc(100% - 40px);
    }

    #myTabContent .tab-pane {
        overflow: auto;
        width: 100%;
        height: 100%;
        padding-top: 5px;
    }

    .trMain {
        background-color: white;
    }

    .trTwo {
        display: none;
        background-color: #eeeeee;
    }

    .trThree {
        background-color: #e8e8e8;
    }

    .addButton {
        float: right;
    }

    .addButton:after {
        content: '+';
    }

    .table th, .table td {
        text-align: center;
    }

    .table > tbody > tr {
        height: 37px;
    }

    .table > thead {
        background-color: #c3c3c3;
    }

    .edit .editTd {
        background-color: #e5f2ff;
        /*border:solid 2px #0000b8;*/
    }

    .edit .editTdtop {
        border-top: solid 2px #0000b8;
    }

    .edit .editTdbottom {
        border-bottom: solid 2px #0000b8;
    }

    .edit .editTdleft {
        border-left: solid 2px #0000b8;
    }

    .edit .editTdright {
        border-right: solid 2px #0000b8;
    }

    .tableThead thead > tr > th {
        min-width: 60px;
        border: 1px solid #ddd;
        white-space: nowrap;
        vertical-align: middle;
        padding: 0;
        height: 37px;
    }

    .table > tbody > tr > td {
        min-width: 60px;
        border: 1px solid #ddd;
        white-space: nowrap;
        vertical-align: middle;
        padding: 0;
        height: 37px;
    }

    .tableThead > thead th {
        border-bottom: solid 3px #929292 !important;
    }

    .tableThead .table > thead > tr > .lieNum {
        position: relative;
    }

    .tableThead .table > thead > tr > .lieNum > div {
        cursor: ew-resize;
        position: absolute;
        right: 0;
        top: 0;
        height: 100%;
        width: 5px;
    }

    .table > tbody > tr > .mergeTd {
        white-space: initial
    }

    .tableBody tr {
        background-color: white;
    }

    .tableBody thead {
        height: 20px;
    }

    .tableBody .table {
        margin-top: -16px;
    }

    .tableBody .table > thead > tr > th {
        border-bottom: none;
    }

    .styleAllSelect {
        float: left;
        width: 60px;
        height: 20px;
        margin: 2px;
        background-color: white;
    }

    .styleSelect {
        border: solid 1px black;
    }

    .idNumOn {
        background-color: #a7a7a7 !important;
        box-shadow: inset 6px -1px 20px 1px #909090;
        color: #e8e8e8;
    }

    .lieNumOn {
        background-color: #a7a7a7 !important;
        box-shadow: inset 0px 6px 20px 3px #909090;
        color: #e8e8e8;
    }

    .addTable {
        font-family: iconfont;
        line-height: 40px;
        border: solid 1px rgba(255, 255, 255, 0);
        border-left: solid 1px #bdbdbd;
        width: 50px;
        font-size: 18px;
        text-align: center;
        cursor: pointer;
    }

    .addTable:hover {
        background-color: #e6e6e6;
        border: solid 1px #b5b5b5;
        border-radius: 2px;
    }

    .table td .tdInsertDiv {
        display: table;
        width: 100%;
    }

    .table td .tdInsertDiv > div {
        display: table-cell;
    }

    .table td .tdInsertDiv > div:nth-child(2) {
        white-space: normal;
        display: block;
        height: 1rem;
    }

    .table td .tdInsertDiv > div:nth-child(2) > span {
        /*max-width: 100px;*/
        display: inline-block;
    }

    .table td .tdInsertDiv > div:first-child {
        text-align: left;
    }

    .table td .tdInsertDiv > div:last-child {
        text-align: right;
    }
</style>
