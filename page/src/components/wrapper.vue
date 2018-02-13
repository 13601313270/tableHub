<style>
    #wrapper {
        display: none;
        position: absolute;
        background-color: rgba(220, 220, 220, 0.95);
        border-radius: 5px;
        padding: 3px 0px;
        box-shadow: 0px 0px 20px 0px #585858;
    }

    #wrapper > ul {
        margin: 0;
        padding-left: 0;
    }

    #wrapper > ul > li {
        list-style-type: none;
        padding: 0 20px;
    }

    #wrapper > ul > li:hover {
        background-color: #4673d1;
        color: white;
    }
</style>
<template>
    <div id="wrapper">
        <ul></ul>
    </div>
</template>
<script>
    window.onload = function() {
        var wrap = document.getElementById('wrapper');
        wrap.style.display = 'none';
        var li = document.getElementsByTagName('li');

        for (var i = 0; i < li.length; i++) {
            li.onmouseover = function() {
                this.classname = "active";
            }
            li.onmouseout = function() {
                this.classname = "";
            }
        }
        document.oncontextmenu = function(e) {
            if ($('.editChange').is('.openEdit')) {
                $(wrap).find('ul').html('');
                var allRightAction = {
                    AddColumn: function() {
                        console.log('添加列');
                        console.log(this);
                    },
                    DeleteColumn: function() {
                        console.log('删除列');
                        console.log(this);
                    },
                    deleteCharts: function() {
                        var tableNum = parseInt($('#myTabContent>.tab-pane.active').attr('data-tableid'));
                        var chartIndex = $(this).attr('index');
                        // $.post('', {
                        //     function: 'deleteChart',
                        //     fileId: fileId,
                        //     tableNum: tableNum,
                        //     chartsIndex: chartIndex,
                        // }, function(result) {
                        //     if (result == 1) {
                        //         // var thisObj = allEcharts[tableNum][chartIndex];
                        //         // var listenCount = thisObj.listening.length;
                        //         // for (var i = listenCount - 1; i >= 0; i--) {
                        //         //     if (thisObj.listening[i] instanceof obj) {
                        //         //         thisObj.listening[i].unBind(thisObj);
                        //         //     }
                        //         // }
                        //         // thisObj.dom.remove();
                        //         // allEcharts[tableNum].splice(chartIndex, 1);
                        //         // $('#myTabContent>.tab-pane.active .allCharts>*').each(function() {
                        //         //     if (parseInt($(this).attr('index')) > chartIndex) {
                        //         //         $(this).attr('index', parseInt($(this).attr('index')) - 1);
                        //         //     }
                        //         // });
                        //     }
                        // });
                        console.log(this);
                    }
                }
                var allRightActionConfig = {
                    '.lieNum': {
                        AddColumn: {
                            title: '添加列',
                        },
                        DeleteColumn: {
                            title: '删除列',
                        }
                    },
                    '.allCharts>div': {
                        deleteCharts: {
                            title: '删除图表',
                        },
                    }
                };
                for (var i in allRightActionConfig) {
                    if ($(e.target).is(i)) {
                        for (var j in allRightActionConfig[i]) {
                            allRightButton.push({
                                action: j,
                                title: allRightActionConfig[i][j].title
                            });
                        }
                        $('#wrapper').data('id', 'lieNum:' + $(e.target).html());
                    }
                }

                if (allRightButton.length > 0) {
                    for (var i = 0; i < allRightButton.length; i++) {
                        $(wrap).find('ul').append($('<li data-action="' + allRightButton[i].action + '">' + allRightButton[i].title + '</li>'));
                    }
                }
                var e = event || window.event;
                wrap.style.display = 'block';
                wrap.style.left = e.pageX + 'px';
                wrap.style.top = (e.pageY - $('#header').height()) + 'px';
                return false;//取消右键点击的默认事件
            }
        };
        document.onclick = function() {
            wrap.style.display = 'none';
        }
    };
    $('#wrapper').on('click', '>ul>li', function() {
        var allRightAction = {
            AddColumn: function() {
                console.log('添加列');
                console.log(this);
                //$.post('/trafficMES/myData.php',{
//                    sAction:'addColumn',
//                    sFileId:fileId,
//                    sbeforeColumn:selectId.split(':')[1],
//                },function(result){
//                    if(result==1){
//                        setTimeout(function(){
////                            location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'')+'&edit=true&scrollLeft='+parseInt($('#myTabContent .active').scrollLeft());
//                        },100);
//                    }
//                });
            },
            DeleteColumn: function() {
                console.log('删除列');
                console.log(this);
                //                $.post('/trafficMES/myData.php',{
//                    sAction:'deleteColumn',
//                    sFileId:fileId,
//                    sDeleteColumn:selectId.split(':')[1],
//                },function(result){
//                    if(result==1){
//                        setTimeout(function(){
////                            location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'')+'&edit=true&scrollLeft='+parseInt($('#myTabContent .active').scrollLeft());
//                        },100);
//                    }
//                });
            },
            deleteCharts: function() {
                var tableNum = parseInt($('#myTabContent>.tab-pane.active').attr('data-tableid'));
                var chartIndex = $(this).attr('index');
                $.post('', {
                    function: 'deleteChart',
                    fileId: fileId,
                    tableNum: tableNum,
                    chartsIndex: chartIndex,
                }, function(result) {
                    if (result == 1) {
                        // var thisObj = allEcharts[tableNum][chartIndex];
                        // var listenCount = thisObj.listening.length;
                        // for (var i = listenCount - 1; i >= 0; i--) {
                        //     if (thisObj.listening[i] instanceof obj) {
                        //         thisObj.listening[i].unBind(thisObj);
                        //     }
                        // }
                        // thisObj.dom.remove();
                        // allEcharts[tableNum].splice(chartIndex, 1);

                        // $('#myTabContent>.tab-pane.active .allCharts>*').each(function() {
                        //     if (parseInt($(this).attr('index')) > chartIndex) {
                        //         $(this).attr('index', parseInt($(this).attr('index')) - 1);
                        //     }
                        // });
                    }
                });
                console.log(this);
            }
        }
        var allRightActionConfig = {
            '.lieNum': {
                AddColumn: {
                    title: '添加列',
                },
                DeleteColumn: {
                    title: '删除列',
                }
            },
            '.allCharts>div': {
                deleteCharts: {
                    title: '删除图表',
                },
            }
        };
        var selectId = $('#wrapper').data('id');
        allRightAction[$(this).data('action')](selectId);
    });
</script>