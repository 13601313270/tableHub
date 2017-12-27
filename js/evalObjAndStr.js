//函数调用对象
//runObj执行这个方法的对象
function __runObj__(runObj, funcName, params) {
    this.runObj = runObj;
    this.bindEvent = [];
    this.listening = [];
    this.state = 0;//0正常,1锁定
    //如果是函数调用,则有函数名
    this.funcName = funcName;
    this.params = params;
    this.get = function () {
        //取值
        var runParams = [];
        for (var i = 0; i < this.params.length; i++) {
            var insert = this.params[i];
            if (insert instanceof obj) {
                insert = insert.get();
                if (typeof insert == 'string') {
                    insert = '"' + insert + '"';
                }
            }
            if (insert instanceof tdValueList) {
                insert = insert.get();
                if (insert.length == 0) {
                    insert = '';
                } else {
                    insert = insert[0][0];
                }
                if (typeof insert == 'string') {
                    insert = '"' + insert + '"';
                }
            }
            if (this.funcName) {
                runParams.push(insert);
            } else {
                runParams.push(insert);
            }
        }
        if (this.funcName) {
            if (this.runObj == window) {
                return window[this.funcName].apply(window, runParams);
            } else {
                var temp = this.runObj.get();
                try {
                    return temp[this.funcName].apply(temp, runParams);
                } catch (e) {
                    return '';
                }

            }
        } else {
            try {
                console.log(runParams);
                return eval(runParams.join(''));
            } catch (e) {
                return '';
            }
        }
    };
}

__runObj__.prototype = new obj('__runObj__');
__runObj__.config = {
    save: function (obj) {
        return obj.params;
    },
    load: function () {

    }
};

//单元格坐标转换
function getCellTemp(str) {
    try {
        str = str.match(/([A-Z]*)\$?(\d+)/);
        let tdStr = str[1];
        let trNum = parseInt(str[2]);
        let tdNum = 0;
        for (let i = 0; i < tdStr.length; i++) {
            tdNum += (tdStr[i].charCodeAt() - 64) * Math.pow(26, tdStr.length - i - 1)
        }
        return [trNum, tdNum];
    } catch (e) {
        return null;
    }

}

function getCellTemp2(trNum, tdNum) {
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
}

