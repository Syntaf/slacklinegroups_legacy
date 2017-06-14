mapboxgl.accessToken = 'pk.eyJ1Ijoic3ludGFmIiwiYSI6ImNqM2Z2bzZhbTAxZWwycW4wcmI5cjk4MW0ifQ.YOd5yuJfLARC2oOfqY-KoA'
var geoJSON = $.ajax({
    url: '/map/groups',
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


        geoJSON.done(function(data) {
            map.addLayer({
                'id': 'maine',
                'type': 'fill',
                'source': {
                    type: 'geojson',
                    data: {
                        type: 'FeatureCollection',
                        features: data
                    }
                },
                'layout': {},
                'paint': {
                    'fill-color': '#088',
                    'fill-opacity': 0.8
                }
            });
            // When a click event occurs on a feature in the states layer, open a popup at the
            // location of the click, with description HTML from its properties.
            map.on('click', 'maine', function (e) {
                new mapboxgl.Popup()
                    .setLngLat(e.lngLat)
                    .setHTML(e.features[0].properties.name)
                    .addTo(map);
            });

            // Change the cursor to a pointer when the mouse is over the states layer.
            map.on('mouseenter', 'maine', function () {
                map.getCanvas().style.cursor = 'pointer';
            });

            // Change it back to a pointer when it leaves.
            map.on('mouseleave', 'maine', function () {
                map.getCanvas().style.cursor = '';
            });
            // map.getSource('maine').setData({
            //     type: 'FeatureCollection',
            //     features: [data]
            // });
        });


    });
};

