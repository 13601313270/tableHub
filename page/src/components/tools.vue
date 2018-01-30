<template>
    <div id="tools">
        <div class="container" :class="{openEdit:isOpenEdit_,closeEdit:!isOpenEdit_}">
            <div class="editChange" v-if="isMyTable" @click="stateChange"></div>
            <div class="title">{{title}}</div>
            <ul class="nav nav-tabs" v-if="isOpenEdit_">
                <li :class="{active:tabState==1}"><a @click="tabState=1"
                                                     data-toggle="tab">开始</a>
                </li>
                <li :class="{active:tabState==2}"><a @click="tabState=2" data-toggle="tab">图表</a></li>
                <li :class="{active:tabState==3}"><a @click="tabState=3" data-toggle="tab">分析</a></li>
            </ul>
            <!--<user-state class="user-state"></user-state>-->
        </div>
        <div v-if="isOpenEdit_" class="toolsContent">
            <div class="tab-content">
                <div class="tab-pane fade" :class="{active:tabState==1,in:tabState==1}" id="tool1"
                     style="width: 812px;">
                    <div class="btn-group">
                        <button class="btn btn-default" :class="{active:this.cellXfInfo.font.bold}" data-name="bold"
                                @click="rewriteStyle">&#xe63f;
                        </button>
                        <button class="btn btn-default" :class="{active:this.cellXfInfo.font.italic}" data-name="italic"
                                @click="rewriteStyle">&#xe60d;
                        </button>
                        <button class="btn btn-default" :class="{active:this.cellXfInfo.font.underline}"
                                data-name="underline" @click="rewriteStyle">&#xe614;
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default"
                                :class="{active:this.cellXfInfo.alignment.horizontal === 'left'}"
                                data-name="horizontal_left"
                                @click.self="rewriteStyle">
                            <span class="glyphicon glyphicon-align-left" aria-hidden="true"></span>
                        </button>
                        <button type="button" class="btn btn-default"
                                :class="{active:this.cellXfInfo.alignment.horizontal === 'center'}"
                                data-name="horizontal_center"
                                @click.self="rewriteStyle">
                            <span class="glyphicon glyphicon-align-center" aria-hidden="true"></span>
                        </button>
                        <button type="button" class="btn btn-default" data-name="horizontal_right"
                                :class="{active:this.cellXfInfo.alignment.horizontal === 'right'}"
                                @click.self="rewriteStyle">
                            <span class="glyphicon glyphicon-align-right" aria-hidden="true"></span>
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default"
                                :class="{active:selectMergeState=='down',disabled:selectMergeState=='disable'}"
                                data-name="tdMerge" @click="rewriteStyle">
                            &#xe60f;
                        </button>
                    </div>
                    <div class="btn-group">
                        <div class="input-group" style="width: 110px;">
                            <div class="input-group-addon">&#xe715;</div>
                            <input type="number"
                                   @change="rewriteStyle" v-model="this.cellXfInfo.font.size"
                                   class="form-control" data-name="size"
                                   placeholder="字号">
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="button"
                                class="btn btn-default"
                                data-name="fill"
                                :style="{backgroundColor:this.cellXfInfo.fill&&this.cellXfInfo.fill.startColor}">
                            &#xe690;
                        </button>
                        <button type="button"
                                class="btn btn-default"
                                data-name="color"
                                :style="{color:this.cellXfInfo.fill&&this.cellXfInfo.font.color}">
                            &#xe613;
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-name="fx" @click="this.fx">&#xe646;</button>
                    </div>
                    <div class="btn-group" style="display: none">
                        <div class="input-group disabled" style="width: 150px;">
                            <div class="input-group-addon">输出格式</div>
                            <select title="格式" class="form-control disabled"
                                    style="appearance: none;-moz-appearance: none;-webkit-appearance: none;background:url(http://ourjs.github.io/static/2015/arrow.png) no-repeat scroll right center rgb(255, 255, 255);">
                                <option>无</option>
                                <option>美元</option>
                                <option>人民币</option>
                            </select>
                        </div>
                    </div>
                    <div class="btn-group" style="display: none">
                        <label class="checkbox-inline">
                            <input type="checkbox disabled" id="inlineCheckbox1" value="option1">网格线
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox disabled" id="inlineCheckbox1" value="option1">标题
                        </label>
                    </div>
                </div>
                <div class="tab-pane fade" :class="{active:tabState==2,in:tabState==2}" id="tool2"
                     style="width: 783px;">
                    <div class="btn-group">
                        <button type="button" class="insertBar btn btn-default" @click="insertCharts('BAR');">&#xe600;柱状图</button>
                        <!--<button type="button" class="btn btn-default">&#xe610;堆积柱状图</button>
                        <button type="button" class="btn btn-default">&#xe611;簇形柱状图</button>-->
                    </div>
                    <div class="btn-group">
                        <button type="button" class="insertLine btn btn-default" @click="insertCharts('LINE');">&#xe636;折线图</button>
                        <!--<button type="button" class="btn btn-default">&#xe62b;标记折线图</button>*}
                        {*<button type="button" class="btn btn-default">&#xe61e;面积折线图</button>-->
                    </div>
                    <div class="btn-group">
                        <button type="button" class="insertPie btn btn-default" @click="insertCharts('PIE')">
                            &#xe60c;饼状图
                        </button>
                    </div>
                    <!--
                    {*<div class="btn-group">*}
                    {*<button type="button" class="btn btn-default">&#xe63a;散点图</button>*}
                    {*</div>*}
                    -->
                </div>
                <div class="tab-pane fade" :class="{active:tabState==3,in:tabState==3}" id="tool3">3</div>
            </div>
        </div>
    </div>
</template>

<script>
    import ajax from '@/tools/ajax.js';
    import userState from './userState.vue';

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
        props: ['title', 'isMyTable', 'isOpenEdit', 'cellXfInfo', 'fileId', 'table-num', 'selectMergeState'],
        methods: {
            stateChange() {
                this.isOpenEdit_ = !this.isOpenEdit_;
                this.$emit('stateChange', this.isOpenEdit_);
            },
            insertCharts(valueStr) {
                valueStr += '("标题","","")';
                var tableNum = this.tableNum;
                var position = [200, 100];
                var size = [300, 200];
                var saveVlalue = valueStr;
                ajax({
                    url: 'http://www.tablehub.cn/action/table.html',
                    type: 'POST',
                    'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                    data: {
                        function: 'insertChartsValue',
                        fileId: this.fileId,
                        tableNum: tableNum,
                        value: saveVlalue,
                        position: position,
                        size: size
                    }
                }).then((data) => {
                    console.log(data);
                    this.$emit('insertChart', {
                        tableNum: tableNum,
                        saveVlalue: saveVlalue,
                        chartsId: data.result,
                        position: position,
                        size: size
                    });
                });
            },
            fx() {
                var this_ = $('.editTd');
                if (this_.length !== 1) {
                    return;
                }
                this.$emit('fx');
            },
            rewriteStyle(event) {
                var self = this;
                let thisDom = event.srcElement;
                if ($(thisDom).is('.disabled')) {
                    return;
                }
                if ($(thisDom).is('[data-name=fill]')) {
                    return;
                }
                if ($(thisDom).is('[data-name=fx]')) {
                    return;
                }
                let actionType = $(thisDom).data('name');
                console.log(actionType);
                let isActive = $(thisDom).is('.active');
                let value = $(thisDom).val();
//        console.log(this);
                let this_ = $('.editTd');
                if (this_.length === 0) {
                    return;
                }
                let cell_xf = $(this_).attr('cell_xf');
                console.log(cell_xf);
                let pos = getCellTemp2($(this_).attr('hang'), $(this_).attr('lie'));

                function run() {
                    let isExist = false;//是否已经存在一个这样样式的id
                    let isExistId = -1;
                    for (let i = 0; i < getCellXfCollection.length; i++) {
                        if (JSON.stringify(getCellXfCollection[i]) === JSON.stringify(cell_xf)) {
                            isExistId = i;
                            isExist = true;
                            break;
                        }
                    }
                    if (isExist) {
                        if (parseInt($(this_).attr('cell_xf')) !== isExistId) {
                            ajax({
                                url: 'http://www.tablehub.cn/action/table.html',
                                type: 'POST',
                                'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                                data: {
                                    'function': 'updateTdXf',
                                    fileId: self.fileId,
                                    tableNum: self.tableNum,
                                    pos: pos,
                                    xfIndex: isExistId,
                                }
                            }).then((data) => {
                                if (data !== '-1') {
                                    $(this_).attr('cell_xf', data);
                                } else {
                                    alert('样式服务器同步失败');
                                }
                            });
                        }
                    }
                    else {
                        ajax({
                            url: 'http://www.tablehub.cn/action/table.html',
                            type: 'POST',
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                            data: {
                                'function': 'updateTdXf',
                                fileId: self.fileId,
                                tableNum: self.tableNum,
                                pos: pos,
                                value: cell_xf,
                            }
                        }).then((data) => {
                            let cssstr = createCss(data, cell_xf);
                            $('style[td_css_list]').append(cssstr);
                            $(this_).attr('cell_xf', data);
                            getCellXfCollection[data] = cell_xf;
                        });
                    }
                }

                if (cell_xf !== undefined) {
                    cell_xf = JSON.parse(JSON.stringify(getCellXfCollection[cell_xf]));//clone成一个新对象
                } else {
                    cell_xf = {
                        font: {}
                    };
                }
                if (cell_xf.alignment === undefined) {
                    cell_xf.alignment = {};
                }
                if (['bold', 'italic'].indexOf(actionType) > -1) {
                    if (isActive) {
                        $('.toolsContent [data-name=' + actionType + ']').removeClass('active');
                    } else {
                        $('.toolsContent [data-name=' + actionType + ']').addClass('active');
                    }
                    cell_xf.font[actionType] = (!isActive) ? 1 : 0;
                }
                else if (actionType === 'underline') {
                    if (isActive) {
                        $('.toolsContent [data-name=' + actionType + ']').removeClass('active');
                        cell_xf.font[actionType] = 'none';
                    } else {
                        $('.toolsContent [data-name=' + actionType + ']').addClass('active');
                        cell_xf.font[actionType] = 'single';
                    }
                }
                else if (['horizontal_left', 'horizontal_center', 'horizontal_right'].indexOf(actionType) > -1) {
                    $('.toolsContent [data-name=horizontal_left]').removeClass('active');
                    $('.toolsContent [data-name=horizontal_center]').removeClass('active');
                    $('.toolsContent [data-name=horizontal_right]').removeClass('active');
                    $('.toolsContent [data-name=' + actionType + ']').addClass('active');
                    if (actionType === 'horizontal_left') {
                        cell_xf.alignment.horizontal = 'left';
                    } else if (actionType === 'horizontal_center') {
                        cell_xf.alignment.horizontal = 'center';
                    } else if (actionType === 'horizontal_right') {
                        cell_xf.alignment.horizontal = 'right';
                    }
                }
                else if (actionType === 'size') {
                    cell_xf.font.size = parseInt(value);
                }
                else if (actionType === 'tdMerge') {
                    if (isActive) {
                        $('.toolsContent [data-name=' + actionType + ']').removeClass('active');
                        let lie = $(this_).attr('lie');
                        let colspan = $(this_).attr('colspan');

                        let hang = $(this_).attr('hang');
                        let rowspan = $(this_).attr('rowspan');

                        ajax({
                            type: 'POST',
                            data: {
                                'function': 'mergeCancel',
                                fileId: self.fileId,
                                tableNum: self.tableNum,
                                pos: pos
                            }
                        }).then((data) => {
                            if (data !== '-1') {
                                $(this_).attr('colspan', '');
                                $(this_).attr('rowspan', '');
                                $(this_).removeClass('mergeTd');

                                let tableDom = $(this_).parents('tbody');
                                for (let i = hang; i < hang + rowspan; i++) {
                                    let hangTr = tableDom.find('tr[hang=' + i + ']');
                                    for (let j = lie; j < lie + colspan; j++) {
                                        hangTr.find('[lie=' + j + ']').show();
                                    }
                                }
                            } else {
                                alert('样式服务器同步失败');
                            }
                        });
                    } else {
                        let top = $('.editTdtop').attr('hang');
                        let bottom = $('.editTdbottom').attr('hang');
                        let left = $('.editTdleft').attr('lie');
                        let right = $('.editTdright').attr('lie');
                        ajax({
                            url: 'http://www.tablehub.cn/action/table.html',
                            type: 'POST',
                            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
                            data: {
                                'function': 'mergeAdd',
                                fileId: self.fileId,
                                tableNum: self.tableNum,
                                top: top,
                                bottom: bottom,
                                left: left,
                                right: right,
                            }
                        }).then((data) => {
                            if (data !== '-1') {
                                //全部都隐藏
                                $(this_).css('display', 'none')
                                    .removeClass('editTdtop editTdbottom editTdleft editTdright editTd mergeTd');
                                //只有第一个显示
                                $(this_).eq(0).show()
                                    .addClass('editTdtop editTdbottom editTdleft editTdright editTd mergeTd');
                                $(this_).eq(0).attr('rowspan', bottom - top + 1);
                                $(this_).eq(0).attr('colspan', right - left + 1);
                                var mergeStr = getCellTemp2(top, left) + ":" + getCellTemp2(bottom, right);
                                // tdData[self.tableNum].mergeCells[mergeStr] = mergeStr;//属性已经不存在this_.allTableDom[table_Num].mergeCells
                                $('.toolsContent [data-name=' + actionType + ']').addClass('active');
                            } else {
                                alert('样式服务器同步失败');
                            }
                        });
                    }
                    return;
                }
                run();
                console.log(cell_xf);
            },
        },
        components: {
            'user-state': userState
        },
        mounted() {
            var self = this;
//            $('#tools .toolsContent [data-name]button').click(this.rewriteStyle);
//            $('#tools .toolsContent [data-name=size]').change(this.rewriteStyle);
            $("[data-name=fill],[data-name=color]").spectrum({
                showPalette: true,
                hide: function (color) {
                    var writeTd = $('.editTd');
                    if (writeTd.length == 0) {
                        return;
                    }
                    var cell_xf = $(writeTd).attr('cell_xf');
                    var pos = getCellTemp2($(writeTd).attr('hang'), $(writeTd).attr('lie'));

                    function run(callBack) {
                        var isExist = false;//是否已经存在一个这样样式的id
                        var isExistId = -1;
                        for (var i = 0; i < getCellXfCollection.length; i++) {
                            if (JSON.stringify(getCellXfCollection[i]) == JSON.stringify(cell_xf)) {
                                isExistId = i;
                                isExist = true;
                                break;
                            }
                        }
                        $(writeTd).attr('cell_xf', 80);
                        if (isExist) {
                            if (parseInt($(writeTd).attr('cell_xf')) !== isExistId) {
                                $.post('/action/table.html', {
                                    function: 'updateTdXf',
                                    fileId: self.fileId,
                                    tableNum: self.tableNum,
                                    pos: pos,
                                    xfIndex: isExistId,
                                }, function (data) {
                                    if (data !== '-1') {
                                        $(writeTd).attr('cell_xf', data);
                                        callBack(data);
                                    } else {
                                        alert('样式服务器同步失败');
                                    }
                                });
                            }
                        }
                        else {
                            $.post('/action/table.html', {
                                function: 'updateTdXf',
                                fileId: self.fileId,
                                tableNum: self.tableNum,
                                pos: pos,
                                value: cell_xf,
                            }, function (data) {
                                let cssstr = createCss(data, cell_xf);
                                $('style[td_css_list]').append(cssstr);
                                $(writeTd).attr('cell_xf', data);
                                getCellXfCollection[data] = cell_xf;
                                callBack(data);
                            });
                        }
                    }

                    if (cell_xf === undefined) {
                        cell_xf = 0;
                    }
                    cell_xf = JSON.parse(JSON.stringify(getCellXfCollection[cell_xf]));//clone成一个新对象
                    var button = $(this);
                    if (button.is('[data-name=fill]')) {
                        console.log(cell_xf);
                        cell_xf.fill.startColor = 'FF' + color.toHexString().substr(1);
                        cell_xf.fill.fillType = 'solid';
                        run(function () {
                            console.log(button);
                            console.log(color.toHexString());
                            button.css('background-color', color.toHexString());
                        });
                    } else {
                        cell_xf.font.color = 'FF' + color.toHexString().substr(1);
                        run(function () {
                            button.css('color', color.toHexString());
                        });
                    }
                },
                palette: [
                    ["#000", "#444", "#666", "#999", "#ccc", "#eee", "#f3f3f3", "#fff"],
                    ["#f00", "#f90", "#ff0", "#0f0", "#0ff", "#00f", "#90f", "#f0f"],
                    ["#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d0e0e3", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                    ["#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                    ["#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                    ["#c00", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3d85c6", "#674ea7", "#a64d79"],
                    ["#900", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#0b5394", "#351c75", "#741b47"],
                    ["#600", "#783f04", "#7f6000", "#274e13", "#0c343d", "#073763", "#20124d", "#4c1130"]
                ]
            });
        },
        data() {
            return {
                tabState: 1,
                isOpenEdit_: this.isOpenEdit
            }
        }
    }
</script>

<style scoped lang="less">
    @font-face {
        font-family: 'iconfont';  /* project id 384848 */
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot');
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot?#iefix') format('embedded-opentype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.woff') format('woff'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.ttf') format('truetype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.svg#iconfont') format('svg');
    }

    #tools:after {
        content: '';
        clear: both;
    }

    .edit #tools {
        display: block;
    }

    #tools {
        .openEdit {
            border-bottom: 1px solid #dddddd;
            padding-bottom: 0 !important;
            margin-bottom: 5px !important;
            .editChange {
                background: url(https://n4-q.mafengwo.net/s10/M00/18/A2/wKgBZ1jc3R6AYhi_AAB-2Jyz1WU027.png);
            }
            .nav-tabs {
                display: block;
            }
        }
        .closeEdit .editChange {
            background: url(https://c2-q.mafengwo.net/s10/M00/18/1D/wKgBZ1jc3A-AKDulAABm0wptOh4037.png);
        }
        .title {
            margin-left: 10px;
            float: left;
            margin-top: 6px;
        }
        .toolsContent {
            padding: 0 5px;
            height: 34px;
            overflow: hidden;
            .tab-content {
                overflow-x: auto;
            }
            .tab-pane {
                height: 34px;
                font-family: iconfont;
            }
        }
        .container {
            background-color: #e6e6e6;
            width: 100%;
            height: 100%;
            margin: 0;
            padding: 10px;
            position: relative;
            .editChange {
                width: 55px;
                height: 20px;
                margin-top: 6px;
                background-size: 100% 100% !important;
                float: left;
            }
            .nav-tabs > li > a {
                padding: 5px 6px;
                cursor: pointer;
            }

            .nav-tabs {
                float: left;
                margin-left: 20px;
                border: none;
            }
            .user-state {
                height: 26px;
                float: right;
            }
        }

    }

    .edit #tools .toolsContent {
        display: block;
    }

    .nav-tabs {
        border-bottom: 1px solid #d4d4d4;
    }

    .tableRow td {
        height: 22px;
    }
</style>