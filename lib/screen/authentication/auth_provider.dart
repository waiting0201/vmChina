import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

import '../../model/models.dart';
import '../../model/repository.dart';

class AuthChangeProvider with ChangeNotifier {
  late bool _status = false;
  late bool _loading = false;
  late Member _member;

  bool get status => _status;
  bool get loading => _loading;
  Member get member => _member;

  AuthChangeProvider() {
    checkislogin();
  }

  Future<void> setLoading(bool value) async {
    _loading = value;
    notifyListeners();
  }

  Future<void> setStatus(bool value) async {
    _status = value;
    notifyListeners();
  }

  Future<void> setMember(dynamic value) async {
    //log(value.toString());

    _member = Member.fromMap(value);
    notifyListeners();
  }

  Future<void> refreshMember() async {
    HttpService httpService = HttpService();
    await httpService.getmemberbymemberid(member.memberid).then((value) async {
      var data = json.decode(value.toString());
      if (data["statusCode"] == 200) {
        await setMember(data["data"]);
      }
    });
  }

  Future<void> checkislogin() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String? token = pres.getString("access_token");
    String? refreshtoken = pres.getString("refresh_token");

    HttpService httpService = HttpService();

    Response response = await httpService.isauthenticated(token);

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      //需是重讀的會員資料
      await setMember(data["data"]);
      await setStatus(true);
    } else if (data["statusCode"] == 403) {
      Response refreshresponse = await httpService.refresh(refreshtoken);

      var refreshdata = json.decode(refreshresponse.toString());

      if (refreshdata["statusCode"] == 200) {
        await pres.setString(
            "access_token", refreshdata["data"]["token"]["access_token"]);
        await pres.setString(
            "refresh_token", refreshdata["data"]["token"]["refresh_token"]);

        await checkislogin();
      } else {
        await setStatus(false);
        await pres.clear();
      }
    } else {
      await setStatus(false);

      log('check islogin: false');
    }
  }

  Future<bool> signUp(String code, String password, String firstname,
      String lastname, int countryid, String mobile) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.signup(
          code, password, firstname, lastname, countryid, mobile);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> forget(String email) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.forget(email);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> update(
      String memberid,
      String firstname,
      String lastname,
      int? gender,
      int month,
      int day,
      int year,
      int? countryid,
      String? mobile) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.update(memberid, firstname,
          lastname, gender, month, day, year, countryid, mobile);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        await setLoading(false);

        return true;
      } else {
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setLoading(false);

      return false;
    }
  }

  Future<bool> updatepassword(String memberid, String password) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.updatepassword(memberid, password);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        await setLoading(false);

        return true;
      } else {
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setLoading(false);

      return false;
    }
  }

  Future<bool> signIn(String mobile, String password, bool ischeck) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      SharedPreferences pres = await SharedPreferences.getInstance();
      Response response = await httpService.login(mobile, password, ischeck);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        //如果有要記憶登入狀態
        if (ischeck) {
          await pres.setString(
              "access_token", data["data"]["token"]["access_token"]);
          await pres.setString(
              "refresh_token", data["data"]["token"]["refresh_token"]);
        }

        await setMember(data["data"]["member"]);
        await setStatus(true);
        await setLoading(false);

        return true;
      } else {
        await setStatus(false);
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setStatus(false);
      await setLoading(false);

      return false;
    }
  }

  Future<WeChatData?> wechatBinding(String code) async {
    log("code: $code");
    await setLoading(true);

    HttpService httpService = HttpService();
    SharedPreferences pres = await SharedPreferences.getInstance();
    Response response = await httpService.wechatbinding(code);

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      await pres.setString(
          "access_token", data["data"]["token"]["access_token"]);
      await pres.setString(
          "refresh_token", data["data"]["token"]["refresh_token"]);

      await setMember(data["data"]["member"]);

      await setStatus(true);
      await setLoading(false);

      return null;
    } else {
      await setStatus(false);
      await setLoading(false);

      return WeChatData(
          nickname: data["data"]["nickname"], unionid: data["data"]["unionid"]);
    }
  }

  Future<bool> wechatLogin(String email, String name, String unionid) async {
    await setLoading(true);

    HttpService httpService = HttpService();
    Response response = await httpService.wechatlogin(email, name, unionid);

    var data = json.decode(response.toString());

    if (data["statusCode"] == 200) {
      await setStatus(false);
      await setLoading(false);

      return true;
    } else {
      await setStatus(false);
      await setLoading(false);

      return false;
    }
  }

  Future<bool> logOut() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String? refreshtoken = pres.getString("refresh_token");

    HttpService httpService = HttpService();
    await httpService.logout(refreshtoken);

    await setStatus(false);
    await pres.remove("refresh_token");
    await pres.remove("access_token");

    return true;
  }

  Future<bool> disablemember(String memberid) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String? refreshtoken = pres.getString("refresh_token");

    HttpService httpService = HttpService();
    await httpService.disablemember(memberid, refreshtoken);

    await setStatus(false);
    await pres.remove("refresh_token");
    await pres.remove("access_token");

    return true;
  }

  Future<bool> disableautorenew(String membershipfeeid) async {
    HttpService httpService = HttpService();
    await httpService.postdisableautorenew(membershipfeeid);
    await refreshMember();

    return true;
  }

  Future<bool> resumeautorenew(String memberid, String brandmemberplanid,
      String membershipfeeid, String paymentmethodid) async {
    HttpService httpService = HttpService();
    await httpService.postresumeautorenew(
      memberid,
      brandmemberplanid,
      membershipfeeid,
      paymentmethodid,
    );
    await refreshMember();

    return true;
  }

  Future<bool> addShippingLocation(
      String memberid,
      int countryid,
      String postcode,
      String city,
      String district,
      String address,
      bool isdefault,
      String? state) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.addshippinglocation(
        memberid,
        countryid,
        postcode,
        city,
        district,
        address,
        isdefault,
        state,
      );

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        await setStatus(true);
        await setLoading(false);

        return true;
      } else {
        await setStatus(false);
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setStatus(false);
      await setLoading(false);

      return false;
    }
  }

  Future<bool> updateShippingLocation(
      String shippinglocationid,
      String memberid,
      int countryid,
      String postcode,
      String city,
      String district,
      String address,
      bool isdefault,
      String? state) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response = await httpService.updateshippinglocation(
        shippinglocationid,
        memberid,
        countryid,
        postcode,
        city,
        district,
        address,
        isdefault,
        state,
      );

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        await setStatus(true);
        await setLoading(false);

        return true;
      } else {
        await setStatus(false);
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setStatus(false);
      await setLoading(false);

      return false;
    }
  }

  Future<bool> deleteShippingLocation(String shippinglocationid) async {
    try {
      await setLoading(true);

      HttpService httpService = HttpService();
      Response response =
          await httpService.deleteshippinglocation(shippinglocationid);

      var data = json.decode(response.toString());

      if (data["statusCode"] == 200) {
        await setStatus(true);
        await setLoading(false);

        return true;
      } else {
        await setStatus(false);
        await setLoading(false);

        return false;
      }
    } catch (e) {
      await setStatus(false);
      await setLoading(false);

      return false;
    }
  }
}
