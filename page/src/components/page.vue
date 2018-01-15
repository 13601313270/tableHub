<template>
    <div>
        <div id="tablePanel" :class="{edit:isOpenEdit}" @click="selectTd_temp($event)"
             @mousedown="mousedown_temp($event)" @mouseover="mouseenter_temp($event)" @mouseup="mouseup_temp">
            <tools @stateChange="isOpenEditSet"
                   @fx="fx"
                   @insertChart="insertChart"
                   :cellXfInfo="cellXfInfo"
                   :title="title"
                   :isMyTable="isMyTable"
                   :isOpenEdit="isOpenEdit"
                   :fileId="fileId"
                   :table-num="this.tableNum"></tools>
            <div id="myTabContentParent">
                <ul class="allTableSelect nav nav-tabs">
                    <li v-for="(item,key) in allTableTitle" v-bind:class="{active:tableNum===key}"
                        style="cursor: pointer"
                        @click="tableNum = key">
                        <a>{{item}}</a>
                    </li>
                    <li v-if="isMyTable&&isOpenEdit" @click="addTable" class="addTable">&#xe641;</li>
                </ul>
                <div id="myTabContent" class="tab-content">
                    <table-vue-obj v-for="(item,key) in allTableDom" class="tab-pane fade"
                                   :key="key"
                                   :class="{active:key===tableNum,in:key===tableNum}"
                                   :data-tableid="key"
                                   :table-obj="item"
                                   :id="'table_' + key"></table-vue-obj>
                </div>
            </div>
        </div>
        <bottom></bottom>
        <dataFloat ref="float"
                   :fileId="this.fileId"
                   :table-num="this.tableNum"
                   :get-eval-obj=this.getEvalObj
                   @change="changeTd"
                   @changeChart="changeChart"></dataFloat>
        <wrapper></wrapper>
    </div>
</template>

