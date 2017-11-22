export default function() {
    if ($(this).attr('cell_xf') == undefined) {
        $('.toolsContent [data-name=color]').css('color', '');
        $('.toolsContent [data-name=bold]').removeClass('active');
        $('.toolsContent [data-name=size]').val('');
        $('.toolsContent [data-name=underline]').removeClass('active');
        $('.toolsContent [data-name=italic]').removeClass('active');
        $('.toolsContent [data-name=fill]').css('backgroundColor', 'white');
        $('.toolsContent [data-name=tdMerge]').removeClass('active');
    } else {
        var cell_xf = getCellXfCollection[$(this).attr('cell_xf')];
        if (cell_xf.font) {
            if (cell_xf.font.color) {
                $('.toolsContent [data-name=color]').css('color', '#' + cell_xf.font.color.slice(2));
            }
            if (cell_xf.font.bold === 1) {
                $('.toolsContent [data-name=bold]').addClass('active');
            } else {
                $('.toolsContent [data-name=bold]').removeClass('active');
            }
            if (cell_xf.font.size) {
                $('.toolsContent [data-name=size]').val(cell_xf.font.size);
            }
            if (cell_xf.font.underline === 'single') {
                $('.toolsContent [data-name=underline]').addClass('active');
            } else {
                $('.toolsContent [data-name=underline]').removeClass('active');
            }
            if (cell_xf.font.italic === 1) {
                $('.toolsContent [data-name=italic]').addClass('active');
            } else {
                $('.toolsContent [data-name=italic]').removeClass('active');
            }
        }
        if (cell_xf.fill && cell_xf.fill.fillType !== 'none') {
            $('.toolsContent [data-name=fill]').css('backgroundColor', '#' + cell_xf.fill.startColor.slice(2));
        }
        else {
            $('.toolsContent [data-name=fill]').css('backgroundColor', 'white');
        }
        if (cell_xf.alignment) {
            $('.toolsContent [data-name=horizontal_left]').removeClass('active');
            $('.toolsContent [data-name=horizontal_center]').removeClass('active');
            $('.toolsContent [data-name=horizontal_right]').removeClass('active');
            if (cell_xf.alignment.horizontal == 'left') {
                $('.toolsContent [data-name=horizontal_left]').addClass('active');
            } else if (cell_xf.alignment.horizontal == 'center') {
                $('.toolsContent [data-name=horizontal_center]').addClass('active');
            } else if (cell_xf.alignment.horizontal == 'right') {
                $('.toolsContent [data-name=horizontal_right]').addClass('active');
            } else if (cell_xf.alignment.horizontal == 'general') {
            }
        }
    }
    console.log(this);
    if (this !== window && !$(this).is('.mergeTd')) {
        //不能拆分
        console.log(1);
        $('.toolsContent [data-name=tdMerge]').removeClass('active');
        $('.toolsContent [data-name=tdMerge]').addClass('disabled');
    } else {
        console.log(2);
        let isHasMerge = false;
        let activeId = $('#myTabContent .active').data('tableid');
        for (let i in tdData[activeId].mergeCells) {
            if (i.split(":")[0] == getCellTemp2($(this).attr('hang'), $(this).attr('lie'))) {
                isHasMerge = true;
                break;
            }
        }
        if (isHasMerge) {
            $('.toolsContent [data-name=tdMerge]').addClass('active');
        } else {
            $('.toolsContent [data-name=tdMerge]').removeClass('active');
        }
        $('.toolsContent [data-name=tdMerge]').removeClass('disabled');
    }
}