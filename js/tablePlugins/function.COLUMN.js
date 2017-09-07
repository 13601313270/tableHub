function COLUMN(value){
    this.bindEvent = [];
    this.listening = [];
    this.value_ = value;
    this.get = function(){
        if(this.value_ instanceof td){
            return this.value_.lie;
        }else{
            return null;
        }
    }
}
COLUMN.prototype = new obj('COLUMN');
functionInit(COLUMN,'单元格列号',{
    params:{
        value_:{
            title:'单元格',
            dataType:'int',
            default:0,
        },
    },
    save:function(obj){
        return [obj.value_];
    }
});