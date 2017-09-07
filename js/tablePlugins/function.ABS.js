function ABS(value){
    this.bindEvent = [];
    this.listening = [];
    this.value_ = value;
    this.get = function(){
        if(this.value_ instanceof obj){
            return Math.abs(this.value_.get());
        }else{
            return Math.abs(this.value_);
        }
    }
}
ABS.prototype = new obj('ABS');
functionInit(ABS,'绝对值',{
    params:{
        value_:{
            title:'值',
            dataType:'int',
            default:0,
        },
    },
    save:function(obj){
        if(typeof obj.value_=='string'){
            obj.value_ = parseFloat(obj.value_);
        }
        return [obj.value_];
    }
});