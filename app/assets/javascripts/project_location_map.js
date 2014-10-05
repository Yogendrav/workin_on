var gmap = null;
var myOptions =null;

function ProjectProfileMap(map, address){
  $.getJSON('http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false', null, function (data){
    geo_loc = data.results[0].geometry.location;
    latlng = new google.maps.LatLng(geo_loc.lat, geo_loc.lng);

    myOptions = {
      zoom: 14,
      center: latlng,
      mapTypeId: 'terrain'
    };
    gmap = new google.maps.Map(map, myOptions);
    // add marker on map
    marker = new google.maps.Marker({ position: latlng, map: gmap, title: address.toString() });
    drawProjectLocationArea(data.results[0].geometry);
    // google.maps.event.addListener(marker, 'click', function () {
    //   window.location.href = path
    // });
  });
}

function projectLocationMapWithHighlightedArea(map, addresses){
  ProjectProfileMap(map, addresses, "");
  $.getJSON('http://maps.googleapis.com/maps/api/geocode/json?address='+addresses+'&sensor=false', null, function (data){
    geometry = data.results.geometry;
    geo_loc = geometry.location
    latlng = new google.maps.LatLng(geo_loc.lat, geo_loc.lng);
    // add marker on map
    new google.maps.Marker({ position: latlng, map: gmap, title: data.results.formatted_address });
    drawProjectLocationArea(geometry);
  });
}

function drawProjectLocationArea(geometry){
  viewport = geometry.viewport;
  ne = viewport.northeast; // LatLng of the north-east corner
  sw = viewport.southwest; // LatLng of the south-west corder

  rectangle = new google.maps.Rectangle({
    strokeColor: '#bbbbbb', strokeOpacity: 1.0,
    strokeWeight: 5, fillColor: '#000',
    fillOpacity: 0.0, map: gmap,
    bounds: new google.maps.LatLngBounds(
      new google.maps.LatLng(sw.lat, sw.lng), new google.maps.LatLng(ne.lat, ne.lng)
    )
  });
}