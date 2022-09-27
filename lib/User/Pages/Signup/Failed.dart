import 'package:flutter/material.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/data.dart';

class FailedPage extends StatefulWidget {
  const FailedPage({Key? key}) : super(key: key);

  @override
  _FailedPageState createState() => _FailedPageState();
}

class _FailedPageState extends State<FailedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "E-Mail Onaylanmadı",
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        foregroundColor: Colors.white,
        toolbarHeight: 60,
        backgroundColor: Color.fromARGB(255, 32, 34, 37),
      ),
      backgroundColor: Color.fromARGB(255, 47, 49, 54),
      body: Center(
          child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: Text(
              "Mail Hesabınıza gönderilen linke tıklayarak hesabınızı onaylayabilirsiniz.",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 16,
                letterSpacing: 1,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Image.asset(
            'assets/images/failed.jpg',
            fit: BoxFit.fill,
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              activeUser.sendEmailVerification();
              ToastWidget("Mail Gönderildi");
            },
            child: Container(
              width: ScreenUtil.getWidth(context) / 1.3,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 62, 66, 73),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  "Yeniden Mail Gönder",
                  style: TextStyle(
                    fontSize: 25,
                    letterSpacing: 1,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