function getEvalObj(tableNum, str, isBind) {
    //解释器梭子
    var forwordStrNum = 0;
    var maxLen = 255;

    function forword(putBack) {
        var oldPutBakc = forwordStrNum;
        var strSplit = '';
        var allUseWord = ['(', ')', ',', ';', '"', "'", ':', '+', '-', '*', '/', '.', '!', '>', '<', '[', ']'];
        if (allUseWord.indexOf(str[forwordStrNum]) > -1) {
            forwordStrNum++;
            var returnStr = str[forwordStrNum - 1];
            if (returnStr == '-') {
                var nearNum = str.substr(forwordStrNum).match(/^\d+/);
                if (nearNum !== null) {
                    returnStr += nearNum[0];
                    forwordStrNum += nearNum[0].length;
                }
            } else {
                var allTwoWord = ['>=', '<='];
                for (var i = 0; i < allTwoWord.length; i++) {
                    if (returnStr == allTwoWord[i][0] && str[forwordStrNum] == allTwoWord[i][1]) {
                        returnStr += str[forwordStrNum];
                        forwordStrNum++;
                        break;
                    }
                }
            }
            if (putBack) {
                forwordStrNum = oldPutBakc;
            }
            return returnStr;
        } else {
            for (var i = forwordStrNum; i < str.length; i++) {
                if (allUseWord.indexOf(str[i]) > -1) {
                    break;
                }
                forwordStrNum++;
                strSplit += str[i];
            }
            if (putBack) {
                forwordStrNum = oldPutBakc;
            }
            return strSplit;
        }
    }

    function a(endstrArr) {
        var baseWord = [];
        while (true) {
            maxLen--;
            if (forwordStrNum > str.length - 1 || maxLen <= 0) {
                break;
            }
            var word = forword(true);
            if (endstrArr !== undefined && endstrArr.indexOf(word) > -1) {
                return baseWord;
            }
            forword();

            if (word === '(') {
                baseWord = a([')']);
                forword();
            }
            else if (['+', '-', '*', '/', '>', '<', '<=', '>='].indexOf(word) > -1) {
                var innerStrArr = [];
                if (typeof baseWord === 'string') {
                    innerStrArr.push('"' + baseWord + '"');
                } else {
                    innerStrArr.push(baseWord);
                }
                innerStrArr.push(word);
                while (true) {
                    if (endstrArr !== undefined) {
                        var temp = a(endstrArr.concat(['+', '-', '*', '/', '>', '<']));
                    } else {
                        var temp = a(['+', '-', '*', '/', '>', '<']);
                    }
                    if (typeof temp === 'string') {
                        innerStrArr.push('"' + temp + '"');
                    } else {
                        innerStrArr.push(temp);
                    }
                    var word2 = forword(true);
                    if (word2 === '') {
                        break;
                    } else if (endstrArr !== undefined && endstrArr.indexOf(word2) > -1) {
                        break;
                    } else {
                        innerStrArr.push(word2);
                        forword();
                    }
                }
                var insertObj = new __runObj__(window, '', innerStrArr);
                baseWord = insertObj;
                if (isBind) {
                    for (var i = 0; i < innerStrArr.length; i++) {
                        if (innerStrArr[i] instanceof obj) {
                            innerStrArr[i].bind(baseWord);
                        }
                    }
                }
            }
            else if (word === '"' || word === "'") {
                var strTemp = "";
                for (var i = forwordStrNum; i < str.length; i++) {
                    if (str[i] === word) {
                        if (strTemp.substr(strTemp.length - 1) === '\\') {
                        } else {
                            break;
                        }
                    }
                    forwordStrNum++;
                    strTemp += str[i];
                }
                forwordStrNum++;
                baseWord = strTemp;
            }
            else if (word === '[') {
                var params = [];
                if (forword(true) === ']') {
                    forword();
                } else {
                    while (forwordStrNum < str.length - 1) {
                        params.push(a([',', ';', ']']));
                        if ([',', ';'].indexOf(forword(true)) > -1) {
                            forword();
                        } else if (forword(true) === ']') {
                            forword();
                            break;
                        }
                    }
                }
                baseWord = params;
            }
            else if (word === ':') {
                if (endstrArr === undefined) {
                    var end = a(['+', '-', '*', '/', '>', '<', ')']);
                } else {
                    var end = a(endstrArr.concat(['+', '-', '*', '/', '>', '<', ')']));
                }
                if (baseWord.tableId === end.tableId) {
                    var resultList = new tdList(baseWord, end);
                    var tableId = baseWord.tableId;
                    for (var i = baseWord.hang; i <= end.hang; i++) {
                        for (var j = baseWord.lie; j <= end.lie; j++) {
                            var tdStr = getCellTemp2(i, j);
                            if (allTD['td:' + tableId + '!' + tdStr]) {
                                var bindTemp = allTD['td:' + tableId + '!' + tdStr];
                            } else {
                                var bindTemp = new td(dom('appMain' + tableId), tdStr);
                            }
                            if (isBind) {
                                bindTemp.bind(resultList);
                            }
                        }
                    }
                    baseWord = resultList;
                } else {
                    throw new DOMException('tdList必须在一张表上');
                }
            }
            else if (word === '.' || typeof window[word] === 'function') {
                if (word === '.') {
                    var funcName = forword();
                } else {
                    var funcName = word;
                }
                if (forword(true) === '(') {
                    forword();
                    var params = [];
                    if (forword(true) === ')') {
                        forword();
                    } else {
                        while (forwordStrNum < str.length - 1) {
                            params.push(a([',', ';', ')']));
                            if ([',', ';'].indexOf(forword(true)) > -1) {
                                forword();
                            } else if (forword(true) === ')') {
                                forword();
                                break;
                            }
                        }
                    }
                    if (typeof window[funcName] === 'function' && window[funcName].prototype instanceof obj) {
                        var applyArgs = [window].concat(params || []);
                        var temp = Function.prototype.bind.apply(window[funcName], applyArgs);
                        baseWord = new temp();
                        baseWord.className = funcName;
                        if (isBind) {
                            for (var i = 0; i < params.length; i++) {
                                if (params[i] instanceof obj) {
                                    params[i].bind(baseWord);
                                }
                            }
                        }
                    } else {
                        if (word === '.') {
                            var oldBase = baseWord;
                            baseWord = new __runObj__(oldBase, funcName, params);
                            if (isBind) {
                                oldBase.bind(baseWord);
                            }
                        } else {
                            baseWord = new __runObj__(window, funcName, params);
                        }
                        if (isBind) {
                            for (var i = 0; i < params.length; i++) {
                                if (params[i] instanceof obj) {
                                    params[i].bind(baseWord);
                                }
                            }
                        }
                    }
                }
            }
            else if (word === ')') {
                return baseWord;
            }
            else if (word === '!') {
                var tdNum = 0;
                for (var i = 0; i < tdData.length; i++) {
                    if (tdData[i].tableTitle === baseWord) {
                        tdNum = i;
                    }
                }
                if (typeof tdNum === 'number') {
                    var tdStr = forword();
                    if (allTD['td:' + tdNum + '!' + tdStr]) {
                        baseWord = allTD['td:' + tdNum + '!' + tdStr];
                    } else {
                        baseWord = new td(dom('appMain' + tdNum), tdStr);
                    }
                } else {
                    console.log('叹号!');
                    console.log(baseWord);
                }
            }
            else {
                var matchObj = null;
                for (let i = 0; i < __allMatch__.length; i++) {
                    if (word.match(__allMatch__[i].match)) {
                        matchObj = __allMatch__[i].value(tableNum, word);
                        break;
                    }
                }
                if (matchObj == null) {
                    var isTableName = false;
                    for (var i = 0; i < tdData.length; i++) {
                        if (tdData[i].tableTitle === word) {
                            isTableName = true;
                            baseWord = word;
                            break;
                        }
                    }
                    if (isTableName === false) {
                        console.log('----------');
                        console.log(str);
                        console.log(word);
                        console.log(word + 'wrong');
                    }
                } else {
                    baseWord = matchObj
                }
            }
        }
        return baseWord;
    }

    return a();
}

