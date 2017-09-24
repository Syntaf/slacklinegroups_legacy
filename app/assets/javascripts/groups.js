function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

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
        var groupType = $('#url-type').find(":selected").text();
        console.log(groupType);

        if (groupName.val().trim().length <= 0) {
            e.preventDefault();
            $('#error-msg').remove();
            groupName.addClass('error');
            return;
        }

        groupName.removeClass('error');
        
        if (groupType === 'Group Type') {
            e.preventDefault();
            $('#error-msg').remove();
            $('.select-dropdown').addClass('error');
            return;
        }

        $('.select-dropdown').removeClass('error')
        
        switch (groupType) {
            case 'Facebook Group':
                var groupGroupUrl = $('#user_submitted_group_fb_group');
                
                if (groupGroupUrl.val().trim().length <= 0 ) {
                    e.preventDefault();
                    groupGroupUrl.addClass('error');
                    return;
                }

                groupGroupUrl.removeClass('error');
            break;
            case 'Facebook Page':
                var groupPageUrl = $('#user_submitted_group_fb_page');
                
                if (groupPageUrl.val().trim().length <= 0) {
                    e.preventDefault();
                    groupPageUrl.addClass('error');
                    return;
                }

                groupPageUrl.removeClass('error');
            break;
            case 'Website/Other':
                var groupOtherUrl = $('#user_submitted_group_website');
            
                if (groupOtherUrl.val().trim().length <= 0) {
                    e.preventDefault();
                    groupOtherUrl.addClass('error');
                    return;
                }

                groupOtherUrl.removeClass('error');
            break;
        }

        var groupEmail = $('#user_submitted_group_email');

        if (groupEmail.val().trim().length <= 0 || !validateEmail(groupEmail.val())) {
            e.preventDefault();
            groupEmail.addClass('error');
            return;
        }

        groupEmail.removeClass('error');
    });
});