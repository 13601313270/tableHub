<template>
    <div @click="bodyClick">
        <div id="tablePanel" :class="{edit:isOpenEdit}">
            <tools @stateChange="isOpenEditSet"
                   @fx="fx"
                   @insertChart="insertChart"
                   @setCellXf="setCellXf"
                   :cellXfInfo="cellXfInfo"
                   :selectMergeState="selectMergeState"
                   :selectPos="selectPos"
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
                <div id="myTabContent" ref="allPage" class="tab-content"></div>
                <div class="floatSingleValueWrite" v-show="userValueWriteIsShow"
                     :style="{left:floatSingleValueWritePosition.x*-1+79+'px',top:floatSingleValueWritePosition.y*-1+39+'px'}">
                    <div class="input" :style="floatInputStyle">
                        <input @keydown="userValueWrite" ref="floatInput" v-model="userValueWriteValue" @click.stop=""/>
                    </div>
                    <div class="span"></div>
                </div>
            </div>
        </div>
        <bottom></bottom>
        <dataFloat ref="float"
                   :fileId="this.fileId"
                   :table-num="this.tableNum"
                   :get-eval-obj="this.getEvalObj"
                   @change="changeTd"
                   @changeChart="changeChart"></dataFloat>
        <wrapper></wrapper>
    </div>
</template>