function getStrByEvalObj(tableNum, beRunObj) {
    var returnStr = '';
    if (beRunObj instanceof td) {
        if (beRunObj.tableId === tableNum) {
            return getCellTemp2(beRunObj.hang, beRunObj.lie);
        } else {
            return beRunObj.tableId + '!' + getCellTemp2(beRunObj.hang, beRunObj.lie);
        }
    } else if (beRunObj instanceof __runObj__) {
        var saveParams = window[beRunObj.className].config.save(beRunObj);
        var tempArr = [];
        if (saveParams.length > 0) {
            for (var i = 0; i < saveParams.length; i++) {
                if (saveParams[i] instanceof obj) {
                    tempArr[i] = getStrByEvalObj(tableNum, saveParams[i]);
                } else {
                    tempArr[i] = saveParams[i];
                }
            }
        }
        if (beRunObj.funcName) {
            if (beRunObj.runObj !== window) {
                if (beRunObj.runObj.funcName === '') {
                    return '(' + getStrByEvalObj(tableNum, beRunObj.runObj) + ').' + beRunObj.funcName + '(' + tempArr.join('') + ')';
                } else {
                    return getStrByEvalObj(tableNum, beRunObj.runObj) + '.' + beRunObj.funcName + '(' + tempArr.join('') + ')';
                }
            } else {
                return beRunObj.funcName + '(' + tempArr.join('') + ')';
            }
        } else {
            return tempArr.join('');
        }
    } else if (beRunObj instanceof obj) {
        var saveParams = window[beRunObj.className].config.save(beRunObj);
        if (saveParams.length > 0) {
            for (var i = 0; i < saveParams.length; i++) {
                if (saveParams[i] instanceof obj) {
                    saveParams[i] = getStrByEvalObj(tableNum, saveParams[i]);
                } else if (typeof saveParams[i] == 'string') {
                    saveParams[i] = '"' + saveParams[i] + '"';
                }
            }
        }
        return beRunObj.className + '(' + saveParams.join(',') + ')';
    } else if (typeof beRunObj == 'object' && beRunObj.name) {//此对象是编辑器dataFloat的getSaveObj方法产生的临时对象
        if (beRunObj.name == '=') {
            return beRunObj.params[0];
        } else if (beRunObj.name == 'td') {
            if (beRunObj.params[0] == undefined || beRunObj.params[0] == tableNum) {
                returnStr += beRunObj.params[1];
            } else {
                if (beRunObj.params[0].match(/[\+|\-|\*|\/\.]/) == null) {
                    returnStr += beRunObj.params[0] + '!' + beRunObj.params[1];
                } else {
                    returnStr += "'" + beRunObj.params[0] + '\'!' + beRunObj.params[1];
                }
            }
        } else if (beRunObj.name == 'tdList') {
            returnStr += getStrByEvalObj(tableNum, beRunObj.params[0]);
            returnStr += ':';
            returnStr += getStrByEvalObj(tableNum, beRunObj.params[1]);
        } else {
            returnStr += beRunObj.name + '(';
            for (var i = 0; i < beRunObj.params.length; i++) {
                if (i != 0) {
                    returnStr += ',';
                }
                if (typeof beRunObj.params[i] == 'string') {
                    returnStr += '"' + beRunObj.params[i] + '"';
                } else if (typeof beRunObj.params[i] == 'number') {
                    returnStr += beRunObj.params[i];
                } else if (beRunObj.params[i] instanceof Array) {
                    returnStr += '[';
                    for (var j = 0; j < beRunObj.params[i].length; j++) {
                        if (j != 0) {
                            returnStr += ',';
                        }
                        if (beRunObj.params[i][j] instanceof obj || typeof beRunObj.params[i][j] == 'object') {
                            returnStr += getStrByEvalObj(tableNum, beRunObj.params[i][j]);
                        } else if (typeof beRunObj.params[i][j] == 'string') {
                            returnStr += '"' + getStrByEvalObj(tableNum, beRunObj.params[i][j]) + '"';
                        }
                    }
                    returnStr += ']';
                } else {
                    returnStr += getStrByEvalObj(tableNum, beRunObj.params[i]);
                }
            }
            returnStr += ')';
        }
        return returnStr;
    } else {
        return beRunObj;
    }
}