function MES_SINGLE(logsource,app_code,event_code,mesParams,uvColumn,date,transpose){
    this.logsource = logsource;
    this.app_code = app_code;
    this.event_code = event_code;
    this.mesParams = mesParams;
    this.uvColumn = uvColumn;
    this.date = date;
    this.transpose = transpose;
    this.value_ = '';
    this.bindEvent = [];
    this.state = 0;
    this.render = function(){
        var sentData = {
            sAction:'MES_SINGLE',
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
            async: false,
            url: "https://admin.mafengwo.cn/trafficMES/myData.php",
            dataType: "jsonp",
            data:sentData,
            success: function(data){
                this_.value_ = data[0][0];
                MES_SINGLE.prototype.render.call(this_);
            },
            error: function(){
            }
        });
    }
}
MES_SINGLE.prototype = new obj('MES_SINGLE');
functionInit(MES_SINGLE,'MES单一数据',{
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
        uvColumn:[{
            title:'返回字段',
            dataType:'string',
            default:'',
            select:{
                'basic.data':'pv',
                'basic.uuid':'uv',
            }
        }],
        date:{
            title:'日期',
            dataType:'string',
            default:'',
        },
        transpose:{
            title:'转置',
            dataType:'bool',
            default:false,
        },
    },
    save:function(obj){
        return [
            obj.logsource,
            obj.app_code,
            obj.event_code,
            obj.mesParams,
            obj.uvColumn,
            obj.date,
            obj.transpose,
        ];
    }
});