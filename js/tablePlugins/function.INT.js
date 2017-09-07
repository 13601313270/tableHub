function INT(value){
    this.bindEvent = [];
    this.listening = [];
    this.value_ = value;
    this.get = function(){
        if(this.value_ instanceof obj){
            return Math.floor(this.value_.get());
        }else{
            return Math.floor(this.value_);
        }
    }
}
INT.prototype = new obj('INT');
functionInit(INT,'向下舍入取整',{
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