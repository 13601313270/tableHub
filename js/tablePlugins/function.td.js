//td

function tdValueList(value) {
    this.value_ = value;
    this.bindEvent = [];
    this.listening = [];
}

tdValueList.prototype = new obj('tdValueList');

function td(table, positionStr) {
    var tableId = table.tableId;
    this.tableId = tableId;
    this.bindEvent = [];
    this.listening = [];
    this.state = 0;//0正常,1锁定
    if (positionStr === '=') {
        positionStr = 'A1';
    }
    this.value_ = '';
    this.tdName = positionStr;//字符串名称入(B1)
    var tdPos = getCellTemp(positionStr);
    this.table = table;
    this.hang = tdPos[0];
    this.lie = tdPos[1];
    this.xfIndex = 0;
    this.dom = document.createElement("div");
    this.dom.className = "tdInsertDiv";
    this.getNearFenshu = function (num, wei) {
        var numList = num.toString().split('.');
        num = '0.' + numList[1];
        var nearHalf = [0, 1];

        var weishuEnd = 10;
        if (wei === 2) {
            weishuEnd = 100;
        } else if (wei === 3) {
            weishuEnd = 1000;
        }
        for (var fenmu = 1; fenmu < weishuEnd; fenmu++) {
            var begin = 1;
            var end = fenmu - 1;
            var half = 0;
            while (true) {
                half = begin + parseInt((end - begin) / 2);
                if (half / fenmu === num) {
                    begin = half;
                    end = half;
                    break;
                }
                if (half / fenmu > num) {
                    end = half;
                } else {
                    begin = half;
                }
                if (end - begin <= 1) {
                    break;
                }
            }
            if (half / fenmu === num) {
                nearHalf = [half, fenmu];
                break;
            }
            if (begin / fenmu === num) {
                nearHalf = [begin, fenmu];
                break;
            }
            if (end / fenmu === num) {
                nearHalf = [end, fenmu];
                break;
            }
            if (wei === 1 || (wei === 2 && fenmu >= 10) || (wei === 3 && fenmu >= 100)) {
                if (Math.abs(end / fenmu - num) < Math.abs(nearHalf[0] / nearHalf[1] - num)) {
                    nearHalf = [end, fenmu];
                }
            }
        }
        nearHalf[0] = parseInt(nearHalf[0]) + numList[0] * nearHalf[1];
        return nearHalf;
    };
    this.formatCode_ = function (value, code) {
        var returnHtml = '';
        //console.log(value);
        if (code.match(/[^*|\\|_]%/) !== null && value.toString().match(/^-?\d+(\.\d+)?$/)) {
            value = (value * 100).toString();
        }
        value = value.toString();
        var oldValue = value;

        //自定义格式中整数部分数字占位符个数
        var codeZhengshuNumCount = 0;
        //自定义格式中小数部分占位符个数
        var codeXiaoshuNumCount = 0;
        //.match(/\.(([#|0](\\\.|[^#|0|\.])*)+)/)[1]
        var runCodeZhengshuNumCount = 0;//
        if (code.match(/(([#|0|\?](\\\.|[^#|0|\.])*)+)\.?/) !== null) {
            codeZhengshuNumCount = code.replace(/[*|\\|_]{2}/g, '').replace(/[*|\\|_]([#|0|\?])/g, '').match(/(([#|0](\\\.|[^#|0|\.])*)+)\.?/)[1].match(/([#|0][^#|0]*)/g).length;
        }
        if (code.match(/\.(([#|0](\\\.|[^#|0|\.])*)+)/) !== null) {
            codeXiaoshuNumCount = code.replace(/[*|\\|_]{2}/g, '').replace(/[*|\\|_]([#|0|\?])/g, '').match(/\.(([#|0](\\\.|[^#|0|\.])*)+)/)[1].match(/([#|0][^#|0]*)/g).length;
        }
        var isQianfenwei = false;//是否千分位
        if (code.match(/[^*|\\|_],/) !== null) {
            isQianfenwei = true;
        }
        //是否是分数表达式
        var isFenShuwei = false;//是否是分数
        if (code.replace(/[*|\\|_]{2}/g, '').replace(/[*|\\|_]([#|0|\?])/g, '').match(/(.*[^*|\\|_])\/[^\d|#|0|\?]*?([\d|#|0|\?]+)/) !== null) {   //如果是分数表达式
            var tempFenshuMatch = code.replace(/[*|\\|_]{2}/g, '').replace(/[*|\\|_]([#|0|\?])/g, '').match(/(.*[^*|\\|_])\/[^\d|#|0|\?]*?([\d|#|0|\?]+)/);
            var isHasZhengshu = tempFenshuMatch[1].match(/([#|0\?]+[^#|0\?]*)/g);
            var fenmu = tempFenshuMatch[2];
            if (isHasZhengshu.length >= 2) {
                isFenShuwei = true;
            }
            if (fenmu == '?') {
                var temp = this.getNearFenshu(value, 1);
                fenmu = temp[1];
            } else if (fenmu == '??') {
                var temp = this.getNearFenshu(value, 2);
                fenmu = temp[1];
            } else if (fenmu == '???') {
                var temp = this.getNearFenshu(value, 3);
                fenmu = temp[1];
            } else {

            }

            var runValue = parseInt((parseInt(value * fenmu * 2) + 1) / 2).toString();
            if (isHasZhengshu.length >= 2) {
                value = [parseInt(runValue / fenmu).toString(), (runValue % fenmu).toString()];
            }

            if (isHasZhengshu.length >= 2) {
                codeZhengshuNumCount = isHasZhengshu[0].match(/([#|0\?])[^#|0\?]*/g).length;
                codeXiaoshuNumCount = isHasZhengshu[1].match(/([#|0\?])[^#|0\?]*/g).length;
            } else {
                value = [runValue];
            }
        } else {
            value = value.split('.');
        }
        value[0] = Math.abs(value[0]).toString();
        var temp = '';
        var returnValue = ['', '', ''];
        while (code.length > 0) {
            temp = code[0];
            if (temp == '_') {
                returnHtml += '<span style="opacity: 0">' + code[1] + '</span>';
                //returnHtml+='<span>'+code[1]+'</span>';
                code = code.slice(2);
            } else if (temp == '*') {
                //returnHtml+='<span>'+code[1]+'</span>';
                returnValue[0] = returnHtml;
                if (code[1] !== '=') {
                    for (var i = 0; i < 30; i++) {
                        returnValue[1] += '<span>' + code[1] + '</span>';
                    }
                }
                returnHtml = '';
                code = code.slice(2);
            } else if (temp == '[') {
                if (code.match(/^\[\$(\S)-804\]/)) {
                    var findStr = code.match(/^\[\$(\S)-804\]/)[1];
                    code = code.replace(/^\[\$\S-804\]/, '');
                    returnHtml += findStr;
                } else {
                }
            }
            else if (temp == '#' || temp == '0' || temp == '?') {
                if (code.match(/^([#|0]+)\.([#|0]+)E\+([#|0]+)/)) {
                    var match = code.match(/^([#|0]+)\.([#|0]+)E\+([#|0]+)/);
                    var match1Length = match[1].length;
                    var match2Length = match[2].length;
                    var match3Length = match[3].length;

                    var firstWeishu = value[0].length;//整数位数
                    var chengshu = 0;
                    if (value.length > 1) { //有小数部分
                        if (value[0] == 0) {    //数字是小于1的
                            value[0] = '';
                            var ppp = 0;
                            while (ppp++ < 100) {
                                if (value[1][0] != '0') {
                                    value[0] += value[1][0];
                                }
                                value[1] = value[1].slice(1);
                                chengshu--;
                                if (value[1].length == 0) {
                                    //if(value[0]=='0'){
                                    value = [value[0]];
                                    firstWeishu = value[0].length;
                                    break;
                                }
                            }
                            //小于1的,表达式整数无论多少位,只进步到一位有效数字,在excel尝试得到,不知道原因
                            if (match1Length > 1) {
                                for (var i = 0; i < match1Length - 1; i++) {
                                    returnHtml += '0';
                                }
                            }
                            match1Length = 1;
                        } else {
                            value = [value[0] + value[1]];
                        }
                    } else {

                    }
                    returnHtml += value[0].toString().slice(0, match1Length) + '.';//整数位
                    //小数部分
                    var xiaoshuValue = '';
                    for (var i = match2Length + match1Length; i >= match1Length + 1; i--) {
                        if (code[i] == '#' && xiaoshuValue == '' && value[0][i - 1] == '0') {
                        } else if (value[0][i - 1] !== undefined) {
                            xiaoshuValue = value[0][i - 1] + xiaoshuValue;
                        } else if (code[i] == '0') {
                            xiaoshuValue = '0' + xiaoshuValue;
                        }
                    }
                    returnHtml += xiaoshuValue + 'E';
                    returnHtml += firstWeishu > match1Length - chengshu ? '+' : '-';
                    //指数部分
                    var valueTemp = Math.abs(firstWeishu - match1Length + chengshu);
                    if (valueTemp.toString().length < match3Length) {
                        for (var i = 0; i < match3Length - valueTemp.toString().length; i++) {
                            returnHtml += '0';
                        }
                    }
                    returnHtml += valueTemp;
                    code = code.replace(/^([#|0]+)\.([#|0]+)E\+([#|0]+)/, '');
                }
                else {
                    if (runCodeZhengshuNumCount == 0 && codeZhengshuNumCount < value[0].length) {
                        //虽然code的位数不够,则都显示
                        for (var i = 0; i < value[0].length - codeZhengshuNumCount + 1; i++) {
                            returnHtml += value[0][i];
                            if (isQianfenwei && (value[0].length - i) % 3 == 1) {
                                returnHtml += ',';
                            }
                        }
                    } else if (runCodeZhengshuNumCount >= codeZhengshuNumCount) { //进入小数区间,或者分数区间
                        if (isFenShuwei == true) {
                            if (runCodeZhengshuNumCount > codeZhengshuNumCount + codeXiaoshuNumCount - 1) {//进入分母区间了
                                if (fenmu.toString()[runCodeZhengshuNumCount - codeZhengshuNumCount - codeXiaoshuNumCount]) {
                                    returnHtml += fenmu.toString()[runCodeZhengshuNumCount - codeZhengshuNumCount - codeXiaoshuNumCount];
                                } else if (temp == '0') {
                                    returnHtml += '0';
                                } else if (temp == '?') {
                                    returnHtml += '&nbsp;';
                                }

                            } else {
                                if (value.length == 2 && runCodeZhengshuNumCount - codeZhengshuNumCount > codeXiaoshuNumCount - value[1].length - 1) {
                                    returnHtml += value[1][value[1].length - codeXiaoshuNumCount + runCodeZhengshuNumCount - codeZhengshuNumCount];
                                } else if (temp == '0') {
                                    returnHtml += '0';
                                } else if (temp == '?') {
                                    returnHtml += '&nbsp;';
                                }
                            }
                        } else {
                            //真实数字精度大于格式小数精度,则进行四舍五入
                            if (runCodeZhengshuNumCount == codeZhengshuNumCount && value.length == 2 && value[1].length > codeXiaoshuNumCount) {
                                value[1] = parseFloat('0.' + value[1]).toFixed(codeXiaoshuNumCount).split('.')[1];
                            }
                            if (value.length == 2 && value[1].length >= runCodeZhengshuNumCount - codeZhengshuNumCount + 1) {
                                returnHtml += value[1][runCodeZhengshuNumCount - codeZhengshuNumCount];
                            } else if (temp == '0') {
                                returnHtml += '0';
                            }
                        }
                    } else if (codeZhengshuNumCount - runCodeZhengshuNumCount <= value[0].length) {
                        if (isFenShuwei && value[0] == '0') {
                            if (temp == '0') {
                                returnHtml += '0';
                            }
                        } else {
                            returnHtml += value[0][value[0].length + runCodeZhengshuNumCount - codeZhengshuNumCount];
                            if (isQianfenwei && (codeZhengshuNumCount - runCodeZhengshuNumCount) % 3 == 1 && codeZhengshuNumCount - runCodeZhengshuNumCount !== 1) {
                                returnHtml += ',';
                            }
                        }
                    } else {
                        if (temp == '0') {
                            returnHtml += '0';
                        }
                    }
                    code = code.slice(1);
                    runCodeZhengshuNumCount++;
                }
            } else if (temp == '@') {
                returnHtml += oldValue;
                code = code.slice(1);
            } else if (temp == '"') {
                var findStr = code.match(/^"([^"]*)"/);
                returnHtml += findStr[1];
                code = code.replace(/^"([^"]*)"/, '');
            } else if (temp == '\\') {
                returnHtml += code[1];
                code = code.slice(2);
            } else if (temp == ',') {
                code = code.slice(1);
            }
            else {
                returnHtml += temp;
                code = code.slice(1);
            }
        }
        returnValue[2] = returnHtml;//value.join('.');
        return returnValue;
    };
    this.formatCode = function (value) {
        var xfIndex = this.xfIndex;
        if (xfIndex == undefined || getCellXfCollection[xfIndex] == undefined) {
            return ['', value, ''];
        }
        if (getCellXfCollection[xfIndex].numberFormat == undefined) {
            return ['', value, ''];
        }
        var formatCode = getCellXfCollection[xfIndex].numberFormat.formatCode;
        if (formatCode == 'General') {
            return ['', value, ''];
        } else {
            formatCode = formatCode.split(';');
            if (formatCode.length == 4) {
                //正;负;零;文本
                if (typeof value == 'number') {
                    if (value > 0) {
                        value = this.formatCode_(value, formatCode[0]);
                    } else if (value < 0) {
                        value = this.formatCode_(value, formatCode[1]);
                    } else {
                        value = this.formatCode_(value, formatCode[2]);
                    }
                } else {
                    value = this.formatCode_(value, formatCode[3]);
                }
            } else if (formatCode.length == 3) {
                if (typeof value == 'number') {
                    if (value > 0) {
                        value = this.formatCode_(value, formatCode[0]);
                    } else if (value < 0) {
                        value = this.formatCode_(value, formatCode[1]);
                    } else {
                        value = this.formatCode_(value, formatCode[2]);
                    }
                } else {
                    value = ['', '', ''];
                }
                //正;负;零
            } else if (formatCode.length == 2) {
                if (typeof value == 'number' && value < 0) {
                    value = this.formatCode_(value, formatCode[1]);
                } else {
                    value = this.formatCode_(value, formatCode[0]);
                }
                //非负数;负数
            } else {
                value = this.formatCode_(value, formatCode[0]);
                //所有值
            }
            //console.log(formatCode);
            return value;
        }
    };
    this.render = function () {
        if (this.value_ instanceof obj && this.value_.dom) {
            var dom = this.value_.dom;
            if (!(dom instanceof Element)) {
                dom = dom[0];
            }
            var compareDom = dom.parentNode;
            if (compareDom !== this.dom) {
                //this.dom.html('');//清空再赋值,会造成新增加的元素,绑定的事件都没了

                this.dom.innerHTML = this.value_.get();
                //这块改乱了，后面清楚的时候再改，好像是输入控件的那部分
                // if (dom.tagName === 'TD') {
                //     this.dom.innerHTML = this.value_.get();
                // } else {
                //     this.dom.append(dom);
                // }
            }
        } else {
            var getValue_ = this.get();
            var getValue = getValue_;
            if (getValue_ instanceof tdValueList) {
                getValue = getValue_.get();
            }
            if (getValue instanceof Array) {
                for (let i = 0; i < getValue.length; i++) {
                    for (let j = 0; j < getValue[i].length; j++) {
                        if (i === 0 && j === 0) {
                            var valueArr = this.formatCode(getValue[i][j]);
                            var insertHtml = '<div>' + valueArr[0] + '</div>' +
                                '<div>' + valueArr[1] + '</div>' +
                                '<div>' + valueArr[2] + '</div>';
                            this.dom.innerHtml = insertHtml;
                        } else {
                            var tdPos = getCellTemp2(this.hang + i, this.lie + j);
                            if (this.table.child(tdPos) === undefined) {
                                var tdTemp = new td(this.table, tdPos);
                            } else {
                                var tdTemp = this.table.child(tdPos);
                            }
                            if (getValue_ instanceof tdValueList) {
                                this.bind(tdTemp);
                            }
                            tdTemp.set(getValue[i][j]);
                        }
                    }
                }
            } else {
                var valueArr = this.formatCode(getValue);
                var insertHtml = '<div>' + valueArr[0] + '</div>' +
                    '<div>' + valueArr[1] + '</div>' +
                    '<div>' + valueArr[2] + '</div>';
                this.dom.innerHTML = insertHtml;
            }
        }
        if (this.xfIndex) {
            this.dom.setAttribute('cell_xf', this.xfIndex);
        } else {
            this.dom.removeAttribute('cell_xf');
        }
        td.prototype.render.call(this);
    }
    this.css = function (callFunc, style) {
        this.cssCallFunction = callFunc;
        this.cssStyle = style;
    };
    this.set = function (value) {
        if (typeof value === 'string') {
            if (value.match(/^\d+$/) !== null) {
                value = parseInt(value);
            } else if (value.match(/^\d+\.\d+$/) !== null) {
                value = parseFloat(value);
            }
        }
        if (value instanceof Array) {
            var insertHang = this.hang;
            var insertLie = this.lie;
            for (let i = 0; i < value.length; i++) {
                for (let j = 0; j < value[i].length; j++) {
                    this.table.td(insertHang + i, insertLie + j).value(value[i][j]);
                }
            }
        } else {
            return td.prototype.set.call(this, value);
        }
    };
    this.get = function () {
        return td.prototype.get.call(this);
    };
    this.lock = function () {
        if (this.value_ instanceof obj && this.value_.dom) {
        } else {
            this.dom.innerHTML = '';
        }
        td.prototype.lock.call(this);
    };
}

td.prototype = new obj('td');

//一组td
function tdList(begin, end) {
    this.begin = begin;
    this.end = end;
    this.bindEvent = [];
    this.listening = [];
    this.state = 0;//0正常,1锁定
    //以行为一级的二维数组
    this.getHangList = function () {
        let returnList = [];
        for (let i = this.begin.hang; i <= this.end.hang; i++) {
            returnList[i - this.begin.hang] = [];
            for (let j = this.begin.lie; j <= this.end.lie; j++) {
                if (this.begin.table.findChild(getCellTemp2(i, j)) !== undefined) {
                    returnList[i - this.begin.hang].push(this.begin.table.findChild(getCellTemp2(i, j)).get());
                }
            }
        }
        return returnList;
    };
    //以列为一级的二维数组
    this.getLieList = function () {
        let returnList = [];
        for (let j = this.begin.lie; j <= this.end.lie; j++) {
            returnList[j - this.begin.lie] = [];
            for (let i = this.begin.hang; i <= this.end.hang; i++) {
                if (this.begin.table.findChild(getCellTemp2(i, j)) !== undefined) {
                    returnList[j - this.begin.lie].push(this.begin.table.findChild(getCellTemp2(i, j)).get());
                }
            }
        }
        return returnList;
    };
    this.get = function () {
        let returnList = [];
        for (let i = this.begin.hang; i <= this.end.hang; i++) {
            for (let j = this.begin.lie; j <= this.end.lie; j++) {
                if (this.begin.table.findChild(getCellTemp2(i, j)) !== undefined) {
                    returnList.push(this.begin.table.findChild(getCellTemp2(i, j)).get());
                } else {
                    returnList.push('');
                }
            }
        }
        return returnList;
    };
}

tdList.prototype = new obj('tdList');
functionInit(tdList, '表格项', {
    params: {
        begin: {
            title: '开始',
            dataType: 'string',
            default: '',
        },
        end: {
            title: '结束',
            dataType: 'string',
            default: '',
        }
    },
    save: function (obj) {
        return [obj.begin, obj.end];
    }
});