import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../Utils/app_widgets.dart';
import '../../main.dart';

class ClientMapComponent extends StatefulWidget {
  const ClientMapComponent({super.key});

  @override
  State<ClientMapComponent> createState() => _ClientMapComponentState();
}

class _ClientMapComponentState extends State<ClientMapComponent> {
  final LatLng _initialCameraPosition = const LatLng(20.5937, 78.9629);
  late GoogleMapController _controller;
  final Location locationService = Location();
  late StreamSubscription<LocationData> locationSubscription;
  late String _darkMapStyle;
  late String _lightMapStyle;
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
    _setMapStyle();
    locationSubscription = locationService.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!), zoom: 15),
        ),
      );
      addMarker(LatLng(l.latitude!, l.longitude!));
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    _loadMapStyles();
  }

  @override
  void dispose() {
    locationSubscription.cancel();
    super.dispose();
  }

  Future<void> addMarker(LatLng currentPosition) async {
    final icon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(36, 36)),
        'images/3d/location_pin.png');
    _markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(currentPosition.latitude, currentPosition.longitude),
        icon: icon, // Load your custom marker image from assets folder
        infoWindow: const InfoWindow(title: 'You are here'),
      ),
    );
  }

  Future _addMarkerLongPressed(LatLng latlang) async {
    setState(() {
      final MarkerId markerId = MarkerId("RANDOM_ID");
      Marker marker = Marker(
        markerId: markerId,
        draggable: true,
        position:
            latlang, //With this parameter you automatically obtain latitude and longitude
        infoWindow: const InfoWindow(
          title: "Marker here",
          snippet: 'This looks good',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );

      _markers.add(marker);
    });
  }

  Future _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle =
        await rootBundle.loadString('assets/map_styles/light.json');
  }

  Future _setMapStyle() async {
    if (appStore.isDarkModeOn) {
      await _controller.setMapStyle(_darkMapStyle);
    } else {
      await _controller.setMapStyle(_lightMapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: _initialCameraPosition),
      mapType: MapType.normal,
      minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
      onMapCreated: _onMapCreated,
      myLocationEnabled: false,
      myLocationButtonEnabled: true,
      markers: _markers,
      zoomControlsEnabled: false,
      onLongPress: (LatLng latLng) {
        toast('Click');
        _addMarkerLongPressed(latLng);
      },
    );
  }
}
