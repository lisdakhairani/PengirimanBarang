import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sampai/Midtrans.dart';
import 'package:sampai/OrderList.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:sampai/PlaceAPI.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sampai/MySQL.dart';
import 'package:sampai/account.dart';

class OrderCreateWidget extends StatefulWidget {
  final String Order_IDs;
  const OrderCreateWidget({super.key, required this.Order_IDs});

  @override
  State<OrderCreateWidget> createState() => _OrderCreateWidgetState();
}

class _OrderCreateWidgetState extends State<OrderCreateWidget> {
  final unfocusNode = FocusNode();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = GlobalKey(),
      key2 = GlobalKey();
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode5;
  TextEditingController? textController5;
  String? Function(BuildContext, String?)? textController5Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode6;
  TextEditingController? textController6;
  String? Function(BuildContext, String?)? textController6Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode7;
  TextEditingController? textController7;
  String? Function(BuildContext, String?)? textController7Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode8;
  TextEditingController? textController8;
  String? Function(BuildContext, String?)? textController8Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode9;
  TextEditingController? textController9;
  String? Function(BuildContext, String?)? textController9Validator;
  // State field(s) for TextField widget.

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  bool reviewers = false;

  PlaceAPI placeAPI = PlaceAPI();
  MySQL mysql = MySQL();
  List<String> Addresses1 = [], Addresses2 = [];
  String Lokasi1 = "", Lokasi2 = "";
  Timer? help_delay1, help_delay2;

  String distance = "", duration = "", biaya = "";
  List<LatLng> decodedPoints = [];

  LatLng? pengambilan, pengantaran, perjalanan;

  @override
  void initState() {
    super.initState();

    textController1 ??= TextEditingController();
    textFieldFocusNode1 ??= FocusNode();

    textController2 ??= TextEditingController();
    textFieldFocusNode2 ??= FocusNode();

    textController3 ??= TextEditingController();
    textFieldFocusNode3 ??= FocusNode();

    textController4 ??= TextEditingController();
    textFieldFocusNode4 ??= FocusNode();

    textController5 ??= TextEditingController();
    textFieldFocusNode5 ??= FocusNode();

    textController6 ??= TextEditingController();
    textFieldFocusNode6 ??= FocusNode();

    textController7 ??= TextEditingController();
    textFieldFocusNode7 ??= FocusNode();

    textController8 ??= TextEditingController();
    textFieldFocusNode8 ??= FocusNode();

    textController9 ??= TextEditingController();
    textFieldFocusNode9 ??= FocusNode();
    if (widget.Order_IDs.isNotEmpty) {
      review_Order();
    }
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();

    textFieldFocusNode5?.dispose();
    textController5?.dispose();

    textFieldFocusNode6?.dispose();
    textController6?.dispose();

    textFieldFocusNode7?.dispose();
    textController7?.dispose();

    textFieldFocusNode8?.dispose();
    textController8?.dispose();

    textFieldFocusNode9?.dispose();
    textController9?.dispose();

    super.dispose();
  }

  void review_Order() async {
    List<String> Datas = widget.Order_IDs.split('‽');
    setState(() {
      reviewers = true;
      textController1 = TextEditingController(text: Datas[2]);
      textController2 = TextEditingController(text: Datas[3]);
      textController3 = TextEditingController(text: Datas[5]);
      textController4 = TextEditingController(text: Datas[6]);
      textController5 = TextEditingController(text: Datas[7]);
      textController6 = TextEditingController(text: Datas[8]);
      textController7 = TextEditingController(text: Datas[9]);
      textController8 = TextEditingController(text: Datas[10]);
      biaya = Datas[14];
      pengambilan = LatLng(double.parse(Datas[16]), double.parse(Datas[17]));
      pengantaran = LatLng(double.parse(Datas[18]), double.parse(Datas[19]));
      distance = Datas[22];
      duration = Datas[23];
    });
    Future.delayed(Duration(seconds: 2), _fitMarkers);
  }

  void AddressList(
      String address, GlobalKey<AutoCompleteTextFieldState<String>> key) async {
    var addresses = await placeAPI.getAddress(address);

    setState(() {
      final autoCompleteState = key.currentState;
      if (autoCompleteState != null) {
        autoCompleteState.updateSuggestions(addresses);
      }
    });
  }

