import 'dart:convert';

class Language {
  final String currid;
  final String langid;
  final String langtitle;
  final String langcode;
  final String currtitle;
  final String currsymbol;
  final double exchange;

  Language({
    required this.currid,
    required this.langid,
    required this.langtitle,
    required this.langcode,
    required this.currtitle,
    required this.currsymbol,
    required this.exchange,
  });

  factory Language.fromJson(String str) => Language.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Language.fromMap(Map<String, dynamic> json)
      : currid = json['currid'],
        langid = json['langid'],
        langtitle = json['langtitle'],
        langcode = json['langcode'],
        currtitle = json['currtitle'],
        currsymbol = json['currsymbol'],
        exchange = json['exchange'];

  Map<String, dynamic> toMap() => {
        'currid': currid,
        'langid': langid,
        'langtitle': langtitle,
        'langcode': langcode,
        'currtitle': currtitle,
        'currsymbol': currsymbol,
        'exchange': exchange,
      };
}

class CartData {
  final List<Carts> items;
  final double subtotal;

  CartData({
    required this.items,
    required this.subtotal,
  });

  factory CartData.fromJson(String str) => CartData.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  CartData.fromMap(Map<String, dynamic> json)
      : items = List<Carts>.from(json['items'].map((x) => Carts.fromMap(x))),
        subtotal = json['subtotal'];

  Map<String, dynamic> toMap() => {
        'items': List<dynamic>.from(items.map((x) => x.toMap())),
        'subtotal': subtotal,
      };
}

class Order {
  final String orderid;
  final String ordertype;
  final String ordercode;
  final String memberid;
  final String firstname;
  final String lastname;
  final String orderdate;
  final double totalprice;
  final double discount;
  final double freight;
  final double reducepoint;
  final String paystatus;
  final String shippingtype;
  final String logisticstatus;
  final String orderstatus;
  final String deliverdate;
  final String? tracknumber;
  final String? trackurl;
  final String? phone;
  final String? email;
  final String? payment;
  final String postcode;
  final String country;
  final String? state;
  final String city;
  final String? district;
  final String address;
  final String? coupon;
  final String? remark;
  final List<OrderDetail> orderdetails;

  Order({
    required this.orderid,
    required this.ordertype,
    required this.ordercode,
    required this.memberid,
    required this.firstname,
    required this.lastname,
    required this.orderdate,
    required this.totalprice,
    required this.discount,
    required this.freight,
    required this.reducepoint,
    required this.paystatus,
    required this.shippingtype,
    required this.logisticstatus,
    required this.orderstatus,
    required this.deliverdate,
    required this.orderdetails,
    this.tracknumber,
    this.trackurl,
    this.phone,
    this.email,
    this.payment,
    required this.postcode,
    required this.country,
    this.state,
    required this.city,
    this.district,
    required this.address,
    this.coupon,
    this.remark,
  });

  factory Order.fromJson(String str) => Order.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Order.fromMap(Map<String, dynamic> json)
      : orderid = json['orderid'],
        ordertype = json['ordertype'],
        ordercode = json['ordercode'],
        memberid = json['memberid'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        orderdate = json['orderdate'],
        totalprice = json['totalprice'],
        discount = json['discount'],
        freight = json['freight'],
        reducepoint = json['reducepoint'],
        paystatus = json['paystatus'],
        shippingtype = json['shippingtype'],
        logisticstatus = json['logisticstatus'],
        orderstatus = json['orderstatus'],
        deliverdate = json['deliverdate'],
        tracknumber = json['tracknumber'],
        trackurl = json['trackurl'],
        phone = json['phone'],
        email = json['email'],
        payment = json['payment'],
        postcode = json['postcode'],
        country = json['country'],
        state = json['state'],
        city = json['city'],
        district = json['district'],
        address = json['address'],
        coupon = json['coupon'],
        remark = json['remark'],
        orderdetails = List<OrderDetail>.from(
            json['orderdetails'].map((x) => OrderDetail.fromMap(x)));

  Map<String, dynamic> toMap() => {
        'orderid': orderid,
        'ordertype': ordertype,
        'ordercode': ordercode,
        'memberid': memberid,
        'firstname': firstname,
        'lastname': lastname,
        'orderdate': orderdate,
        'totalprice': totalprice,
        'discount': discount,
        'freight': freight,
        'reducepoint': reducepoint,
        'paystatus': paystatus,
        'shippingtype': shippingtype,
        'logisticstatus': logisticstatus,
        'orderstatus': orderstatus,
        'deliverdate': deliverdate,
        'tracknumber': tracknumber,
        'trackurl': trackurl,
        'phone': phone,
        'email': email,
        'payment': payment,
        'postcode': postcode,
        'country': country,
        'state': state,
        'city': city,
        'district': district,
        'address': address,
        'coupon': coupon,
        'remark': remark,
        'orderdetails': List<dynamic>.from(orderdetails.map((x) => x.toMap())),
      };
}

class OrderDetail {
  final String orderdetailid;
  final String productid;
  final String? brandtitle;
  final String producttitle;
  final String? productsummary;
  final String? productphotourl;
  final String size;
  final int quantity;
  final double price;
  final double total;

  OrderDetail({
    required this.orderdetailid,
    required this.productid,
    required this.producttitle,
    required this.size,
    required this.quantity,
    required this.price,
    required this.total,
    this.brandtitle,
    this.productsummary,
    this.productphotourl,
  });