<script>
    import bottom from '@/components/bottom.vue'
    import tools from '@/components/tools.vue'
    import dataFloat from '@/components/dataFloat.vue'
    import wrapper from '@/components/wrapper.vue'
    import pageFloatPanel from '@/components/pageFloatPanel.vue'
    import ajax from '@/tools/ajax.js'
    import Vue from 'vue'
    import echarts from 'echarts'
    import setTdSelectState from '@/tools/setTdSelectState.js';

    var tableVueObj = {
        props: ['tableObj'],
        methods: {
            getCellTemp2(trNum, tdNum) {
                var result = '';
                do {
                    var append = String.fromCharCode(tdNum % 26 + 64);
                    if (append === '@') {
                        append = 'Z';
                        tdNum -= 26;
                    }
                    result = append + '' + result;
                    tdNum = parseInt(tdNum / 26);
                } while (tdNum > 0);
                return result + trNum;
            },
        },
        // tbodyDom.scroll(function () {
        //     this_.thead.css('marginLeft', tbodyDom.scrollLeft() * -1);
        //     this_.row.css('marginTop', tbodyDom.scrollTop() * -1);
        // });
        template: `<div>
    <div class="tableThead" style="position:absolute;left:80px;width: calc(100% - 80px);overflow: hidden">
        <table class="table">
        <thead>
            <tr>
                <th v-for="i in tableObj.lie" class="lieNum"
                    :lienum="getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]">{{getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]}}<div></div></th>
            </tr>
        </thead></table>
    </div>
    <div class="tableRow">
        <table class="table">
        <tbody>
            <tr v-for="i in tableObj.hang">
                <td class="idNum" :hang="i" style="width: 80px;">{{i}}<div></div></td>
            </tr>
        </tbody>
        </table>
    </div>
    <div class="tableBody">
        <div class="floatSingleValueWrite">
            <div class="input">
                <input/>
            </div>
            <div class="span"></div>
        </div>
        <div class="allCharts"></div>
        <table class="table">
            <thead>
                <tr>
                    <th v-for="i in tableObj.lie" class="lienum"
                        :lienum="getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="i in tableObj.hang" :hang="i">
                    <td v-for="j in tableObj.lie" :hang="i" :lie="j">

                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</div>`,
        mounted() {
            setTimeout(() => {
                for (let i = 0; i < this.tableObj.alltableObj.length; i++) {
                    let chartsItem = this.tableObj.alltableObj[i];
                    $('.allCharts:eq(' + this.tableObj.tableId + ')').append(chartsItem.dom);
                    chartsItem.render();
                }
                // console.log('=====');
            }, 100);
        },
    };

    //表
    function tableClass(tableId, hang, lie) {
        this.table = $('<table class="table"><thead></thead></table>');
        this.tdList = {};
        this.tableId = tableId;
        this.hang = hang;
        this.lie = lie;
        this.addMoreHang = 3;//编辑状态下额外添加的行的数量
        this.alltableObj = [];//保存图表charts
        this.addHang = function () {
            for (var i = 0; i < this.addMoreHang; i++) {
                this.hang++;
            }
        };
        this.render = function (cssStr) {
        }
        this.child = function (positionStr) {
            return this.tdList[positionStr];
        }
        this.findChild = function (positionStr) {
            if (this.tdList[positionStr] === undefined) {
                new td(this, positionStr);
            }
            return this.tdList[positionStr];
        }
    }

    function selectTd2(temp, activeId) {
        if (temp !== window && !$(temp).is('.mergeTd')) {
            //不能拆分
            $('.toolsContent [data-name=tdMerge]').removeClass('active');
            $('.toolsContent [data-name=tdMerge]').addClass('disabled');
        } else {
            let isHasMerge = false;
            for (let i in tdData[activeId].mergeCells) {
                if (i.split(":")[0] == getCellTemp2($(temp).attr('hang'), $(temp).attr('lie'))) {
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
            fx(obj) {
                var selectPos = getCellTemp2(parseInt($(obj.td).attr('hang')), parseInt($(obj.td).attr('lie')));
                var tempValue = this.allTableDom[obj.tableNum].findChild(selectPos).value_;
                this.$refs.float.initFloatDom(obj.td, obj.tableNum, tempValue);
            },
            writeTd(tableNum, tdPos, str, xfIndex) {
                var thisTd = this.allTableDom[tableNum].findChild(tdPos);
                thisTd.xfIndex = xfIndex;
                if (str === null) {
                    thisTd.set('');
                } else if (typeof str === 'string' && str.substr(0, 1) === '=') {
                    str = str.match(/=(.*)/)[1];
                    thisTd.set(getEvalObj(tableNum, str, true));
                } else {
                    thisTd.set(str);
                }
                readyObj.bind(thisTd);
            },
            changeChart(charts) {
                var {tableNum, chartsIndex, content} = charts;
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
            },
            insertChart(opt) {
                var {tableNum, saveVlalue, chartsId, position, size} = opt;
                var chartsItem = getEvalObj(tableNum, saveVlalue, true);
                $('.allCharts:eq(0)').append(chartsItem.dom);
                chartsItem.myChart = echartsObj.init(chartsItem.dom.find('>div')[0], 'macarons');
                chartsItem.top = parseInt(position[0]);
                chartsItem.left = parseInt(position[1]);
                chartsItem.width = parseInt(size[0]);
                chartsItem.height = parseInt(size[1]);
                chartsItem.dom.attr('index', chartsId);
                chartsItem.index = chartsId;
                allEcharts[tableNum][chartsId] = chartsItem;
                allEcharts[tableNum][chartsId].render();
                allEcharts[tableNum][chartsId].myChart.resize();
            },
            isOpenEditSet(state) {
                this.isOpenEdit = state;
                let lieAddCount = 2;//增加
                if (this.isOpenEdit) {
                    if (lieAddCount > 0) {
                        $('#myTabContent .tab-pane').each(function () {
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
                        $('#myTabContent .tableBody table tbody tr').each(function () {
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
                        $('#myTabContent .tableThead table').each(function () {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('thead tr th:last').remove();
                            }
                        });
                        $('#myTabContent .tableBody table thead tr').each(function () {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('th:last').remove();
                            }
                        });
                        $('#myTabContent .tableBody table tbody tr').each(function () {
                            for (var i = 0; i < lieAddCount; i++) {
                                $(this).find('td:last').remove();
                            }
                        });
                    }
                    $('#tablePanel').removeClass('edit');
                    $('#dataFloat').hide();
                }
            },
            rewriteExcel(dataList) {
                var this_ = this;
                //单元格数据
                this.allFileData = dataList;

                function initMerge(table_Num, mergeData) {
                    for (let i in mergeData) {
                        let beginAndEnd = i.split(':');
                        let begin = getCellTemp(beginAndEnd[0]);
                        let end = getCellTemp(beginAndEnd[1]);

                        this_.allTableDom[table_Num].findChild(beginAndEnd[0]).dom.attr('rowspan', end[0] - begin[0] + 1);
                        this_.allTableDom[table_Num].findChild(getCellTemp2(begin[0], begin[1])).dom.attr('colspan', end[1] - begin[1] + 1);
                        this_.allTableDom[table_Num].findChild(beginAndEnd[0]).dom.addClass('mergeTd');

                        for (let tr = begin[0]; tr <= end[0]; tr++) {
                            let firstTdWidth = 0;
                            for (let td = end[1]; td >= begin[1]; td--) {
                                firstTdWidth += this_.allTableDom[table_Num].thead.find('thead th').eq(td - 1).outerWidth();
                                if (tr === begin[0] && td === begin[1]) {

                                } else {
                                    this_.allTableDom[table_Num].td(getCellTemp2(tr, td)).dom.hide();
                                }
                            }
                        }
                    }
                }


                td.config.params.tableId.select = {};
                for (let table_Num = 0; table_Num < this.allFileData.length; table_Num++) {
                    var tableObj = this.allFileData[table_Num];
                    var tableTitle = tableObj.title;
                    this.allTableTitle.push(tableTitle);
                    td.config.params.tableId.select[table_Num.toString()] = tableTitle;
                    tdData[table_Num] = {
                        tableTitle: tableTitle,
                        tableData: tableObj.tableValue,
                        mergeCells: tableObj.mergeCells,
                    };
                    //获取宽高
                    var hang = 0;
                    var lie = 0;
                    for (let i in tdData[table_Num].tableData) {
                        try {
                            var tdPos = getCellTemp(i);
                        } catch (e) {
                            continue;
                        }
                        hang = Math.max(hang, tdPos[0]);
                        lie = Math.max(lie, tdPos[1]);
                    }
                    lie = Math.max(lie, 6);//至少补充到6列
                    this_.allTableDom[table_Num] = new tableClass(table_Num, hang, lie);
                    this_.allTableDom[table_Num].render();
                    (function () {
                        //单元格列宽
                        let nod = document.createElement("style");
                        nod.type = "text/css";
                        $(nod).attr('td_css_list', 1);
                        let str = "";
                        var column = tableObj.column;
                        for (let i in column) {
                            let thNum = getCellTemp(i + '1')[1];
                            let strItem = "#myTabContent>.tab-pane:nth-child(" + (table_Num + 1) + ") [lie=\"" + thNum + "\"],#myTabContent>.tab-pane:nth-child(" + (table_Num + 1) + ") [lienum=\"" + i + "\"]{\n";
                            strItem += 'width:' + column[i].width * 10 + 'px;\n';
                            strItem += "}\n";
                            str += strItem;
                        }
                        let row = tableObj.row;
                        for (let i in row) {
                            let strItem = "#myTabContent>.tab-pane:nth-child(" + (table_Num + 1) + ") [hang=\"" + i + "\"],#myTabContent>.tab-pane:nth-child(" + (table_Num + 1) + ") [hang=\"" + i + "\"]{\n";
                            strItem += 'height:' + (row[i].height) + 'px;\n';
                            strItem += "}\n";
                            str += strItem;
                        }
                        if (nod.styleSheet) { //ie下
                            nod.styleSheet.cssText = str;
                        } else {
                            nod.innerHTML += str;
                        }
                        document.getElementsByTagName("head")[0].appendChild(nod);
                    })();
                    //单元格合并
                    initMerge(table_Num, tdData[table_Num].mergeCells);
                }
                for (let table_Num = 0; table_Num < this.allFileData.length; table_Num++) {
                    //绘制图表
                    allEcharts[table_Num] = [];
                    this_.allTableDom[table_Num].alltableObj = [];
                    var tableObj = this.allFileData[table_Num];
                    if (tableObj.charts !== undefined) {
                        for (let chartsId = 0; chartsId < tableObj.charts.length; chartsId++) {
                            let position = tableObj.charts[chartsId].position.split(',');
                            let size = tableObj.charts[chartsId].size.split(',');
                            if (tableObj.charts[chartsId].value !== null) {
                                let chartsItem = getEvalObj(table_Num, tableObj.charts[chartsId].value, true);
                                // $('.allCharts:eq(' + table_Num + ')').append(chartsItem.dom);
                                chartsItem.myChart = echartsObj.init(chartsItem.dom.find('>div')[0], 'macarons');
                                chartsItem.top = parseInt(position[0]);
                                chartsItem.left = parseInt(position[1]);
                                chartsItem.width = parseInt(size[0]);
                                chartsItem.height = parseInt(size[1]);
                                chartsItem.dom.attr('index', chartsId);
                                chartsItem.index = chartsId;
                                readyObj.bind(chartsItem);
                                this_.allTableDom[table_Num].alltableObj.push(chartsItem);
                                allEcharts[table_Num][chartsId] = chartsItem;

                            }
                        }
                    }
                }
                //vue的dom渲染比jquery慢一点点
                setTimeout(() => {
                    for (let table_Num = 0; table_Num < this.allFileData.length; table_Num++) {
                        for (let i in tdData[table_Num].tableData) {
                            this_.writeTd(table_Num, i, tdData[table_Num].tableData[i].value, tdData[table_Num].tableData[i].xfIndex);
                        }
                    }
                }, 100);

                //修改列宽度
                $('.tableThead>.table>thead>tr>.lieNum>div').each(function () {
                    function setTdWidth(table_Num, thNum, width) {
                        this_.allTableDom[table_Num].thead.find('thead th').eq(thNum - 1).css({
                            width: width * 10
                        });
                        this_.allTableDom[table_Num].table.find('tbody tr:eq(0) td').eq(thNum - 1).css({
                            width: width * 10
                        });
                    }

                    $(this).dragging({
                        move: 'x',
                        xLimit: false,
                        yLimit: false,
                        randomPosition: false,
                        onMousemove: function (dom, pos) {
                            var thNum = getCellTemp(dom.parent().attr('lienum') + '1')[1];
                            setTdWidth(this_.tableNum, thNum, (pos.left + 5) / 10);
                        },
                        onMouseup: function (dom) {
                            var lienum = dom.parent().attr('lienum');
                            var width = dom.parent().width();
                            ajax({
                                type: 'POST',
                                data: {
                                    'function': 'updateWidth',
                                    'fileId': this_.fileId,
                                    'tableNum': this_.tableNum,
                                    'lienum': lienum,
                                    'width': (width / 10).toFixed(1)
                                }
                            }).then((data) => {
                                $('#myTabContent>.tab-pane:nth-child(' + (this_.tableNum + 1) + ') .tableBody [lie="' + getCellTemp(lienum + '1')[1] + '"]').width(width);
                                $('#myTabContent>.tab-pane:nth-child(' + (this_.tableNum + 1) + ') .tableBody [lienum="' + lienum + '"]').width(width + 2);//2是边框的宽度
                            });
                        }
                    });
                });
                //修改列高度
                $('.tableRow>.table>tbody>tr>.idNum>div').each(function () {
                    function setTdHeight(table_Num, thNum, height) {
                        this_.allTableDom[table_Num].thead.find('thead th').eq(thNum - 1).css({
                            height: height * 10
                        });
                        this_.allTableDom[table_Num].table.find('tbody tr:eq(0) td').eq(thNum - 1).css({
                            height: height * 10
                        });
                    }

                    $(this).dragging({
                        move: 'y',
                        xLimit: false,
                        yLimit: false,
                        randomPosition: false,
                        onMousemove: function (dom_, pos) {
                            var thNum = dom_.parent().data('num');
                            var height = (pos.top + 5);
                            dom_.parent().css('height', height);
                            this_.allTableDom[this_.tableNum].table.find('tbody tr').eq(thNum - 1).css({
                                height: height
                            });
                        },
                        onMouseup: function (dom) {
                            var hangnum = dom.parent().data('num');
                            var height = dom.parent().height();
                            ajax({
                                type: 'POST',
                                data: {
                                    'function': 'updateHeight',
                                    'fileId': this_.fileId,
                                    'tableNum': this_.tableNum,
                                    'row': hangnum,

                                    'height': parseInt(height)
                                }
                            }).then(() => {

                            });
                        }
                    });
                });
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
                        }
                    }).then((data) => {
                        if (data === -2) {
                            alert('工作表名称已存在');
                        } else if (data === 1) {
                            location.href = location.href;//很多情况下无法刷新
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
                    selectTd2(eventDom, this.tableNum);
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
                    var tableid = this.tableNum;
                    for (let i = top; i <= bottom; i++) {
                        for (let j = left; j <= right; j++) {
                            if (i === top) {
                                this.allTableDom[tableid].findChild(getCellTemp2(i, j)).dom.addClass('editTdtop');
                            }
                            if (i === bottom) {
                                this.allTableDom[tableid].findChild(getCellTemp2(i, j)).dom.addClass('editTdbottom');
                            }
                            if (j === left) {
                                this.allTableDom[tableid].findChild(getCellTemp2(i, j)).dom.addClass('editTdleft');
                            }
                            if (j === right) {
                                this.allTableDom[tableid].findChild(getCellTemp2(i, j)).dom.addClass('editTdright');
                            }
                            this.allTableDom[tableid].findChild(getCellTemp2(i, j)).dom.addClass('editTd');
                        }
                    }
                    this.selectTd(undefined);
                    selectTd2(window, this.tableNum);
                }
            },
            mouseup_temp() {
                isSelectDoms = false;
            },
            changeTd(td) {
                let {tableNum, pos, value, xfIndex} = td;
                this.writeTd(tableNum, pos, value, xfIndex);
                if (getCellTemp(pos)[0] > this.allTableDom[tableNum].hang) {
                    this.allTableDom[tableNum].addHang();
                }
            }
        },
        data: function () {
            return {
                title: '',
                getEvalObj: getEvalObj,
                isMyTable: true,
                isOpenEdit: false,
                tableNum: 0,//表序列
                allTableTitle: [],
                fileId: parseInt(window.location.href.match(/\/table\/(\d+)\.html/)[1]),
                allFileData: [],
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
                },
                allTableDom: [],
            }
        },
        components: {
            bottom, tools, dataFloat, wrapper, pageFloatPanel, tableVueObj
        },
        created() {
            var this_ = this;
            functionInit(td, '表格项', {
                params: {
                    tableId: {
                        title: '表',
                        dataType: 'int',
                        default: 0,
                        //select:{
                        //    'string':'字符串',
                        //    'int':'数字'
                        //}
                    },
                    tdName: {
                        title: '表格位置',
                        dataType: 'string',
                        default: 'A1',
                    }
                },
                save: function (obj) {
                    return [this_.allTableDom[obj.tableId], obj.tdName];
                }
            });
            __allMatch__.push({
                match: /^[A-Z]+\d+$/,
                value: function (tableNum, word, baseWord) {
                    if (baseWord === null) {
                        return this_.allTableDom[tableNum].findChild(word);
                    } else {
                        return this_.allTableDom[baseWord.tableId].findChild(word);
                    }
                }
            });
            __allMatch__.push({
                match: /^\!$/,
                value: function (tableNum, word, baseWord) {
                    let searchTableNum = tableNum;
                    for (let i = 0; i < tdData.length; i++) {
                        if (tdData[i].tableTitle === baseWord) {
                            searchTableNum = i;
                        }
                    }
                    return this_.allTableDom[searchTableNum];
                }
            });
            ajax({
                type: 'POST',
                data: {
                    function: 'tableInfo',
                    fileId: this.fileId,
                    temp: 1,
                }
            }).then((data) => {
                this.title = data.title;
                this.isMyTable = data.isMyTable;
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
                this.rewriteExcel(data.data);
                //触发表格完成
                readyObj.set(1);
            });
            $('body').click(function () {
                if ($('.floatSingleValueWrite .input input[pos]').length > 0) {
                    $('.floatSingleValueWrite .input input[pos]').each(function () {
                        var inputDom = this;

                        function afterUpdate() {
                            this_.writeTd($(inputDom).attr('tableid'),
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
                                type: 'POST',
                                data: {
                                    function: 'updateTdValue',
                                    fileId: this_.fileId,
                                    tableNum: $(this).attr('tableid'),
                                    pos: $(this).attr('pos'),
                                    value: $(this).val()
                                }
                            }).then((data) => {
                                if (data !== '-1') {
                                    if (getCellTemp($(inputDom).attr('pos'))[0] > this_.allTableDom[$(inputDom).attr('tableid')].hang) {
                                        this_.allTableDom[$(inputDom).attr('tableid')].addHang();
                                    }
                                    afterUpdate();
                                } else {
                                    alert('样式服务器同步失败');
                                }
                            });
                        } else {
                            afterUpdate();
                        }
                    });
                }
            });

            $('body').on('dblclick', '.edit #myTabContent td', function () {
                setTdSelectState.call(this);
                //看看当前单元格是否有合并
                var activeId = this_.tableNum;
                var selectPos = getCellTemp2(parseInt($(this).attr('hang')), parseInt($(this).attr('lie')));
                var tempValue = this_.allTableDom[activeId].findChild(selectPos).value_;
                if (typeof tempValue === 'string' || typeof tempValue === 'number' || tempValue === undefined) {
                    //计算宽度
                    function getTrueWidth(str, xf) {
                        var span = $('<span></span>');
                        span.attr('cell_xf', xf);
                        span.html(str);
                        $(this).parents('.tableBody').find('.floatSingleValueWrite .span').html('').append(span);
                        return span.width() + 8;
                    }

                    $('.tableBody').eq(activeId).scrollTop();
                    var position = $(this).position();
                    var inputTd = $(this).parents('.tableBody').find('.floatSingleValueWrite .input');
                    inputTd.show();
                    inputTd.find('input').val(tempValue);
                    inputTd.find('input').attr('cell_xf', $(this).attr('cell_xf'));
                    inputTd.find('input').attr('tableId', activeId);
                    inputTd.find('input').attr('pos', getCellTemp2($(this).attr('hang'), $(this).attr('lie')));
                    inputTd.find('input').attr('oldValue', tempValue);
                    inputTd.css('left', position.left - parseInt($(this).parents('.tableBody').css('marginLeft')) + $('.tableBody').eq(activeId).scrollLeft() - 1);
                    inputTd.css('top', position.top - parseInt($(this).parents('.tableBody').css('marginTop')) + $('.tableBody').eq(activeId).scrollTop());
                    inputTd.css('height', $(this).outerHeight() + 2);
                    inputTd.css('min-width', $(this).outerWidth() + 3);
                    inputTd.css('width', getTrueWidth.call(this, tempValue, $(this).attr('cell_xf')) + 1);
                    var this2_ = this;
                    inputTd.find('input').on('input', function () {
                        inputTd.css('width', getTrueWidth.call(this2_, $(this).val(), $(this2_).attr('cell_xf')));
                    });
                    inputTd.find('input').click(function (event) {
                        event.stopPropagation();
                    });
                    inputTd.find('input').focus();
                } else {
                    this_.$refs.float.initFloatDom(this, activeId, tempValue);
                }
            });

            $('body').on('keydown', '#myTabContent .floatSingleValueWrite .input input', function (e) {
                if (['Enter', 'ArrowRight'].indexOf(e.key) > -1) {    //'ArrowRight',
                    let inputDom = this;
                    let tableId = $(inputDom).attr('tableid');
                    let posId = $(inputDom).attr('pos');

                    function turnNewTD() {
                        this_.changeTd({
                            tableNum: tableId,
                            pos: posId,
                            value: $(inputDom).val(),
                            xfIndex: $(inputDom).attr('cell_xf')
                        });
                        $(inputDom).removeAttr('tableid');
                        $(inputDom).removeAttr('pos');
                        $(inputDom).removeAttr('cell_xf');
                        $(inputDom).val('');
                        $(inputDom).parent().hide();
                        let temp = getCellTemp(posId);
                        if (e.key === 'Enter') {

                        } else {
                            //键盘向右箭头
                            if (e.key === 'ArrowRight') {
                                temp[1]++;
                            }
                            let rightDom = this_.allTableDom[getCellTemp2(temp[0], temp[1])].findChild(getCellTemp2(temp[0], temp[1])).dom;
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
                                fileId: this_.fileId,
                                tableNum: $(this).attr('tableid'),
                                pos: $(this).attr('pos'),
                                value: $(this).val()
                            }
                        }).then((data) => {
                            if (data === 1) {
                                turnNewTD();
                            } else {
                                alert('样式服务器同步失败');
                            }
                        });
                    } else {
                        turnNewTD();
                    }
                }
            });
        }
    }

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="less">
    .floatSingleValueWrite {
        height: 1px;
        width: 1px;
        position: relative;
        margin-top: -2px;
        .input {
            position: absolute;
            z-index: 2;
            display: none;
            background-color: rgb(255, 255, 255);
            box-shadow: 0 0 30px rgba(0, 0, 0, 0.63);
        }
        input {
            width: 100%;
            height: 100%;
            &:focus {
                outline: none;
            }
        }
        .span {
            opacity: 0;
        }
    }
