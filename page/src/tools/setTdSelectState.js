export default function(){
    $('body .edit td').removeClass('editTd');
    $('body .edit td').removeClass('editTdtop');
    $('body .edit td').removeClass('editTdbottom');
    $('body .edit td').removeClass('editTdleft');
    $('body .edit td').removeClass('editTdright');
    $(this).addClass('editTd');
    $(this).addClass('editTdtop');
    $(this).addClass('editTdbottom');
    $(this).addClass('editTdleft');
    $(this).addClass('editTdright');
}