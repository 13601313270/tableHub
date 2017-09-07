function NOW(){
    this.bindEvent = [];
    this.listening = [];
    this.get = function(){
        var today = new Date();
        today.setTime(today.getTime()-24*60*60*1000);
        return (today.getYear()+1900)+'-'+(today.getMonth()+1<10?'0':'')+(today.getMonth()+1)+'-'+(today.getDate()<10?'0':'')+today.getDate();
    }
}
NOW.prototype = new obj('NOW');
functionInit(NOW,'当前时间',{
    save:function(data){
        return [];
    }
});

function DATEINPUT(time,reduce){
    this.value_ = time;
    this.addNum = reduce;
    this.bindEvent = [];
    this.listening = [];
    this.get = function(){
        var addNum = this.addNum;
        if(addNum instanceof obj){
            addNum = addNum.get();
        }
        if(this.value_ instanceof obj){
            var returnStr = Date.parse(this.value_.get())+1000*60*60*24*addNum;
        }else{
            var returnStr = Date.parse(this.value_)+1000*60*60*24*addNum;
        }
        returnStr = new Date(returnStr);
        return returnStr.getYear()+1900+'-'+(returnStr.getMonth()<9?'0':'')+(returnStr.getMonth()+1)+'-'+(returnStr.getDate()<10?'0':'')+returnStr.getDate()
    }
    this.dom = $('<div class="input-group input-group-sm">' +
        '<span class="input-group-addon">日期</span>' +
        '<input type="text" class="form-control" placeholder="日期选择" value="'+this.get()+'">' +
        '</div>');
    var this_ = this;
    this.dom.find('input').datepicker({
        dateFormat:'yy-mm-dd',
        onSelect:function(value){
            this_.set($(this).val());
        }
    });

    this.render = function(dom){
        this.dom.find('input').val(this.get());
        $(dom).append(this.dom);
        DATEINPUT.prototype.render.call(this);
    };
}
DATEINPUT.prototype = new obj('DATEINPUT');
functionInit(DATEINPUT,'时间输入框',{
    params:{
        value_:{
            title:'基础值(NOW()为今天)',
            dataType:'string',
            default:'',
        },
        addNum:{
            title:'缩进值(1代表明天-1代表昨天)',
            dataType:'int',
            default:0,
        }
    },
    save:function(obj){
        if(typeof obj.addNum=='string'){
            obj.addNum = parseInt(obj.addNum);
        }
        return [obj.value_,obj.addNum];
    }
});
