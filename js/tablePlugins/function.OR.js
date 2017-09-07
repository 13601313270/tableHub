function OR(){
    this.bindEvent = [];
    this.listening = [];
    this.allChild = Array.prototype.slice.apply(arguments);
    this.get = function(){
        for(var i=0;i<this.allChild.length;i++){
            if(this.allChild[i] instanceof obj){
                if(Boolean(this.allChild[i].get())==true){
                    return true;
                }
            }else{
                if(this.allChild[i]==true){
                    return true;
                }
            }
        }
        return false;
    }
}
OR.prototype = new obj('OR');
functionInit(OR,'或',{
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
                returnArr.push(obj.allChild[i]);
            }
            return returnArr;
        }else{
            var returnArr = [];
            for(var i in obj.allChild){
                returnArr.push(obj.allChild[i]);
            }
            return returnArr;
            return obj.allChild;
        }
    }
});