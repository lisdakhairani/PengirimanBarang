import 'package:flutter/material.dart';
import 'package:sampai/MySQL.dart';
import 'package:sampai/OrderCreate.dart';
import 'package:sampai/account.dart';

class OrderListWidget extends StatefulWidget {
  const OrderListWidget({super.key});

  @override
  State<OrderListWidget> createState() => _OrderListWidgetState();
}

class _OrderListWidgetState extends State<OrderListWidget> {
  final unfocusNode = FocusNode();

  final scaffoldKey = GlobalKey<ScaffoldState>();
  MySQL mysql = MySQL();

  List<String> Pesanan = [];

  @override
  void initState() {
    super.initState();
    Ambil_Pesanan();
  }

  @override
  void dispose() {
    unfocusNode.dispose();

    super.dispose();
  }

  void Ambil_Pesanan() async {
    List<String> result = [], end_order = [];

    result = await mysql.readDatabase(
        "SELECT * FROM pengiriman WHERE ID_Pengirim = '${account.No}' ORDER BY Status ASC;");

    for (int i = 0; i < result.length; i += 17) {
      end_order.add(
          "${result[i]}‽${result[i + 1]}‽${result[i + 2]}‽${result[i + 3]}‽${result[i + 4]}‽${result[i + 5]}‽${result[i + 6]}‽${result[i + 7]}‽${result[i + 8]}‽${result[i + 9]}‽${result[i + 10]}‽${result[i + 11]}‽${result[i + 12]}‽${result[i + 13]}‽${result[i + 14]}‽${result[i + 15]}‽${result[i + 16]}");
    }
    setState(() {
      Pesanan = end_order;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFFFFFFF),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 20, 0, 0),
                          child: Text(
                            'History Pengiriman',
                            style: TextStyle(
                                fontFamily: 'Outfit',
                                letterSpacing: 0,
                                fontSize: 24,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(24, 4, 0, 0),
                          child: Text(
                            'Daftar pesanan pengiriman paket',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontFamily: 'Readex Pro',
                              letterSpacing: 0,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              for (int i = 0; i < Pesanan.length; i++)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      16, 15, 16, 0),
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFE0E3E7),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            16, 12, 16, 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              flex: 4,
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 0, 12, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      textScaler:
                                                          MediaQuery.of(context)
                                                              .textScaler,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text: 'Resi #: ',
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF000000),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: Pesanan[i]
                                                                .split('‽')[0],
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFF4B39EF),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          )
                                                        ],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0, 4, 0, 0),
                                                      child: Text(
                                                        Pesanan[i]
                                                            .split('‽')[15],
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Readex Pro',
                                                          letterSpacing: 0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  Pesanan[i].split('‽')[14],
                                                  style: TextStyle(
                                                    fontFamily: 'Readex Pro',
                                                    color: Color(0xFF14181B),
                                                    fontSize: 18,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 5),
                                                  child: SizedBox(
                                                    width: 100,
                                                    height: 40,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                OrderCreateWidget(
                                                                    Order_IDs:
                                                                        Pesanan[
                                                                            i]),
                                                          ),
                                                        );
                                                      },
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Color(0xFF4B39EF),
                                                        elevation: 3,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                      child: Text(
                                                        Pesanan[i]
                                                            .split('‽')[1],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'Readex Pro',
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
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
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 15, 15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderCreateWidget(
                            Order_IDs: '',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      primary: Color(0xFF4B39EF),
                      side: BorderSide.none,
                    ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