  factory OrderDetail.fromJson(String str) =>
      OrderDetail.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  OrderDetail.fromMap(Map<String, dynamic> json)
      : orderdetailid = json['orderdetailid'],
        productid = json['productid'],
        producttitle = json['producttitle'],
        size = json['size'],
        quantity = json['quantity'],
        price = json['price'],
        total = json['total'],
        brandtitle = json['brandtitle'],
        productsummary = json['productsummary'],
        productphotourl = json['productphotourl'];

  Map<String, dynamic> toMap() => {
        'orderdetailid': orderdetailid,
        'productid': productid,
        'producttitle': producttitle,
        'size': size,
        'quantity': quantity,
        'price': price,
        'total': total,
        'brandtitle': brandtitle,
        'productsummary': productsummary,
        'productphotourl': productphotourl,
      };
}

class OrderResponse {
  final String orderid;
  final String clientsecret;

  OrderResponse({
    required this.orderid,
    required this.clientsecret,
  });

  factory OrderResponse.fromJson(String str) =>
      OrderResponse.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  OrderResponse.fromMap(Map<String, dynamic> json)
      : orderid = json['orderid'],
        clientsecret = json['clientsecret'];

  Map<String, dynamic> toMap() => {
        'orderid': orderid,
        'clientsecret': clientsecret,
      };
}

class Carts {
  final String productid;
  final String brandtitle;
  final String producttitle;
  String? productphoto;
  final String sizetitle;
  final String productsizeid;
  final int quantity;
  final double price;
  final double total;

  Carts({
    required this.productid,
    required this.brandtitle,
    required this.producttitle,
    this.productphoto,
    required this.sizetitle,
    required this.productsizeid,
    required this.quantity,
    required this.price,
    required this.total,
  });

  factory Carts.fromJson(String str) => Carts.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Carts.fromMap(Map<String, dynamic> json)
      : productid = json['productid'],
        brandtitle = json['brandtitle'],
        producttitle = json['producttitle'],
        productphoto = json['productphoto'],
        sizetitle = json['sizetitle'],
        productsizeid = json['productsizeid'],
        quantity = json['quantity'],
        price = json['price'],
        total = json['total'];

  Map<String, dynamic> toMap() => {
        'productid': productid,
        'brandtitle': brandtitle,
        'producttitle': producttitle,
        'productphoto': productphoto,
        'sizetitle': sizetitle,
        'productsizeid': productsizeid,
        'quantity': quantity,
        'price': price,
        'total': total,
      };
}

class Member {
  final String memberid;
  final String email;
  final int countryid;
  final String? mobile;
  final String photourl;
  final List<MembershipFee>? membershipfees;
  final List<MemberBrand>? memberbrands;
  final List<MemberProduct>? memberproducts;
  final int? gender;
  final String? firstname;
  final String? lastname;
  final int? year;
  final int? month;
  final int? day;
  final bool? ispayment;
  final String? awid;

  Member({
    required this.memberid,
    required this.email,
    required this.countryid,
    this.mobile,
    required this.photourl,
    this.membershipfees,
    this.memberbrands,
    this.memberproducts,
    this.gender,
    this.firstname,
    this.lastname,
    this.year,
    this.month,
    this.day,
    this.ispayment,
    this.awid,
  });

  factory Member.fromJson(String str) => Member.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Member.fromMap(Map<String, dynamic> json)
      : memberid = json['memberid'],
        email = json['email'],
        countryid = json['countryid'],
        mobile = json['mobile'],
        photourl = json['photourl'],
        membershipfees = List<MembershipFee>.from(
            json['membershipfees']!.map((x) => MembershipFee.fromMap(x))),
        memberbrands = List<MemberBrand>.from(
            json['memberbrands']!.map((x) => MemberBrand.fromMap(x))),
        memberproducts = List<MemberProduct>.from(
            json['memberproducts']!.map((x) => MemberProduct.fromMap(x))),
        gender = json['gender'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        year = json['year'],
        month = json['month'],
        day = json['day'],
        ispayment = json['ispayment'],
        awid = json['awid'];

  Map<String, dynamic> toMap() => {
        'memberid': memberid,
        'email': email,
        'countryid': countryid,
        'mobile': mobile,
        'photourl': photourl,
        'membershipfees':
            List<dynamic>.from(membershipfees!.map((x) => x.toMap())),
        'memberbrands': List<dynamic>.from(memberbrands!.map((x) => x.toMap())),
        'memberproducts':
            List<dynamic>.from(memberproducts!.map((x) => x.toMap())),
        'gender': gender,
        'firstname': firstname,
        'lastname': lastname,
        'year': year,
        'month': month,
        'day': day,
        'ispayment': ispayment,
        'awid': awid,
      };
}

class MembershipFee {
  final String membershipfeeid;
  final double totalprice;
  final String? orderdate;
  final String? expiredate;
  final String paystatus;
  final String createdate;
  final String? canceldate;
  final String? awid;
  final BrandMemberPlan? brandmemberplan;

  MembershipFee({
    required this.membershipfeeid,
    required this.totalprice,
    this.orderdate,
    this.expiredate,
    required this.paystatus,
    required this.createdate,
    this.canceldate,
    this.awid,
    this.brandmemberplan,
  });

