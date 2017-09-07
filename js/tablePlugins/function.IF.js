function IF(logical_test,value_if_true,value_if_false){
    this.bindEvent = [];
    this.listening = [];
    this.logical_test = logical_test;
    this.value_if_true = value_if_true;
    this.value_if_false = value_if_false;
    this.get = function(){
        var logical_test = this.logical_test;
        if(logical_test instanceof obj){
            logical_test = logical_test.get();
        }
        var value_if_true = this.value_if_true;
        if(value_if_true instanceof obj){
            value_if_true = value_if_true.get();
        }
        var value_if_false = this.value_if_false;
        if(value_if_false instanceof obj){
            value_if_false = value_if_false.get();
        }
        if(logical_test){
            return value_if_true;
        }else{
            return value_if_false;
        }
    };
}
IF.prototype = new obj('IF');
functionInit(IF,'判断',{
    params:{
        logical_test:{
            title:'条件',
        },
        value_if_true:{
            title:'正确逻辑'
        },
        value_if_false:{
            title:'错误逻辑'
        }
    },
    save:function(obj){
        return [obj.logical_test,obj.value_if_true,obj.value_if_false];
    },
});
