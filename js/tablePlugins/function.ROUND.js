function ROUND(number,num_digits){
    this.bindEvent = [];
    this.listening = [];
    this.value_ = number;
    this.dig = num_digits;
    this.get = function(){
        var value = this.value_;
        if(value instanceof obj){
            var value = value.get();
        }
        var dig = this.dig;
        if(dig instanceof obj){
            dig = dig.get();
        }
        if(dig==0){
            return value;
        }else{
            return parseFloat(value).toFixed(dig);
        }
    }
}
ROUND.prototype = new obj('ROUND');
functionInit(ROUND,'四舍五入',{
    params:{
        value_:{
            title:'值',
            dataType:'int',
            default:0,
        },
        dig:{
            title:'小数位',
            dataType:'int',
            default:0,
        }
    },
    save:function(obj){
        if(typeof obj.dig=='string'){
            obj.dig = parseInt(obj.dig);
        }
        return [obj.value_,obj.dig];
    }
});