</style>
<style lang="less" scoped>
    body {
        background-color: #e6e6e6;
    }

    .table {
        width: 0 !important;
        margin-top: 0;
        background-color: white;
        table-layout: fixed;
        > thead > tr > th {
            width: 100px;
        }

        > tbody > tr > td {
            width: 100px;
            overflow: hidden;
        }
    }

    .idNum {
        background-color: #c3c3c3;
        border-right: solid 3px #929292;
        min-width: 30px;
    }

    .tableBody {
        margin-left: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        margin-top: 0;
        .input-group {
            width: 98%;
            margin-left: 1%;
        }
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
        top: 37px;
        height: calc(100% - 39px);
        overflow: hidden;
    }

    .tableThead {
        display: none;
    }

    .edit {
        .table {
            margin: 0 0;
        }

        .tableRow {
            display: block;
        }

        .tableThead {
            display: block;
        }
    }

    #myTabContent {
        position: relative;
        height: calc(~"100% - 40px");
        .tab-pane {
            overflow: auto;
            width: 100%;
            height: 100%;
            padding-top: 5px;
        }
    }

    .edit #myTabContentParent .tab-pane {
        padding-top: 1px;
    }

    #myTabContentParent {
        position: fixed;
        top: 45px;
        left: 0;
        right: 0;
        bottom: 20px;
    }

    .edit #myTabContentParent {
        top: 90px;
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

    .edit {
        .editTd {
            background-color: #e5f2ff;
            /*border:solid 2px #0000b8;*/
        }

        .editTdtop {
            border-top: solid 2px #0000b8;
        }

        .editTdbottom {
            border-bottom: solid 2px #0000b8;
        }

        .editTdleft {
            border-left: solid 2px #0000b8;
        }

        .editTdright {
            border-right: solid 2px #0000b8;
        }
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

    .tableThead {
        > thead th {
            border-bottom: solid 3px #929292 !important;
        }
        .table > thead > tr > .lieNum {
            position: relative;
            > div {
                cursor: ew-resize;
                position: absolute;
                right: 0;
                top: 0;
                height: 100%;
                width: 5px;
            }
        }
    }

    .table > tbody > tr > .mergeTd {
        white-space: initial
    }

    .tableBody {
        tr {
            background-color: white;
        }

        thead {
            height: 20px;
        }

        thead [lienum] {
            padding: 0;
        }

        .table {
            margin-top: -16px;
        }

        .table > thead > tr > th {
            border-bottom: none;
        }
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
        > div {
            display: table-cell;
        }

        > div:nth-child(2) {
            white-space: normal;
            display: block;
            height: 1rem;
        }

        > div:nth-child(2) > span {
            /*max-width: 100px;*/
            display: inline-block;
        }

        > div:first-child {
            text-align: left;
        }

        > div:last-child {
            text-align: right;
        }
    }
</style>
