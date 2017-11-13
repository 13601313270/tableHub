<template>
    <div id="tools">
        <div class="container" :class="{openEdit:isOpenEdit_,closeEdit:!isOpenEdit_}">
            <div class="editChange" v-if="isMyTable" @click="stateChange"></div>
            <div class="title">{{title}}</div>
            <ul class="nav nav-tabs">
                <li :class="{active:tabState==1}"><a @click="tabState=1" data-toggle="tab">开始</a></li>
                <li :class="{active:tabState==2}"><a @click="tabState=2" data-toggle="tab">图表</a></li>
                <li :class="{active:tabState==3}"><a @click="tabState=3" data-toggle="tab">分析</a></li>
            </ul>
        </div>
        <div v-if="isOpenEdit_" class="toolsContent">
            <div class="tab-content">
                <div class="tab-pane fade" :class="{active:tabState==1,in:tabState==1}" id="tool1" style="width: 812px;">
                    <div class="btn-group">
                        <button class="btn btn-default" data-name="bold">&#xe63f;</button>
                        <button class="btn btn-default" data-name="italic">&#xe60d;</button>
                        <button class="btn btn-default" data-name="underline">&#xe614;</button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-name="horizontal_left"><span class="glyphicon glyphicon-align-left" aria-hidden="true"></span></button>
                        <button type="button" class="btn btn-default" data-name="horizontal_center"><span class="glyphicon glyphicon-align-center" aria-hidden="true"></span></button>
                        <button type="button" class="btn btn-default" data-name="horizontal_right"><span class="glyphicon glyphicon-align-right" aria-hidden="true"></span></button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-name="tdMerge">&#xe60f;</button>
                    </div>
                    <div class="btn-group">
                        <div class="input-group" style="width: 110px;">
                            <div class="input-group-addon">&#xe715;</div>
                            <input type="number" class="form-control" data-name="size" placeholder="字号">
                        </div>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-name="fill">&#xe690;</button>
                        <button type="button" class="btn btn-default" data-name="color">&#xe613;</button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" data-name="fx">&#xe646;</button>
                    </div>
                    <div class="btn-group" style="display: none">
                        <div class="input-group disabled" style="width: 150px;">
                            <div class="input-group-addon">输出格式</div>
                            <select class="form-control disabled" style="appearance: none;-moz-appearance: none;-webkit-appearance: none;background:url(http://ourjs.github.io/static/2015/arrow.png) no-repeat scroll right center rgb(255, 255, 255);">
                                <option>无</option>
                                <option>美元</option>
                                <option>人民币</option>
                            </select>
                        </div>
                    </div>
                    <div class="btn-group" style="display: none">
                        <label class="checkbox-inline">
                            <input type="checkbox disabled" id="inlineCheckbox1" value="option1">网格线
                        </label>
                        <label class="checkbox-inline">
                            <input type="checkbox disabled" id="inlineCheckbox1" value="option1">标题
                        </label>
                    </div>
                </div>
                <div class="tab-pane fade" :class="{active:tabState==2,in:tabState==2}" id="tool2" style="width: 783px;">
                    <div class="btn-group">
                        <button type="button" class="insertBar btn btn-default">&#xe600;柱状图</button>
                        <!--<button type="button" class="btn btn-default">&#xe610;堆积柱状图</button>
                        <button type="button" class="btn btn-default">&#xe611;簇形柱状图</button>-->
                    </div>
                    <div class="btn-group">
                        <button type="button" class="insertLine btn btn-default">&#xe636;折线图</button>
                        <!--<button type="button" class="btn btn-default">&#xe62b;标记折线图</button>*}
                        {*<button type="button" class="btn btn-default">&#xe61e;面积折线图</button>-->
                    </div>
                    <div class="btn-group">
                        <button type="button" class="insertPie btn btn-default">&#xe60c;饼状图</button>
                    </div>
                    <!--
                    {*<div class="btn-group">*}
                    {*<button type="button" class="btn btn-default">&#xe63a;散点图</button>*}
                    {*</div>*}
                    -->
                </div>
                <div class="tab-pane fade" :class="{active:tabState==3,in:tabState==3}" id="tool3">3</div>
            </div>
        </div>
    </div>
</template>

<script>
export default {
    props: ['title','isMyTable','isOpenEdit'],
    methods:{
        stateChange(){
            this.isOpenEdit_ = !this.isOpenEdit_;
            this.$emit('stateChange',this.isOpenEdit_);


            var lieAddCount = 2;//增加
            if($('.editChange').parent().is('.closeEdit')){
                $('.editChange').parent().attr('class','container openEdit');
                if(lieAddCount>0){
                    $('#myTabContent .tab-pane').each(function(){
                        for(var i=0;i<lieAddCount;i++){
                            var lieNum = getCellTemp2(0,$(this).find('.tableThead table thead tr th').length+1).match(/([A-Z]*)(\d+)/)[1];
                            var headTdHtml = '<th class="lieNum" lienum="'+lieNum+'" style="position: relative; overflow: hidden;">'+
                                lieNum+
                                '<div style="position: absolute; cursor: ew-resize;"></div>' +
                                '</th>';
                            var bodyTheadHtml = '<th class="lieNum" lienum="'+lieNum+'"></th>';
                            $(this).find('.tableThead table thead tr').append($(headTdHtml));
                            $(this).find('.tableBody table thead tr').append($(bodyTheadHtml));
                        }
                    });
                    $('#myTabContent .tableBody table tbody tr').each(function(){
                        for(var i=0;i<lieAddCount;i++){
                            var newTd = $('<td></td>');
                            newTd.attr('hang',$(this).index()+1);
                            newTd.attr('lie',$(this).find('>td').length+1);
                            $(this).append(newTd);
                        }
                    });
                }
                $('#tablePanel').addClass('edit');
            }else{
                $('.editChange').parent().attr('class','container closeEdit');
                if(lieAddCount>0){
                    $('#myTabContent .tableThead table').each(function(){
                        for(var i=0;i<lieAddCount;i++){
                            $(this).find('thead tr th:last').remove();
                        }
                    });
                    $('#myTabContent .tableBody table thead tr').each(function(){
                        for (var i=0;i<lieAddCount;i++){
                            $(this).find('th:last').remove();
                        }
                    });
                    $('#myTabContent .tableBody table tbody tr').each(function(){
                        for (var i=0;i<lieAddCount;i++){
                            $(this).find('td:last').remove();
                        }
                    });
                }
                $('#tablePanel').removeClass('edit');
//        location.href = location.href.replace('&edit=true','').replace(/&scrollLeft=(\d+)/,'');
                $('#dataFloat').hide();
            }
        }
    },
    data(){
        return {
            tabState:1,
            isOpenEdit_:this.isOpenEdit
        }
    }
}
</script>

<style>
    @font-face {
        font-family: 'iconfont';  /* project id 384848 */
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot');
        src: url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.eot?#iefix') format('embedded-opentype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.woff') format('woff'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.ttf') format('truetype'),
        url('//at.alicdn.com/t/font_384848_zl5f4iiqczbyb9.svg#iconfont') format('svg');
    }
    #tools:after{
        content: '';
        clear: both;
    }
    .edit #tools{
        display: block;
    }
    #tools .editChange{
        width: 55px;height: 20px;margin-top:6px;background-size: 100% 100%!important;float: left;
    }
    #tools .openEdit{
        border-bottom: 1px solid #ddd;padding-bottom: 0!important;margin-bottom: 10px!important;
    }
    #tools .openEdit .editChange{
        background: url(https://n4-q.mafengwo.net/s10/M00/18/A2/wKgBZ1jc3R6AYhi_AAB-2Jyz1WU027.png);
    }

    #tools .closeEdit .editChange{
        background: url(https://c2-q.mafengwo.net/s10/M00/18/1D/wKgBZ1jc3A-AKDulAABm0wptOh4037.png);
    }
    #tools .title{
        margin-left: 10px;float: left;margin-top:6px;
    }
    #tools .toolsContent{
        padding: 0 5px;height:34px;overflow: hidden;
    }
    #tools .toolsContent .tab-content{
        overflow-x: auto;
    }
    .edit #tools .toolsContent{
        display: block;
    }
    .nav-tabs{
        border-bottom:1px solid #d4d4d4;
    }
    #tools .container{
        background-color: #e6e6e6;width:100%;height:100%;margin: 0;padding: 10px;position: relative;
    }
    #tools .container .nav-tabs>li>a{
        padding: 5px 6px;cursor: pointer;
    }
    #tools .container .nav-tabs{
        display: none;float: left;margin-left: 20px;border: none;
    }
    #tools .openEdit .nav-tabs{
        display: block;
    }
    #tools .tab-pane{
        height:34px;font-family: iconfont;
    }
    .edit #myTabContentParent .tab-pane{
        padding-top: 1px;
    }
    #myTabContentParent{
        position:fixed;top:45px;left:0;right:0;bottom:20px;
    }
    .edit #myTabContentParent{
        top:90px;
    }
    .tableRow td{
        height:22px;
    }
</style>