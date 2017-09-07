//mes对象
function INPUT_SELECT(){
    this.bindEvent = [];
    this.listening = [];
    this.default = arguments[0];
    this.selectList = Array.prototype.slice.apply(arguments).slice(1);
    this.dom = $('<div class="input-group input-group-sm">' +
        '<select class="form-control" name="dataType"></select>'+
    '</div>');
    for(var i=0;i<this.selectList.length;i++){
        if(this.default==this.selectList[i]){
            this.dom.find('select').append('<option value="'+this.selectList[i]+'"'+' selected>'+this.selectList[i]+'</option>');
        }else{
            this.dom.find('select').append('<option value="'+this.selectList[i]+'"'+'>'+this.selectList[i]+'</option>');
        }
    }
    this.get = function(){
        var returnValue = this.dom.find('select').val();
        return returnValue;
    };
    var this_ = this;
    this.dom.find('select').change(function(){
        this_.set($(this).val());
    });
}
INPUT_SELECT.prototype = new obj('INPUT_SELECT');
functionInit(INPUT_SELECT,'下拉框',{
    params:{
        default:{
            title:'默认值',
            dataType:'string',
            default:''
        },
        selectList:[{
            title:'项',
            dataType:'string',
            default:''
        }]
    },
    save:function(obj){
        return [].concat(obj.default,obj.selectList);
    },
});
