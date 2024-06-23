import 'package:flutter/material.dart';
import 'package:sampai/MySQL.dart';
import 'package:sampai/OrderCreate.dart';
import 'package:sampai/OrderList.dart';
import 'package:sampai/account.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final unfocusNode = FocusNode();
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  MySQL mysql = MySQL();
  bool register = true;

  @override
  void initState() {
    super.initState();

    textController1 ??= TextEditingController();
    textFieldFocusNode1 ??= FocusNode();

    textController2 ??= TextEditingController();
    textFieldFocusNode2 ??= FocusNode();
  }

  @override
  void dispose() {
    unfocusNode.dispose();
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    super.dispose();
  }

  void Login_Register() async {
    List<String> result = [];
    if (textController1!.text.isEmpty || textController2!.text.isEmpty) {
      return;
    }
    result = await mysql.readDatabase(
        "SELECT ID FROM account WHERE Username = '${textController1!.text}' AND Password = '${textController2!.text}' AND Akses = 'Pelanggan'");
    if (result.isEmpty) {
      if (register) {
        await mysql.executeDatabase(
            "INSERT INTO account VALUES (DEFAULT, 'Pelanggan', '${textController1!.text}', '${textController2!.text}')");
        result = await mysql.readDatabase(
            "SELECT ID FROM account WHERE Username = '${textController1!.text}' AND Password = '${textController2!.text}'");

        setState(() {
          register = false;
          textController1 = TextEditingController(text: "");
          textController2 = TextEditingController(text: "");
        });
      } else {
        setState(() {
          textController1 = TextEditingController(text: "Akun Tidak Ditemukan");
          textController2 = TextEditingController(text: "");
        });
      }
      return;
    }
    account.No = result[0];
    account.Username = textController1!.text;
    account.Password = textController2!.text;

    Future.delayed(const Duration(seconds: 1), () async {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const OrderCreateWidget(Order_IDs: ""),
        ),
      );
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
        backgroundColor: Color(0xFFF1F4F8),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(50, 0, 50, 0),
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E3E7),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: Text(
                          'APLIKASI PENGIRIMAN',
                          style: TextStyle(
                            fontFamily: 'Open Sans',
                            fontSize: 18,
                            letterSpacing: 0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                            child: TextFormField(
                              controller: textController1,
                              focusNode: textFieldFocusNode1,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Masukkan Username...',
                                labelStyle: TextStyle(
                                  fontFamily: 'Open Sans',
                                  letterSpacing: 0,
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF57636C),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF4B39EF),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 0),
                              ),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(12, 15, 12, 0),
                            child: TextFormField(
                              controller: textController2,
                              focusNode: textFieldFocusNode2,
                              autofocus: true,
                              obscureText: false,
                              decoration: InputDecoration(
                                labelText: 'Masukkan Password...',
                                labelStyle: TextStyle(
                                  fontFamily: 'Open Sans',
                                  letterSpacing: 0,
                                ),
                                hintStyle: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0,
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF57636C),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF4B39EF),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                errorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFFF5963),
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                contentPadding: EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 0),
                              ),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: AlignmentDirectional(1, 1),
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 15, right: 15),
                          child: ElevatedButton(
                            onPressed: () {
                              Login_Register();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 0),
                              primary: Color(
                                  0xFF39D2C0), // Assuming secondary color is the accent color
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide.none,
                              ),
                            ),
                            child: Text(
                              register ? 'Register' : 'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Readex Pro',
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                      child: Text(
                        register ? 'Sudah punya akun ?' : 'Belum punya akun ?',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF14181B),
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          register = !register;
                          textController1 = TextEditingController(text: "");
                          textController2 = TextEditingController(text: "");
                        });
                      },
                      child: Text(
                        'Click disini',
                        style: TextStyle(
                          fontFamily: 'Readex Pro',
                          color: Color(0xFF4B39EF),
                          letterSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
