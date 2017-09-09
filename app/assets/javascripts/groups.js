$(document).ready(function() {
    $('#url-type').change(function() {
        switch ($('#url-type').find(':selected').val()) {
            case 'group':
                $('.fb-group').show();
            break;
            case 'page':
                $('.fb-page').show();
            break;
            case 'other':
                $('.other').show();
            break;
        }
    })
});