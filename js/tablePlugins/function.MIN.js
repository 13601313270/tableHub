function MIN(){
    this.bindEvent = [];
    this.listening = [];
    this.allChild = Array.prototype.slice.apply(arguments);
    this.get = function(){
        var sum = '';
        if(this.allChild.length==1 && this.allChild[0] instanceof tdList){
            var valueList = this.allChild[0].get();
            if(valueList.length>0){
                for(var i=0;i<valueList.length;i++){
                    var temp = parseInt(valueList[i]);
                    if(!isNaN(temp)){
                        if(sum===''){
                            sum = temp;
                        }else if(temp<sum){
                            sum = temp;
                        }
                    }
                }
            }
        }else{
            for(var i=0;i<this.allChild.length;i++){
                if(this.allChild[i] instanceof obj){
                    var item = parseFloat(this.allChild[i].get());
                }else{
                    var item = parseFloat(this.allChild[i]);
                }
                if(sum===''){
                    sum = item;
                }else if(item<sum){
                    sum = item;
                }
            }
        }
        return sum;
    }
}
MIN.prototype = new obj('MIN');
functionInit(MIN,'最小值',{
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