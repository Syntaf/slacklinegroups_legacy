mapboxgl.accessToken = 'pk.eyJ1Ijoic3ludGFmIiwiYSI6ImNqM2Z2bzZhbTAxZWwycW4wcmI5cjk4MW0ifQ.YOd5yuJfLARC2oOfqY-KoA'

// Keeps track of what feature was clicked between unclusteredPointClicked and
// unclusteredPointZoomend. If a zoom needs to be done before the popup appears,
// we set the clickEvent which is used to build the popup after the zoom is finished.
var clickEvent = null;

// List of group names to be used in autocomplete. After the data is loaded, this variable
// is populated with every group name
var groupNames = null;

// Holds the data returned by a GET to /map/clusters
var groupList = null;

// Sometimes the popup needs to be shifted manually, but by default it is usually fine
var defaultOffset = 0;

// Contains a mapboxgl.Popup which we store so we can call .remove() on it when we shift views
var currentPopup = null;

// For mobile parity, we don't want to actually zoom to a point being at the center (we'd have
// no room for the popup). Instead, we zoom to the point being offset lower on the screen.
var zoomOffsetLat = 0;

// Embedded map specific options
var showSearchBar = typeof showSearchBar === 'undefined' ? true : (showSearchBar === 'true');
var showHome = typeof showHome === 'undefined' ? true : (showHome === 'true');
var center = typeof center === 'undefined' ? [0, 35] : (function (c) {var s = c.split(','); return [parseFloat(s[0]), parseFloat(s[1])]})(center);
var group = typeof group === 'undefined' ? null : group;
var zoom = typeof zoom === 'undefined'? 1.75 : parseFloat(zoom);

