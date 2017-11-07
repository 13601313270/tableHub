/*
function SUMIFS(allChild,criteria,sum_range){
    this.allChild = allChild;
    this.criteria = criteria;
    this.sum_range = sum_range;
    this.get = function(){
        var sum = 0;
        if(this.allChild instanceof obj){
            var allChild = this.allChild.get();
        }else if(this.allChild instanceof Array){
            var allChild = this.allChild;
        }
        if(this.sum_range==undefined){
            var sum_range = undefined;
        }else if(this.sum_range instanceof obj) {
            var sum_range = this.sum_range.get();
        } else if(this.sum_range instanceof Array){
            var sum_range = this.sum_range;
        }
        for(var i=0;i<allChild.length;i++){
            var dataSingle = 0;
            if(allChild[i] instanceof obj){
                dataSingle = allChild[i].get();
            }else{
                dataSingle = allChild[i];
            }
            var addNum = 0;
            if(sum_range==undefined){
                addNum = parseInt(dataSingle);
            }else{
                addNum = parseInt(sum_range[i]);
            }
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
                        sum += addNum;
                    }
                }else if(this.criteria.params[1]=='>='){
                    if(dataSingle>=tempValue){
                        sum += addNum;
                    }
                }else if(this.criteria.params[1]=='<'){
                    if(dataSingle<=tempValue){
                        sum += addNum;
                    }
                }else if(this.criteria.params[1]=='<='){
                    if(dataSingle<=tempValue){
                        sum += addNum;
                    }
                }
            }else if(dataSingle==this.criteria){
                sum += addNum;
            }
        }
        return sum;
    }
}
SUMIFS.prototype = new obj('SUMIFS');
functionInit(SUMIFS,'多条件加和',{
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
        },
        sum_range:{
            title:'要求和的实际单元格',
            dataType:'string',
            default:'',
        }
    },
    save:function(obj){
        if(obj.sum_range===''){
            return [obj.allChild,obj.criteria];
        }else{
            return [obj.allChild,obj.criteria,obj.sum_range];
        }
    }
});
    */