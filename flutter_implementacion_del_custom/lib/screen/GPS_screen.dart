import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GPSScreen extends StatefulWidget {
  const GPSScreen({super.key});

  @override
  State<GPSScreen> createState() => _GPSScreenState();
}

class _GPSScreenState extends State<GPSScreen> {
  String coordenadas = "Presiona el botón para obtener tu ubicación";

  Future<void> obtenerUbicacion() async {
    bool servicioActivo;
    LocationPermission permiso;

    servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      setState(() {
        coordenadas = "GPS desactivado. Actívalo e intenta de nuevo.";
      });
      return;
    }

    permiso = await Geolocator.checkPermission();

    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        setState(() {
          coordenadas = "Permiso denegado.";
        });
        return;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      setState(() {
        coordenadas =
            "El permiso está bloqueado permanentemente. Ve a configuración.";
      });
      return;
    }

    Position posicion = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      coordenadas =
          "Latitud: ${posicion.latitude}\nLongitud: ${posicion.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GPS - Coordenadas")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              coordenadas,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: obtenerUbicacion,
              child: const Text("Obtener mi ubicación"),
            ),
          ],
        ),
      ),
    );
  }
}