  void _fitMarkers() async {
    if (pengambilan == null && pengantaran == null || _mapController == null)
      return;
    print("ye");
    LatLngBounds bounds = _calculateBounds();

    _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));

    if (pengambilan != null && pengantaran != null) {
      await placeAPI.takeRute(pengambilan!, pengantaran!);
      setState(() {
        distance = PlaceAPI.distance;
        duration = PlaceAPI.duration;
        biaya = placeAPI.calculateDeliveryPrice(distance, true);
        textController9 = TextEditingController(text: biaya);
        decodedPoints = PlaceAPI.decodedPoints;
      });
    }
  }

  LatLngBounds _calculateBounds() {
    double minLat = double.infinity;
    double minLng = double.infinity;
    double maxLat = -double.infinity;
    double maxLng = -double.infinity;

    for (LatLng? marker in [pengambilan, pengantaran]) {
      if (marker == null) continue;

      double lat = marker.latitude;
      double lng = marker.longitude;

      minLat = min(lat, minLat);
      minLng = min(lng, minLng);
      maxLat = max(lat, maxLat);
      maxLng = max(lng, maxLng);
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  void Buat_Pesanan() async {
    List<String> result = await mysql.readDatabase("SELECT No FROM pengiriman");
    int No_Pesanan = buatNo_Pesanan(result);
    Random random = Random();
    result = await mysql
        .readDatabase("SELECT ID FROM account WHERE Akses = 'Kurir'");
    String ID_Kurir = result[random.nextInt(result.length)];
    await mysql.executeDatabase(
        "INSERT INTO pengiriman VALUES('$No_Pesanan', 'Sedang Dikirim', '${textController1!.text}', '${textController2!.text}', '${textController1!.text}', '${textController3!.text}', '${textController4!.text}', '${textController5!.text}', '${textController6!.text}', '${textController7!.text}', '${textController8!.text}', '', '${account.No}', '$ID_Kurir', '$biaya', CURRENT_TIMESTAMP(), '${pengambilan!.latitude}‽${pengambilan!.longitude}‽${pengantaran!.latitude}‽${pengantaran!.longitude}‽null‽null‽$distance‽$duration')");
    print(
        "INSERT INTO pengiriman VALUES('$No_Pesanan', 'Dikirim', '${textController1!.text}', '${textController2!.text}', '${textController1!.text}', '${textController3!.text}', '${textController4!.text}', '${textController5!.text}', '${textController6!.text}', '${textController7!.text}', '${textController8!.text}', '', '${account.No}', '$ID_Kurir', '$biaya', CURRENT_TIMESTAMP(), '${pengambilan!.latitude}‽${pengambilan!.longitude}‽${pengantaran!.latitude}‽${pengantaran!.longitude}‽null‽null‽$distance‽$duration')");
    Midtrans midtrans = Midtrans();
    String paymentLink = await midtrans.createPaymentLink(
        int.parse(placeAPI.calculateDeliveryPrice(distance, false)));
    Uri uri = Uri.parse(paymentLink);
    await launchUrl(uri);
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderListWidget(),
        ),
      );
    });
  }

  int buatNo_Pesanan(List<String> exclusionList) {
    Random random = Random();
    int? randomNumber;
    do {
      randomNumber = 1000000000 + random.nextInt(99999999);
    } while (exclusionList.contains(randomNumber.toString()));
    return randomNumber;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF1F4F8),
        appBar: AppBar(
          backgroundColor: Color(0xFF4B39EF),
          automaticallyImplyLeading: false,
          title: Text(
            'Buat Pesanan',
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Colors.white,
              fontSize: 22,
              letterSpacing: 0,
            ),
          ),
          actions: [],
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(-1.5824545477351275, 113.71842186361921),
                      zoom: 2,
                    ),
                    markers: {
                      if (pengambilan != null)
                        Marker(
                          markerId: MarkerId('pengambilan'),
                          position: pengambilan!,
                          onTap: () async {
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    pengambilan!.latitude,
                                    pengambilan!.longitude);
                            Placemark place = placemarks[0];
                            print("${place}");
                          },
                        ),
                      if (pengantaran != null)
                        Marker(
                          markerId: MarkerId('pengantaran'),
                          position: pengantaran!,
                          onTap: () async {
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                    pengantaran!.latitude,
                                    pengantaran!.longitude);
                            Placemark place = placemarks[0];
                            print(
                                "${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}");
                          },
                        ),
                    },
                    polylines: Set<Polyline>.of([
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: decodedPoints,
                        color: Colors.blue,
                        width: 5,
                      ),
                    ]),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 0),
                    child: Text(
                      'Data Pengiriman Barang',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF14181B),
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: AutoCompleteTextField<String>(
                    key: key1,
                    controller: textController1,
                    submitOnSuggestionTap: true,
                    clearOnSubmit: false,
                    focusNode: textFieldFocusNode1,
                    decoration: InputDecoration(
                      labelText: 'Pilih Titik Pengambilan Paket',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                    suggestions: Addresses1,
                    itemBuilder: (BuildContext context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    itemSubmitted: (String suggestion) async {
                      final coordinates = await placeAPI.getLatLng(suggestion);
                      setState(() {
                        pengambilan =
                            LatLng(coordinates['lat']!, coordinates['lng']!);
                        _fitMarkers();
                      });
                    },
                    itemFilter: (String suggestion, String query) => true,
                    itemSorter: (String a, String b) => 0,
                    textChanged: (String value) {
                      if (reviewers) return;
                      if (help_delay1?.isActive ?? false) help_delay1!.cancel();
                      help_delay1 =
                          Timer(const Duration(milliseconds: 2500), () {
                        // Call AddressList after a delay of 500 milliseconds
                        AddressList(value, key1);
                      });
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: AutoCompleteTextField<String>(
                    key: key2,
                    controller: textController2,
                    submitOnSuggestionTap: true,
                    clearOnSubmit: false,
                    focusNode: textFieldFocusNode2,
                    decoration: InputDecoration(
                      labelText: 'Pilih Titik Pengiriman Paket',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                    suggestions: Addresses2,
                    itemBuilder: (BuildContext context, String suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    itemSubmitted: (String suggestion) async {
                      final coordinates = await placeAPI.getLatLng(suggestion);
                      setState(() {
                        pengantaran =
                            LatLng(coordinates['lat']!, coordinates['lng']!);
                        _fitMarkers();
                      });
                    },
                    itemFilter: (String suggestion, String query) => true,
                    itemSorter: (String a, String b) => 0,
                    textChanged: (String value) {
                      if (reviewers) return;
                      if (help_delay2?.isActive ?? false) help_delay2!.cancel();
                      help_delay2 =
                          Timer(const Duration(milliseconds: 2500), () {
                        // Call AddressList after a delay of 500 milliseconds
                        AddressList(value, key2);
                      });
                    },
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 0),
                    child: Text(
                      'Informasi Paket',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF14181B),
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController3,
                    focusNode: textFieldFocusNode3,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Berat paket (gram)',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController4,
                    focusNode: textFieldFocusNode4,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi isi paket',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 0),
                    child: Text(
                      'Informasi Pengirim dan Penerima',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF14181B),
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController5,
                    focusNode: textFieldFocusNode5,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Nama Pengirim',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController6,
                    focusNode: textFieldFocusNode6,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Kontak Pengirim',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController7,
                    focusNode: textFieldFocusNode7,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Nama Penerima',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController8,
                    focusNode: textFieldFocusNode8,
                    autofocus: false,
                    obscureText: false,
                    enabled: reviewers ? false : true,
                    decoration: InputDecoration(
                      labelText: 'Kontak Penerima',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 12, 0, 0),
                    child: Text(
                      'Biaya Layanan ',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Color(0xFF14181B),
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(12, 5, 12, 0),
                  child: TextFormField(
                    controller: textController9,
                    focusNode: textFieldFocusNode9,
                    autofocus: false,
                    readOnly: true,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Tarif pengiriman',
                      labelStyle: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      hintStyle: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Color(0xFF57636C),
                        letterSpacing: 0,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF57636C),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFF4B39EF),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color(0xFFFF5963),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding:
                          EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    ),
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF14181B),
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (!reviewers)
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OrderListWidget(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF4B39EF),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              'Batal',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Buat_Pesanan();
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF4B39EF),
                            elevation: 3,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Container(
                            width: MediaQuery.sizeOf(context).width * 0.3,
                            height: 40,
                            alignment: Alignment.center,
                            child: Text(
                              'Buat Pesanan',
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                letterSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