  factory MembershipFee.fromJson(String str) =>
      MembershipFee.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  MembershipFee.fromMap(Map<String, dynamic> json)
      : membershipfeeid = json['membershipfeeid'],
        totalprice = json['totalprice'],
        orderdate = json['orderdate'],
        expiredate = json['expiredate'],
        paystatus = json['paystatus'],
        createdate = json['createdate'],
        canceldate = json['canceldate'],
        awid = json['awid'],
        brandmemberplan = BrandMemberPlan.fromMap(json['brandmemberplan']);

  Map<String, dynamic> toMap() => {
        'membershipfeeid': membershipfeeid,
        'totalprice': totalprice,
        'orderdate': orderdate,
        'expiredate': expiredate,
        'paystatus': paystatus,
        'createdate': createdate,
        'canceldate': canceldate,
        'awid': awid,
        'brandmemberplan': brandmemberplan?.toMap(),
      };
}

class MemberBrand {
  final String memberbrandid;
  final String brandid;

  MemberBrand({
    required this.memberbrandid,
    required this.brandid,
  });

  factory MemberBrand.fromJson(String str) =>
      MemberBrand.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  MemberBrand.fromMap(Map<String, dynamic> json)
      : memberbrandid = json['memberbrandid'],
        brandid = json['brandid'];

  Map<String, dynamic> toMap() => {
        'memberbrandid': memberbrandid,
        'brandid': brandid,
      };
}

class MemberProduct {
  final String memberproductid;
  final String productid;

  MemberProduct({
    required this.memberproductid,
    required this.productid,
  });

  factory MemberProduct.fromJson(String str) =>
      MemberProduct.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  MemberProduct.fromMap(Map<String, dynamic> json)
      : memberproductid = json['memberproductid'],
        productid = json['productid'];

  Map<String, dynamic> toMap() => {
        'memberproductid': memberproductid,
        'productid': productid,
      };
}

class ShippingLocation {
  final String shippinglocationid;
  final String memberid;
  final String country;
  final int countryid;
  final String postcode;
  final String? state;
  final String city;
  final String? district;
  final String address;
  final bool isdefault;

  ShippingLocation({
    required this.shippinglocationid,
    required this.memberid,
    required this.country,
    required this.countryid,
    required this.postcode,
    this.state,
    required this.city,
    this.district,
    required this.address,
    required this.isdefault,
  });

  factory ShippingLocation.fromJson(String str) =>
      ShippingLocation.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  ShippingLocation.fromMap(Map<String, dynamic> json)
      : shippinglocationid = json['shippinglocationid'],
        memberid = json['memberid'],
        country = json['country'],
        countryid = json['countryid'],
        postcode = json['postcode'],
        state = json['state'],
        city = json['city'],
        district = json['district'],
        address = json['address'],
        isdefault = json['isdefault'];

  Map<String, dynamic> toMap() => {
        'shippinglocationid': shippinglocationid,
        'memberid': memberid,
        'country': country,
        'countryid': countryid,
        'postcode': postcode,
        'state': state,
        'city': city,
        'district': district,
        'address': address,
        'isdefault': isdefault,
      };
}

class BrandMemberPlan {
  final String brandmemberplanid;
  final String brandid;
  final String? brandtitle;
  final String plantitle;
  final double price;
  final double totalspend;
  final double promote;
  final int? trialday;
  final String? proid;
  final String? awid;
  final int sort;

  BrandMemberPlan({
    required this.brandmemberplanid,
    required this.brandid,
    this.brandtitle,
    required this.plantitle,
    required this.price,
    required this.totalspend,
    required this.promote,
    this.trialday,
    this.proid,
    this.awid,
    required this.sort,
  });

  factory BrandMemberPlan.fromJson(String str) =>
      BrandMemberPlan.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  BrandMemberPlan.fromMap(Map<String, dynamic> json)
      : brandmemberplanid = json['brandmemberplanid'],
        brandid = json['brandid'],
        brandtitle = json['brandtitle'],
        plantitle = json['plantitle'],
        price = json['price'],
        totalspend = json['totalspend'],
        promote = json['promote'],
        trialday = json['trialday'],
        proid = json['proid'],
        awid = json['awid'],
        sort = json['sort'];

  Map<String, dynamic> toMap() => {
        'brandmemberplanid': brandmemberplanid,
        'brandid': brandid,
        'brandtitle': brandtitle,
        'plantitle': plantitle,
        'price': price,
        'totalspend': totalspend,
        'promote': promote,
        'trialday': trialday,
        'proid': proid,
        'awid': awid,
        'sort': sort
      };
}

class MyPaymentMethod {
  final String paymentmethodid;
  final String brand;
  final String cardlast4;
  final int expmonth;
  final int expyear;

  MyPaymentMethod({
    required this.paymentmethodid,
    required this.brand,
    required this.cardlast4,
    required this.expmonth,
    required this.expyear,
  });

  factory MyPaymentMethod.fromJson(String str) =>
      MyPaymentMethod.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  MyPaymentMethod.fromMap(Map<String, dynamic> json)
      : paymentmethodid = json['paymentmethodid'],
        brand = json['brand'],
        cardlast4 = json['cardlast4'],
        expmonth = json['expmonth'],
        expyear = json['expyear'];

