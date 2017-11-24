$(document).ready(function() {
    $('#group_group_type').material_select();
    $('ul.tabs').tabs();
    $('.approve-action').click(function() {
        var group_id = $(this).attr('id');
        $.ajax({
            type: 'POST',
            url: '/admin/approve',
            data: {
                id: group_id
            },
            headers: {
                'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
            },
            dataType: 'json',
            success: function(data) {
                console.log(data);
                if(data.errors) {
                    console.log(data.errors);
                    alert('Seems something went wrong :( , check logs');
                } else {
                    $("row-" + group_id).remove();
                }
            }
        });
    });
});