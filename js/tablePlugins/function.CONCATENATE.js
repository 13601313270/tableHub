function CONCATENATE(){
    this.bindEvent = [];
    this.listening = [];
    this.allChild = Array.prototype.slice.apply(arguments);
    this.get = function(){
        var sum = '';
        for(var i=0;i<this.allChild.length;i++){
            if(this.allChild[i] instanceof obj){
                sum += (this.allChild[i].get()).toString();
            }else{
                sum += (this.allChild[i]).toString();
            }
        }
        return sum;
    }
}
CONCATENATE.prototype = new obj('CONCATENATE');
functionInit(CONCATENATE,'字符串拼接',{
    params:{
        allChild:[{
            title:'项',
            dataType:'string',
            default:'',
        }],
    },
    save:function(obj){
        if(typeof obj=='object'){
            var returnArr = [];
            for(var i in obj.allChild){
                returnArr.push(obj.allChild[i]);
            }
            return returnArr;
        }else{
            return obj.allChild;
        }
    }
});