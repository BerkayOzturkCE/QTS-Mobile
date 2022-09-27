import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:technical_services/User/Pages/Chat/messages.dart';
import 'package:technical_services/User/Pages/Map/maps.dart';
import 'package:technical_services/User/Utils/functions.dart';
import 'package:technical_services/User/Widgets/widgets.dart';
import 'package:technical_services/User/data/Services.dart';
import 'package:technical_services/User/data/data.dart';
import 'package:technical_services/User/data/message.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:technical_services/main.dart';

class ChatPage extends StatefulWidget {
  ChatPage();
  List<Message> messageList = [];
  bool ChatRead = true;
  @override
  _ChatPageState createState() => _ChatPageState();
  Chat chat = new Chat();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatTextContr = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<QuerySnapshot> _MessageStream;

  @override
  Widget build(BuildContext context) {
    getChatFromFirebase();
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
        elevation: 0,
        backgroundColor: AppbarColor,
      ),
      backgroundColor: AppbarColor,
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: BGColor3,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: widget.ChatRead == true
                      ? Center(child: CircularProgressIndicator())
                      : StreamBuilder(
                          stream: _MessageStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text("Loading");
                            }

                            return ListView(
                              reverse: true,
                              children: snapshot.data!.docs
                                  .map((message) => MessageWidget(message))
                                  .toList(),
                            );
                          },
                        )),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: BGColor3,
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: chatTextContr,
                            autofocus: false,
                            maxLines: 6,
                            minLines: 1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Mesajını Yaz...',
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            PhotoSender();
                          },
                          icon: Icon(
                            Icons.attach_file,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () {
                      if (chatTextContr.text != "") {
                        Message message = new Message();
                        message.sender = CurrentuserData.id;
                        message.text = chatTextContr.text;
                        message.time = DateTime.now();
                        message.messageType = "Text";
                        message.imageHeight = 0;
                        message.imageWidth = 0;
                        message.url = "";
                        LoadMessagetoFirebase(message);
                        chatTextContr.text = "";
                        setState(() {});
                      }
                    },
                    icon: Icon(Icons.check),
                    color: Colors.black,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Message msgSnapToMsg(QueryDocumentSnapshot snapshot) {
    Message message = new Message();

    message.sender = snapshot['Sender'];
    message.text = snapshot['Message'].toString();
    message.url = snapshot['Url'].toString();
    Timestamp timestamp = snapshot['Time'];
    message.time = timestamp.toDate();
    message.messageType = snapshot['MessageType'].toString();
    message.imageHeight = snapshot['ImgHeight'];
    message.imageWidth = snapshot['ImgWidth'];

    return message;
  }

  Widget MessageWidget(
    QueryDocumentSnapshot messageSnap,
  ) {
    Message message = msgSnapToMsg(messageSnap);
    print(message.imageHeight);
    print(message.imageWidth);
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: message.sender == CurrentuserData.id
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                padding: message.messageType == "Text"
                    ? EdgeInsets.all(10)
                    : EdgeInsets.all(2),
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7),
                decoration: BoxDecoration(
                    color: message.sender == CurrentuserData.id
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(
                          message.sender == CurrentuserData.id ? 16 : 0),
                      bottomRight: Radius.circular(
                          message.sender == CurrentuserData.id ? 0 : 16),
                    )),
                child: message.messageType == "Text"
                    ? Text(
                        message.text,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                      )
                    : Container(
                        height:
                            (message.imageHeight - message.imageWidth).abs() >
                                    150
                                ? (message.imageHeight > message.imageWidth
                                    ? 320
                                    : 200)
                                : 250,
                        width:
                            (message.imageHeight - message.imageWidth).abs() >
                                    150
                                ? (message.imageWidth > message.imageHeight
                                    ? 320
                                    : 200)
                                : 250,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          child: Image.network(
                            message.url,
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              }
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      CircularLoadingIndicatorColor,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: message.sender == CurrentuserData.id
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 8,
                ),
                Text(
                  DateFormat('Hm', 'en_US').format(message.time).toString(),
                  style: TextStyle(
                      color: TextColor,
                      fontWeight: FontWeight.w300,
                      fontSize: 8),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void LoadMessagetoFirebase(Message message) async {
    try {
      DocumentReference ref = FirebaseFirestore.instance
          .collection("Chats")
          .doc(widget.chat.ChatId)
          .collection('Messages')
          .doc();

      Map<String, dynamic> eklenecek = Map();
      eklenecek["Sender"] = message.sender;
      eklenecek["MessageType"] = message.messageType;
      eklenecek["Message"] = message.text;
      eklenecek["Time"] = message.time;
      eklenecek["Url"] = message.url;
      eklenecek["ImgWidth"] = message.imageWidth;
      eklenecek["ImgHeight"] = message.imageHeight;

      ref.set(eklenecek);
    } catch (e) {
      WarningWidget(e.toString() + " Hatası Alındı", "Hata", context);
    }
  }

  void getMessageFromFirebase() async {
    if (widget.ChatRead == true) {
      Chat chat = new Chat();
      var veriler = await _firestore
          .collection("Chats")
          .where("UserId", isEqualTo: CurrentuserData.id)
          .where("ServiceId", isEqualTo: Activeservices.Id)
          .get();
      print("/n/n/n/n");
      print(veriler.size);

      if (veriler.size == 0) {
        DocumentReference ref =
            FirebaseFirestore.instance.collection("Chats").doc();

        chat.ChatId = ref.id;
        chat.ServiceId = Activeservices.Id;
        chat.UserId = CurrentuserData.id;
        chat.UserImg = CurrentuserData.Image;
        Map<String, dynamic> eklenecek = Map();
        eklenecek["Id"] = chat.ChatId;
        eklenecek["ServiceId"] = chat.ServiceId;
        eklenecek["UserId"] = chat.UserId;
        eklenecek["UserImg"] = chat.UserImg;
        ref.set(eklenecek);
      } else {
        for (var veri in veriler.docs) {
          debugPrint(veri.data().toString());

          chat.ChatId = veri.get("Id").toString();
          chat.ServiceId = veri.get("ServiceId").toString();
          chat.UserId = veri.get("UserId").toString();
          chat.UserImg = veri.get("UserImg").toString();
        }
      }
      widget.chat = chat;
      if (this.mounted) {
        setState(() {
          widget.ChatRead = false;
        });
      }
      ;
    }
  }

  void getChatFromFirebase() async {
    if (widget.ChatRead == true) {
      Chat chat = new Chat();
      var veriler = await _firestore
          .collection("Chats")
          .where("UserId", isEqualTo: CurrentuserData.id)
          .where("ServiceId", isEqualTo: Activeservices.Id)
          .get();
      print("/n/n/n/n");

      print(veriler.size);

      if (veriler.size == 0) {
        DocumentReference ref =
            FirebaseFirestore.instance.collection("Chats").doc();

        chat.ChatId = ref.id;
        chat.ServiceId = Activeservices.Id;
        chat.UserId = CurrentuserData.id;
        chat.UserImg = CurrentuserData.Image;
        chat.UserName = CurrentuserData.name;
        Map<String, dynamic> eklenecek = Map();
        eklenecek["Id"] = chat.ChatId;
        eklenecek["ServiceId"] = chat.ServiceId;
        eklenecek["UserId"] = chat.UserId;
        eklenecek["UserImg"] = chat.UserImg;
        eklenecek["UserName"] = chat.UserName;
        ref.set(eklenecek);
      } else {
        for (var veri in veriler.docs) {
          debugPrint(veri.data().toString());

          chat.ChatId = veri.get("Id").toString();
          chat.ServiceId = veri.get("ServiceId").toString();
          chat.UserId = veri.get("UserId").toString();
          chat.UserImg = veri.get("UserImg").toString();
        }
      }
      widget.chat = chat;
      _MessageStream = FirebaseFirestore.instance
          .collection('Chats')
          .doc(widget.chat.ChatId)
          .collection('Messages')
          .orderBy('Time', descending: true)
          .snapshots();

      if (this.mounted) {
        setState(() {
          widget.ChatRead = false;
        });
      }
      ;
    }
  }

  void PhotoSender() async {
    try {
      String resimUrl;
      var resim = await ImagePicker()
          .pickImage(source: ImageSource.gallery)
          .onError((error, stackTrace) => null);

      if (resim != null) {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child("images")
            .child(resim.path);
        firebase_storage.UploadTask uploadTask = ref.putFile(File(resim.path));
        showLoaderDialog(context);
        debugPrint(resim.path);
        File imageFile = File(resim.path);
        var decodedImage =
            await decodeImageFromList(imageFile.readAsBytesSync());

        print(decodedImage.height);
        resimUrl = await (await uploadTask.whenComplete(() async {
          Message message = new Message();
          message.sender = CurrentuserData.id;
          message.text = "";
          message.time = DateTime.now();
          message.messageType = "Image";
          message.imageHeight = decodedImage.height;
          message.imageWidth = decodedImage.width;

          message.url = await ref.getDownloadURL();
          LoadMessagetoFirebase(message);
          FocusManager.instance.primaryFocus!.unfocus();
          setState(() {});
          Navigator.pop(context);
        }))
            .ref
            .getDownloadURL();
      }
    } catch (error) {
      print(error);
    }
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Yükleniyor...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
