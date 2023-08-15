import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_fyp/provider/location_provider.dart';
import 'package:provider/provider.dart';

class GoogleMapPage extends StatefulWidget {
  @override
  State<GoogleMapPage> createState() => _GoogleMapPagetState();
}

class _GoogleMapPagetState extends State<GoogleMapPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false).initalization();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Google Map Live Tracking"),
          backgroundColor: Colors.redAccent,
        ),
        body: googleMapUI());
  }

  Widget googleMapUI() {
    return Consumer<LocationProvider>(
      builder: (consumerContext, model, child) {
        if (model.locationPosition != null) {
          return Column(children: [
            Expanded(
                child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition:
                  CameraPosition(target: model.locationPosition, zoom: 18),
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              markers: Set<Marker>.of(model.markers.values),
              onMapCreated: (GoogleMapController controller) {},
            ))
          ]);
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
