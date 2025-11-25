import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../utils/app_widgets.dart';

class MapComponent extends StatefulWidget {
  const MapComponent({super.key});

  @override
  State<MapComponent> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
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
    _loadMapStyles();
    init();
  }

  init() async {}

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
    return SizedBox(
      height: context.height() / 2,
      child: Card(
        elevation: 5,
        shape: buildCardCorner(),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: _initialCameraPosition),
          mapType: MapType.normal,
          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
          onMapCreated: _onMapCreated,
          myLocationEnabled:false,
          myLocationButtonEnabled: false,
          markers: _markers,
          zoomControlsEnabled: false,
          onLongPress: (LatLng latLng) {
            toast('Click');
            addMarker(latLng);
          },
        ).cornerRadiusWithClipRRect(16),
      ).paddingOnly(top: 70),
    );
  }
}
