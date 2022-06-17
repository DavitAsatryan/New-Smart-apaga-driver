import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:http_parser/http_parser.dart';

import 'package:firebase_device_id/firebase_device_id.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

class UserRepository {
  static String tokenF = "";
  static String exeptionText = "";
  static const String baseURL = 'http://159.223.29.24';
  static var api_url = baseURL + '/api/customer';
  static var orderAPI = 'https://jsonplaceholder.typicode.com/posts';

  Future<void> refreshToken(String refresh) async {
    dynamic token = await FlutterSession().get('token');
    Map<String, String> mapData = {"refreshToken": refresh};
    var respose = await http.post(
      Uri.parse(baseURL + '/refresh'),
      headers: <String, String>{
        'content-type': "application/json; charset=utf-8",
      },
      body: jsonEncode(mapData),
    );
    var body = jsonDecode(respose.body);
    if (respose.statusCode == 200) {
      var refresh = body['accessToken'];

      await FlutterSession().set('token', refresh);
    }
  }

  Future<bool> register(UserRegister userRegister) async {
    var respose = await http.post(
      Uri.parse(baseURL + '/signup'),
      headers: <String, String>{
        'content-type': "application/json; charset=utf-8",
      },
      body: jsonEncode(userRegister.toDatabaseJson()),
    );

    var body = jsonDecode(respose.body);
    if (respose.statusCode == 201) {
      print("register status Code 201__");

      return true;
    } else {
      exeptionText = body.toString();
      throw Exception(json.decode(respose.body));
    }
  }

  Future<bool> login(UserLogin userLogin) async {
    dynamic token = await FlutterSession().get('token');
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    print(prefs);
    var response = await http.post(
      Uri.parse(baseURL + '/login'),
      headers: <String, String>{
        "content-type": "application/json; charset=utf-8"
      },
      body: jsonEncode(userLogin.toDatabaseJson()),
    );
    var body = jsonDecode(response.body);
    var data = body['token'];
    var refresh = body['refreshToken'];

    print(data);
    // print("responce body  ${response.body}");
    if (response.statusCode == 200) {
      print("Login statusCode 200");
      await FlutterSession().set('token', data);
      await FlutterSession().set('refreshToken', refresh);
      return true;
      // dynamic token = data['accessToken'];
    } else {
      exeptionText = body.toString();
      print(exeptionText);
      throw Exception(json.decode(response.body));
    }
  }

  Future<bool> phoneNumberSend(PhoneNumberModel phoneNumber) async {
    dynamic token = await FlutterSession().get('token');
    var response = await http.post(
      Uri.parse(baseURL + '/forgot'),
      headers: <String, String>{
        'content-type': 'application/json',
      },
      body: jsonEncode(phoneNumber.toDatabaseJson()),
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("PhoneNumber statusCode 200");
      return true;
      //await FlutterSession().set('token', token);
    } else {
      exeptionText = body.toString();
      throw Exception(json.decode(response.body));
    }
  }

