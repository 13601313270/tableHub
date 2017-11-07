function AVERAGE(){
    this.bindEvent = [];
    this.listening = [];
    this.allChild = Array.prototype.slice.apply(arguments);
    this.get = function(){
        var sum = 0;
        if(this.allChild.length==1 && this.allChild[0] instanceof tdList){
            var valueList = this.allChild[0].get();
            if(valueList.length>0){
                for(var i=0;i<valueList.length;i++){
                    sum += parseFloat(valueList[i]);
                }
            }
            return sum/valueList.length;
        }else{
            for(var i=0;i<this.allChild.length;i++){
                if(this.allChild[i] instanceof obj){
                    sum += parseFloat(this.allChild[i].get());
                }else{
                    sum += parseFloat(this.allChild[i]);
                }
            }
            return sum/this.allChild.length;
        }
    }
}
AVERAGE.prototype = new obj('AVERAGE');
functionInit(AVERAGE,'平均数',{
    params:{
        allChild:[{
            title:'项',
            dataType:'int',
            default:0,
        }],
    },
    save:function(obj){
        if(typeof obj=='object'){
            var returnArr = [];
            for(var i in obj.allChild){
                if(typeof obj.allChild[i]=='string'){
                    returnArr.push(parseInt(obj.allChild[i]));
                }else{
                    returnArr.push(obj.allChild[i]);
                }
            }
            return returnArr;
        }else{
            return obj.allChild;
        }
    }
});