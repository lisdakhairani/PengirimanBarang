import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceAPI {
  static String distance = "", duration = "";
  static List<LatLng> decodedPoints = [];

  Future<List<String>> getAddress(String input) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=id&types=geocode&key=AIzaSyDUJZU-Rn-s4WTY1dvWfwt4f0beyMXSXJU');

    final response = await http.get(url);
    List<String> descriptions = [];

    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody['status'] == 'OK') {
        final List<dynamic> predictions = jsonBody['predictions'];

        for (var prediction in predictions) {
          descriptions.add(prediction['description']);
        }

        return descriptions;
      } else {
        return descriptions;
      }
    } else {
      return descriptions;
    }
  }

  Future<Map<String, double>> getLatLng(String address) async {
    final encodedAddress = Uri.encodeComponent(address);
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$encodedAddress&key=AIzaSyDUJZU-Rn-s4WTY1dvWfwt4f0beyMXSXJU';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List<dynamic>;
      if (results.isNotEmpty) {
        final location = results[0]['geometry']['location'];
        final lat = location['lat'] as double;
        final lng = location['lng'] as double;
        return {'lat': lat, 'lng': lng};
      }
    }

    return {'lat': 0.0, 'lng': 0.0};
  }

  Future<void> takeRute(LatLng origin, LatLng destination) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&key=AIzaSyDUJZU-Rn-s4WTY1dvWfwt4f0beyMXSXJU';
    print(url);
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List<dynamic>;
      if (routes.isNotEmpty) {
        final points = routes[0]['overview_polyline']['points'];
        distance = routes[0]['legs'][0]['distance']['text'];
        duration = routes[0]['legs'][0]['duration']['text'];

        // Decode polyline points
        decodedPoints = decodePolyline(points);

        print('Distance: $distance, Duration: $duration');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  String calculateDeliveryPrice(String distanceText, bool formatteds) {
    double distanceInKm =
        double.parse(distanceText.replaceAll(RegExp(r'[^\d.]'), ''));

    double basePrice = 10000;
    double pricePerKm = 1000;

    double totalPrice = basePrice + (distanceInKm * pricePerKm);

    int roundedTotalPrice = totalPrice.round();

    if (formatteds) {
      String formattedPrice = 'Rp ' +
          roundedTotalPrice.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match match) => '${match[1]},',
              );

      return formattedPrice;
    } else {
      return "$roundedTotalPrice";
    }
  }
}
