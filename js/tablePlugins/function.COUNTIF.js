function COUNTIF(allChild,criteria){
    this.allChild = allChild;
    this.bindEvent = [];
    this.listening = [];
    this.criteria = criteria;
    this.get = function(){
        var sum = 0;
        if(this.allChild instanceof obj){
            var allChild = this.allChild.get();
        }else if(this.allChild instanceof Array){
            var allChild = this.allChild;
        }
        for(var i=0;i<allChild.length;i++){
            var dataSingle = 0;
            if(allChild[i] instanceof obj){
                dataSingle = allChild[i].get();
            }else{
                dataSingle = allChild[i];
            }
            var addNum = parseInt(dataSingle);
            if(this.criteria instanceof __runObj__ &&
                this.criteria.params[0] instanceof Array &&
                this.criteria.params[0].length==0 &&
                ['>','<','>=','<='].indexOf(this.criteria.params[1])>-1
            ){

                if(this.criteria.params[1] instanceof obj){
                    var tempValue = this.criteria.params[2].get();
                }else{
                    var tempValue = this.criteria.params[2];
                }
                if(this.criteria.params[1]=='>'){
                    if(dataSingle>tempValue){
                        sum ++;
                    }
                }else if(this.criteria.params[1]=='>='){
                    if(dataSingle>=tempValue){
                        sum ++;
                    }
                }else if(this.criteria.params[1]=='<'){
                    if(dataSingle<tempValue){
                        sum ++;
                    }
                }else if(this.criteria.params[1]=='<='){
                    if(dataSingle<=tempValue){
                        sum ++;
                    }
                }
            }else if(dataSingle==this.criteria){
                sum ++;
            }
        }
        return sum;
    }
}
COUNTIF.prototype = new obj('COUNTIF');
functionInit(COUNTIF,'满足条件个数',{
    params:{
        allChild:{
            title:'条件计算的单元格区域',
            dataType:'int',
            default:0,
        },
        criteria:{
            title:'条件',
            dataType:'string',
            default:'',
        }
    },
    save:function(obj){
        return [obj.allChild,obj.criteria];
    }
});