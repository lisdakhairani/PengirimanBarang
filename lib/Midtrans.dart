import "dart:convert";
import "package:http/http.dart" as http;

class Midtrans {
  Future<String> createPaymentLink(int Price) async {
    final String midtransApiUrl = "https://api.midtrans.com/v1/payment-links";
    final String midtransApiKey =
        "TWlkLXNlcnZlci13MnZiOVVJV3cyWDNrT29kXzk5SnNuVU06";

    Map<String, dynamic> transactionDetails = {
      "transaction_details": {
        "order_id": "0-${getTime()}",
        "gross_amount": Price
      },
      "customer_required": true,
      "usage_limit": 1,
      "expiry": {"duration": 1, "unit": "hours"},
      "item_details": [
        {"id": "1", "name": "Pengiriman Barang", "price": Price, "quantity": 1}
      ],
      "custom_field1": "Pengiriman Barang",
      "custom_field2": "1",
    };

    // Kirim permintaan HTTP POST ke API Midtrans
    final http.Response response = await http.post(
      Uri.parse(midtransApiUrl),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization": "Basic $midtransApiKey",
      },
      body: jsonEncode(transactionDetails),
    );

    // Proses respon
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Respon sukses
      print(response.body);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String paymentLink = responseData["payment_url"];
      return paymentLink;
    } else {
      // Respon gagal
      print(
          "Failed to create payment link: ${response.statusCode}\n${response.body}");
      throw Exception(
          "Failed to create payment link: ${response.statusCode}\n$response");
    }
  }

  String getTime() {
    DateTime now = DateTime.now();
    String year = now.year.toString();
    String month = now.month.toString().padLeft(2, "0");
    String day = now.day.toString().padLeft(2, "0");
    String hour = now.hour.toString().padLeft(2, "0");
    String minute = now.minute.toString().padLeft(2, "0");
    String second = now.second.toString().padLeft(2, "0");

    return "$year.$month.$day.$hour.$minute.$second";
  }
}
