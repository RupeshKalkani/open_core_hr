import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';
import 'package:open_core_hr/utils/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MapHelper {
  Future<String?> getAddress(LatLng? location) async {
    try {
      final endpoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location?.latitude},${location?.longitude}'
          '&key=$mapsKey&language=en';

      final response = jsonDecode((await http.get(
        Uri.parse(endpoint),
      ))
          .body);

      return response['results'][0]['formatted_address'];
      /*  setState(() {

      _shortName =
            response['results'][0]['address_components'][1]['long_name'];
      }); */
    } catch (e) {
      log('Unable to get address$e');
    }
    return null;
  }

  Future<String?> getCurrentAddress() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    try {
      final endpoint =
          'https://maps.googleapis.com/maps/api/geocode/json?latlng=${currentLocation.latitude},${currentLocation.longitude}'
          '&key=$mapsKey&language=en';

      final response = jsonDecode((await http.get(
        Uri.parse(endpoint),
      ))
          .body);

      return response['results'][0]['formatted_address'];
      /*  setState(() {

      _shortName =
            response['results'][0]['address_components'][1]['long_name'];
      }); */
    } catch (e) {
      log('Unable to get address$e');
    }
    return null;
  }

  void launchMap(BuildContext context, double latitude, double longitude,
      String label) async {
    if (Platform.isIOS) {
      try {
        final url =
            Uri.parse('maps:$latitude,$longitude?q=$latitude,$longitude');
        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        } else {
          toast('Unable to launch map');
        }
      } catch (error) {
        if (context.mounted) {
          log(error.toString());
        }
      }
    } else {
      try {
        final url = Uri.parse(
            'geo:$latitude,$longitude?q=$latitude,$longitude($label)');
        await launchUrl(url);
      } catch (error) {
        if (context.mounted) {
          toast('Unable to launch map');
        }
      }
    }
  }
}
