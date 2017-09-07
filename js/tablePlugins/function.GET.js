function GET(key){
    this.bindEvent = [];
    this.listening = [];
    this.key = key;
    this.get = function(){
        if(location.href.split('?').length>1){
            var allGet = location.href.split('?')[1].split('&');
            for(var i=0;allGet.length;i++){
                allGet[i] = allGet[i].split('=');
                if(allGet[i][0]==this.key){
                    return allGet[i][1];
                }
            }
        }else{
            return '';
        }
    }
}
GET.prototype = new obj('GET');
functionInit(GET,'网址参数',{
    params:{
        key:{
            title:'键',
            dataType:'string',
            default:'',
        },
    },
    save:function(data){
        return [data.key];
    }
});