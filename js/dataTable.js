//对象
function obj(className){
    this.className = className;
    //绑定本对象修改后会影响的其他对象
    this.bindEvent = [];
    this.listening = [];
    this.state = 0;//0正常,1锁定,2正在执行
    this.dom = '';
    this.value_;
    this.bind = function(obj){
        if(this.bindEvent.indexOf(obj)==-1){
            this.bindEvent.push(obj);
            obj.listening.push(this);
        }
    }
    this.unBind = function(obj){
        if(this.bindEvent.length>0){
            for(var i=0;i<this.bindEvent.length; i++) {
                if(this.bindEvent[i] == obj) {
                    this.bindEvent.splice(i, 1);
                    break;
                }
            }
        }
        if(obj.listening.length>0){
            for(var i=0;i<obj.listening.length; i++) {
                if(obj.listening[i] == this) {
                    obj.listening.splice(i, 1);
                    break;
                }
            }
        }
    }
    this.lock = function(){
        this.state = 1;
        if(this.bindEvent instanceof Array && this.bindEvent.length>0){
            for(var i=0;i<this.bindEvent.length;i++){
                this.bindEvent[i].lock();
            }
        }
    }
    //判断当前是否是可运算状态
    this.isReady = function(){
        var isReady = true;
        if(this.listening.length>0){
            for(var i=0;i<this.listening.length;i++){
                if(this.listening[i].state!==0){
                    isReady = false;
                }
            }
        }
        return isReady;
    }
    //run
    this.render = function(){
        var isReady = this.isReady();
        if(isReady && this.state != 0){
            this.state = 0;
            //console.log('--------------------');
            //console.log(this);
            //console.log(this.bindEvent);
            if(this.bindEvent instanceof Array && this.bindEvent.length>0){
                for(var i=0;i<this.bindEvent.length;i++){
                    this.bindEvent[i].render();
                }
            }
        }
    };
    //是否是锁住的状态,表示这里的值正在计算中,因为有时候,有的值依赖于多个变量
    this.set = function(value){
        this.lock();
        if(value instanceof obj){
            if(this.value_ instanceof obj){
                this.value_.unBind(this);
            }
            value.bind(this);
        }
        this.value_ = value;
        this.render();
    };
    //取值
    this.get = function(){
        if(this.value_ instanceof obj){
            return this.value_.get();
        }else{
            return this.value_;
        }
    }
}
var __allMatch__ = [
    {
        match:/^-?\d+$/,
        value:function(tableNum,word){
            return parseInt(word);
        }
    },
    {
        match:/^TRUE|true$/,
        value:function(tableNum,word){
            return true;
        }
    },
    {
        match:/^FALSE|false/,
        value:function(tableNum,word){
            return false;
        }
    }
];
var alldoms = {};
function dom(name){
    return alldoms[name];
}
var allFunc = [];
function functionInit(CLASS,title,conf){
    CLASS.config = conf;
    allFunc.push({
        title:title,
        funcName:CLASS.name
    });
}
var allChartFunction = [];
function chartsInit(CLASS,title,conf){
    CLASS.config = conf;
    allChartFunction.push({
        title:title,
        funcName:CLASS.name
    });
}