import Vue from 'vue'
import absoluteMove from '@/components/widthMove.vue';
import ajax from '@/tools/ajax.js';

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
            poiCenter: {
                top: 2,
                bottom: 4,
                left: 1,
                right: 3,
            },//用于记录选择区间
            lastEnterTd: [],//用于记录最后一次触发的坐标
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
                //initTdStyle(this_.tableNum);
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
                //initTdStyle(this_.tableNum);
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
                    //initTdStyle(this_.tableNum);
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
            // console.log(hang);
            this.lastEnterTd = [hang, lie];
            if (this.isSelectDoms) {
                // 防止重复出发
                // if (this.lastEnterTd[0] === hang && this.lastEnterTd[1] === lie) {
                //     return;
                // }
                this.lastEnterTd = [hang, lie];


                $('body .edit td').removeClass('editTd');
                $('body .edit td').removeClass('editTdtop');
                $('body .edit td').removeClass('editTdbottom');
                $('body .edit td').removeClass('editTdleft');
                $('body .edit td').removeClass('editTdright');
                var top = Math.min(hang, this.beginSelect[0]);
                var bottom = Math.max(hang, this.beginSelect[0]);
                var left = Math.min(lie, this.beginSelect[1]);
                var right = Math.max(lie, this.beginSelect[1]);
                this.poiCenter.top = top;
                this.poiCenter.bottom = bottom;
                this.poiCenter.left = left;
                this.poiCenter.right = right;
                console.log(this.poiCenter.top, this.poiCenter.bottom, this.poiCenter.left, this.poiCenter.right);
                for (let i = top; i <= bottom; i++) {
                    for (let j = left; j <= right; j++) {
                        this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className = '';
                        if (i === top) {
                            // console.log(this.tableObj);
                            // console.log(this.tableObj.findChild(getCellTemp2(i, j)));
                            // console.log(this.tableObj.findChild(getCellTemp2(i, j)).dom);
                            this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className = 'editTdtop';
                        }
                        if (i === bottom) {
                            this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className += ' editTdbottom';
                        }
                        if (j === left) {
                            this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className += ' editTdleft';
                        }
                        if (j === right) {
                            this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className += ' editTdright';
                        }
                        this.tableObj.findChild(getCellTemp2(i, j)).dom.parentNode.className += ' editTd';
                    }
                }
                // this.selectTd(undefined);
                // selectTd2(window, this.tableNum);
            }
        },
        mouseup_temp() {
            this.isSelectDoms = false;
        },
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
        <div class="floatSingleValueWrite">
            <div class="input">
                <input/>
            </div>
            <div class="span"></div>
        </div>
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
                        :key="i+','+j"
                        :hang="i"
                        :lie="j" 
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
                        // console.log(this.$refs.allCharts.getElementsByClassName('move'));
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
    this.dom = document.createElement("div");
    this.active = function (val) {
        if (val === false) {
            this._vueDom.$el.setAttribute('class', 'tab-pane fade');
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
    this.cssNod = document.createElement("style");
    (function () {
        this.cssNod.id = "tdWidthHeight";
        this.cssNod.type = "text/css";
        $(this.cssNod).attr('td_css_list', 1);
        document.getElementsByTagName("head")[0].appendChild(this.cssNod);
    }).call(this);
    this.render = function (cssStr) {
    };
    this.initTdStyle = function () {
        var column = this.dbSave.column;
        var row = this.dbSave.row;
        //单元格列宽
        let str = "";
        for (let i in column) {
            let thNum = getCellTemp(i + '1')[1];
            let strItem = "#myTabContent>.tab-pane:nth-child(" + (this.tableId + 1) + ") [lie=\"" + thNum + "\"],#myTabContent>.tab-pane:nth-child(" + (this.tableId + 1) + ") [lienum=\"" + i + "\"]{\n";
            strItem += 'width:' + column[i].width * 10 + 'px;\n';
            strItem += "}\n";
            str += strItem;
        }
        for (let i in row) {
            let strItem = "#myTabContent>.tab-pane:nth-child(" + (this.tableId + 1) + ") [hang=\"" + i + "\"],#myTabContent>.tab-pane:nth-child(" + (this.tableId + 1) + ") [hang=\"" + i + "\"]{\n";
            strItem += 'height:' + (row[i].height) + 'px;\n';
            strItem += "}\n";
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
        if (this.tdList[position[0] - 1] === undefined) {
            this.tdList[position[0] - 1] = [];
        }
        if (this.tdList[position[0] - 1][position[1] - 1] === undefined) {
            //新建td
            var newTd = new td(this, positionStr);
            this.tdList[position[0] - 1][position[1] - 1] = newTd;
            this.vueObj.$refs.tableBody.children[position[0] - 1].children[position[1] - 1].append(newTd.dom);
            return newTd;
        }
        return this.tdList[position[0] - 1][position[1] - 1];
    }
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