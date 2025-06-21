import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationAccessScreen extends StatefulWidget {
  const LocationAccessScreen({super.key});

  @override
  _LocationAccessScreenState createState() => _LocationAccessScreenState();
}

class _LocationAccessScreenState extends State<LocationAccessScreen> {
  String _locationMessage = "Grant location access to find nearby farmers.";
  bool _isLoading = false;

  Future<void> _requestLocationPermission() async {
    setState(() {
      _isLoading = true;
      _locationMessage = "Requesting location permissions...";
    });

    LocationPermission permission;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationMessage = "Location permissions are denied.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationMessage = "Location permissions are permanently denied. Please enable them in your device settings.";
          _isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        // Permissions granted, you can now get the location
        setState(() {
          _locationMessage = "Location permissions granted!";
          _isLoading = false;
        });
        // TODO: Implement logic to get location and navigate to next screen
      }
    } catch (e) {
      setState(() {
        _locationMessage = "Error requesting location permissions: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Access'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _locationMessage,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            ),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _requestLocationPermission,
                child: Text('Grant Location Access'),
              ),
          ],
        ),
      ),
    );
  }
}