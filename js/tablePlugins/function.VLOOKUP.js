function VLOOKUP(lookup_value,table_array,col_index_num,range_lookup){
    this.lookup_value = lookup_value;
    this.table_array = table_array;
    this.col_index_num = col_index_num;
    this.range_lookup = range_lookup;
    this.bindEvent = [];
    this.listening = [];
    this.get = function(){
        var table_array = [];
        if(this.table_array instanceof tdList){
            table_array = this.table_array.getLieList();
        }else{
            table_array = this.table_array;
            throw new DOMException('VLOOKUP函数第一个参数,目前只支持表格区间的形式,请联系开发者');
        }
        var lookup_value = this.lookup_value;
        if(lookup_value instanceof obj){
            lookup_value = lookup_value.get();
        }
        var col_index_num = this.col_index_num;
        if(col_index_num instanceof obj){
            col_index_num = col_index_num.get();
        }
        for(var i=0;i<table_array[0].length;i++){
            if(lookup_value==table_array[0][i]){
                console.log(col_index_num);
                return table_array[col_index_num-1][i];
            }
        }
        return null;
    }
}
VLOOKUP.prototype = new obj('VLOOKUP');
functionInit(VLOOKUP,'条件检索',{
    params:{
        lookup_value:{
            title:'匹配值',
            dataType:'int',
            default:0,
        },
        table_array:{
            title:'查询区域',
            dataType:'string',
            default:'',
        },
        col_index_num:{
            title:'返回值列号',
            dataType:'int',
            default:1,
        },
        range_lookup:{
            title:'是否模糊匹配',
            dataType:'bool',
            default:false,
        }
    },
    save:function(obj){
        var lookup_value = obj.lookup_value;
        var col_index_num = obj.col_index_num;
        if(typeof col_index_num=='string'){
            col_index_num = parseInt(col_index_num)
        }
        return [lookup_value,obj.table_array,col_index_num,obj.range_lookup];
    }
});