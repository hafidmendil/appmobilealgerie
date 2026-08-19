import 'package:url_launcher/url_launcher.dart';
import 'dart:math' show cos, sqrt, asin;

class LocationService {
  /// Opens the native map application at the given coordinates.
  Future<void> openMap(double latitude, double longitude, {String? label}) async {
    final Uri googleMapsUri = Uri.parse("https://www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    final Uri appleMapsUri = Uri.parse("https://maps.apple.com/?q=$latitude,$longitude");

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(appleMapsUri)) {
      await launchUrl(appleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open map';
    }
  }

  /// Calculates the distance between two points in kilometers using Haversine formula.
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p) / 2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
