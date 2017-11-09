<template>
    <div>
        <div id="tablePanel" :class="{edit:isOpenEdit}">
            <tools @stateChange="isOpenEditSet" :title="title" :isMyTable="isMyTable" :isOpenEdit="isOpenEdit"></tools>

            <div id="myTabContentParent">
                <p></p>
                <p></p>
                <p></p>
                <p></p>
                asdf
                asfd

                <ul class="allTableSelect nav nav-tabs"></ul>

                <div id="myTabContent" class="tab-content"></div>
            </div>
        </div>
        <bottom>asfds</bottom>
    </div>
</template>

<script>
    import bottom from '@/components/bottom.vue'
    import tools from '@/components/tools.vue'
    export default {
        name: 'page',
        methods:{
            isOpenEditSet(state){
                this.isOpenEdit = state;
            }
        },
        data:function(){
            return {
                title:'标题222',
                isMyTable:true,
                isOpenEdit:false,
            }
        },
        components: {
            bottom,tools
        }
    }
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
    body{
        background-color: #e6e6e6;
    }
    .table{
        width:0!important;
        margin-top: 0;
        background-color: white;
        table-layout: fixed;
    }
    .table>thead>tr>th{
        width:100px;
    }
    .table>tbody>tr>td{
        width:100px;
        overflow: hidden;
    }
    .idNum{
        background-color: #c3c3c3;border-right:solid 3px #929292;min-width:30px;
    }
    .tableBody{
        margin-left:0px;width:100%;height:100%;overflow: auto;margin-top:0px;
    }
    .tableBody .input-group{
        width:98%;margin-left: 1%;
    }
    .edit .tableBody{
        margin-left:80px;width: calc(100% - 80px);height:calc(100% - 39px);overflow: scroll;margin-top: 39px;cursor: cell;
    }
    .tableRow{
        display: none;position:absolute;left:0;width:80px;top:39px;height:calc(100% - 39px);overflow: hidden;
    }
    .tableThead{
        display: none;
    }
    .edit .table{
        margin: 0 0;
    }
    .edit .tableRow{
        display: block;
    }
    .edit .tableThead{
        display: block;
    }
    #myTabContent{
        position:relative;height: calc(100% - 40px);
    }
    #myTabContent .tab-pane{
        overflow: auto;width: 100%;height: 100%;padding-top: 5px;
    }
    .trMain{
        background-color: white;
    }
    .trTwo{
        display: none;
        background-color: #EEEEEE;
    }
    .trThree{
        background-color: #E8E8E8;
    }
    .addButton{
        float: right;
    }
    .addButton:after{
        content: '+';
    }
    .table th, .table td{
        text-align: center;
    }
    .table>tbody>tr{
        height: 37px;
    }
    .table>thead{
        background-color: #c3c3c3;
    }
    .edit .editTd{
        background-color: #e5f2ff;
        /*border:solid 2px #0000b8;*/
    }
    .edit .editTdtop{
        border-top:solid 2px #0000b8;
    }
    .edit .editTdbottom{
        border-bottom:solid 2px #0000b8;
    }
    .edit .editTdleft{
        border-left:solid 2px #0000b8;
    }
    .edit .editTdright{
        border-right:solid 2px #0000b8;
    }
    .tableThead thead>tr>th{
        min-width: 60px;border: 1px solid #ddd;white-space:nowrap;vertical-align: middle;padding:0;height:37px;
    }
    .table>tbody>tr>td{
        min-width: 60px;border: 1px solid #ddd;white-space:nowrap;vertical-align: middle;padding:0;height:37px;
    }
    .tableThead>thead th{
        border-bottom: solid 3px #929292!important;
    }
    .tableThead .table>thead>tr>.lieNum{
        position:relative;
    }
    .tableThead .table>thead>tr>.lieNum>div{
        cursor: ew-resize;
        position: absolute;
        right: 0;
        top: 0;
        height: 100%;
        width: 5px;
    }
    .table>tbody>tr>.mergeTd{
        white-space:initial
    }
    .tableBody tr{
        background-color: white;
    }
    .tableBody thead{
        height: 20px;
    }
    .tableBody .table{
        margin-top: -16px;
    }
    .tableBody .table>thead>tr>th{
        border-bottom: none;
    }
    .styleAllSelect{
        float:left;width:60px;height:20px;margin:2px;background-color: white;
    }
    .styleSelect{
        border: solid 1px black;
    }
    .idNumOn{
        background-color:#a7a7a7!important;
        box-shadow: inset 6px -1px 20px 1px #909090;
        color: #e8e8e8;
    }
    .lieNumOn{
        background-color: #a7a7a7!important;
        box-shadow: inset 0px 6px 20px 3px #909090;
        color: #e8e8e8;
    }
    .addTable{
        font-family: iconfont;
        line-height: 40px;
        border: solid 1px rgba(255, 255, 255, 0);
        border-left: solid 1px #bdbdbd;
        width: 50px;
        font-size: 18px;
        text-align: center;
        cursor: pointer;
    }
    .addTable:hover{
        background-color: #e6e6e6;
        border: solid 1px #b5b5b5;
        border-radius: 2px;
    }
    .table td .tdInsertDiv{
        display: table;width: 100%;
    }
    .table td .tdInsertDiv>div{
        display: table-cell;
    }
    .table td .tdInsertDiv>div:nth-child(2){
        white-space: normal;
        display: block;
        height:1rem;
    }
    .table td .tdInsertDiv>div:nth-child(2)>span{
        /*max-width: 100px;*/
        display: inline-block;
    }
    .table td .tdInsertDiv>div:first-child{
        text-align: left;
    }
    .table td .tdInsertDiv>div:last-child{
        text-align: right;
    }
</style>
