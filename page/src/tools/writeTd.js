export default function(tableNum,tdPos,str,xfIndex){
    if(allTD['td:'+tableNum+'!'+tdPos]===undefined){
        var thisTd = new td(tableNum,tdPos);
    }else{
        var thisTd = allTD['td:'+tableNum+'!'+tdPos];
    }
    thisTd.xfIndex = xfIndex;
    if(str===null){
        thisTd.set('');
    }else if(typeof str==='string' && str.substr(0,1)==='='){
        str = str.match(/=(.*)/)[1];
        thisTd.set(getEvalObj(tableNum,str,true));
    }else{
        thisTd.set(str);
    }
    readyObj.bind(thisTd);
}