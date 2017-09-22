$(document).ready(function() {
    $('#url-type').change(function() {
        switch ($('#url-type').find(':selected').val()) {
            case 'group':
                $('.fb-page').hide();
                $('.other').hide();
                $('.fb-group').show();
            break;
            case 'page':
                $('.fb-group').hide();
                $('.other').hide();
                $('.fb-page').show();
            break;
            case 'other':
                $('.fb-group').hide();
                $('.fb-page').hide();
                $('.other').show();
            break;
        }
    })

    $('#new_user_submitted_group').submit(function(e) {
        console.log('heya');
        var form = $('#new_user_submitted_group');
        var groupName = $('#user_submitted_group_name');
        var error = $('#error_explanation');
        if (groupName.val().trim().length <= 0) {
            e.preventDefault();
            $('#error-msg').remove();
            form.before('<p id="error-msg" style="color: red; text-align: center; width: 100%;">Please provide a group type</p>');
            groupName.addClass('error');
            $('.submit-button').prop('disabled', false);
            return;
        }

        var groupType = $('#url-type');
        
        if (groupType.val().trim().length <= 0) {
            e.preventDefault();
            $('#error-msg').remove();
            form.before('<p id="error-msg" style="color: red; text-align: center; width: 100%;">Please provide a group type</p>');
            groupType.addClass('error');
            return;
        }

        switch (groupType) {
            case 'group':
                var groupGroupUrl = $('#user_submitted_group_fb_group');
                
                if (groupGroupUrl.val().trim().length <= 0 ) {
                    e.preventDefault();
                    error.val('Please provide a group link');
                    groupGroupUrl.addClass('error');
                    return;
                }
            break;
            case 'page':
                var groupPageUrl = $('#user_submitted_group_fb_page');
                
                if (groupPageUrl.val().trim().length <= 0) {
                    e.preventDefault();
                    error.val('Please provide a group link');
                    groupPageUrl.addClass('error');
                    return;
                }
            break;
            case 'other':
                var groupOtherUrl = $('#user_submitted_group_website');
            
                if (groupOtherUrl.val().trim().length <= 0) {
                    e.preventDefault();
                    error.val('Please provide a group link');
                    groupOtherUrl.addClass('error');
                    return;
                }
            break;
        }

        var groupEmail = $('#user_submitted_group_email')();

        if (groupType.val.trim().length <= 0) {
            e.preventDefault();
            error.val('Please provide a contact email');
            groupType.addClass('error');
            return;
        }
    });
});