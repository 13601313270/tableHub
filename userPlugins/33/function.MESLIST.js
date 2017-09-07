function MES_LIST(logsource,app_code,event_code,mesParams,fenbu,uvColumn,date,transpose,order){
    this.logsource = logsource;
    this.app_code = app_code;
    this.event_code = event_code;
    this.mesParams = mesParams;
    for(var i=0;i<this.mesParams.length;i++){
        if(this.mesParams[i] instanceof obj){
            this.mesParams[i].bind(this);
        }
    }
    this.fenbu = fenbu;
    this.uvColumn = uvColumn;
    for(var i=0;i<this.uvColumn.length;i++){
        if(this.uvColumn[i] instanceof obj){
            this.uvColumn[i].bind(this);
        }
    }
    this.date = date;
    this.transpose = transpose;
    this.value_ = '';
    this.bindEvent = [];
    this.state = 0;
    this.order = order;
    this.get = function(){
        return this.value_;
    }
    this.render = function(){
        var sentData = {
            sAction:'MES_LIST',
        };
        if(this.logsource instanceof obj){
            sentData.sLogsource = this.logsource.get();
        }else{
            sentData.sLogsource = this.logsource;
        }
        if(this.app_code instanceof obj){
            sentData.sApp_code = this.app_code.get();
        }else{
            sentData.sApp_code = this.app_code;
        }
        if(this.event_code instanceof obj){
            sentData.sEvent_code = this.event_code.get();
        }else{
            sentData.sEvent_code = this.event_code;
        }
        sentData.sMesParams = [];
        for(var i=0;i<this.mesParams.length;i++){
            if(this.mesParams[i] instanceof obj){
                sentData.sMesParams.push(this.mesParams[i].get());
            }else{
                sentData.sMesParams.push(this.mesParams[i]);
            }
        }
        if(this.fenbu instanceof obj){
            sentData.sFenbu = this.fenbu.get();
        }else{
            sentData.sFenbu = this.fenbu;
        }
        sentData.sUvColumn = [];
        for(var i=0;i<this.uvColumn.length;i++){
            if(this.uvColumn[i] instanceof obj){
                sentData.sUvColumn.push(this.uvColumn[i].get());
            }else{
                sentData.sUvColumn.push(this.uvColumn[i]);
            }
        }
        if(this.date instanceof obj){
            sentData.sDate = this.date.get();
        }else{
            sentData.sDate = this.date;
        }
        var this_ = this;
        $.ajax({
            type: "get",
            async: true,
            url: "https://admin.mafengwo.cn/trafficMES/myData.php",
            dataType: "jsonp",
            data:sentData,
            success: function(data){
                //console.log(this_);
                if(this_.order instanceof Array && this_.order.length>0){
                    var selectList = this_.order[0].get();
                    var returnData = [];
                    for(var i=0;i<selectList.length;i++){
                        if(data[i]!==undefined){
                            var dataItem = [];
                            for(var j=1;j<data[i].length;j++){
                                dataItem.push(data[i][j]);
                            }
                            returnData.push(dataItem);
                        }
                    }
                    this_.value_ = new tdValueList(returnData);
                    //this_.lock();
                    //this_.render();
                    MES_LIST.prototype.render.call(this_);
                }else{
                    this_.value_ = new tdValueList(data);
                    MES_LIST.prototype.render.call(this_);
                }
            },
            error: function(){
            }
        });
    }
}
MES_LIST.prototype = new obj('MES_LIST');
functionInit(MES_LIST,'MES分布',{
    params:{
        logsource:{
            title:'logsource',
            dataType:'string',
            default:'page_event',
            select:{
                'page_event':'page_event',
                'mobile_event':'mobile_event',
                'server_event':'server_event',
            }
        },
        app_code:{
            title:'app_code',
            dataType:'string',
            default:'',
        },
        event_code:{
            title:'event_code',
            dataType:'string',
            default:'',
        },
        mesParams:[{
            title:'条件',
            dataType:'string',
            default:'',
        }],
        fenbu:{
            title:'分布字段',
            dataType:'string',
            default:'',
        },
        uvColumn:[{
            title:'返回字段',
            dataType:'string',
            default:'',
            select:{
                'basic.data':'pv',
                'basic.uuid':'uv'
            }
        }],
        date:{
            title:'日期',
            dataType:'string',
            default:''
        },
        transpose:{
            title:'转置',
            dataType:'bool',
            default:false
        },
        order:[{
            title:'输出顺序',
            dataType:'string',
            default:''
        }]
    },
    save:function(obj){
        return [
            obj.logsource,
            obj.app_code,
            obj.event_code,
            obj.mesParams,
            obj.fenbu,
            obj.uvColumn,
            obj.date,
            obj.transpose,
            obj.order
        ];
    }
});