<script>
    import bottom from '@/components/bottom.vue';
    import tools from '@/components/tools.vue';
    import dataFloat from '@/components/dataFloat.vue';
    import wrapper from '@/components/wrapper.vue';
    import pageFloatPanel from '@/components/pageFloatPanel.vue';
    import ajax from '@/tools/ajax.js';
    import echarts from 'echarts';
    import tableClass from '@/tools/table';
    import $ from 'jquery';
    //    import 'bootstrap/dist/css/bootstrap.min.css';
    //    import 'bootstrap/dist/js/bootstrap.min';

    function tableReady() {
    }

    tableReady.prototype = new obj();

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
            if (item.alignment.horizontal === 'left') {
                strItem += 'text-align: left!important;\n';
            } else if (item.alignment.horizontal === 'right') {
                strItem += 'text-align: right!important;\n';
            } else if (item.alignment.horizontal === 'center') {
                strItem += 'text-align: center!important;\n';
            } else if (item.alignment.horizontal === 'general') {
//                    strItem+='text-align: center;\n';
            }
        }
        strItem += "}\n";
        return strItem;
    }

    export default {
        name: 'page',
        methods: {
            fx() {
                if (this.selectPos === '') {
                    return;
                }
                var tempValue = this.allTableDom[this.tableNum].findChild(this.selectPos).value_;

                var tempTd = this.allTableDom[this.tableNum].findChild(this.selectPos);
                this.$refs.float.initFloatDom(tempTd, this.tableNum, tempValue);
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
                this.readyObj.bind(thisTd);
            },
            changeChart(charts) {
                var {tableNum, chartsIndex, content} = charts;
                var oldObj = this.allTableDom[tableNum].alltableObj[chartsIndex];
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
                chartsItem.myChart = echarts.init(chartsItem.dom.find('>div')[0], 'macarons');
                chartsItem.top = parseInt(position[0]);
                chartsItem.left = parseInt(position[1]);
                chartsItem.width = parseInt(size[0]);
                chartsItem.height = parseInt(size[1]);
                chartsItem.dom.attr('index', chartsId);
                chartsItem.index = chartsId;
                this.allTableDom[tableNum].alltableObj.push(chartsItem);
                chartsItem.render();
                chartsItem.myChart.resize();
            },
            isOpenEditSet(state) {
                this.isOpenEdit = state;
                let lieAddCount = 2;// 增加
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
                    this.$refs.float.hide();
                }
            },
            rewriteExcel(dataList) {
                var this_ = this;
                // 单元格数据
                this.allFileData = dataList;

                function initMerge(table_Num, mergeData) {
                    for (let i in mergeData) {
                        let beginAndEnd = i.split(':');
                        let begin = getCellTemp(beginAndEnd[0]);
                        let end = getCellTemp(beginAndEnd[1]);
                        var beginDom = this_.allTableDom[table_Num].findChild(beginAndEnd[0]).dom;

                        if (beginDom instanceof jQuery) {
                            beginDom = beginDom[0];
                        }
                        beginDom = beginDom.parentNode;
                        beginDom.setAttribute('rowspan', end[0] - begin[0] + 1);
                        var domTemp = this_.allTableDom[table_Num].findChild(getCellTemp2(begin[0], begin[1])).dom;
                        if (domTemp instanceof jQuery) {
                            domTemp = domTemp[0];
                        }
                        domTemp = domTemp.parentNode;
                        domTemp.setAttribute('colspan', end[1] - begin[1] + 1);
                        let beginClass = beginDom.className.split(' ');
                        if (beginClass.includes('mergeTd')) {
                            beginClass.push('mergeTd');
                        }
                        // beginDom.className = 'mergeTd';//beginClass.join(' ');

                        for (let tr = begin[0]; tr <= end[0]; tr++) {
                            for (let td = end[1]; td >= begin[1]; td--) {
                                if (tr === begin[0] && td === begin[1]) {
                                    // if (end[1] > begin[1]) {
                                    //     this_.allTableDom[table_Num].findChild(getCellTemp2(tr, td)).dom.parentNode.setAttribute('colspan', end[1] - begin[1] + 1);
                                    // }
                                    // if (end[0] > begin[0]) {
                                    //     this_.allTableDom[table_Num].findChild(getCellTemp2(tr, td)).dom.parentNode.setAttribute('rowspan', end[0] - begin[0] + 1);
                                    // }
                                } else {
                                    this_.allTableDom[table_Num].findChild(getCellTemp2(tr, td)).dom.parentNode.style.display = 'none';
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
                        // mergeCells: tableObj.mergeCells,
                    };
                    // 获取宽高123
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
                    lie = Math.max(lie, 6);// 至少补充到6列
                    this_.allTableDom[table_Num] = new tableClass(table_Num, tableObj, hang, lie);
                    this_.allTableDom[table_Num].addListener('tdSelect', function (data) {
                        if (this_.isOpenEdit) {
                            this_.cellXfInfo = data.xf;
                            this_.selectMergeState = data.selectMergeState;
                            this_.selectPos = data.pos;
                            this_.userValueWriteIsShow = false;
                        }
                    });
                    this_.allTableDom[table_Num].addListener('scroll', (data) => {
                        this_.floatSingleValueWritePosition.x = data.x;
                        this_.floatSingleValueWritePosition.y = data.y;
                    });
                    this_.allTableDom[table_Num].addListener('dblclick', (pos) => {
                        if (this_.isOpenEdit) {
                            this_.selectPos = pos;
                            // 看看当前单元格是否有合并
                            var activeId = this.tableNum;
                            var tempValue = this_.allTableDom[activeId].findChild(pos).value_;
                            if (typeof tempValue === 'string' || typeof tempValue === 'number' || tempValue === undefined) {
                                // 计算坐标
                                var position = {x: 0, y: 0};
                                var allColumnInfo = this_.allFileData[this.tableNum].column;
                                for (let i = getCellTemp(pos)[1] - 1; i >= 1; i--) {
                                    var lieNum = getCellTemp2(0, i).match(/([A-Z]*)\$?(\d+)/)[1];
                                    if (allColumnInfo[lieNum] === undefined) {
                                        position.x += 10;
                                    } else {
                                        position.x += parseFloat(allColumnInfo[lieNum].width);
                                    }
                                }
                                allColumnInfo = this_.allFileData[this.tableNum].row;
                                for (let i = getCellTemp(pos)[0] - 1; i >= 1; i--) {
                                    if (allColumnInfo[i] === undefined) {
                                        position.y += 37;
                                    } else {
                                        position.y += parseFloat(allColumnInfo[i].height);
                                    }
                                }

                                this_.userValueWriteIsShow = true;
                                this_.userValueWriteValue = tempValue;

                                this_.floatInputStyle.left = position.x * 10 + 'px';
                                this_.floatInputStyle.top = position.y + 'px';

//
                                var row = this_.allFileData[this.tableNum].row[getCellTemp(pos)[0]];
                                if (row) {
                                    this_.floatInputStyle.height = parseFloat(row.height) + 2 + 'px';
                                } else {
                                    this_.floatInputStyle.height = 37 + 2 + 'px';
                                }
//
                                var lie = this_.allFileData[this.tableNum].column[pos.match(/([A-Z]*)\$?(\d+)/)[1]];
                                if (lie) {
                                    // 这块有个bug,merge的td只显示左侧的宽度
                                    this_.floatInputStyle.minWidth = lie.width * 10 + 3 + 'px';
                                } else {
                                    this_.floatInputStyle.minWidth = 100 + 3 + 'px';
                                }
                                setTimeout(() => {
                                    this_.$refs.floatInput.focus();
                                }, 100);
                                this_.$refs.float.hide();
                            } else {
                                this_.userValueWriteIsShow = false;
                                var tempTd = this_.allTableDom[this_.tableNum].findChild(pos);
                                this_.$refs.float.initFloatDom(tempTd, activeId, tempValue);
                                this_.$refs.float.show();
                            }
                        }
                    });

                    this_.$refs.allPage.append(this_.allTableDom[table_Num].dom);

                    this_.allTableDom[table_Num].render();
                    this_.allTableDom[table_Num].initTdStyle();
                    // 单元格合并
                    initMerge(table_Num, this_.allTableDom[table_Num].mergeCells);

                    for (let i in tdData[table_Num].tableData) {
                        this_.writeTd(table_Num, i, tdData[table_Num].tableData[i].value, tdData[table_Num].tableData[i].xfIndex);
                    }

                    // 绘制图表，一定要排在td之后
                    if (tableObj.charts !== undefined) {
                        for (let chartsId = 0; chartsId < tableObj.charts.length; chartsId++) {
                            let position = tableObj.charts[chartsId].position.split(',');
                            let size = tableObj.charts[chartsId].size.split(',');
                            if (tableObj.charts[chartsId].value !== null) {
                                let chartsItem = getEvalObj(table_Num, tableObj.charts[chartsId].value, true);
                                chartsItem.myChart = echarts.init(chartsItem.dom.find('>div')[0], 'macarons');
                                chartsItem.top = parseInt(position[0]);
                                chartsItem.left = parseInt(position[1]);
                                chartsItem.width = parseInt(size[0]);
                                chartsItem.height = parseInt(size[1]);
                                chartsItem.dom.attr('index', chartsId);
                                chartsItem.index = chartsId;
                                this_.readyObj.bind(chartsItem);
                                chartsItem.dom[0].addEventListener('dblclick', function (event) {
                                    this_.$refs.float.initCharts(table_Num, chartsId, this_.allTableDom[table_Num].alltableObj[chartsId]);
                                });
                                this_.allTableDom[table_Num].alltableObj.push(chartsItem);

                            }
                        }
                    }
                }
            },
            setCellXf(id) {
                this.allTableDom[this.tableNum].findChild(this.selectPos).xfIndex = id;
                this.allTableDom[this.tableNum].findChild(this.selectPos).render();
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
                            location.href = location.href;// 很多情况下无法刷新
                        }
                    });
                }
            },
            changeTd(td) {
                let {tableNum, pos, value, xfIndex} = td;
                this.writeTd(tableNum, pos, value, xfIndex);
                if (getCellTemp(pos)[0] > this.allTableDom[tableNum].hang) {
                    this.allTableDom[tableNum].addHang();
                }
            },
            bodyClick() {
                if (this.userValueWriteIsShow) {
                    var this_ = this;

                    function afterUpdate() {
                        this_.changeTd({
                            tableNum: this_.tableNum,
                            pos: this_.selectPos,
                            value: this_.userValueWriteValue,
                            xfIndex: this_.allTableDom[this_.tableNum].findChild(this_.selectPos).xfIndex
                        });
                        this_.userValueWriteIsShow = false;
                        this_.userValueWriteValue = '';
                        this_.selectPos = '';
                    }

                    if (this_.allTableDom[this_.tableNum].findChild(this_.selectPos).get().toString() !== this_.userValueWriteValue) {
                        ajax({
                            type: 'POST',
                            data: {
                                'function': 'updateTdValue',
                                fileId: this_.fileId,
                                tableNum: this_.tableNum,
                                pos: this_.selectPos,
                                value: this_.userValueWriteValue
                            }
                        }).then((data) => {
                            if (data !== '-1') {
                                if (getCellTemp(this_.selectPos)[0] > this_.allTableDom[this_.tableNum].hang) {
                                    this_.allTableDom[this_.tableNum].addHang();
                                }
                                afterUpdate();
                            } else {
                                alert('样式服务器同步失败');
                                this.selectPos = '';
                            }
                        });
                    } else {
                        afterUpdate();
                    }
                } else {
                    this.selectPos = '';
                }
            },
            userValueWrite(value) {
                var key = value.key;
                var this_ = this;
                if (['Enter', 'ArrowRight'].indexOf(key) > -1) {
                    let tableId = this.tableNum;
                    let posId = this.selectPos;

                    function turnNewTD() {
                        this_.changeTd({
                            tableNum: tableId,
                            pos: posId,
                            value: value.target.value,
                            xfIndex: this_.allTableDom[this_.tableNum].findChild(this_.selectPos).xfIndex
                        });
                        this_.userValueWriteValue = '';
                        this_.userValueWriteIsShow = false;
                        let temp = getCellTemp(posId);
                        if (key === 'Enter') {

                        } else {
                            // 键盘向右箭头
                            if (key === 'ArrowRight') {
                                temp[1]++;
                            }
                            this_.allTableDom[tableId].events_.emit('dblclick', getCellTemp2(temp[0], temp[1]));
                        }
                    }

                    if (this.allTableDom[this.tableNum].findChild(this.selectPos).get().toString() !== value.target.value) {
                        ajax({
                            url: 'http://www.tablehub.cn/action/table.html',
                            type: 'POST',
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                            data: {
                                function: 'updateTdValue',
                                fileId: this.fileId,
                                tableNum: tableId,
                                pos: posId,
                                value: value.target.value
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
            }
        },
        watch: {
            tableNum(val) {
                for (let i = 0; i < this.allTableDom.length; i++) {
                    if (i === val) {
                        this.allTableDom[i].active(true);
                    } else {
                        this.allTableDom[i].active(false);
                    }
                }
            }
        },
        data: function () {
            return {
                title: '',
                readyObj: new tableReady(),
                getEvalObj: getEvalObj,
                isMyTable: true,
                isOpenEdit: false,
                tableNum: 0, // 表序列
                allTableTitle: [],
                userValueWriteIsShow: false,
                userValueWriteValue: '',
                fileId: parseInt(window.location.href.match(/\/table\/(\d+)\.html/)[1]),
                allFileData: [],
                selectPos: '',
                selectMergeState: false,
                floatSingleValueWritePosition: {x: 0, y: 0},
                floatInputStyle: {},
                cellXfInfo: {
                    font: {
                        bold: false,
                        underline: false,
                        italic: false,
                    },
                    alignment: {
                        horizontal: 'general'
                    }
                },
                allTableDom: []
            };
        },
        components: {
            bottom, tools, dataFloat, wrapper, pageFloatPanel
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
                value(tableNum, word, baseWord) {
                    if (baseWord === null) {
                        return this_.allTableDom[tableNum].findChild(word);
                    } else {
                        return this_.allTableDom[baseWord.tableId].findChild(word);
                    }
                }
            });

            __allMatch__.push({
                match: /^\:$/,
                value(tableNum, word, baseWord, getAfterObjFunc) {
                    var end = getAfterObjFunc(['+', '-', '*', '/', '>', '<', ')']);
                    return new tdList(baseWord, end);
                }
            });
            __allMatch__.push({
                match: /^\!$/,
                value(tableNum, word, baseWord) {
                    let searchTableNum = tableNum;
                    for (let i = 0; i < tdData.length; i++) {
                        if (tdData[i].tableTitle === baseWord) {
                            searchTableNum = i;
                        }
                    }
                    return this_.allTableDom[searchTableNum];
                }
            });
            __allMatch__.push({
                match: /^\!$/,
                value(tableNum, word, baseWord) {
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
                // 单元格样式
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
                this_.readyObj.set(1);
            });
        }
    }

</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style lang="less">
    .floatSingleValueWrite {
        height: 1px;
        width: 1px;
        position: absolute;
        margin-top: 41px;
        .input {
            position: absolute;
            z-index: 2;
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
        th, td {
            text-align: center;
        }

        > tbody > tr {
            height: 37px;
            > td {
                min-width: 60px;
                border: 1px solid #ddd;
                white-space: nowrap;
                vertical-align: middle;
                padding: 0;
                height: 37px;
            }
            > .mergeTd {
                white-space: initial
            }
        }

        > thead {
            background-color: #c3c3c3;
        }

        td .tdInsertDiv {
            display: flex;
            width: 100%;
            height: 100%;
            align-items: stretch;
            > div:nth-child(2) {
                flex-grow: 1;
                > span {
                    display: inline-block;
                }
            }
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
        .allCharts {
            height: 1px;
            width: 1px;
            position: relative;
        }
    }

    .tableRow {
        display: none;
        position: absolute;
        left: 0;
        width: 80px;
        top: 39px;
        height: calc(~"100% - 39px");
        overflow: hidden;
    }

    .edit {
        .table {
            margin: 0 0;
        }

        .tableRow {
            display: block;
            .table > tbody > tr > .idNum {
                position: relative;
                > div {
                    cursor: ns-resize;
                    position: absolute;
                    left: 0;
                    bottom: 0;
                    height: 5px;
                    width: 100%;
                }
            }
        }

        .tableThead {
            display: block;
        }
        .tableBody {
            margin-left: 80px;
            width: calc(~"100% - 80px");
            height: calc(~"100% - 39px");
            overflow: scroll;
            margin-top: 39px;
            cursor: cell;
        }
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

    .tableThead thead > tr > th {
        min-width: 60px;
        border: 1px solid #ddd;
        white-space: nowrap;
        vertical-align: middle;
        padding: 0;
        height: 37px;
    }

    .tableThead {
        display: none;
        position: absolute;
        left: 80px;
        width: calc(~"100% - 80px");
        overflow: hidden;
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
            margin-top: -2px;
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
</style>