Object.defineProperty(HTMLElement.prototype, 'slacklinegroups', {
    value: function(options) {
        var iFrameUrl = 'http://localhost:3000/embed';
        var optionsString = '';
        if (options)
        {
            if ('showSearchbar' in options) {
                if (typeof options['showSearchbar'] !== 'boolean') {
                    console.error('showSearchbar option must have value of type boolean, given ' + typeof options['showSearchbar'] + ' instead.');
                } else {
                    optionsString += '&showSearchbar=' + options['showSearchbar'];
                }
            }
            if ('showHome' in options) {
                if (typeof options['showHome'] !== 'boolean') {
                    console.error('showHome option must have value of type boolean, given ' + typeof options['showHome'] + ' instead.');
                } else {
                    optionsString += '&showHome=' + options['showSearchbar'];
                }
            }
            if ('center' in options) {
                if (!(options['center'] instanceof Array)) {
                    console.error('center option must have value of type Array, given ' + typeof options['center'] + ' instead.');
                } else {
                    if (options['center'].length !== 2) {
                        console.error('too many coordinates supplied to center option. Requires [lon,lat]');
                    } else {
                        optionsString += '&center=' + options['center'].join(',');
                    }
                }
            }
            if ('group' in options) {
                if (typeof options['group'] !== 'number') {
                    console.error('group option must have value of type number, given ' + typeof options['group'] + ' instead.');
                } else {
                    optionsString += '&group=' + options['group'];
                }
            }

            if (optionsString !== '') {
                iFrameUrl += '?' + optionsString.substring(1);
            }
        }
        var slg = document.getElementById("slacklinegroups");
        var iframe = document.createElement("iframe");
        iframe.setAttribute('src', iFrameUrl);
        iframe.style.width = '600px';
        iframe.style.height = '600px';
        slg.appendChild(iframe);
    },
    enumerable: false
});
