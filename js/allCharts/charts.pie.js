//饼状图
function PIE(title, XtdLists, valueTdLists) {
    this.top = 0;
    this.left = 0;
    this.width = 300;
    this.height = 300;
    this.title = title;
    this.XtdLists = XtdLists;
    this.bindEvent = [];
    this.listening = [];
    this.valueTdLists = valueTdLists;
    this.dom = $('<div type="PIE"><div style="width:100%;height:100%;"></div></div>');
    this.dom.css({
        backgroundColor: 'white',
        position: 'absolute',
        zIndex: 3,
        border: 'solid 1px #6f6f6f',
        top: this.top,
        left: this.left,
        width: this.width,
        height: this.height,
    });
    this.myChart = null;
    this.render = function () {
        this.dom.css({
            top: this.top,
            left: this.left,
            width: this.width,
            height: this.height,
        });
        var domTemp = this.dom.find('>div');
        if (domTemp.width() !== domTemp.find('>div').width() || domTemp.height() !== domTemp.find('>div').height()) {
            if (this.myChart !== null) {
                this.myChart.resize()
            }
        }
        if ((this.XtdLists instanceof tdList) == false) {
            this.myChart.setOption({
                title: {
                    text: '请配置数据源',
                    x: 'center'
                },
                tooltip: {
                    trigger: 'item',
                    formatter: "{a} <br/>{b} : {c} ({d}%)"
                },
                series: [
                    {
                        type: 'pie',
                        radius: '55%',
                        center: ['50%', '60%'],
                        data: [{value: 0, title: ' '}]
                    }
                ]
            });
            return;
        }
        var X = this.XtdLists.get();
        var value = this.valueTdLists.get();
        var data = [];
        for (var i = 0; i < value.length; i++) {
            data.push({value: value[i], name: X[i]});
        }
        var title = this.title;
        if (title instanceof obj) {
            title = title.get();
        }
        this.myChart.setOption({
            title: {
                text: title,
                x: 'center'
            },
            series: [
                {
                    name: title,
                    type: 'pie',
                    radius: '55%',
                    center: ['50%', '60%'],
                    data: data
                }
            ]
        });
    };
}

PIE.prototype = new obj('PIE');
chartsInit(PIE, '饼状图', {
    params: {
        title: {
            title: '标题',
            dataType: 'int',
            default: 0,
        },
        XtdLists: {
            title: '数据标题轴',
            dataType: 'int',
            default: 0,
        },
        valueTdLists: {
            title: '数据值',
            dataType: 'int',
            default: 0,
        }
    },
    save: function (obj) {
        return [obj.title, obj.XtdLists, obj.valueTdLists];
    }
});