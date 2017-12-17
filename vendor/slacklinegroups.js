var createFrame = function(options) {
    var iFrameUrl = 'http://localhost:3000/embed';
    var iFrameHeight = '450px';
    var iFrameWidth = '450px';
    var optionsString = '';
    if (options)
    {
        if ('showSearchBar' in options) {
            if (typeof options['showSearchBar'] !== 'boolean') {
                console.error('showSearchBar option must have value of type boolean, given ' + typeof options['showSearchBar'] + ' instead.');
            } else {
                optionsString += '&showSearchBar=' + options['showSearchBar'];
            }
        }
        if ('showHome' in options) {
            if (typeof options['showHome'] !== 'boolean') {
                console.error('showHome option must have value of type boolean, given ' + typeof options['showHome'] + ' instead.');
            } else {
                optionsString += '&showHome=' + options['showHome'];
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
                optionsString += '&id=' + options['group'];
            }
        }
        if ('zoom' in options) {
            if (typeof options['zoom'] !== 'number') {
                console.error('zoom option must have value of type number, given ' + typeof options['zoom'] + ' instead.');
            } else {
                optionsString += '&zoom=' + options['zoom'];
            }
        }
        if ('width' in options) {
            if (typeof options['width'] !== 'number') {
                console.error('width option must have value of type number, given ' + typeof options['width'] + ' instead.');
            } else {
                iFrameWidth = options['width'] + 'px';
            }
        }
        if ('height' in options) {
            if (typeof options['height'] !== 'number') {
                console.error('height option must have value of type number, given ' + typeof options['height'] + ' instead.');
            } else {
                iFrameHeight = options['height'] + 'px';
            }
        }

        if (optionsString !== '') {
            iFrameUrl += '?' + optionsString.substring(1);
        }
    }
    var iframe = document.createElement("iframe");
    iframe.setAttribute('src', iFrameUrl);
    iframe.style.width = iFrameWidth;
    iframe.style.height = iFrameHeight;
    if (window.jQuery) {
        this.append(iframe);
    } else {
        this.appendChild(iframe);
    }   
}

if (window.jQuery) {
    jQuery.fn.extend({
        slacklinegroups: createFrame
    });
}

if (!HTMLElement.prototype.hasOwnProperty('slacklinegroups')) {
    Object.defineProperty(HTMLElement.prototype, 'slacklinegroups', {
        value: createFrame,
        enumerable: false
    });
}
