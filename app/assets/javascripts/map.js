mapboxgl.accessToken = 'pk.eyJ1Ijoic3ludGFmIiwiYSI6ImNqM2Z2bzZhbTAxZWwycW4wcmI5cjk4MW0ifQ.YOd5yuJfLARC2oOfqY-KoA'

zoomThresh = 2;

var createPopUp = function(f) {
    console.log(f);
    return `
        <p class="title">${f[0].properties.name}</p>
        <hr>
        <p class="label">Last recorded member count:</p>
        <p class="members">${f[0].properties.members}</p>
        <a href="">Visit on Facebook</a>
    `;
}

var geoJSON = $.ajax({
    url: '/map/groups',
    dataType: 'json'
});

var geoPointJSON = $.ajax({
    url: '/map/pointclouds',
    dataType: 'json'
});

window.onload = function() {
    var map = new mapboxgl.Map({
        center: [0, 35],
        zoom: 1.75,
        container: 'map',
        style: 'mapbox://styles/syntaf/cj3rys2fx000q2qodb7zlbh2v'
    });

    $(".button-collapse").sideNav();

    map.on('load', function () {
        geoPointJSON.done(function(data) {
            console.log(data);
            map.addLayer({
                id: 'group-clusters',
                type: 'circle',
                source: {
                    type: 'geojson',
                    data: {
                        type: 'FeatureCollection',
                        features: data
                    }
                },
                filter: ['has', 'point_count'],
                paint: {
                    'circle-color': {
                        property: 'point_count',
                        type: 'interval',
                        stops: [
                            [0, "#51bbd6"],
                            [100, "#f1f075"],
                            [750, "#f28cb1"],
                        ]
                    },
                    "circle-radius": {
                        property: "point_count",
                        type: "interval",
                        stops: [
                            [0, 20],
                            [100, 30],
                            [750, 40]
                        ]
                    }
                }
            });

            map.addLayer({
                id: "cluster-count",
                type: "symbol",
                source: {
                    type: 'geojson',
                    data: {
                        type: 'FeatureCollection',
                        features: data
                    }
                },
                filter: ["has", "point_count"],
                layout: {
                    "text-field": "{point_count_abbreviated}",
                    "text-font": ["DIN Offc Pro Medium", "Arial Unicode MS Bold"],
                    "text-size": 12
                }
            });

            map.addLayer({
                id: "unclustered-point",
                type: "circle",
                source: {
                    type: 'geojson',
                    data: {
                        type: 'FeatureCollection',
                        features: data
                    }
                },
                filter: ["!has", "point_count"],
                paint: {
                    "circle-color": "#11b4da",
                    "circle-radius": 4,
                    "circle-stroke-width": 1,
                    "circle-stroke-color": "#fff"
                }
            });
        });
        geoJSON.done(function(data) {
            map.addLayer({
                'id': 'group-locations',
                'type': 'fill',
                'source': {
                    type: 'geojson',
                    data: {
                        type: 'FeatureCollection',
                        features: data
                    }
                },
                'layout': {
                    'visibility': 'none'
                },
                'paint': {
                    'fill-color': '#088',
                    'fill-opacity': 0.8
                }
            });

            // When a click event occurs on a feature in the states layer, open a popup at the
            // location of the click, with description HTML from its properties.
            map.on('click', 'group-locations', function (e) {
                new mapboxgl.Popup()
                    .setLngLat(e.lngLat)
                    .setHTML(createPopUp(e.features))
                    .addTo(map);
            });

            // Change the cursor to a pointer when the mouse is over the states layer.
            map.on('mouseenter', 'group-locations', function () {
                map.getCanvas().style.cursor = 'pointer';
            });

            // Change it back to a pointer when it leaves.
            map.on('mouseleave', 'group-locations', function () {
                map.getCanvas().style.cursor = '';
            });

            map.on('zoom', function() {
                if(map.getZoom() < zoomThresh) {
                    map.setLayoutProperty('group-locations', 'visibility', 'none');
                } else {
                    map.setLayoutProperty('group-locations', 'visibility', 'visible');
                }
            });
        });
    });
};