  Future<bool> pinCodeSend(PinCodeModel pinCode) async {
    var response = await http.post(
      Uri.parse(baseURL + '/codeConfirm'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(pinCode.toDatabaseJson()),
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("PinCode statusCode 200");
      return true;
    } else {
      exeptionText = body.toString();
      throw Exception(json.decode(response.body));
    }
  }

  Future<dynamic> passwordNewSend(PasswordNew newPassword) async {
    var response = await http.put(
      Uri.parse(baseURL + '/storeNewPassword'),
      headers: <String, String>{
        'content-type': 'application/json',
      },
      body: jsonEncode(newPassword.toDatabaseJson()),
    );
    return response;
  }

  Future<void> confirm(int id) async {
    print(id);
    dynamic token = await FlutterSession().get('token');
    var response = await http.get(
      Uri.parse(baseURL + '/takeDailyPickup/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token'
      },
    );
    if (response.statusCode == 200) {
      print("Confirm statusCode 200");
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      confirm(id);
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  ///
  Future profileSend(ProfileModel profileSendText) async {
    dynamic token = await FlutterSession().get('token');

    var response = await http.post(Uri.parse(baseURL + '/PersonalData'),
        headers: <String, String>{
          'content-type': 'application/json',
          'auth-token': '$token'
        },
        body: jsonEncode(
          profileSendText.toDatabaseJson(),
        ));

    if (response.statusCode == 200) {
      print(response);
      return true;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      profileSend(profileSendText);
    }
    //exeptionText = body.toString();
    // throw Exception(json.decode(response.body));
  }

  Future<List<ProfileModel>> profileDataGet() async {
    List<ProfileModel> listModel = [];
    dynamic token = await FlutterSession().get('token');
    var response = await http.get(
      Uri.parse(baseURL + '/personalPage'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token'
      },
    );
    dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("PasswordChange statusCode 200");

      for (var element in (body['personalData'] as List)) {
        ProfileModel model = ProfileModel.fromJson(element);
        listModel.add(model);
        print(listModel);
      }

      return listModel;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return profileDataGet();
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<bool> passwordChange(PasswordChange passwordChangeText) async {
    dynamic token = await FlutterSession().get('token');
    var response = await http.put(
      Uri.parse(baseURL + '/changePassword'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token'
      },
      body: jsonEncode(passwordChangeText.toDatabaseJson()),
    );
    if (response.statusCode == 200) {
      print("PasswordChange statusCode 200");

      return true;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return passwordChange(passwordChangeText);
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<bool> qrCounterAndReasonModel(
      QrCounterAndReasonModel counterAndResasonText) async {
    dynamic token = await FlutterSession().get('token');
    var response = await http.post(
      Uri.parse(baseURL + '/finish'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token',
      },
      body: jsonEncode(counterAndResasonText.toDatabaseJson()),
    );
    //var body = jsonDecode(response.body);
    print("responce body  ${response.body}");
    if (response.statusCode == 200) {
      print("counterAndResason statusCode 200");
      return true;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return qrCounterAndReasonModel(counterAndResasonText);
    } else {
      throw Exception(json.decode(response.body));
    }
  }

  Future<bool> qrCodeSend(QrCodeSendModel qrCodeSendModel) async {
    dynamic token = await FlutterSession().get('token');
    var response = await http.post(
      Uri.parse(baseURL + '/qr'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token',
      }, //
      body: jsonEncode(qrCodeSendModel.toDatabaseJson()),
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("QrCodeSend statusCode 200");
      return true;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return qrCodeSend(qrCodeSendModel);
    } else {
      exeptionText = body.toString();
      throw Exception(json.decode(response.body));
    }
  }

  Future filtrdSendData(
      FiltrModel unassignedText, String api_url, String urlHost) async {
    dynamic token = await FlutterSession().get('token');
    var response = await http.post(
      Uri.parse(api_url + urlHost),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(unassignedText.toDatabaseJson()),
    );
    var body = jsonDecode(response.body);
    var data = body['data'];
    print("responce body  ${response.body}");
    if (response.statusCode == 200) {
      print("filtrdSendData statusCode 200");
      String token = data['access_token'];
      await FlutterSession().set('token', token);
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return filtrdSendData(unassignedText, api_url, urlHost);
    } else {
      throw Exception(json.decode(response.body));
    }
  }

// Notifications
  Future<List<NotificationModel>> notification() async {
    List<NotificationModel> notificationList = [];
    dynamic token = await FlutterSession().get('token');

    var response = await http.get(
      Uri.parse(baseURL + '/getNotifications/?notificationId='),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'auth-token': '$token'
      },
    );
    dynamic body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("Notification statusCode____200");
      for (var element in (body["allFoundNotifications"] as List)) {
        NotificationModel notificationModel =
            NotificationModel.fromJson(element);
        notificationList.add(notificationModel);
      }
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return notification();
    } else {
      throw Exception(json.decode(response.body));
    }

    return notificationList;
  }

  // Future sendSections(List<String> names) async {
  //   dynamic rToken = await FlutterSession().get('refreshToken');
  //   refreshToken(rToken);
  //   print("sections Names $names");
  //   var response = await http.post(
  //     Uri.parse('https://jsonplaceholder.typicode.com/albums/$names'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //   );
  //   var body = jsonDecode(response.body);
  //   if (response.statusCode == 200) {
  //     print(" statusCode____200");
  //     var data = body['data'];
  //     String token = data['access_token'];
  //     await FlutterSession().set('token', token);
  //   }
  // }

  Future<bool> deleteItem(List<int> id) async {
    dynamic token = await FlutterSession().get('token');
    print(id);
    //List<int> id
    Map<String, List<int>> mapData = {"notificationId": id};
    var response = await http.delete(
      Uri.parse(baseURL + "/deleteNotifications/"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': '$token'
      },
      body: jsonEncode(mapData),
    );
    var body = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("notiDelete statusCode____200");
      return true;
    } else if (response.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return deleteItem(id);
    }
    return false;
  }

  Future<List<OrderModel>> pickups(List section, int index) async {
    dynamic token = await FlutterSession().get('token');
    List<OrderModel> orderList = [];
    if (index == 1 || index == 2) {
      print("index $index");
      Map<String, List> mapData = {"customer_address": section};
      var respose = await http.post(
        Uri.parse(baseURL + "/dailyPickup"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'auth-token': '$token'
        },
        body: jsonEncode(mapData),
      );
      dynamic body = jsonDecode(respose.body);

      if (respose.statusCode == 200 && index == 1) {
        print("index $index");
        print("Order statusCode____200");
        for (var element in (body['pickups'] as List)) {
          OrderModel orderModel = OrderModel.fromJson(element);
          orderList.add(orderModel);
        }
      }
      if (respose.statusCode == 200 && index == 2) {
        print("index $index");
        print("Order statusCode____200");
        for (var element in (body['dailyPickups'] as List)) {
          OrderModel orderModel = OrderModel.fromJson(element);
          orderList.add(orderModel);
        }
      } else if (respose.statusCode == 401) {
        dynamic rToken = await FlutterSession().get('refreshToken');
        await refreshToken(rToken);
        return pickups(section, index);
      }
    }

    return orderList;
  }

//LISTS add new dat.....
  Future<List<OrderModel>> orderMassage(List sections, int index) async {
    dynamic token = await FlutterSession().get('token');
    List<OrderModel> orderList = [];
    // if (index == 1 || index == 2) {
    //   print("index $index");
    //   Map<String, List> mapData = {"customer_address": sections};
    //   var respose = await http.post(
    //     Uri.parse(baseURL + "/dailyPickup"),
    //     headers: <String, String>{
    //       'Content-Type': 'application/json; charset=UTF-8',
    //       'Accept': '*/*',
    //       'auth-token': '$token'
    //     },
    //     body: jsonEncode(mapData),
    //   );
    //   dynamic body = jsonDecode(respose.body);
    //   if (respose.statusCode == 200 && index == 1) {
    //     print("index $index");
    //     print("Order statusCode____200");
    //     (body['pickups'] as List).forEach((element) {
    //       OrderModel orderModel = OrderModel.fromJson(element);
    //       orderList.add(orderModel);
    //     });
    //   }
    //   if (respose.statusCode == 200 && index == 2) {
    //     print("index $index");
    //     print("Order statusCode____200");
    //     (body['dailyPickups'] as List).forEach((element) {
    //       OrderModel orderModel = OrderModel.fromJson(element);
    //       orderList.add(orderModel);
    //     });
    //   }
    // }
    if (index == 3) {
      print("index my $index");
      Map<String, List> mapData = {"customer_address": sections};
      var respose = await http.post(
        Uri.parse(baseURL + "/MyDailyPickups"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'auth-token': '$token'
        },
        body: jsonEncode(mapData),
      );
      dynamic body = jsonDecode(respose.body);
      if (respose.statusCode == 200) {
        print("myOrders statusCode____200");
        for (var element in (body['pickups'] as List)) {
          OrderModel orderModel = OrderModel.fromJson(element);
          orderList.add(orderModel);
        }
      } else if (respose.statusCode == 401) {
        dynamic rToken = await FlutterSession().get('refreshToken');
        await refreshToken(rToken);
        return orderMassage(sections, index);
      }
    }
    if (index == 4) {
      print("index $index");
      Map<String, List> mapData = {"customer_address": sections};
      var respose = await http.post(
        Uri.parse(baseURL + "/MyDailyPickups"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': '*/*',
          'auth-token': '$token'
        },
        body: jsonEncode(mapData),
      );
      dynamic body = jsonDecode(respose.body);
      if (respose.statusCode == 200) {
        print("myOrders filtr statusCode____200");
        for (var element in (body['myDailyPickups'] as List)) {
          OrderModel orderModel = OrderModel.fromJson(element);
          orderList.add(orderModel);
        }
      } else if (respose.statusCode == 401) {
        dynamic rToken = await FlutterSession().get('refreshToken');
        await refreshToken(rToken);
        return orderMassage(sections, index);
      }
    }
    return orderList;
  }

  Future<List<OrderModel>> ordersListGet(String status) async {
    dynamic token = await FlutterSession().get('token');
    print(status);
    List<OrderModel> orderList = [];
    orderList.clear();
    var respose = await http.get(
      Uri.parse(baseURL + "/myPickupsByStatus/$status"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': '$token'
      },
    );
    dynamic body = jsonDecode(respose.body);
    if (respose.statusCode == 200) {
      for (var element in (body['pickups'] as List)) {
        OrderModel orderGetModel = OrderModel.fromJson(element);
        orderList.add(orderGetModel);
      }
    } else if (respose.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return ordersListGet(status);
    }
    return orderList;
  }

  Future<List<OrderModel>> seeMoreData(int id) async {
    dynamic token = await FlutterSession().get('token');
    print(id);
    List<OrderModel> orderList = [];
    orderList.clear();
    var respose = await http.get(
      //url ??
      Uri.parse(baseURL + "/dailyPickup/seeMore/$id"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'auth-token': '$token'
      },
    );
    dynamic body = jsonDecode(respose.body);
    if (respose.statusCode == 200) {
      for (var element in (body['pickups'] as List)) {
        OrderModel orderModelSeeMore = OrderModel.seeMoreDaily(element);
        orderList.add(orderModelSeeMore);
      }
    } else if (respose.statusCode == 401) {
      dynamic rToken = await FlutterSession().get('refreshToken');
      await refreshToken(rToken);
      return seeMoreData(id);
    }

    return orderList;
  }
}

class UserLogin {
  String phoneNumber;
  String password;
  String firebase_token;
  UserLogin(
      {required this.phoneNumber,
      required this.password,
      required this.firebase_token});
  Map<String, dynamic> toDatabaseJson() => {
        "phone_number": this.phoneNumber,
        "password": this.password,
        "firebase_token": this.firebase_token,
      };
}

class PhoneNumberModel {
  String phoneNumber;
  PhoneNumberModel({required this.phoneNumber});
  Map<String, dynamic> toDatabaseJson() => {
        "phone_number": this.phoneNumber,
      };
}

class PinCodeModel {
  String pinCode;
  String phoneNumber;
  PinCodeModel({required this.pinCode, required this.phoneNumber});
  Map<String, dynamic> toDatabaseJson() => {
        "code": this.pinCode,
        "phoneNumber": this.phoneNumber,
      };
}

class PasswordNew {
  String phoneNumber;
  String newPassword;
  PasswordNew({required this.phoneNumber, required this.newPassword});
  Map<String, dynamic> toDatabaseJson() => {
        "phone_number": this.phoneNumber,
        "newPassword": this.newPassword,
      };
}

class ConfirmModel {
  int confirmId;
  ConfirmModel({required this.confirmId});
  Map<String, dynamic> toDatabaseJson() => {
        "pickup_id": this.confirmId,
      };
}

class QrCounterAndReasonModel {
  int pickup_id;
  String comment_driver;
  String status;
  QrCounterAndReasonModel(
      {required this.pickup_id,
      required this.comment_driver,
      required this.status});
  Map<String, dynamic> toDatabaseJson() => {
        "pickup_id": this.pickup_id,
        "comment_driver": this.comment_driver,
        "status": this.status,
      };
}

class QrCodeSendModel {
  String qrCode;
  String id;
  QrCodeSendModel({required this.qrCode, required this.id});
  Map<String, dynamic> toDatabaseJson() => {
        "qr_code": this.qrCode,
        "pickup_id": this.id,
      };
}

class FiltrModel {
  String unassignedText;
  FiltrModel({required this.unassignedText});
  Map<String, dynamic> toDatabaseJson() => {
        "UnassignedModel": this.unassignedText,
      };
}

class UserRegister {
  String fullName;
  String phoneNumber;
  String carNumber;
  String carName;
  String carColor;
  String carCapacity;
  String password;
  String firebase_token;

  UserRegister({
    required this.fullName,
    required this.phoneNumber,
    required this.carNumber,
    required this.carName,
    required this.carColor,
    required this.carCapacity,
    required this.password,
    required this.firebase_token,
  });
  Map<String, dynamic> toDatabaseJson() => {
        "fullName": this.fullName,
        "phone_number": this.phoneNumber,
        "carNumber": this.carNumber,
        "carName": this.carName,
        "carColor": this.carColor,
        "carCapacity": this.carCapacity,
        "password": this.password,
        "firebase_token": this.firebase_token,
      };
}

class PasswordChange {
  String oldPassword;
  String newPassword;
  PasswordChange({
    required this.oldPassword,
    required this.newPassword,
  });
  Map<String, dynamic> toDatabaseJson() => {
        "oldPassword": this.oldPassword,
        "newPassword": this.newPassword,
      };
}

class ProfileModel {
  int? id;
  dynamic avatar;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  int? idD;
  int? userId;
  List<Vehicles>? vehicles;

  ProfileModel({
    this.id,
    required this.avatar,
    required this.firstname,
    required this.lastname,
    required this.phoneNumber,
    this.userId,
    this.idD,
    required this.vehicles,
  });

  ProfileModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNumber = json['phone_number'];
    idD = json['driver']['id'];
    userId = json['driver']['user_id'];
    vehicles = [];
    (json['driver']['vehicles'] as List).forEach((element) {
      print(element);

      vehicles!.add(Vehicles.fromJson(element));
    });
    // for (var element in (json['driver']['vehicles'] as List)) {

    // }
  }
  Map<String, dynamic> toDatabaseJson() => {
        "avatar": this.avatar,
        "firstname": this.firstname,
        "lastname": this.lastname,
        "phone_number": this.phoneNumber,
        // "title": this.title,
        // "color": this.color,
        // "volume": this.volume,
      };
}

class Vehicles {
  int? id;
  int? driver_id;
  String? license_plate;
  String? title;
  String? color;
  String? volume;
  Vehicles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    driver_id = json['driver_id'];
    license_plate = json['license_plate'];
    title = json['title'];
    color = json['color'];
    volume = json['volume'];
  }
}

class OrderModel {
  var pickup_id;
  String? order_date;
  String? order_start_time;
  String? order_time_end;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  String? customerAddress;
  dynamic customer_address;

  String? building;
  String? apartment;
  String? entrance;
  String? floor;
  String? coordinateType;
  List? coordinates;
  int? customer_id;
  int? address_id;
  String? comment_customer;
  String? status;
  int? quantity;
  int? price;
  List? waste_type;
  int paper = 0;
  int plastic = 0;
  int glass = 0;
  int? bagsCounter;
  bool hideButton = false;
  bool colorMenu = false;
  bool navigQR = true;
  String textNext = "Ավարտել";
  OrderModel(
      {required this.pickup_id,
      required this.order_date,
      required this.order_start_time,
      required this.order_time_end,
      required this.firstname,
      required this.lastname,
      required this.phoneNumber,
      required this.customer_address,
      required this.building,
      required this.apartment,
      required this.entrance,
      required this.floor,
      required this.coordinateType,
      required this.coordinates,
      required this.comment_customer,
      required this.quantity,
      required this.price,
      required this.status,
      required this.waste_type});
  OrderModel.fromJson(Map<dynamic, dynamic> json) {
    pickup_id = json['id'];
    status = json['status'];
    order_start_time = json['order_start_time'];
    order_time_end = json['order_time_end'];
    customer_id = json['customer_id'];
    address_id =
        json['address_id']; //Address.fromJson(json['customer_address'])
    customer_address = json['address']['customer_address'];
    print("customer_address  $customer_address");
    if (json['Pickup_bags'] != null) {
      waste_type = [];
      for (var element in (json['Pickup_bags'] as List)) {
        waste_type!.add(element);
      }
    }
    quantity = json['quantity'];
    price = json['price'];
  }
  OrderModel.seeMoreDaily(Map<dynamic, dynamic> json) {
    status = json['status'];
    order_date = json['order_date'];
    order_start_time = json['order_start_time'];
    order_time_end = json['order_time_end'];
    customer_id = json['customer_id'];
    address_id = json['address_id'];
    comment_customer = json['comment_customer'];
    customer_address = json['address']['customer_address'];
    building = json['address']['building'];
    apartment = json['address']['apartment'];
    entrance = json['address']['entrance'];
    floor = json['address']['floor'];
    coordinateType = json['address']['coordinate']['type'];
    if (json['address']['coordinate']['coordinates'] != null) {
      coordinates = [];
      for (var element
          in (json['address']['coordinate']['coordinates'] as List)) {
        coordinates!.add(element);
      }
    }

    if (json['Pickup_bags'] != null) {
      waste_type = [];
      for (var element in (json['Pickup_bags'] as List)) {
        waste_type!.add(element);
      }
    }
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNumber = json['phone_number'];
    quantity = json['quantity'];
    price = json['price'];
    // Map<dynamic, dynamic> toDatabaseJson() {
    //   final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    //   data['userId'] = this.userId;
    //   data['id'] = this.id;
    //   data['title'] = this.title;
    //   data['body'] = this.body;
    //   return data;
    // }
  }
  // OrderModel.fromJsonSeeMore(Map<dynamic, dynamic> json) {
  //   pickup_id = json['id'];
  //   status = json['status'];
  //   order_date = json['order_date'];
  //   order_start_time = json['order_start_time'];
  //   order_time_end = json['order_time_end'];
  //   customer_id = json['customer_id'];
  //   address_id = json['address_id'];
  //   comment_customer = json['comment_customer'];
  //   customer_address = Address.fromJson(json['address']);
  //   if (json['Pickup_bags'] != null) {
  //     waste_type = [];
  //     (json['Pickup_bags'] as List).forEach((element) {
  //       waste_type!.add(element);
  //     });
  //   }
  //   firstname = json['firstname'];
  //   lastname = json['lastname'];
  //   phoneNumber = json['phone_number'];
  //   quantity = json['quantity'];
  //   price = json['price'];
  //   // Map<dynamic, dynamic> toDatabaseJson() {
  //   //   final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
  //   //   data['userId'] = this.userId;
  //   //   data['id'] = this.id;
  //   //   data['title'] = this.title;
  //   //   data['body'] = this.body;
  //   //   return data;
  //   // }
  // }
}

class OrderGettingModel {
  var pickup_id;
  String? order_date;
  String? order_start_time;
  String? order_time_end;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  String? customer_address;
  String? comment_customer;
  int? quantity;
  String? status;
  List? waste_type;
  OrderGettingModel(
      {required this.pickup_id,
      required this.order_date,
      required this.order_start_time,
      required this.order_time_end,
      required this.firstname,
      required this.lastname,
      required this.phoneNumber,
      required this.customer_address,
      required this.comment_customer,
      required this.quantity,
      required this.status,
      required this.waste_type});
  OrderGettingModel.fromJson(Map<dynamic, dynamic> json) {
    pickup_id = json['pickup_id'];
    order_date = json['order_date'];
    order_start_time = json['order_start_time'];
    order_time_end = json['order_time_end'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    phoneNumber = json['phoneNumber'];
    customer_address = json['customer_address'];
    comment_customer = json['comment_customer'];
    quantity = json['quantity'];
    status = json['status'];
    if (json['waste_type'] != null) {
      waste_type = [];
      for (var element in (json['waste_type'] as List)) {
        waste_type!.add(element);
      }
    }
  }
}

class NotificationModel {
  var id;
  var user_id;
  var notification;
  var createdAt;

  bool check = false;
  NotificationModel(
      {required this.id,
      required this.user_id,
      required this.notification,
      required this.createdAt});
  NotificationModel.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    user_id = json['user_id'];
    notification = json['notification'];
    createdAt = json['createdAt'];
  }
}
