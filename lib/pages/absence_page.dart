import 'dart:io';
import 'package:aplikasi_absensi/components/digital_clock.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AbsencePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => AbsencePage());
  const AbsencePage({super.key});

  @override
  State<AbsencePage> createState() => _AbsencePageState();
}

class _AbsencePageState extends State<AbsencePage> {
  // reference the hive box
  final _myBox = Hive.box("mybox");

  String statusText = "Belum Absen";
  String status = 'Menunggu pengecekan lokasi...';
  String statusPhoto = '❌ Foto belum diambil';
  bool isValid = false;
  String address = 'Lokasi Tidak Ada';
  File? selfieImage;
  String userPhotoPath = '';

  // office coordinate (example: Jakarta)
  final double officeLat = -6.200000;
  final double officeLng = 106.816666;

  // current coordinate
  double currentLat = -6.199808541820199;
  double currentLng = 106.81705819857534;

  Future<void> askLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // making sure GPS enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        status = "GPS tidak aktif. Aktifkan GPS terlebih dahulu.";
      });
      return;
    }

    // ask location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          status = "Izin lokasi ditolak.";
        });
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      setState(() {
        status = "Izin lokasi ditolak permanen. Ubah di pengaturan.";
      });
      return;
    }
  }

  Future<void> checkCurrentLocation() async {
    // get user's current location
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high),
    );

    // change currentLat & currentLng
    setState(() {
      currentLat = position.latitude;
      currentLng = position.longitude;
    });

    // change coordinate to address
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];
    String completeAddress = "${place.street}";

    setState(() {
      address = completeAddress;
    });

    // calculate distance
    double distanceInMeters = Geolocator.distanceBetween(
      officeLat,
      officeLng,
      currentLat,
      currentLng,
    );

    // check if it's within radius
    if (distanceInMeters <= 100) {
      setState(() {
        status =
            "✅ Berada di area kantor (jarak: ${distanceInMeters.toStringAsFixed(2)} m)";
        isValid = true;
      });
    } else {
      setState(() {
        status =
            "❌ Di luar area kantor (jarak: ${distanceInMeters.toStringAsFixed(2)} m)";
        isValid = false;
      });
    }
  }

  Future<void> takeSelfie() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    if (photo != null) {
      setState(() {
        selfieImage = File(photo.path);
        userPhotoPath = photo.path;
        statusPhoto = '✅ Foto sudah diambil';
      });
    }
  }

  void saveNewAttendance() {
    _myBox.add({
      'dateTime': DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
      'latitude': currentLat,
      'longitude': currentLng,
      'photoPath': userPhotoPath,
    });

    setState(() {
      status = "✅ Absensi berhasil disimpan";

      // reset photo
      selfieImage = null;
      userPhotoPath = '';
      statusPhoto = '❌ Foto belum diambil';
    });

    // change status text
    checkAttendanceToday();
  }

  void checkAttendanceToday() async {
    // date format (YYYY-MM-DD) to easily compare
    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    bool alreadyCheckedIn = false;

    for (var i = 0; i < _myBox.length; i++) {
      var data = _myBox.getAt(i) as Map;
      String dateFromData = data["dateTime"].toString().split(' ')[0];
      if (dateFromData == today) {
        alreadyCheckedIn = true;
        break;
      }
    }

    setState(() {
      statusText = alreadyCheckedIn ? "Sudah Absen" : "Belum Absen";
    });
  }

  @override
  void initState() {
    super.initState();
    askLocationPermission();
    checkCurrentLocation();
    checkAttendanceToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance Page'), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // user's profile
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 15,
                  top: 14,
                  right: 5,
                  bottom: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // user's data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // name
                          Text(
                            'Andi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),

                          SizedBox(height: 2),

                          // digital clock
                          DigitalClock(),

                          SizedBox(height: 2),

                          // address
                          Text(address, overflow: TextOverflow.clip),
                        ],
                      ),
                    ),

                    // attendance status
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        statusText,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // location radius status
              Text(status, textAlign: TextAlign.center),

              SizedBox(height: 15),

              // take photo status
              Text(statusPhoto, textAlign: TextAlign.center),

              SizedBox(height: 20),

              // button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // take photo
                  ElevatedButton(
                    onPressed: takeSelfie,
                    child: Text("Ambil Foto Absensi"),
                  ),

                  SizedBox(width: 15),

                  // save attendance
                  ElevatedButton(
                    onPressed: isValid && selfieImage != null
                        ? saveNewAttendance
                        : null,
                    child: Text("Simpan Absensi"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