var createPopUp = function(f) {
return  "<div class=\"title-bar\">"                                         +
            "<p class=\"title\">"+f[0].properties.name+"</p>"              +
        "</div>"                                                            +
        "<div class=\"content\">"                                           +
            "<table>"                                                       +
                "<tr>"                                                      +
                    "<td class=\"label\">Page Type:</td>"                   +
                    "<td class=\"value\">"+f[0].properties.type+"</td>"     +
                "</tr>"                                                     +
                "<tr>"                                                      +
                    "<td class=\"label\">Member Count(Estimate)</td>"       +
                    "<td class=\"value\">"+f[0].properties.members+"</td>"  +
                "</tr>"                                                     +
            "</table>"                                                      +
            "<div class=\"no-img\">"                                        +
                "<p>Photos Coming Soon :)</p>"                              +
            "</div>"                                                        +
        "</div>"                                                            +
        "<a class=\"bottom left go-to\" target=\"_blank\" "                 +
            "href=\""+f[0].properties.link+"\">Go to Group</a>"             +
        "<a class=\"bottom right issue\" "                                  +
            "id=\""+f[0].properties.id+"\">See Something Wrong?</a>"
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

var getCords = function(f, offset) {
    var x = f[0].geometry.coordinates;
    x[1] += offset;
    return x;
}

var geoPointJSON = $.ajax({
    url: '/embed/clusters',
    dataType: 'json'
});

$(document).ready(function() {
    var window_height = $(window).height();
    if (window_height < 450) {
        zoomOffsetLat = .3;
    } else if (window_height < 1000) {
        zoomOffsetLat = .2;
    }

    $('.modal').modal();
    $('.button-collapse').sideNav({
        closeOnClick: true
    });
    $('a').click(function() {
        $('#sidenav-overlay').remove();
    });
    
    var map = new mapboxgl.Map({
        center: center,
        zoom: zoom,
        container: 'map',
        style: 'mapbox://styles/syntaf/cj7f7kxzx2jw52sp82gqdlu82'
    });

    if (showHome) {
        var homeButton = $('.zoom-out');
        homeButton.click(function() {
            if (currentPopup != null) {
                currentPopup.remove();
                currentPopup = null;
            }
            map.flyTo({
                center: {
                    lng: 0,
                    lat: 35
                },
                zoom: 1.75
            });
        });
        if (!showSearchBar) {
            homeButton.css('top', '15px');
            homeButton.css('left', '15px');
        }
    } else {
        $('.zoom-out').remove();
    }

    if (showSearchBar) {
        $('#search-field').prop('disabled', true);
        $('#search-field').autocomplete({
            source: function(request, response) {
                var results = $.ui.autocomplete.filter(groupNames, request.term);
                response(results.slice(0, 7));
                $('.ui-menu-item-wrapper').click(function() {
                    var slackGroupName = $(this).html();
                    for(var i = 0; i < groupList.length; i++) {
                        var group = groupList[i];
                        if(group.properties.name.toLowerCase() === slackGroupName.toLowerCase()) {
                            if (currentPopup != null) {
                                currentPopup.remove();
                                currentPopup = null;
                            }
                            unclusteredPointClicked({
                                features: 
                                [
                                    {
                                        geometry: 
                                        {
                                            coordinates: [group.geometry.coordinates[0], group.geometry.coordinates[1]]
                                        },
                                        properties:
                                        {
                                            name: group.properties.name,
                                            members: group.properties.members,
                                            type: group.properties.type,
                                            link: group.properties.link,
                                            id: group.properties.id
                                        }
                                    }
                                ],
                                fromSearch: true
                            });
                            break;
                        }
                    }
                });
            }
        });
    } else {
        $('.search-bar').remove();
    }


    function unclusteredPointClicked(e)
    {
        clickEvent = e;
        if (map.getZoom() < 7.7 || e.fromSearch == true) {
            var lngLat = getCords(e.features, defaultOffset);
            map.flyTo({
                center: {
                    lng: lngLat[0],
                    lat: lngLat[1] + zoomOffsetLat
                },
                zoom: 7.7
            });
        } else {
            currentPopup = new mapboxgl.Popup()
                .setLngLat(getCords(clickEvent.features, defaultOffset))
                .setHTML(createPopUp(clickEvent.features))
                .addTo(map);
            clickEvent = null;
        }
    }

    function unclusteredPointZoomend(e)
    {
        if (clickEvent)
        {
            currentPopup = new mapboxgl.Popup()
                .setLngLat(getCords(clickEvent.features, 0.04))
                .setHTML(createPopUp(clickEvent.features))
                .addTo(map);
            clickEvent = null;
            $('.issue').click(function() {
                var id = $(this).attr('id');
                $('#issue-modal').modal('open');
                $('.submit-issue').click(function() {
                    $('#issue-modal').modal('close');
                })
            });
        }
    }

    map.on('load', function () {
        geoPointJSON.done(function(data) {
            groupList = data;
            groupNames = groupList.map(function(group) { return group.properties.name });
            $('.loader').remove();
            $('#search-field').prop('disabled', false);

            map.addSource('group-points', {
                type: 'geojson',
                data: {
                    type: 'FeatureCollection',
                    features: data
                },
                cluster: true,
                clusterMaxZoom: 14,
                clusterRadius: 35
            });

            map.addSource('ungrouped-points', {
                type: 'geojson',
                data: {
                    type: 'FeatureCollection',
                    features: data
                }
            });

            map.addLayer({
                id: 'group-clusters',
                type: 'circle',
                source: 'group-points',
                filter: ['has', 'point_count'],
                paint: {
                    'circle-color': {
                        property: 'point_count',
                        type: 'interval',
                        stops: [
                            [0, '#DAF7A6'],
                            [5, '#F1A3CD'],
                            [10, '#75cff0'],
                            [25, '#34B7A7'],
                            [50, '#F04950'],
                        ]
                    },
                    'circle-radius': {
                        property: 'point_count',
                        type: 'interval',
                        stops: [
                            [0, 20],
                            [5, 20],
                            [10, 30],
                            [25, 35],
                            [50, 40]
                        ]
                    }
                }
            });

            map.addLayer({
                id: 'cluster-count',
                type: 'symbol',
                source: 'group-points',
                filter: ['has', 'point_count'],
                layout: {
                    'text-field': '{point_count_abbreviated}',
                    'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
                    'text-size': 12
                }
            });

            map.addLayer({
                id: 'unclustered-local-point',
                type: 'symbol',
                source: 'group-points',
                filter: ['all', ['!has', 'point_count'], ['==', 'is_regional', false]],
                layout: {
                    'icon-image': 'slackgroup',
                    'icon-size': 1
                }
            });
            map.on('click', 'unclustered-local-point', unclusteredPointClicked);
            map.on('zoomend', 'unclustered-local-point', unclusteredPointZoomend);

            map.addLayer({
                id: 'unclustered-regional-point',
                type: 'symbol',
                source: 'group-points',
                filter: ['all', ['!has', 'point_count'], ['==', 'is_regional', true]],
                layout: {
                    'icon-image': 'regionalGroup',
                    'icon-size': 1
                }
            });
            map.on('click', 'unclustered-regional-point', unclusteredPointClicked);
            map.on('zoomend', 'unclustered-regional-point', unclusteredPointZoomend);

            map.on('click', 'group-clusters', function(e) {
                clickEvent = null;
                if(e.features[0].properties.point_count > 10) {
                    map.flyTo({
                        center: e.lngLat,
                        zoom: map.getZoom() + 1.75
                    });
                } else if(e.features[0].properties.point_count > 5) {
                    map.flyTo({
                        center: e.lngLat,
                        zoom: map.getZoom() + 2.0
                    });
                } else if(e.features[0].properties.point_count > 0) {
                    map.flyTo({
                        center: e.lngLat,
                        zoom: map.getZoom() + 3.0
                    });
                }
            });

            map.on('mouseenter', 'group-clusters', function () {
                map.getCanvas().style.cursor = 'pointer';
            });

            map.on('mouseleave', 'group-clusters', function () {
                map.getCanvas().style.cursor = '';
            });

            map.on('mouseenter', 'unclustered-local-point', function () {
                map.getCanvas().style.cursor = 'pointer';
            });

            map.on('mouseleave', 'unclustered-local-point', function () {
                map.getCanvas().style.cursor = '';
            });

            if (group && group.length !== 0)
            {
                unclusteredPointClicked(group);
            }
        });
    });
});

