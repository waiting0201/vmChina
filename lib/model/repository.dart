import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpService {
  late Dio _dio;
  late String? accessToken = "";

  final apiKey = "!@#qwe";
  //final baseUrl = "https://api.vetrinamia.com.cn/api";
  final baseUrl = "https://vmhkdemo-api.azurewebsites.net/api";

  HttpService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
    ));

    initializeInterceptors();
  }

  Future<String> getLanguage() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String languageid = pres.getString("languageid") ?? "";
    return languageid;
  }

  Future<Response> signup(String email, String password, String firstname,
      String lastname, int countryid, String mobile) async {
    Response response = await _dio.post('/auth/signup', queryParameters: {
      "email": email,
      "password": password,
      "firstname": firstname,
      "lastname": lastname,
      "countryid": countryid,
      "mobile": mobile,
    });

    return response;
  }

  Future<Response> forget(String email) async {
    Response response = await _dio.post('/auth/forget', queryParameters: {
      "email": email,
    });

    return response;
  }

  Future<Response> login(String email, String password, bool ischeck) async {
    Response response = await _dio.post('/auth/signin', queryParameters: {
      "email": email,
      "password": password,
      "ischeck": ischeck,
    });

    return response;
  }

  Future<Response> sociallogin(String socialid, String socialemail,
      String socialname, String socialvendor) async {
    Response response = await _dio.post('/auth/sociallogin', queryParameters: {
      "socialid": socialid,
      "socialemail": socialemail,
      "socialname": socialname,
      "socialvendor": socialvendor,
    });

    return response;
  }

  Future<Response> wechatbinding(String code) async {
    Response response =
        await _dio.post('/auth/wechatbinding', queryParameters: {
      "code": code,
    });

    return response;
  }

  Future<Response> wechatlogin(
      String email, String name, String unionid) async {
    Response response = await _dio.post('/auth/wechatlogin', queryParameters: {
      "email": email,
      "name": name,
      "unionid": unionid,
    });

    return response;
  }

  Future<Response> isauthenticated(String? token) async {
    accessToken = token;
    Response response = await _dio.post('/auth/isauthenticated');

    return response;
  }

  Future<Response> refresh(String? refreshtoken) async {
    Response response = await _dio.post('/auth/refresh', queryParameters: {
      "refreshtoken": refreshtoken,
    });

    return response;
  }

  Future<Response> logout(String? refreshtoken) async {
    Response response = await _dio.post('/auth/logout', queryParameters: {
      "refreshtoken": refreshtoken,
    });

    return response;
  }

  Future<Response> disablemember(String memberid, String? refreshtoken) async {
    Response response =
        await _dio.post('/auth/disablemember', queryParameters: {
      "memberid": memberid,
      "refreshtoken": refreshtoken,
    });

    return response;
  }

  Future<Response> update(
    String memberid,
    String firstname,
    String lastname,
    int? gender,
    int month,
    int day,
    int year,
    int? countryid,
    String? mobile,
  ) async {
    Response response = await _dio.post('/auth/update', queryParameters: {
      "memberid": memberid,
      "firstname": firstname,
      "lastname": lastname,
      "gender": gender,
      "month": month,
      "day": day,
      "year": year,
      "countryid": countryid,
      "mobile": mobile,
    });

    return response;
  }

  Future<Response> updatepassword(String memberid, String password) async {
    Response response =
        await _dio.post('/auth/updatepassword', queryParameters: {
      "memberid": memberid,
      "password": password,
    });

    return response;
  }

  Future<Response> getmemberbymemberid(String memberid) async {
    Response response =
        await _dio.post('/auth/getmemberbymemberid', queryParameters: {
      "memberid": memberid,
    });

    return response;
  }

  Future<Response> getmembershipfeelists(
      String memberid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/auth/getmembershipfeelists', queryParameters: {
      "memberid": memberid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> postaddmemberproduct(
    String memberid,
    String productid,
  ) async {
    Response response =
        await _dio.post('/auth/postaddmemberproduct', queryParameters: {
      "memberid": memberid,
      "productid": productid,
    });

    return response;
  }

  Future<Response> postaddmemberbrand(
    String memberid,
    String brandid,
  ) async {
    Response response =
        await _dio.post('/auth/postaddmemberbrand', queryParameters: {
      "memberid": memberid,
      "brandid": brandid,
    });

    return response;
  }

  Future<Response> addshippinglocation(
      String memberid,
      int countryid,
      String postcode,
      String city,
      String district,
      String address,
      bool isdefault,
      String? state) async {
    Response response =
        await _dio.post('/auth/addshippinglocation', queryParameters: {
      "memberid": memberid,
      "countryid": countryid,
      "postcode": postcode,
      "state": state,
      "city": city,
      "district": district,
      "address": address,
      "isdefault": isdefault,
    });

    return response;
  }

  Future<Response> updateshippinglocation(
      String shippinglocationid,
      String memberid,
      int countryid,
      String postcode,
      String city,
      String district,
      String address,
      bool isdefault,
      String? state) async {
    Response response =
        await _dio.post('/auth/updateshippinglocation', queryParameters: {
      "shippinglocationid": shippinglocationid,
      "memberid": memberid,
      "countryid": countryid,
      "postcode": postcode,
      "state": state,
      "city": city,
      "district": district,
      "address": address,
      "isdefault": isdefault,
    });

    return response;
  }

  Future<Response> deleteshippinglocation(String shippinglocationid) async {
    Response response =
        await _dio.post('/auth/deleteshippinglocation', queryParameters: {
      "shippinglocationid": shippinglocationid,
    });

    return response;
  }

  Future<Response> getshippinglocationlistsbymemberid(
      String memberid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/auth/getshippinglocationlistsbymemberid', queryParameters: {
      "memberid": memberid,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getpaymentmethodbyawid(String awid) async {
    Response response =
        await _dio.post('/auth/getpaymentmethodbyawid', queryParameters: {
      "awid": awid,
    });
    return response;
  }

  Future<Response> getmemberproductlists(
      String memberid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/auth/getmemberproductlists', queryParameters: {
      "memberid": memberid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> removememberproduct(
      String memberid, String productid) async {
    Response response =
        await _dio.post('/auth/removememberproduct', queryParameters: {
      "memberid": memberid,
      "productid": productid,
    });

    return response;
  }

  Future<Response> getmemberbrandlists(
      String memberid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/auth/getmemberbrandlists', queryParameters: {
      "memberid": memberid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> removememberbrand(String memberid, String brandid) async {
    Response response =
        await _dio.post('/auth/removememberbrand', queryParameters: {
      "memberid": memberid,
      "brandid": brandid,
    });

    return response;
  }

  Future<Response> gethomebannerlists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/homebanner/gethomebannerlists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getbrandlists(
      int skip, int take, String? k, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/brand/getbrandlists', queryParameters: {
      "skip": skip,
      "take": take,
      "k": k,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getpublishstatusbrandlists(
      int publishstatus, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/brand/getpublishstatusbrandlists', queryParameters: {
      "publishstatus": publishstatus,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getbrandlistsstartwithkeyword(
      String k, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/brand/getbrandlistsstartwithkeyword', queryParameters: {
      "k": k,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getbrandbyid(String brandid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/brand/getbrandbyid', queryParameters: {
      "brandid": brandid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getbrandmediasbyid(String brandid) async {
    Response response =
        await _dio.post('/brand/getbrandmediasbyid', queryParameters: {
      "brandid": brandid,
    });

    return response;
  }

  Future<Response> getstorymediasbyid(String brandid) async {
    Response response =
        await _dio.post('/brand/getstorymediasbyid', queryParameters: {
      "brandid": brandid,
    });

    return response;
  }

  Future<Response> getdesignerbyid(
      String designerid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/designer/getdesignerbyid', queryParameters: {
      "designerid": designerid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getdesignermediasbyid(String designerid) async {
    Response response =
        await _dio.post('/designer/getdesignermediasbyid', queryParameters: {
      "designerid": designerid,
    });

    return response;
  }

  Future<Response> getdesignerlistsbybrandid(
      String brandid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/designer/getdesignerlistsbybrandid', queryParameters: {
      "brandid": brandid,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getdesignervideolists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/designer/getdesignervideolists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> postdesignermessage(String memberid, String designerid,
      String name, String email, String message) async {
    Response response =
        await _dio.post('/designer/postdesignermessage', queryParameters: {
      "memberid": memberid,
      "designerid": designerid,
      "name": name,
      "email": email,
      "message": message,
    });
    return response;
  }

  Future<Response> getcategorylists(String? brandid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/category/getcategorylists', queryParameters: {
      "brandid": brandid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getcategorybrandlists(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/category/getcategorybrandlists', queryParameters: {
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getcategorypopularbrandlists(
      String categoryid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/brand/getcategorypopularbrandlists', queryParameters: {
      "categoryid": categoryid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getcategoryallbrandlists(String categoryid) async {
    Response response =
        await _dio.post('/brand/getcategorybrandlists', queryParameters: {
      "categoryid": categoryid,
    });

    return response;
  }

  Future<Response> getsubcategoryallbrandlists(String subcategoryid) async {
    Response response =
        await _dio.post('/brand/getsubcategorybrandlists', queryParameters: {
      "subcategoryid": subcategoryid,
    });

    return response;
  }

  Future<Response> getfaqlists(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post('/faq/getfaqlists', queryParameters: {
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getlaws(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post('/faq/getlaws', queryParameters: {
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getlawbyid(int id, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post('/faq/getlawbyid', queryParameters: {
      "id": id,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getlegals(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post('/faq/getlegals', queryParameters: {
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getlatesteventlists(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/event/getlatesteventlists', queryParameters: {
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> geteventmediasbyid(String eventid) async {
    Response response =
        await _dio.post('/event/geteventmediasbyid', queryParameters: {
      "eventid": eventid,
    });

    return response;
  }

  Future<Response> getnewcampaignlists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/campaign/getnewcampaignlists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getcampaignlistsbybrandid(
      String brandid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/campaign/getcampaignlistsbybrandid', queryParameters: {
      "brandid": brandid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getcampaignlistswithoutselfbybrandid(String brandid,
      String campaignid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post(
        '/campaign/getcampaignlistswithoutselfbybrandid',
        queryParameters: {
          "brandid": brandid,
          "campaignid": campaignid,
          "skip": skip,
          "take": take,
          "languageid": languageid,
        });
    return response;
  }

  Future<Response> getcampaignmediasbyid(String campaignid) async {
    Response response =
        await _dio.post('/campaign/getcampaignmediasbyid', queryParameters: {
      "campaignid": campaignid,
    });

    return response;
  }

  Future<Response> getnewcollectionlists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/collection/getnewcollectionlists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getpublishstatuscollectionlists(
      int publishstatus, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/collection/getpublishstatuscollectionlists', queryParameters: {
      "publishstatus": publishstatus,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getcollectionlistsbybrandid(
      String brandid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/collection/getcollectionlistsbybrandid', queryParameters: {
      "brandid": brandid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getcollectionlistswithoutselfbybrandid(String brandid,
      String collectionid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post(
        '/collection/getcollectionlistswithoutselfbybrandid',
        queryParameters: {
          "brandid": brandid,
          "collectionid": collectionid,
          "skip": skip,
          "take": take,
          "languageid": languageid,
        });
    return response;
  }

  Future<Response> getcollectionmediasbyid(String collectionid) async {
    Response response = await _dio
        .post('/collection/getcollectionmediasbyid', queryParameters: {
      "collectionid": collectionid,
    });

    return response;
  }

  Future<Response> getmanufacturelistsbyproductid(
      String productid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/manufacture/getmanufacturelistsbyproductid', queryParameters: {
      "productid": productid,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getlatestwhatsnew(String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/whatsnew/getlatestwhatsnew', queryParameters: {
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getwhatsnewlists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/whatsnew/getwhatsnewlists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getwhatsnewmediasbyid(String whatsnewid) async {
    Response response =
        await _dio.post('/whatsnew/getwhatsnewmediasbyid', queryParameters: {
      "whatsnewid": whatsnewid,
    });

    return response;
  }

  Future<Response> getjustforyoulistsbybrandid(
      String brandid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/justforyou/getjustforyoulistsbybrandid', queryParameters: {
      "brandid": brandid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });
    return response;
  }

  Future<Response> getjustforyoumediasbyid(String justforyouid) async {
    Response response = await _dio
        .post('/justforyou/getjustforyoumediasbyid', queryParameters: {
      "justforyouid": justforyouid,
    });

    return response;
  }

  Future<Response> getcolorlists() async {
    Response response = await _dio.post('/color/getcolorlists');

    return response;
  }

  Future<Response> getnewproductlists(
      int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/product/getnewproductlists', queryParameters: {
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbyparameters(
    int skip,
    int take,
    String? categoryid,
    String? subcategoryid,
    String? thirdcategoryid,
    String? brandid,
    String? collectionid,
    String? justforyouid,
    String? whatsnewid,
    String? eventid,
    String? q,
    String? languageid,
  ) {
    late Future<Response> response;
    if (categoryid != null && q != null) {
      response =
          getproductlistsbycategoryid(categoryid, skip, take, q, languageid);
    } else if (categoryid != null && subcategoryid != null) {
      response = getproductlistsbysubcategoryid(
          subcategoryid, skip, take, brandid, languageid);
    } else if (categoryid != null && thirdcategoryid != null) {
      response = getproductlistsbythirdcategoryid(
          thirdcategoryid, skip, take, brandid, languageid);
    } else if (collectionid != null) {
      response =
          getproductlistsbycollectionid(collectionid, skip, take, languageid);
    } else if (justforyouid != null) {
      response =
          getproductlistsbyjustforyouid(justforyouid, skip, take, languageid);
    } else if (whatsnewid != null) {
      response =
          getproductlistsbywhatsnewid(whatsnewid, skip, take, languageid);
    } else if (eventid != null) {
      response = getproductlistsbyeventid(eventid, skip, take, languageid);
    }

    return response;
  }

  Future<Response> getproductlistsbycategoryid(
    String categoryid,
    int skip,
    int take,
    String? q,
    String? languageid,
  ) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbycategoryid', queryParameters: {
      "categoryid": categoryid,
      "skip": skip,
      "take": take,
      "q": q,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbysubcategoryid(
    String subcategoryid,
    int skip,
    int take,
    String? brandid,
    String? languageid,
  ) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbysubcategoryid', queryParameters: {
      "subcategoryid": subcategoryid,
      "skip": skip,
      "take": take,
      "brandid": brandid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbythirdcategoryid(
    String thirdcategoryid,
    int skip,
    int take,
    String? brandid,
    String? languageid,
  ) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbythirdcategoryid', queryParameters: {
      "thirdcategoryid": thirdcategoryid,
      "skip": skip,
      "take": take,
      "brandid": brandid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbycollectionid(
      String collectionid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbycollectionid', queryParameters: {
      "collectionid": collectionid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbycampaignid(
      String campaignid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbycampaignid', queryParameters: {
      "campaignid": campaignid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbyjustforyouid(
      String justforyouid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbyjustforyouid', queryParameters: {
      "justforyouid": justforyouid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbywhatsnewid(
      String whatsnewid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistsbywhatsnewid', queryParameters: {
      "whatsnewid": whatsnewid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistsbyeventid(
      String eventid, int skip, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/product/getproductlistsbyeventid', queryParameters: {
      "eventid": eventid,
      "skip": skip,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductlistswithoutselfbycollectionid(
      String collectionid, String productid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio.post(
        '/product/getproductlistswithoutselfbycollectionid',
        queryParameters: {
          "collectionid": collectionid,
          "productid": productid,
          "languageid": languageid,
        });

    return response;
  }

  Future<Response> getproductlistswithoutselfbybrandid(String brandid,
      String productid, String collectionid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getproductlistswithoutselfbybrandid', queryParameters: {
      "brandid": brandid,
      "productid": productid,
      "collectionid": collectionid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getnewproductlistsbybrandid(
      String brandid, int take, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getnewproductlistsbybrandid', queryParameters: {
      "brandid": brandid,
      "take": take,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getorderdetailmessagesbyproductid(
      String productid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response = await _dio
        .post('/product/getorderdetailmessagesbyproductid', queryParameters: {
      "productid": productid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductbyid(String productid, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/product/getproductbyid', queryParameters: {
      "productid": productid,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getproductmediasbyid(String productid) async {
    Response response =
        await _dio.post('/product/getproductmediasbyid', queryParameters: {
      "productid": productid,
    });

    return response;
  }

  Future<Response> getproductbysku(String sku, String? languageid) async {
    String slanguageid = await getLanguage();
    languageid = (languageid != null) ? languageid : slanguageid;
    Response response =
        await _dio.post('/product/getproductbysku', queryParameters: {
      "sku": sku,
      "languageid": languageid,
    });

    return response;
  }

  Future<Response> getsizelistsbycategoryid(String categoryid) async {
    Response response =
        await _dio.post('/product/getsizelistsbycategoryid', queryParameters: {
      "categoryid": categoryid,
    });

    return response;
  }

  Future<Response> getsizelistsbycategoryidandtype(
      String categoryid, int sizetype) async {
    Response response = await _dio
        .post('/product/getsizelistsbycategoryidandtype', queryParameters: {
      "categoryid": categoryid,
      "sizetype": sizetype,
    });

    return response;
  }

  Future<Response> getlanguagelists() async {
    Response response = await _dio.post('/language/getlanguagelists');

    return response;
  }

  Future<Response> getcnlanguagelists() async {
    Response response = await _dio.post('/language/getcnlanguagelists');

    return response;
  }

  Future<Response> getlanguagebycurr(String curr, String code) async {
    Response response =
        await _dio.post('/language/getlanguagebycurr', queryParameters: {
      "curr": curr,
      "code": code,
    });

    return response;
  }

  Future<Response> getcountrylists() async {
    Response response = await _dio.post('/country/getcountrylists');

    return response;
  }

  Future<Response> getcncountrylists() async {
    Response response = await _dio.post('/country/getcncountrylists');

    return response;
  }

  Future<Response> getsetup() async {
    Response response = await _dio.post('/setup/getsetup');

    return response;
  }

  Future<Response> getorderlistsbymemberid(
      String memberid, int skip, int take) async {
    Response response =
        await _dio.post('/order/getorderlistsbymemberid', queryParameters: {
      "memberid": memberid,
      "skip": skip,
      "take": take,
    });

    return response;
  }

  Future<Response> getorderbyorderid(String orderid) async {
    Response response =
        await _dio.post('/order/getorderbyorderid', queryParameters: {
      "orderid": orderid,
    });

    return response;
  }

  Future<Response> getorderbyordercode(String ordercode) async {
    Response response =
        await _dio.post('/order/getorderbyordercode', queryParameters: {
      "ordercode": ordercode,
    });

    return response;
  }

  Future<Response> gettotalspendbybrandidandmemberid(
      String brandid, String memberid) async {
    Response response = await _dio
        .post('/order/gettotalspendbybrandidandmemberid', queryParameters: {
      "brandid": brandid,
      "memberid": memberid,
    });

    return response;
  }

  Future<Response> postchinapayorderdetail(
    String carts,
    String memberid,
    String orderid,
    String paymentmethodid,
  ) async {
    Response response = await _dio.post('/order/postchinapayorderdetail',
        data: carts,
        options: Options(
          contentType: 'application/json',
        ),
        queryParameters: {
          "memberid": memberid,
          "orderid": orderid,
          "paymentmethodid": paymentmethodid,
        });

    return response;
  }

  Future<Response> postorderdetail(
    String carts,
    String orderid,
  ) async {
    Response response = await _dio.post('/order/postorderdetail',
        data: carts,
        options: Options(
          contentType: 'application/json',
        ),
        queryParameters: {
          "orderid": orderid,
        });

    return response;
  }

  Future<Response> postasiapayorder(
    String carts,
    String memberid,
    String shippinglocationid,
    String shippingtype,
    String ispreorder,
  ) async {
    Response response = await _dio.post('/order/postasiapayorder',
        data: carts,
        options: Options(
          contentType: 'application/json',
        ),
        queryParameters: {
          "memberid": memberid,
          "shippinglocationid": shippinglocationid,
          "shippingtype": shippingtype,
          "ispreorder": ispreorder,
        });

    return response;
  }

  Future<Response> postpaymentintent(
    String carts,
    String memberid,
    String paymentmethodid,
    String shippinglocationid,
    String shippingtype,
    String ispreorder,
  ) async {
    Response response = await _dio.post('/order/postpaymentintent',
        data: carts,
        options: Options(
          contentType: 'application/json',
        ),
        queryParameters: {
          "memberid": memberid,
          "paymentmethodid": paymentmethodid,
          "shippinglocationid": shippinglocationid,
          "shippingtype": shippingtype,
          "ispreorder": ispreorder,
        });

    return response;
  }

  Future<Response> postcreateprice(
    String brandmemberplanid,
  ) async {
    Response response =
        await _dio.post('/order/postcreateprice', queryParameters: {
      "brandmemberplanid": brandmemberplanid,
    });

    return response;
  }

  Future<Response> postsetupintentandcreatesubscription(
    String memberid,
    String brandmemberplanid,
    String paymentmethodid,
  ) async {
    Response response = await _dio
        .post('/order/postsetupintentandcreatesubscription', queryParameters: {
      "memberid": memberid,
      "brandmemberplanid": brandmemberplanid,
      "paymentmethodid": paymentmethodid,
    });

    return response;
  }

  Future<Response> postcreatesubscription(
    String memberid,
    String brandmemberplanid,
    String paymentmethodid,
  ) async {
    Response response =
        await _dio.post('/order/postcreatesubscription', queryParameters: {
      "memberid": memberid,
      "brandmemberplanid": brandmemberplanid,
      "paymentmethodid": paymentmethodid,
    });

    return response;
  }

  Future<Response> postcreatecnsubscription(
    String memberid,
    String brandmemberplanid,
  ) async {
    Response response =
        await _dio.post('/order/postcreatecnsubscription', queryParameters: {
      "memberid": memberid,
      "brandmemberplanid": brandmemberplanid,
    });

    return response;
  }

  Future<Response> postupdatesubscription(
    String brandmemberplanid,
    String membershipfeeid,
  ) async {
    Response response =
        await _dio.post('/order/postupdatesubscription', queryParameters: {
      "brandmemberplanid": brandmemberplanid,
      "membershipfeeid": membershipfeeid,
    });

    return response;
  }

  Future<Response> postsetupintent(
    String memberid,
    String paymentmethodid,
  ) async {
    Response response =
        await _dio.post('/order/postsetupintent', queryParameters: {
      "memberid": memberid,
      "paymentmethodid": paymentmethodid,
    });

    return response;
  }

  Future<Response> deletepaymentmethod(
    String paymentmethodid,
  ) async {
    Response response =
        await _dio.post('/order/deletepaymentmethod', queryParameters: {
      "paymentmethodid": paymentmethodid,
    });

    return response;
  }

  Future<Response> postdisableautorenew(
    String membershipfeeid,
  ) async {
    Response response =
        await _dio.post('/order/postdisableautorenew', queryParameters: {
      "membershipfeeid": membershipfeeid,
    });

    return response;
  }

  Future<Response> postresumeautorenew(
    String memberid,
    String brandmemberplanid,
    String membershipfeeid,
    String paymentmethodid,
  ) async {
    Response response =
        await _dio.post('/order/postresumeautorenew', queryParameters: {
      "memberid": memberid,
      "brandmemberplanid": brandmemberplanid,
      "membershipfeeid": membershipfeeid,
      "paymentmethodid": paymentmethodid,
    });

    return response;
  }

  Future<Response> postmessage(String name, String phone, String email,
      String message, String? company) async {
    Response response =
        await _dio.post('/contact/postmessage', queryParameters: {
      "name": name,
      "phone": phone,
      "email": email,
      "message": message,
      "company": company,
    });
    return response;
  }

  initializeInterceptors() {
    _dio.interceptors.clear();
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          //log('header token: ${accessToken.toString()}');
          //log('header Key: ${apiKey.toString()}');
          /*
          登入若有提供 token 的效期的話
          可以在打請求前判斷效期是否已過做重 fetch 請求的事
          */
          options.headers['Authorization'] = accessToken;
          options.headers['Key'] = apiKey;

          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          log('onError response statusCode: ${e.response?.statusCode}');

          return handler.next(e);
        },
      ),
    );
  }
}
