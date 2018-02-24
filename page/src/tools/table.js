import Vue from 'vue';
import absoluteMove from '@/components/widthMove.vue';
import ajax from '@/tools/ajax.js';

var events = require('events');
var tableVueObj = Vue.extend({
    props: ['tableObj', 'edit'],
    components: {absoluteMove},
    data() {
        return {
            theadLeft: 0,
            rowTop: 0,
            alltableObj: this.tableObj.alltableObj,
            tdList: this.tableObj.tdList,
            isSelectDoms: false,
            beginSelect: [],
            lastEnterTd: [],// 用于记录最后一次触发的坐标
            poiCenter: {
                top: 2,
                bottom: 1,
                left: 2,
                right: 1,
            },// 用于记录选择区间
        };
    },
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
        scroll(event) {
            this.theadLeft = event.target.scrollLeft;
            this.rowTop = event.target.scrollTop;
            this.tableObj.events_.emit('scroll', {
                x: this.theadLeft,
                y: this.rowTop,
            });
        },
        Xmousemove(e) {
            let thNum = e.dom.parentNode.getAttribute('lienum');
            this.tableObj.dbSave.column[thNum].width = (e.x + 5) / 10;
            this.tableObj.initTdStyle();
        },
        Ymousemove(e) {
            let thNum = e.dom.parentNode.getAttribute('hang');
            this.tableObj.dbSave.row[thNum].height = e.y;
            this.tableObj.initTdStyle();
        },
        Xmouseup(e) {
            let thNum = e.dom.parentNode.getAttribute('lienum');
            let width = e.x + 5;
            ajax({
                type: 'POST',
                data: {
                    'function': 'updateWidth',
                    'fileId': this.tableObj.fileId,
                    'tableNum': this.tableObj.tableId,
                    'lienum': thNum,
                    'width': (width / 10).toFixed(1)
                }
            }).then((data) => {
                //initTdStyle(this_.tableObj.tableId);
            });
        },
        Ymouseup(e) {
            let row = e.dom.parentNode.getAttribute('hang');
            ajax({
                type: 'POST',
                data: {
                    'function': 'updateHeight',
                    'fileId': this.tableObj.fileId,
                    'tableNum': this.tableObj.tableId,
                    'row': row,
                    'height': parseInt(e.y)
                }
            }).then(() => {
                //initTdStyle(this_.tableObj.tableId);
            });
        },
        moveCharts(pos) {
            let chartsIndex = Array.from(pos.dom.parentNode.children).indexOf(pos.dom);
            if (this.alltableObj[chartsIndex].left !== pos.x || this.alltableObj[chartsIndex].top !== pos.y) {
                ajax({
                    type: 'POST',
                    data: {
                        function: 'updateChartsPos',
                        fileId: this.tableObj.fileId,
                        tableNum: this.tableObj.tableId,
                        chartsIndex: chartsIndex,
                        top: pos.y,
                        left: pos.x,
                        width: this.alltableObj[chartsIndex].width,
                        height: this.alltableObj[chartsIndex].height,
                    }
                }).then((data) => {
                    this.alltableObj[chartsIndex].left = pos.x;
                    this.alltableObj[chartsIndex].top = pos.y;
                    //initTdStyle(this_.tableObj.tableId);
                });
            }
        },
        mousedown_temp(hang, lie) {
            if (this.edit) {
                this.beginSelect = [hang, lie];
                this.isSelectDoms = true;
                event.preventDefault();
            }
        },
        mouseenter_temp(hang, lie) {
            if (this.isSelectDoms) {
                // 防止重复出发
                if (this.lastEnterTd[0] === hang && this.lastEnterTd[1] === lie) {
                    return;
                }
                this.lastEnterTd = [hang, lie];
                var top = Math.min(hang, this.beginSelect[0]);
                var bottom = Math.max(hang, this.beginSelect[0]);
                var left = Math.min(lie, this.beginSelect[1]);
                var right = Math.max(lie, this.beginSelect[1]);
                this.poiCenter = {
                    top: top,
                    bottom: bottom,
                    left: left,
                    right: right
                };
                this.tableObj.events_.emit('tdSelect', {
                    pos: getCellTemp2(hang, lie),
                    xf: this.selectTd(),
                    selectMergeState: 'up',
                });
            }
        },
        setSelectClass(i, j) {
            var inCenter = i >= this.poiCenter.top && i <= this.poiCenter.bottom && j >= this.poiCenter.left && j <= this.poiCenter.right;
            let isHasMerge = false;
            for (let cell in this.tableObj.mergeCells) {
                if (cell.split(':')[0] === getCellTemp2(i, j)) {
                    isHasMerge = true;
                    break;
                }
            }
            return {
                mergeTd: isHasMerge,
                editTd: inCenter,
                editTdtop: inCenter && i === this.poiCenter.top,
                editTdbottom: inCenter && i === this.poiCenter.bottom,
                editTdleft: inCenter && j === this.poiCenter.left,
                editTdright: inCenter && j === this.poiCenter.right,
            };
        },
        mouseup_temp() {
            this.isSelectDoms = false;
        },
        selectTd(cellXf_) {
            var cellXfInfo = {
                font: {},
                alignment: {},
                fill: {},
            };
            if (cellXf_ === undefined) {
                cellXfInfo.font.color = '';
                cellXfInfo.font.bold = false;
                cellXfInfo.font.underline = false;
                cellXfInfo.font.size = '';
                cellXfInfo.font.italic = false;
                cellXfInfo.alignment.horizontal = 'general';
                cellXfInfo.fill.startColor = 'while';
            } else {
                var cell_xf = getCellXfCollection[cellXf_];
                if (cell_xf.font) {
                    if (cell_xf.font.color) {
                        cellXfInfo.font.color = '#' + cell_xf.font.color.slice(2);
                    }
                    cellXfInfo.font.bold = (cell_xf.font.bold === 1 ? 1 : 0);
                    if (cell_xf.font.size) {
                        cellXfInfo.font.size = cell_xf.font.size;
                    }
                    if (cell_xf.font.underline === 'single') {
                        cellXfInfo.font.underline = cell_xf.font.underline;
                    } else {
                        cellXfInfo.font.underline = 'none';
                    }
                    cellXfInfo.font.italic = cell_xf.font.italic === 1 ? 1 : 0;
                    cellXfInfo.font.size = cell_xf.font.size;
                }
                if (cell_xf.fill && cell_xf.fill.fillType !== 'none') {
                    cellXfInfo.fill.startColor = '#' + cell_xf.fill.startColor.slice(2);
                }
                else {
                    cellXfInfo.fill.startColor = 'white';
                }

                if (cell_xf.alignment) {
                    if (cell_xf.alignment.horizontal === 'left') {
                        cellXfInfo.alignment.horizontal = 'left';
                    } else if (cell_xf.alignment.horizontal === 'center') {
                        cellXfInfo.alignment.horizontal = 'center';
                    } else if (cell_xf.alignment.horizontal === 'right') {
                        cellXfInfo.alignment.horizontal = 'right';
                    } else if (cell_xf.alignment.horizontal === 'general') {
                        cellXfInfo.alignment.horizontal = 'general';
                    }
                } else {
                    cellXfInfo.alignment.horizontal = 'general';
                }
            }
            return cellXfInfo;
        },

        isDoubleClick: false,
        selectTd_temp(hang, lie) {
            this.isDoubleClick = true;
            if (this.isDoubleClick === true) {
                this.poiCenter = {
                    top: hang,
                    bottom: hang,
                    left: lie,
                    right: lie
                };
                var td = this.tableObj.tdList[hang - 1][lie - 1];
                if (td !== undefined) {
                    let isHasMerge = false;// 选择的td是不是merge的td
                    for (let cell in this.tableObj.mergeCells) {
                        if (cell.split(':')[0] === getCellTemp2(hang, lie)) {
                            isHasMerge = true;
                            break;
                        }
                    }
                    if (isHasMerge) {
                        this.tableObj.events_.emit('tdSelect', {
                            pos: getCellTemp2(hang, lie),
                            xf: this.selectTd(td.xfIndex),
                            selectMergeState: 'down'
                        });
                    } else {
                        this.tableObj.events_.emit('tdSelect', {
                            pos: getCellTemp2(hang, lie),
                            xf: this.selectTd(td.xfIndex),
                            selectMergeState: 'disable'
                        });
                    }
                } else {
                    this.tableObj.events_.emit('tdSelect', {
                        pos: getCellTemp2(hang, lie),
                        xf: this.selectTd(),
                        selectMergeState: 'disable'
                    });
                }
            }
        },
        dbselectTd_temp(hang, lie) {
            this.isDoubleClick = false;
            this.tableObj.events_.emit('dblclick', getCellTemp2(hang, lie));
            this.poiCenter = {
                top: 0,
                bottom: 0,
                left: 0,
                right: 0
            };
        }
    },
    template: `<div>
    <div class="tableThead">
        <table class="table" :style="{marginLeft:theadLeft*-1+'px'}">
        <thead>
            <tr>
                <th v-for="i in tableObj.lie" class="lieNum"
                    :lienum="getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]">{{getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]}}
                    <absolute-move @mousemove="Xmousemove" @mouseup="Xmouseup" move="x"></absolute-move>
                </th>
            </tr>
        </thead></table>
    </div>
    <div class="tableRow">
        <table class="table" :style="{marginTop:rowTop*-1+'px'}">
        <tbody>
            <tr v-for="i in tableObj.hang">
                <td class="idNum" :hang="i" style="width: 80px;">{{i}}
                    <absolute-move @mousemove="Ymousemove" @mouseup="Ymouseup" move="y"></absolute-move>
                </td>
            </tr>
        </tbody>
        </table>
    </div>
    <div class="tableBody" @scroll="scroll($event)">
        <div class="allCharts" ref="allCharts">
            <absolute-move
                :key="key"
                :move="edit?'both':'none'"
                @mouseup="moveCharts"
                v-for="item,key in this.alltableObj"
                :left="item.left"
                :top="item.top"></absolute-move>
        </div>
        <table class="table">
            <thead>
                <tr>
                    <th v-for="i in tableObj.lie" class="lienum"
                        :lienum="getCellTemp2(0, i).match(/([A-Z]*)(\\d+)/)[1]"></th>
                </tr>
            </thead>
            <tbody ref="tableBody">
                <tr v-for="i in tableObj.hang" :hang="i">
                    <td v-for="j in tableObj.lie"
                        @click.stop="selectTd_temp(i,j)"
                        @dblclick.stop="dbselectTd_temp(i,j)"
                        :key="i+','+j"
                        :hang="i"
                        :lie="j" 
                        :class="setSelectClass(i,j)" 
                        @mousedown="mousedown_temp(i,j)" 
                        @mouseover="mouseenter_temp(i,j)" 
                        @mouseup="mouseup_temp"></td>
                </tr>
            </tbody>
        </table>
    </div>
</div>`,
    watch: {
        alltableObj(value) {
            let domArr = Array.from(this.$refs.allCharts.children);
            setTimeout(() => {
                for (let i = 0; i < value.length; i++) {
                    let item = value[i];
                    if (!domArr.includes(item.dom[0].parentNode)) {
                        this.$refs.allCharts.getElementsByClassName('move')[i].append(item.dom[0]);
                        item.render();
                    }
                }
            }, 100);
        }
    },
    mounted() {
        this.tableObj.dom = this.$el;
        this.tableObj.vueObj = this;
        setTimeout(() => {
            for (let i = 0; i < this.alltableObj.length; i++) {
                let chartsItem = this.alltableObj[i];
                this.$refs.allCharts.getElementsByClassName('move')[i].append(chartsItem.dom[0]);
                chartsItem.render();
            }
        }, 100);
    },
});

