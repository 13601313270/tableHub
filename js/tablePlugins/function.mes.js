////mes对象
//
//function MES(data){
//    function getMesOneData(params,async){
//        this.hang = '';
//        this.lie = '';
//        this.logsource = '';
//        this.app_code = '';
//        this.event_code = '';
//        this.mesParams = '';
//        this.column = '';
//        this.uvColumn = '';
//        this.date = '';
//        this.transpose = false;
//        this.limit;
//        this.orderBy;
//        this.sentData;
//        var allPro = ['logsource','app_code','event_code','mesParams','column','uvColumn','date','transpose','limit','orderBy'];
//        for(var i=0;i<allPro.length;i++){
//            if(params[allPro[i]] && params[allPro[i]].value){
//                params[allPro[i]].bind(this);
//            }
//            this[allPro[i]] = params[allPro[i]];
//        }
//        this.value_ = 'sfdsafsdafdsdsafds';
//        this.render = function(){
//            var this_ = this;
//            setTimeout(function(){
//                getMesOneData.prototype.render.call(this_);
//            },1000);
//        };
//        this.finishInit();
//    }
//    getMesOneData.prototype = new obj();
//    ddd = new getMesOneData(data);
//    return ddd;
//}
//functionInit(MES,{
//    params:{
//        logsource:{
//            title:'logsource',
//            dataType:'select',
//            select:{
//                'server_event':'server_event',
//                'mobile_event':'mobile_event',
//                'page_event':'page_event',
//            }
//        },
//        app_code:{
//            title:'app_code',
//            dataType:'string'
//        },
//        event_code:{
//            title:'event_code',
//            dataType:'string'
//        },
//        mesparams:{
//            title:'mesparams',
//            dataType:'textarea'
//        },
//        column:{
//            title:'column',
//            dataType:'string'
//        },
//        uvcolumn:{
//            title:'uvcolumn',
//            dataType:'string'
//        },
//        date:{
//            title:'日期',
//            dataType:'string'
//        },
//        transpose:{
//            title:'转置',
//            dataType:'bool'
//        },
//        limit:{
//            title:'限制范围',
//            dataType:'string'
//        }
//    },
//    save:function(data){
//        return [data.logsource,data.app_code,data.event_code];
//    },
//    load:function(data){
//        return {
//            logsource:data[0],
//            app_code:data[1],
//            event_code:data[2],
//        };
//    }
//});
