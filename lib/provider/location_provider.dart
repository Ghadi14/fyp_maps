import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider with ChangeNotifier {
  BitmapDescriptor _pinlocationIcon;
  BitmapDescriptor get pinLocationIcon => _pinlocationIcon;
  Map<MarkerId, Marker> _markers;
  Map<MarkerId, Marker> get markers => _markers;

  final MarkerId markerId = MarkerId("1");

  Location _location;
  Location get location => _location;
  LatLng _locationPosition;
  LatLng get locationPosition => _locationPosition;

  LatLng _locationPositionMarker;
  bool markerSet = false;

  bool locationServiceActive = true;

  LocationProvider() {
    _location = new Location();
  }

  initalization() async {
    await getUserLocation();
    await setCustomMapPin();
  }

  getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      _locationPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      if (currentLocation != null && markerSet == false) {
        _locationPositionMarker =
            LatLng(currentLocation.latitude, currentLocation.longitude);
        markerSet = true;
      }
      print('current location: ${_locationPosition}');

      _markers = <MarkerId, Marker>{};

      Marker marker = Marker(
          markerId: markerId,
          position: LatLng(_locationPositionMarker.latitude,
              _locationPositionMarker.longitude),
          icon: pinLocationIcon,
          draggable: true,
          onDragEnd: ((newPosition) {
            _locationPositionMarker = LatLng(_locationPositionMarker.latitude,
                _locationPositionMarker.longitude);
            notifyListeners();
          }));

      _markers[markerId] = marker;
      notifyListeners();
    });
  }

  setCustomMapPin() async {
    _pinlocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 1), 'assets/marker.png');
  }
}
