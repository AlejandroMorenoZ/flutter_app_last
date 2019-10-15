import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class Authenticaation extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

abstract class BaseAuth {
  Future<void> verifyNumber();
}


class _AuthenticationState extends State<Authenticaation> {
  String phoneNo;
  String smsCode;
  String verificationId;

  @override
  Future<void> verifyNumber() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve=(String verID){
      this.verificationId=verID;
    };
    final PhoneVerificationCompleted verificationSuccess=(AuthCredential credential){
      print("Verified");
      {Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
          MyHomePage(),
      ));
      }
    };

    final PhoneCodeSent smsCodeSent=(String verID,[int forceCodeResend]){
      this.verificationId=verID;
      Navigator.pop(context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>MyHomePage()));
    };

    final PhoneVerificationFailed verificationFailed= (AuthException exception){
      print('$exception.message');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verificationSuccess,
      verificationFailed: verificationFailed,
    );
  }

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)=> AlertDialog(
          title: Text("Enter SMS Code"),
          content: TextField(
              onChanged: (value){
                this.smsCode=value;
              }
          ),
          actions: <Widget>[
            RaisedButton(
              color: Colors.teal,
              child: Text("Done", style: TextStyle(color: Colors.white),),
              onPressed: (){
                FirebaseAuth.instance.currentUser().then((user){
                  if(user!=null) {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) =>
                            MyHomePage()
                        ));
                  }
                  else{
                    Navigator.pop(context);
                    signIn();
                  }
                });
              },
            )
          ],
        )
    );
  }

  signIn() async{
    final AuthCredential credential= PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,);
    await FirebaseAuth.instance.signInWithCredential(credential).then((user){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>
          MyHomePage()

      ));
    }).catchError((e)=>print(e));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}