  Map<String, dynamic> toMap() => {
        'paymentmethodid': paymentmethodid,
        'brand': brand,
        'cardlast4': cardlast4,
        'expmonth': expmonth,
        'expyear': expyear,
      };
}

class Brand {
  final String brandid;
  final String title;
  final int publishstatus;
  final String? videourl;
  final String? storyvideourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  //正方形圖
  final String? squareurl;
  final String? iconurl;
  final String? flagurl;
  final String? summary;
  final String? content;
  final List<BrandMemberPlan> brandmemberplans;

  Brand({
    required this.brandid,
    required this.title,
    required this.publishstatus,
    this.videourl,
    this.storyvideourl,
    this.landscapeurl,
    this.portraiturl,
    this.squareurl,
    this.iconurl,
    this.flagurl,
    this.summary,
    this.content,
    required this.brandmemberplans,
  });

  factory Brand.fromJson(String str) => Brand.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Brand.fromMap(Map<String, dynamic> json)
      : brandid = json['brandid'],
        title = json['title'],
        publishstatus = json['publishstatus'],
        videourl = json['videourl'],
        storyvideourl = json['storyvideourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        squareurl = json['squareurl'],
        iconurl = json['iconurl'],
        flagurl = json['flagurl'],
        summary = json['summary'],
        content = json['content'],
        brandmemberplans = List<BrandMemberPlan>.from(
            json['brandmemberplans'].map((x) => BrandMemberPlan.fromMap(x)));

  Map<String, dynamic> toMap() => {
        'brandid': brandid,
        'title': title,
        'publishstatus': publishstatus,
        'videourl': videourl,
        'storyvideourl': storyvideourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'squareurl': squareurl,
        'iconurl': iconurl,
        'flagurl': flagurl,
        'summary': summary,
        'content': content,
        'brandmemberplans':
            List<dynamic>.from(brandmemberplans.map((x) => x.toMap())),
      };
}

class BrandMedia {
  final String brandmediaid;
  final int scaletype;
  final String url;

  BrandMedia({
    required this.brandmediaid,
    required this.scaletype,
    required this.url,
  });

