function MDW_SINGLE(id,tbname,params,date,column,limit,transpose){
    this.bindEvent = [];
    this.listening = [];
    this.id = id;
    this.tbname = tbname;
    this.params = params;
    this.date = date;
    this.column = column;
    this.limit = limit;
    for(var i=0;i<this.limit.length;i++){
        if(this.limit[i] instanceof obj){
            this.limit[i].bind(this);
        }
    }
    this.transpose = transpose;
    this.value_ = '';
    this.state = 0;
    this.updateState = function(){
        this.state = 2;
        var sentData = {
            sAction:'MDW_SINGLE',
        };
        if(this.id instanceof obj){
            sentData.iId = this.id.get();
        }else{
            sentData.iId = this.id;
        }
        if(this.tbname instanceof obj){
            sentData.sTbname = this.tbname.get();
        }else{
            sentData.sTbname = this.tbname;
        }

        sentData.aParams = [];
        for(var i=0;i<this.params.length;i++){
            if(this.params[i] instanceof obj){
                sentData.aParams.push(this.params[i].get());
            }else{
                sentData.aParams.push(this.params[i]);
            }
        }
        if(this.date instanceof obj){
            sentData.sDate = this.date.get();
        }else{
            sentData.sDate = this.date;
        }
        if(this.column instanceof obj){
            sentData.sColumn = this.column.get();
        }else{
            sentData.sColumn = this.column;
        }
        sentData.sLimit = [];
        console.log('--------------------');
        console.log(this.limit);
        for(var i=0;i<this.limit.length;i++){
            if(this.limit[i] instanceof obj){
                sentData.sLimit.push(this.limit[i].get());
            }else{
                sentData.sLimit.push(this.limit[i]);
            }
        }
        console.log(sentData.sLimit);
        var this_ = this;
        $.ajax({
            type: "get",
            async: false,
            url: "https://admin.mafengwo.cn/trafficMES/myData.php",
            dataType: "jsonp",
            data:sentData,
            success: function(data){
                //console.log(data);
                this_.value_ = data[0][0];
                MDW_SINGLE.prototype.render.call(this_);
            },
            error: function(){
                //console.log('fail');
            }
        });
    }
    this.render = function(){
        this.updateState.call(this);
    }
    this.get = function(){
        if(this.value_===''){
            this.updateState();
            return '';
        }else{
            return this.value_;
        }
    }
}
MDW_SINGLE.prototype = new obj('MDW_SINGLE');
functionInit(MDW_SINGLE,'MDW单一数据',{
    params:{
        id:{
            title:'id',
            dataType:'int',
            default:0,
        },
        tbname:{
            title:'tbname',
            dataType:'string',
            default:'',
        },
        params:[{
            title:'条件',
            dataType:'string',
            default:'',
        }],
        date:{
            title:'日期',
            dataType:'string',
            default:'',
        },
        column:{
            title:'查询值',
            dataType:'string',
            default:'',
        },
        limit:[{
            title:'限制值',
            dataType:'string',
            default:'',
        }],
        transpose:{
            title:'转置',
            dataType:'bool',
            default:false,
        },
    },
    save:function(obj){
        return [
            obj.id,
            obj.tbname,
            obj.params,
            obj.date,
            obj.column,
            obj.limit,
            obj.transpose,
        ];
    }
});