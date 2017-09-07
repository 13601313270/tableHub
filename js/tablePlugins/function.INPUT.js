//mes对象
function INPUT(type,value){
    this.type = type;
    this.value_ = value;
    this.bindEvent = [];
    this.listening = [];
    this.dom = $('<div class="input-group input-group-sm">' +
        '<input type="text" class="form-control" value="'+this.value_+'">' +
        '</div>');
    var this_ = this;
    this.get = function(){
        var returnValue = this.dom.find('input').val();
        if(this.type=='int'){
            returnValue = parseInt(returnValue);
        }
        return returnValue;
    };
    this_.dom.find('input').change(function(){
        this_.set($(this).val());
    });
}
INPUT.prototype = new obj('INPUT');
functionInit(INPUT,'输入框',{
    params:{
        type:{
            title:'类型',
            dataType:'string',
            default:'string',
            select:{
                'string':'字符串',
                'int':'数字'
            }
        },
        value_:{
            title:'默认值',
            dataType:'string',
            default:'',
        }
    },
    save:function(obj){
        if(obj.type=='int' && typeof obj.value_=='string'){
            obj.value_ = parseInt(obj.value_);
        }
        return [obj.type,obj.value_];
    },
});
