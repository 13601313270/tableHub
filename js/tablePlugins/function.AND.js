function AND(){
    this.bindEvent = [];
    this.listening = [];
    this.allChild = Array.prototype.slice.apply(arguments);
    this.get = function(){
        for(var i=0;i<this.allChild.length;i++){
            if(this.allChild[i] instanceof obj){
                if(Boolean(this.allChild[i].get())==false){
                    return false;
                }
            }else{
                if(this.allChild[i]==false){
                    return false;
                }
            }
        }
        return true;
    }
}
AND.prototype = new obj('AND');
functionInit(AND,'且',{
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