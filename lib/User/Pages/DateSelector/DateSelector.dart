import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Date.dart';
import 'package:technical_services/User/data/UserCalls.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:technical_services/User/data/hour.dart';

class DateSelectorPage extends StatefulWidget {
  Hour? selectedhour = null;
  Date? selectedDate = null;
  DateTime currentday = DateTime.now();
  bool dayMarker = false;
  List<Date> dateList = [];
  List<UserCalls> usercallList = [];
  List<Hour> hourList = [];
  bool download = true;
  bool datecreate = true;

  List<int> timeList = [];
  List<int> MinuteList = [];

  @override
  State<DateSelectorPage> createState() => _DateSelectorPageState();
}

class _DateSelectorPageState extends State<DateSelectorPage> {
  int _selectedCategory = 0;
  PageController _pageController = PageController(initialPage: 0);
  FixedExtentScrollController fixedextent = FixedExtentScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final panelController = PanelController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String locale = Localizations.localeOf(context).languageCode;

    datecategorycreate();
    veriAl();
    String sonuc = "";

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        foregroundColor: TextColor,
        centerTitle: false,
        title: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                Activeservices.Image,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Activeservices.Name,
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 30),
            margin: EdgeInsets.only(right: 5),
          )
        ],
        elevation: 0,
        backgroundColor: AppbarColor,
      ),
      backgroundColor: AppbarColor,
      body: widget.datecreate == true
          ? Center(
              child: Column(children: [
                SizedBox(
                  height: 80,
                ),
                CircularProgressIndicator(
                  backgroundColor: CircularLoadingIndicatorColor,
                ),
              ]),
            )
          : SlidingUpPanel(
              controller: panelController,
              color: BGColor3,
              backdropEnabled: true,
              minHeight: 0,
              maxHeight: 800,
              backdropTapClosesPanel: true,
              panelSnapping: true,
              renderPanelSheet: true,
              defaultPanelState: PanelState.CLOSED,
              backdropColor: BGColor3,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50), topRight: Radius.circular(50)),
              panel: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: BGColor3,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                child: Column(children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      DateFormat.yMMMMd('tr').format(widget.selectedDate!.date),
                      style: TextStyle(
                          color: TextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 5,
                  ),
                  Text(DateFormat.EEEE('tr').format(widget.selectedDate!.date),
                      style: TextStyle(
                          color: TextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w500)),
                  Container(
                    height: 180,
                    child: CupertinoPicker(
                        scrollController: fixedextent,
                        itemExtent: 32.0,
                        magnification: 3.35 / 2.1,
                        useMagnifier: true,
                        backgroundColor: Colors.transparent,
                        squeeze: 1,
                        onSelectedItemChanged: (i) {
                          widget.selectedhour = widget.hourList[i];
                        },
                        children: widget.hourList
                            .map((e) => ClockWidget(e))
                            .toList()),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (widget.selectedhour!.durum == "full") {
                        WarningWidget(
                            "Seçtiğiniz tarih geçersiz", "Hata", context);
                      } else {
                        ServisEkle(context);
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.all(40),
                      height: 60,
                      decoration: BoxDecoration(
                        color: buttonColor2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          "Teknik Servis Çağır",
                          style: TextStyle(
                            fontSize: 25,
                            letterSpacing: 1,
                            color: TextColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              body: Container(
                height: double.maxFinite,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: BGColor1,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                  children: [
                    TableCalendar(
                      locale: 'tr',
                      onDaySelected: (selectedDay, focusedDay) {
                        if (selectedDay.weekday == DateTime.sunday) {
                        } else {
                          print(panelController.isAttached);
                          if (panelController.isAttached) {
                            panelController.animatePanelToPosition(0.5,
                                curve: Curves.linear,
                                duration: Duration(milliseconds: 500));
                            fixedextent.jumpToItem(0);

                            widget.download = true;
                            widget.currentday = selectedDay;
                            widget.dayMarker = true;
                            Date date = new Date();
                            date.date = selectedDay;
                            date.ddmmyyyy = DateFormat('dd.MM.yyyy')
                                .format(selectedDay)
                                .toString();
                            date.hour = "";
                            date.id = 0;
                            widget.selectedDate = date;
                            setState(() {});
                          }
                        }
                      },
                      currentDay: widget.currentday,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      calendarStyle: CalendarStyle(
                        isTodayHighlighted: widget.dayMarker,
                        defaultTextStyle: TextStyle(
                          color: TextColor,
                        ),
                        disabledTextStyle:
                            TextStyle(color: TextDateColor, fontSize: 14),
                        holidayTextStyle:
                            TextStyle(color: TextDateColor, fontSize: 14),
                        selectedTextStyle:
                            TextStyle(color: TextColor, fontSize: 18),
                        todayTextStyle:
                            TextStyle(color: TextColor, fontSize: 18),
                        weekendTextStyle:
                            TextStyle(color: TextDateColor, fontSize: 14),
                      ),
                      calendarFormat: CalendarFormat.month,
                      daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle:
                              TextStyle(color: TextColor, fontSize: 16),
                          weekendStyle:
                              TextStyle(color: TextDateColor, fontSize: 16)),
                      headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(color: TextColor),
                          formatButtonVisible: false,
                          leftChevronIcon: Icon(
                            Icons.keyboard_arrow_left,
                            color: TextColor,
                          ),
                          rightChevronIcon: Icon(
                            Icons.keyboard_arrow_right,
                            color: TextColor,
                          )),
                      weekendDays: [7],
                      firstDay: DateTime.now(),
                      lastDay: DateTime.now().add(Duration(days: 30)),
                      focusedDay: DateTime.now(),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget ClockWidget(Hour hour) {
    Color? bgColor;
    Icon? icon;
    if (hour.durum == "selected") {
      bgColor = Colors.green;
      icon = Icon(
        Icons.check_outlined,
        size: 20,
        color: TextColor,
      );
    } else if (hour.durum == "full") {
      bgColor = Colors.red;
      icon = Icon(
        Icons.close,
        size: 25,
        color: TextColor,
      );
    } else {
      icon = Icon(
        Icons.check,
        color: TextColor,
      );
      bgColor = Colors.grey[700];
    }
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            hour.saat.padLeft(4, '0') + "0",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: TextColor,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          icon != null
              ? icon
              : SizedBox(
                  width: 0,
                ),
        ],
      ),
    );
  }

  Widget CategoryItem(Date date) {
    String Title = date.date.day.toString().padLeft(2, '0') +
        "\n" +
        date.date.month.toString().padLeft(2, '0') +
        "." +
        date.date.year.toString();
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = date.id;
          widget.selectedDate = date;
          widget.download = true;
          widget.selectedhour = null;
        });

        //_pageController.animateToPage(date.id,
        //  duration: Duration(milliseconds: 300), curve: Curves.ease);
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(Title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: TextColor,
                  fontWeight: _selectedCategory == date.id
                      ? FontWeight.bold
                      : FontWeight.normal,
                )),
            SizedBox(
              height: 4,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: 2,
              width: _selectedCategory == date.id ? Title.length * 4.5 : 0,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(4)),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> datecategorycreate() async {
    if (widget.download == true) {
      if (widget.datecreate == true) {
        widget.dateList.clear();
        for (var i = 0; i < 5; i++) {
          Date date = new Date();
          date.date = DateTime.now().add(Duration(days: i));
          date.ddmmyyyy = DateFormat('dd.MM.yyyy')
              .format(DateTime.now().add(Duration(days: i)))
              .toString();
          date.hour = "";
          date.id = i;
          widget.dateList.add(date);
        }
        widget.datecreate = false;
        widget.selectedDate = widget.dateList[0];
      }
    }
  }

  void hourCreate() {
    if (widget.download == true) {
      double sayac = 09.00;
      widget.hourList.clear();
      for (var i = 0; i < 12; i++) {
        Hour hour = new Hour();
        hour.durum = "";
        hour.saat = (sayac + i).toString();
        print(hour.saat.padLeft(4, '0') + "0");
        widget.hourList.add(hour);
      }

      for (var i = 0; i < widget.usercallList.length; i++) {
        for (var j = 0; j < widget.hourList.length; j++) {
          if (widget.usercallList[i].hour.toString() ==
              widget.hourList[j].saat) {
            widget.hourList[j].durum = "full";
            print(widget.hourList[j].saat + "\n asdsadsadsadsad");
            print(widget.hourList[j].durum + "\n asdsadsadsadsad");
          }
        }
      }
      print(widget.selectedDate!.date.toString());

      if (DateFormat('dd.MM.yyyy').format(widget.selectedDate!.date) ==
          DateFormat('dd.MM.yyyy').format(DateTime.now())) {
        for (var j = 0; j < widget.hourList.length; j++) {
          if (double.parse(widget.hourList[j].saat) <=
              DateTime.now().add(Duration(hours: 2)).hour.toDouble()) {
            print(widget.hourList[j].saat);
            widget.hourList[j].durum = "full";
          }
        }
      }
      widget.selectedhour = widget.hourList[0];
      widget.download = false;
      setState(() {});
    }
  }

  Future<void> veriAl() async {
    try {
      if (widget.download == true) {
        widget.usercallList.clear();
        var veriler = await _firestore
            .collection("Calls")
            .where("ServiceId", isEqualTo: Activeservices.Id)
            .where("Date", isEqualTo: widget.selectedDate!.ddmmyyyy)
            .get();

        for (var veri in veriler.docs) {
          UserCalls userCalls = new UserCalls();

          debugPrint(veri.data().toString());

          userCalls.Id = veri.get("Id").toString();
          userCalls.Image =
              Cryptology().Decryption(veri.get("Image").toString(), context);
          Timestamp tarih = veri.get("Tarih");
          userCalls.tarih = tarih.toDate();
          userCalls.Name =
              Cryptology().Decryption(veri.get("Name").toString(), context);
          userCalls.category =
              Cryptology().Decryption(veri.get("Category").toString(), context);
          userCalls.Fiyat = double.parse(
              Cryptology().Decryption(veri.get("Fiyat").toString(), context));
          userCalls.ServiceId = veri.get("ServiceId");
          userCalls.UserId = veri.get("UserId");
          userCalls.adres = Cryptology().Decryption(veri.get("Adres"), context);
          userCalls.apt = Cryptology().Decryption(veri.get("Apt"), context);
          userCalls.kat = Cryptology().Decryption(veri.get("Kat"), context);
          userCalls.no = Cryptology().Decryption(veri.get("No"), context);
          userCalls.lat = double.parse(
              Cryptology().Decryption(veri.get("Lat").toString(), context));
          userCalls.lon = double.parse(
              Cryptology().Decryption(veri.get("Lon").toString(), context));

          userCalls.hour = double.parse(veri.get("Hour").toString());
          userCalls.date = veri.get("Date").toString();

          widget.usercallList.add(userCalls);
        }
      }
      hourCreate();
    } catch (e) {
      WarningWidget(e.toString() + " hatası alındı!", "Hata", context);
    }
  }

  Future<void> ServisEkle(BuildContext context) async {
    try {
      if (widget.selectedhour != null) {
        userCalls.ServiceId = Activeservices.Id;
        userCalls.UserId = activeUser.uid;
        userCalls.Image = Activeservices.Image;
        userCalls.Name = Activeservices.Name;
        userCalls.category = Activeservices.category;
        userCalls.date = widget.selectedDate!.ddmmyyyy;
        userCalls.hour = double.parse(widget.selectedhour!.saat);
        userCalls.Fiyat = 0;
        print(userCalls);
        DocumentReference ref =
            FirebaseFirestore.instance.collection("Calls").doc();
        Map<String, dynamic> eklenecek = Map();
        eklenecek["ServiceId"] = userCalls.ServiceId;
        eklenecek["UserId"] = userCalls.UserId;
        eklenecek["Image"] = Cryptology().Encryption(userCalls.Image, context);
        eklenecek["Name"] = Cryptology().Encryption(userCalls.Name, context);
        eklenecek["UserName"] =
            Cryptology().Encryption(CurrentuserData.name, context);

        eklenecek["Category"] =
            Cryptology().Encryption(userCalls.category, context);
        eklenecek["Fiyat"] =
            Cryptology().Encryption(userCalls.Fiyat.toString(), context);

        eklenecek["Adres"] = Cryptology().Encryption(userCalls.adres, context);
        eklenecek["Apt"] = Cryptology().Encryption(userCalls.apt, context);
        eklenecek["Kat"] = Cryptology().Encryption(userCalls.kat, context);
        eklenecek["No"] = Cryptology().Encryption(userCalls.no, context);
        eklenecek["Lat"] =
            Cryptology().Encryption(userCalls.lat.toString(), context);
        eklenecek["Lon"] =
            Cryptology().Encryption(userCalls.lon.toString(), context);
        eklenecek["Tarih"] = widget.selectedDate!.date;
        eklenecek["Hour"] = userCalls.hour;
        eklenecek["Date"] = userCalls.date;
        userCalls.Id = ref.id;

        eklenecek["Id"] = userCalls.Id;

        ref.set(eklenecek);
        success("İşlem Başarılı", "Başarılı", context);
      } else {
        WarningWidget("Lütfen Bir Saat Seçin", "Hata", context);
      }
    } catch (e) {
      WarningWidget(e.toString() + " Hatası Alındı", "Hata", context);
    }
  }

  void success(String warning, String title, BuildContext context) {
    showDialog(
      useRootNavigator: true,
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(const Radius.circular(15))),
          backgroundColor: BGColor1,
          title: Text(
            title,
            style: TextStyle(color: TextColor),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                  warning,
                  style: TextStyle(color: TextColor),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                    buttonColor,
                  )),
                  child: Text(
                    'Tamam',
                    style: TextStyle(color: TextColor),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName("/Service"));
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
