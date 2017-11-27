function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

$(document).ready(function() {
    var $selectType = $('#submitted_group_group_type');
    var type = $('option[selected="selected"]').val();

    if (type == 'facebook group' || type == 'facebook page' || type == 'website') {
        $('label[for="submitted_group_group_type"]').hide();
    }

    $selectType.change(function() {
        var type = $('li.active span').text();
        if (type == 'Facebook Group' || type == 'Facebook Page' || type == 'Website/Other') {
            $('label[for="submitted_group_group_type"]').hide();
        } else {
            $('label[for="submitted_group_group_type"]').show();
        }
    })

    $('#new_submitted_group').submit(function(e) {
        var form = $('#new_submitted_group');
        var groupName = $('#submitted_group_name');
        var error = $('#error_explanation');
        var groupType = $('li.active span').text();
        var link = $('#submitted_group_link');
        var groupEmail = $('#submitted_group_email');
        var memberCount = $('#submitted_group_members');

        if (groupName.val().trim().length <= 0) {
            e.preventDefault();
            $('#error-msg').remove();
            groupName.addClass('error');
            return;
        }

        // remove error incase it was previously there, since the check passed
        groupName.removeClass('error');
        
        if (groupType === '') {
            e.preventDefault();
            $('#error-msg').remove();
            $('.select-dropdown').addClass('error');
            return;
        }

        // remove error incase it was previously there, since the check passed
        $('.select-dropdown').removeClass('error')

        if (groupType === 'Facebook Group' && memberCount.val().trim().length <= 0) {
            e.preventDefault();
            memberCount.addClass('error');
            return;
        }

        // remove error incase it was previously there, since the check passed
        memberCount.removeClass('error');
        
        if (link.val().trim().length <= 0) {
            e.preventDefault();
            link.addClass('error');
            return;
        }

        // remove error incase it was previously there, since the check passed
        link.removeClass('error');

        if (groupEmail.val().trim().length <= 0 || !validateEmail(groupEmail.val())) {
            e.preventDefault();
            groupEmail.addClass('error');
            return;
        }

        // remove error incase it was previously there, since the check passed
        groupEmail.removeClass('error');

        var lat = $('#submitted_group_lat');
        var lon = $('#submitted_group_lon');

        if (!lat.val().trim() || !lon.val().trim()) {
            e.preventDefault();
            $('#no-location').modal('open');
            $('.no-redirect').click(function(){
                $('#no-location').modal('close');
            });
            return;
        }
    });
});