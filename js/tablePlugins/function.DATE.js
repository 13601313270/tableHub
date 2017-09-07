function DATE(year,month,day){
    this.bindEvent = [];
    this.listening = [];
    this.year = year;
    this.month = month;
    this.day = day;
    this.get = function(){
        var dateInMonth = [31,28,31,30,31,30,31,31,30,31,30,31];
        var year = this.year;
        var month = this.month;
        var day = this.day;

        while(true){
            var before = year+'-'+month+'-'+day;
            if(month>12){
                var moveYear = parseInt((month-1)/12);
                year += 1*moveYear;
                month -= 12*moveYear;
            }
            var monthTemp = dateInMonth[month-1];
            if(month==2){
                if(year/100==0){
                    if(year/400==0){
                        monthTemp=29;
                    }
                }else if(year/4==0){
                    monthTemp=29;
                }
            }
            if(day>monthTemp){
                day-=monthTemp;
                month++;
            }
            if((year+'-'+month+'-'+day)==before){
                break;
            }
        }
        return year+'-'+month+'-'+day;
    }
}
DATE.prototype = new obj('DATE');
functionInit(DATE,'日期',{
    params:{
        year:{
            title:'年',
            dataType:'int',
            default:2000
        },
        month:{
            title:'月',
            dataType:'int',
            default:0
        },
        day:{
            title:'日',
            dataType:'int',
            default:0
        }
    },
    save:function(obj){
        if(typeof obj.year=='string'){
            obj.year = parseFloat(obj.year);
        }
        if(typeof obj.month=='string'){
            obj.month = parseFloat(obj.month);
        }
        if(typeof obj.day=='string'){
            obj.day = parseFloat(obj.day);
        }
        return [obj.year,obj.month,obj.day];
    }
});