//表
export default function (tableId, dbSave, hang, lie) {
    this.fileId = parseInt(window.location.href.match(/\/table\/(\d+)\.html/)[1]);
    this.tdList = [];
    this.mergeCells = dbSave.mergeCells;
    //事件监听
    this.events_ = new events.EventEmitter();
    this.addListener = function (eventName, callBack) {
        this.events_.addListener(eventName, callBack);
    };
    this.dom = document.createElement('div');
    this.active = function (val) {
        if (val === false) {
            this._vueDom.$el.setAttribute('class', 'tab-pane fade');
            this._vueDom.poiCenter = {
                top: 2,
                bottom: 1,
                left: 2,
                right: 1,
            };
        } else {
            this._vueDom.$el.setAttribute('class', 'tab-pane fade active in');
        }
    };
    this.tableId = tableId;
    this.dbSave = dbSave;
    this.hang = hang;
    this.lie = lie;
    this.addMoreHang = 3;//编辑状态下额外添加的行的数量
    this.alltableObj = [];//保存图表charts
    this.addHang = function () {
        for (let i = 0; i < this.addMoreHang; i++) {
            this.hang++;
        }
    };
    this.cssNod = document.createElement('style');
    (function () {
        this.cssNod.id = 'tdWidthHeight';
        this.cssNod.type = 'text/css';
        this.cssNod.setAttribute('td_css_list', 1);
        document.getElementsByTagName('head')[0].appendChild(this.cssNod);
    }).call(this);
    this.render = function (cssStr) {
    };
    this.initTdStyle = function () {
        var column = this.dbSave.column;
        var row = this.dbSave.row;
        //单元格列宽
        let str = '';
        for (let i in column) {
            let thNum = getCellTemp(i + '1')[1];
            let strItem = '#myTabContent>.tab-pane:nth-child(' + (this.tableId + 1) + ') [lie="' + thNum + '"],#myTabContent>.tab-pane:nth-child(' + (this.tableId + 1) + ') [lienum="' + i + '"]{\n';
            strItem += 'width:' + column[i].width * 10 + 'px;\n';
            strItem += '}\n';
            str += strItem;
        }
        for (let i in row) {
            let strItem = '#myTabContent>.tab-pane:nth-child(' + (this.tableId + 1) + ') [hang="' + i + '"],#myTabContent>.tab-pane:nth-child(' + (this.tableId + 1) + ') [hang="' + i + '"]{\n';
            strItem += 'height:' + (row[i].height) + 'px;\n';
            strItem += '}\n';
            str += strItem;
        }
        if (this.cssNod.styleSheet) { //ie下
            this.cssNod.styleSheet.cssText = str;
        } else {
            this.cssNod.innerHTML += str;
        }
    };
    this.findChild = function (positionStr) {
        var position = getCellTemp(positionStr);
        var hang = Math.max(position[0] - 1, 0);
        var lie = position[1] - 1;
        if (this.tdList[hang] === undefined) {
            this.tdList[hang] = [];
        }
        if (this.tdList[hang][lie] === undefined) {
            //新建td
            var newTd = new td(this, positionStr);
            this.tdList[hang][lie] = newTd;
            this.vueObj.$refs.tableBody.children[hang].children[lie].append(newTd.dom);
            return newTd;
        }
        return this.tdList[hang][lie];
    };
    this._vueDom = new tableVueObj({
        propsData: {
            tableObj: this,
            edit: true,
        }
    });
    this._vueDom.$mount(this.dom);
    this._vueDom.$el.setAttribute('id', 'table_' + tableId);
    this._vueDom.$el.setAttribute('class', 'tab-pane fade' + (tableId == 0 ? ' active in' : ''));

}