  factory BrandMedia.fromJson(String str) =>
      BrandMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  BrandMedia.fromMap(Map<String, dynamic> json)
      : brandmediaid = json['brandmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'brandmediaid': brandmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class StoryMedia {
  final String storymediaid;
  final int scaletype;
  final String url;

  StoryMedia({
    required this.storymediaid,
    required this.scaletype,
    required this.url,
  });

  factory StoryMedia.fromJson(String str) =>
      StoryMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  StoryMedia.fromMap(Map<String, dynamic> json)
      : storymediaid = json['storymediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'storymediaid': storymediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class Country {
  final int countryid;
  final String nickname;
  final String phonecode;
  final String flagurl;

  Country({
    required this.countryid,
    required this.nickname,
    required this.phonecode,
    required this.flagurl,
  });

  factory Country.fromJson(String str) => Country.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Country.fromMap(Map<String, dynamic> json)
      : countryid = json['countryid'],
        nickname = json['nickname'],
        phonecode = json['phonecode'],
        flagurl = json['flagurl'];

  Map<String, dynamic> toMap() => {
        'countryid': countryid,
        'nickname': nickname,
        'phonecode': phonecode,
        'flagurl': flagurl,
      };
}

class Faq {
  final String title;
  final List<Faqlist> faqlists;

  Faq({
    required this.title,
    required this.faqlists,
  });

  factory Faq.fromJson(String str) => Faq.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Faq.fromMap(Map<String, dynamic> json)
      : title = json['title'],
        faqlists =
            List<Faqlist>.from(json['faqlists'].map((x) => Faqlist.fromMap(x)));

  Map<String, dynamic> toMap() => {
        'title': title,
        'faqlists': List<dynamic>.from(faqlists.map((x) => x.toMap())),
      };
}

class Faqlist {
  final String question;
  final String answer;

  Faqlist({
    required this.question,
    required this.answer,
  });

  factory Faqlist.fromJson(String str) => Faqlist.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Faqlist.fromMap(Map<String, dynamic> json)
      : question = json['question'],
        answer = json['answer'];

  Map<String, dynamic> toMap() => {
        'question': question,
        'answer': answer,
      };
}

class Category {
  final String categoryid;
  final String title;
  final String? summary;
  final List<Subcategory>? subcategorys;
  //橫圖
  final String? landscapeurl;

  Category({
    required this.categoryid,
    required this.title,
    this.summary,
    this.subcategorys,
    this.landscapeurl,
  });

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Category.fromMap(Map<String, dynamic> json)
      : categoryid = json['categoryid'],
        title = json['title'],
        summary = json['summary'],
        subcategorys = List<Subcategory>.from(
            json['subcategorys'].map((x) => Subcategory.fromMap(x))),
        landscapeurl = json['landscapeurl'];

  Map<String, dynamic> toMap() => {
        'categoryid': categoryid,
        'title': title,
        'summary': summary,
        'subcategorys': List<dynamic>.from(subcategorys!.map((x) => x.toMap())),
        'landscapeurl': landscapeurl,
      };
}

class Subcategory {
  final String subcategoryid;
  final String title;
  final List<Thirdcategory> thirdcategorys;
  final String? landscapeurl;
  final String? portraiturl;

  Subcategory({
    required this.subcategoryid,
    required this.title,
    required this.thirdcategorys,
    this.landscapeurl,
    this.portraiturl,
  });

  factory Subcategory.fromJson(String str) =>
      Subcategory.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Subcategory.fromMap(Map<String, dynamic> json)
      : subcategoryid = json['subcategoryid'],
        title = json['title'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        thirdcategorys = List<Thirdcategory>.from(
            json['thirdcategorys'].map((x) => Thirdcategory.fromMap(x)));

  Map<String, dynamic> toMap() => {
        'subcategoryid': subcategoryid,
        'title': title,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'thirdcategorys':
            List<dynamic>.from(thirdcategorys.map((x) => x.toMap())),
      };
}

class Thirdcategory {
  final String thirdcategoryid;
  final String title;

  Thirdcategory({
    required this.thirdcategoryid,
    required this.title,
  });

  factory Thirdcategory.fromJson(String str) =>
      Thirdcategory.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Thirdcategory.fromMap(Map<String, dynamic> json)
      : thirdcategoryid = json['thirdcategoryid'],
        title = json['title'];

  Map<String, dynamic> toMap() => {
        'thirdcategoryid': thirdcategoryid,
        'title': title,
      };
}

class Designer {
  final String designerid;
  final String title;
  final String subtitle;
  final String country;
  final String flagurl;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  //正方形圖
  final String? squareurl;
  final String? summary;
  final String? content;
  final String? hometown;

  Designer({
    required this.designerid,
    required this.title,
    required this.subtitle,
    required this.country,
    required this.flagurl,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.squareurl,
    this.summary,
    this.content,
    this.hometown,
  });

  factory Designer.fromJson(String str) => Designer.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Designer.fromMap(Map<String, dynamic> json)
      : designerid = json['designerid'],
        title = json['title'],
        subtitle = json['subtitle'],
        country = json['country'],
        flagurl = json['flagurl'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        squareurl = json['squareurl'],
        summary = json['summary'],
        content = json['content'],
        hometown = json['hometown'];

  Map<String, dynamic> toMap() => {
        'designerid': designerid,
        'title': title,
        'subtitle': subtitle,
        'country': country,
        'flagurl': flagurl,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'squareurl': squareurl,
        'summary': summary,
        'content': content,
        'hometown': hometown,
      };
}

class DesignerMedia {
  final String designermediaid;
  final int scaletype;
  final String url;

  DesignerMedia({
    required this.designermediaid,
    required this.scaletype,
    required this.url,
  });

  factory DesignerMedia.fromJson(String str) =>
      DesignerMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  DesignerMedia.fromMap(Map<String, dynamic> json)
      : designermediaid = json['designermediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'designermediaid': designermediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class DesignerVideo {
  final String designerid;
  final String brandid;
  final String videourl;

  DesignerVideo({
    required this.designerid,
    required this.brandid,
    required this.videourl,
  });

  factory DesignerVideo.fromJson(String str) =>
      DesignerVideo.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  DesignerVideo.fromMap(Map<String, dynamic> json)
      : designerid = json['designerid'],
        brandid = json['brandid'],
        videourl = json['videourl'];

  Map<String, dynamic> toMap() => {
        'designerid': designerid,
        'brandid': brandid,
        'videourl': videourl,
      };
}

class Product {
  final String productid;
  final String title;
  final String brandid;
  final String categoryid;
  final int? sizetype;
  final String? collectionid;
  final String? campaignid;
  final String brandtitle;
  final double price;
  final double discountprice;
  final List<ProductSize>? productsizes;
  final List<ProductColor>? productcolors;
  final int popular;
  final String? summary;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? content;
  final String? productcare;
  final String? flagurl;
  final String? materialflagurl;
  final int createdate;

  Product({
    required this.productid,
    required this.title,
    required this.brandid,
    required this.categoryid,
    this.sizetype,
    this.collectionid,
    this.campaignid,
    required this.brandtitle,
    required this.price,
    required this.discountprice,
    this.productsizes,
    this.productcolors,
    required this.popular,
    this.summary,
    this.landscapeurl,
    this.portraiturl,
    this.content,
    this.productcare,
    this.flagurl,
    this.materialflagurl,
    required this.createdate,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Product.fromMap(Map<String, dynamic> json)
      : productid = json['productid'],
        title = json['title'],
        brandid = json['brandid'],
        categoryid = json['categoryid'],
        sizetype = json['sizetype'],
        collectionid = json['collectionid'],
        campaignid = json['campaignid'],
        brandtitle = json['brandtitle'],
        price = json['price'],
        discountprice = json['discountprice'],
        productsizes = List<ProductSize>.from(
            json['productsizes'].map((x) => ProductSize.fromMap(x))),
        productcolors = List<ProductColor>.from(
            json['productcolors'].map((x) => ProductColor.fromMap(x))),
        popular = json['popular'],
        summary = json['summary'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        content = json['content'],
        productcare = json['productcare'],
        flagurl = json['flagurl'],
        materialflagurl = json['materialflagurl'],
        createdate = json['createdate'];

  Map<String, dynamic> toMap() => {
        'productid': productid,
        'title': title,
        'brandid': brandid,
        'categoryid': categoryid,
        'sizetype': sizetype,
        'collectionid': collectionid,
        'campaignid': campaignid,
        'brandtitle': brandtitle,
        'price': price,
        'discountprice': discountprice,
        'productsizes': List<dynamic>.from(productsizes!.map((x) => x.toMap())),
        'productcolors':
            List<dynamic>.from(productcolors!.map((x) => x.toMap())),
        'popular': popular,
        'summary': summary,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'content': content,
        'productcare': productcare,
        'flagurl': flagurl,
        'materialflagurl': materialflagurl,
        'createdate': createdate,
      };
}

class ProductMedia {
  final String productmediaid;
  final int scaletype;
  final String url;

  ProductMedia({
    required this.productmediaid,
    required this.scaletype,
    required this.url,
  });

  factory ProductMedia.fromJson(String str) =>
      ProductMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  ProductMedia.fromMap(Map<String, dynamic> json)
      : productmediaid = json['productmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'productmediaid': productmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class ProductSize {
  final String productsizeid;
  final String sizeid;
  final String size;
  final int inventory;

  ProductSize({
    required this.productsizeid,
    required this.sizeid,
    required this.size,
    required this.inventory,
  });

  factory ProductSize.fromJson(String str) =>
      ProductSize.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  ProductSize.fromMap(Map<String, dynamic> json)
      : productsizeid = json['productsizeid'],
        sizeid = json['sizeid'],
        size = json['size'],
        inventory = json['inventory'];

  Map<String, dynamic> toMap() => {
        'productsizeid': productsizeid,
        'sizeid': sizeid,
        'size': size,
        'inventory': inventory,
      };
}

class VSize {
  final String sizeid;
  final int? sizetype;
  final String title;
  final String? detail;
  final String? us;
  final String? eu;
  final String? jp;

  VSize({
    required this.sizeid,
    this.sizetype,
    required this.title,
    this.detail,
    this.us,
    this.eu,
    this.jp,
  });

  factory VSize.fromJson(String str) => VSize.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  VSize.fromMap(Map<String, dynamic> json)
      : sizeid = json['sizeid'],
        sizetype = json['sizetype'],
        title = json['title'],
        detail = json['detail'],
        us = json['us'],
        eu = json['eu'],
        jp = json['jp'];

  Map<String, dynamic> toMap() => {
        'sizeid': sizeid,
        'sizetype': sizetype,
        'title': title,
        'detail': detail,
        'us': us,
        'eu': eu,
        'jp': jp,
      };
}

class ProductColor {
  final String productcolorid;
  final String colorid;
  final String color;
  final String hexcode;

  ProductColor({
    required this.productcolorid,
    required this.colorid,
    required this.color,
    required this.hexcode,
  });

  factory ProductColor.fromJson(String str) =>
      ProductColor.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  ProductColor.fromMap(Map<String, dynamic> json)
      : productcolorid = json['productcolorid'],
        colorid = json['colorid'],
        color = json['color'],
        hexcode = json['hexcode'];

  Map<String, dynamic> toMap() => {
        'productcolorid': productcolorid,
        'colorid': colorid,
        'color': color,
        'hexcode': hexcode,
      };
}

class VColor {
  final String colorid;
  final String title;
  final String hexcode;

  VColor({
    required this.colorid,
    required this.title,
    required this.hexcode,
  });

  factory VColor.fromJson(String str) => VColor.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  VColor.fromMap(Map<String, dynamic> json)
      : colorid = json['colorid'],
        title = json['title'],
        hexcode = json['hexcode'];

  Map<String, dynamic> toMap() => {
        'colorid': colorid,
        'title': title,
        'hexcode': hexcode,
      };
}

class Manufacture {
  final String manufactureid;
  final String title;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? videourl;
  final String? content;
  final String? flagurl;

  Manufacture({
    required this.manufactureid,
    required this.title,
    this.landscapeurl,
    this.portraiturl,
    this.videourl,
    this.content,
    this.flagurl,
  });

  factory Manufacture.fromJson(String str) =>
      Manufacture.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Manufacture.fromMap(Map<String, dynamic> json)
      : manufactureid = json['manufactureid'],
        title = json['title'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        videourl = json['videourl'],
        content = json['content'],
        flagurl = json['flagurl'];

  Map<String, dynamic> toMap() => {
        'manufactureid': manufactureid,
        'title': title,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'videourl': videourl,
        'content': content,
        'flagurl': flagurl,
      };
}

class OrderDetailMessage {
  final String orderdetailmessageid;
  final String firstname;
  final String lastname;
  final String memberphoto;
  final String message;
  final List<OrderDetailMessageMedia>? orderdetailmessagemedias;
  final String createdate;

  OrderDetailMessage({
    required this.orderdetailmessageid,
    required this.firstname,
    required this.lastname,
    required this.memberphoto,
    required this.message,
    this.orderdetailmessagemedias,
    required this.createdate,
  });

  factory OrderDetailMessage.fromJson(String str) =>
      OrderDetailMessage.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  OrderDetailMessage.fromMap(Map<String, dynamic> json)
      : orderdetailmessageid = json['orderdetailmessageid'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        memberphoto = json['memberphoto'],
        message = json['message'],
        orderdetailmessagemedias = List<OrderDetailMessageMedia>.from(
            json['orderdetailmessagemedias']!
                .map((x) => OrderDetailMessageMedia.fromMap(x))),
        createdate = json['createdate'];

  Map<String, dynamic> toMap() => {
        'orderdetailmessageid': orderdetailmessageid,
        'firstname': firstname,
        'lastname': lastname,
        'memberphoto': memberphoto,
        'message': message,
        'orderdetailmessagemedias':
            List<dynamic>.from(orderdetailmessagemedias!.map((x) => x.toMap())),
        'createdate': createdate,
      };
}

class OrderDetailMessageMedia {
  final String orderdetailmessagemediaid;
  final String url;

  OrderDetailMessageMedia({
    required this.orderdetailmessagemediaid,
    required this.url,
  });

  factory OrderDetailMessageMedia.fromJson(String str) =>
      OrderDetailMessageMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  OrderDetailMessageMedia.fromMap(Map<String, dynamic> json)
      : orderdetailmessagemediaid = json['orderdetailmessagemediaid'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'orderdetailmessagemediaid': orderdetailmessagemediaid,
        'url': url,
      };
}

class Justforyou {
  final String justforyouid;
  final String brandid;
  final String title;
  final String? subtitle;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? summary;
  final String? content;

  Justforyou({
    required this.justforyouid,
    required this.brandid,
    required this.title,
    this.subtitle,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.summary,
    this.content,
  });

  factory Justforyou.fromJson(String str) =>
      Justforyou.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Justforyou.fromMap(Map<String, dynamic> json)
      : justforyouid = json['justforyouid'],
        brandid = json['brandid'],
        title = json['title'],
        subtitle = json['subtitle'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        summary = json['summary'],
        content = json['content'];

  Map<String, dynamic> toMap() => {
        'justforyouid': justforyouid,
        'brandid': brandid,
        'title': title,
        'subtitle': subtitle,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'summary': summary,
        'content': content,
      };
}

class JustforyouMedia {
  final String justforyoumediaid;
  final int scaletype;
  final String url;

  JustforyouMedia({
    required this.justforyoumediaid,
    required this.scaletype,
    required this.url,
  });

  factory JustforyouMedia.fromJson(String str) =>
      JustforyouMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  JustforyouMedia.fromMap(Map<String, dynamic> json)
      : justforyoumediaid = json['justforyoumediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'justforyoumediaid': justforyoumediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class Homebanner {
  final String homebannerid;
  final String brandid;
  final String title;
  final String videourl;
  final String flagurl;

  Homebanner({
    required this.homebannerid,
    required this.brandid,
    required this.title,
    required this.videourl,
    required this.flagurl,
  });

  factory Homebanner.fromJson(String str) =>
      Homebanner.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Homebanner.fromMap(Map<String, dynamic> json)
      : homebannerid = json['homebannerid'],
        brandid = json['brandid'],
        title = json['title'],
        videourl = json['videourl'],
        flagurl = json['flagurl'];

  Map<String, dynamic> toMap() => {
        'homebannerid': homebannerid,
        'brandid': brandid,
        'title': title,
        'videourl': videourl,
        'flagurl': flagurl,
      };
}

class Campaign {
  final String campaignid;
  final String brandid;
  final String title;
  final String? subtitle;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? summary;
  final String? content;

  Campaign({
    required this.campaignid,
    required this.brandid,
    required this.title,
    this.subtitle,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.summary,
    this.content,
  });

  factory Campaign.fromJson(String str) => Campaign.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Campaign.fromMap(Map<String, dynamic> json)
      : campaignid = json['campaignid'],
        brandid = json['brandid'],
        title = json['title'],
        subtitle = json['subtitle'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        summary = json['summary'],
        content = json['content'];

  Map<String, dynamic> toMap() => {
        'campaignid': campaignid,
        'brandid': brandid,
        'title': title,
        'subtitle': subtitle,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'summary': summary,
        'content': content,
      };
}

class CampaignMedia {
  final String campaignmediaid;
  final int scaletype;
  final String url;

  CampaignMedia({
    required this.campaignmediaid,
    required this.scaletype,
    required this.url,
  });

  factory CampaignMedia.fromJson(String str) =>
      CampaignMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  CampaignMedia.fromMap(Map<String, dynamic> json)
      : campaignmediaid = json['campaignmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'campaignmediaid': campaignmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class Collection {
  final String collectionid;
  final String brandid;
  final String title;
  final String? subtitle;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? flagurl;
  final String? summary;
  final String? content;

  Collection({
    required this.collectionid,
    required this.brandid,
    required this.title,
    this.subtitle,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.flagurl,
    this.summary,
    this.content,
  });

  factory Collection.fromJson(String str) =>
      Collection.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Collection.fromMap(Map<String, dynamic> json)
      : collectionid = json['collectionid'],
        brandid = json['brandid'],
        title = json['title'],
        subtitle = json['subtitle'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        flagurl = json['flagurl'],
        summary = json['summary'],
        content = json['content'];

  Map<String, dynamic> toMap() => {
        'collectionid': collectionid,
        'brandid': brandid,
        'title': title,
        'subtitle': subtitle,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'flagurl': flagurl,
        'summary': summary,
        'content': content,
      };
}

class CollectionMedia {
  final String collectionmediaid;
  final int scaletype;
  final String url;

  CollectionMedia({
    required this.collectionmediaid,
    required this.scaletype,
    required this.url,
  });

  factory CollectionMedia.fromJson(String str) =>
      CollectionMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  CollectionMedia.fromMap(Map<String, dynamic> json)
      : collectionmediaid = json['collectionmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'collectionmediaid': collectionmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class Event {
  final String eventid;
  final String brandid;
  final String title;
  final String? subtitle;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? flagurl;
  final String? summary;
  final String? content;

  Event({
    required this.eventid,
    required this.brandid,
    required this.title,
    this.subtitle,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.flagurl,
    this.summary,
    this.content,
  });

  factory Event.fromJson(String str) => Event.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Event.fromMap(Map<String, dynamic> json)
      : eventid = json['eventid'],
        brandid = json['brandid'],
        title = json['title'],
        subtitle = json['subtitle'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        flagurl = json['flagurl'],
        summary = json['summary'],
        content = json['content'];

  Map<String, dynamic> toMap() => {
        'eventid': eventid,
        'brandid': brandid,
        'title': title,
        'subtitle': subtitle,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'flagurl': flagurl,
        'summary': summary,
        'content': content,
      };
}

class EventMedia {
  final String eventmediaid;
  final int scaletype;
  final String url;

  EventMedia({
    required this.eventmediaid,
    required this.scaletype,
    required this.url,
  });

  factory EventMedia.fromJson(String str) =>
      EventMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  EventMedia.fromMap(Map<String, dynamic> json)
      : eventmediaid = json['eventmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'eventmediaid': eventmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class WhatsNew {
  final String whatsnewid;
  final String title;
  final String? videourl;
  //橫圖
  final String? landscapeurl;
  //直圖
  final String? portraiturl;
  final String? summary;
  final String? content;

  WhatsNew({
    required this.whatsnewid,
    required this.title,
    this.videourl,
    this.landscapeurl,
    this.portraiturl,
    this.summary,
    this.content,
  });

  factory WhatsNew.fromJson(String str) => WhatsNew.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  WhatsNew.fromMap(Map<String, dynamic> json)
      : whatsnewid = json['whatsnewid'],
        title = json['title'],
        videourl = json['videourl'],
        landscapeurl = json['landscapeurl'],
        portraiturl = json['portraiturl'],
        summary = json['summary'],
        content = json['content'];

  Map<String, dynamic> toMap() => {
        'whatsnewid': whatsnewid,
        'title': title,
        'videourl': videourl,
        'landscapeurl': landscapeurl,
        'portraiturl': portraiturl,
        'summary': summary,
        'content': content,
      };
}

class WhatsNewMedia {
  final String whatsnewmediaid;
  final int scaletype;
  final String url;

  WhatsNewMedia({
    required this.whatsnewmediaid,
    required this.scaletype,
    required this.url,
  });

  factory WhatsNewMedia.fromJson(String str) =>
      WhatsNewMedia.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  WhatsNewMedia.fromMap(Map<String, dynamic> json)
      : whatsnewmediaid = json['whatsnewmediaid'],
        scaletype = json['scaletype'],
        url = json['url'];

  Map<String, dynamic> toMap() => {
        'whatsnewmediaid': whatsnewmediaid,
        'scaletype': scaletype,
        'url': url,
      };
}

class WeChatData {
  final String nickname;
  final String unionid;

  WeChatData({
    required this.nickname,
    required this.unionid,
  });

  factory WeChatData.fromJson(String str) =>
      WeChatData.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  WeChatData.fromMap(Map<String, dynamic> json)
      : nickname = json['nickname'],
        unionid = json['unionid'];

  Map<String, dynamic> toMap() => {
        'nickname': nickname,
        'unionid': unionid,
      };
}

class Setup {
  final int discounttype;
  final int isfreeshipping;
  final double freeshippingreach;
  final double freightsd;
  final double freight;
  final int ischargemembershipfee;
  final String? freemembershipfeeuntil;
  final int quantitytype;
  final int stockwarnamount;

  Setup({
    required this.discounttype,
    required this.isfreeshipping,
    required this.freeshippingreach,
    required this.freightsd,
    required this.freight,
    required this.ischargemembershipfee,
    this.freemembershipfeeuntil,
    required this.quantitytype,
    required this.stockwarnamount,
  });

  factory Setup.fromJson(String str) => Setup.fromMap(json.decode(str));
  String toJson() => json.encode(toMap());

  Setup.fromMap(Map<String, dynamic> json)
      : discounttype = json['discounttype'],
        isfreeshipping = json['isfreeshipping'],
        freeshippingreach = json['freeshippingreach'],
        freightsd = json['freightsd'],
        freight = json['freight'],
        ischargemembershipfee = json['ischargemembershipfee'],
        freemembershipfeeuntil = json['freemembershipfeeuntil'],
        quantitytype = json['quantitytype'],
        stockwarnamount = json['stockwarnamount'];

  Map<String, dynamic> toMap() => {
        'discounttype': discounttype,
        'isfreeshipping': isfreeshipping,
        'freeshippingreach': freeshippingreach,
        'freightsd': freightsd,
        'freight': freight,
        'ischargemembershipfee': ischargemembershipfee,
        'freemembershipfeeuntil': freemembershipfeeuntil,
        'quantitytype': quantitytype,
        'stockwarnamount': stockwarnamount,
      };
}
