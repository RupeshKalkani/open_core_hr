import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';

class MyTimeLineScreen extends StatefulWidget {
  const MyTimeLineScreen({super.key});

  @override
  State<MyTimeLineScreen> createState() => _MyTimeLineScreenState();
}

class _MyTimeLineScreenState extends State<MyTimeLineScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  int _selectedMarkerIndex = 0;
  DateTime _selectedDate = DateTime.now();
  bool isMapView = true;

  final List<TimelineMarkerModel> _markerData = [
    TimelineMarkerModel(
        id: 1,
        type: 'check_in',
        latitude: 12.9716,
        longitude: 77.5946,
        title: 'Check-In',
        time: '09:00 AM',
        description: 'Employee started the day'),
    TimelineMarkerModel(
        id: 2,
        type: 'visit',
        latitude: 12.9750,
        longitude: 77.6050,
        title: 'Client Visit',
        time: '10:30 AM',
        description: 'Visited XYZ Company'),
    TimelineMarkerModel(
        id: 3,
        type: 'break_start',
        latitude: 12.9822,
        longitude: 77.6228,
        title: 'Break Start',
        time: '01:00 PM',
        description: 'Lunch Break Started'),
    TimelineMarkerModel(
        id: 4,
        type: 'break_stop',
        latitude: 12.9870,
        longitude: 77.6400,
        title: 'Break Stop',
        time: '01:30 PM',
        description: 'Lunch Break Ended'),
    TimelineMarkerModel(
        id: 5,
        type: 'visit',
        latitude: 12.9900,
        longitude: 77.6300,
        title: 'Client Visit',
        time: '03:00 PM',
        description: 'Visited ABC Corp'),
    TimelineMarkerModel(
        id: 6,
        type: 'travel',
        latitude: 12.9952,
        longitude: 77.6512,
        title: 'Travel Point',
        time: '03:45 PM',
        description: 'Traveled to new location'),
    TimelineMarkerModel(
        id: 7,
        type: 'check_out',
        latitude: 13.0000,
        longitude: 77.6600,
        title: 'Check-Out',
        time: '06:00 PM',
        description: 'Employee ended the day'),
  ];

  @override
  void initState() {
    super.initState();
    _loadMarkersAndPolylines();
  }

  void _loadMarkersAndPolylines() {
    _markers.clear();
    _polylines.clear();

    LatLng previousPoint =
        LatLng(_markerData.first.latitude, _markerData.first.longitude);

    for (int i = 0; i < _markerData.length; i++) {
      var markerData = _markerData[i];
      LatLng currentPoint = LatLng(markerData.latitude, markerData.longitude);

      _markers.add(
        Marker(
          markerId: MarkerId(markerData.id.toString()),
          position: currentPoint,
          infoWindow: InfoWindow(
              title: markerData.title, snippet: markerData.description),
          icon: _getMarkerIcon(markerData.type),
          onTap: () {
            setState(() => _selectedMarkerIndex = i);
          },
        ),
      );

      if (i > 0) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route_$i'),
            points: [previousPoint, currentPoint],
            color: appStore.appPrimaryColor,
            width: 4,
          ),
        );
      }
      previousPoint = currentPoint;
    }
  }

  BitmapDescriptor _getMarkerIcon(String type) {
    switch (type) {
      case 'check_in':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'check_out':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'break_start':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange);
      case 'break_stop':
        return BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueYellow);
      case 'visit':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _loadMarkersAndPolylines();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedMarker = _markerData[_selectedMarkerIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('My Timeline', style: boldTextStyle(size: 20)),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.calendar_1),
            onPressed: () => _selectDate(context),
            tooltip: 'Filter by Date',
          ),
          IconButton(
            icon: Icon(isMapView ? Icons.list : Iconsax.map),
            onPressed: () => setState(() => isMapView = !isMapView),
            tooltip: isMapView ? 'Switch to List View' : 'Switch to Map View',
          ),
        ],
      ),
      body: Stack(
        children: [
          isMapView ? _buildMapView(selectedMarker) : _buildListView(),
          if (isMapView) _buildTopDetails(selectedMarker),
          Positioned(
              bottom: 20, left: 16, right: 16, child: _buildBottomStats()),
        ],
      ),
    );
  }

  Widget _buildMapView(TimelineMarkerModel selectedMarker) {
    return GoogleMap(
      initialCameraPosition:
          const CameraPosition(target: LatLng(12.9716, 77.5946), zoom: 12),
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (controller) => _mapController = controller,
      myLocationEnabled: true,
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: _markerData.length,
      itemBuilder: (_, index) {
        final data = _markerData[index];
        return Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Icon(Iconsax.location, color: appStore.appPrimaryColor),
            title: Text(data.title, style: boldTextStyle(size: 16)),
            subtitle: Text('${data.description}\nTime: ${data.time}',
                style: secondaryTextStyle(size: 12)),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildTopDetails(TimelineMarkerModel selectedMarker) {
    return Positioned(
      top: 20,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: boxDecorationWithShadow(
          borderRadius: BorderRadius.circular(12),
          backgroundColor: white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(selectedMarker.title, style: boldTextStyle(size: 18)),
            4.height,
            Text(selectedMarker.description, style: primaryTextStyle(size: 14)),
            4.height,
            Text('Time: ${selectedMarker.time}',
                style: secondaryTextStyle(size: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStats() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: boxDecorationWithShadow(
        borderRadius: BorderRadius.circular(16),
        backgroundColor: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(Iconsax.map, 'Distance', '12 km'),
          _buildStatCard(Iconsax.profile_2user, 'Visits', '2 Clients'),
          _buildStatCard(Iconsax.clock, 'Working Hours', '6 hrs'),
          _buildStatCard(Iconsax.coffee, 'Breaks', '2 Times'),
        ],
      ),
    );
  }

  Widget _buildStatCard(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: appStore.appPrimaryColor, size: 28),
        6.height,
        Text(label, style: secondaryTextStyle(size: 12)),
        2.height,
        Text(value, style: boldTextStyle(size: 14)),
      ],
    );
  }
}

class TimelineMarkerModel {
  final int id;
  final String type;
  final double latitude;
  final double longitude;
  final String title;
  final String time;
  final String description;

  TimelineMarkerModel({
    required this.id,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.time,
    required this.description,
  });
}
