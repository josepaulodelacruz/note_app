import 'package:flutter/material.dart';
import 'package:note_common/bloc/note/note_cubit.dart';
import 'package:note_ui/screens/home/widgets/inputs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_ui/services/AdMobService.dart';
import 'package:note_ui/utils/appbar_shape.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  createState () => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen>  {
  MobileAdTargetingInfo targetingInfo;
  BannerAd myBanner;
  bool disposed = false;
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: AdMobService.bannerAd2(),
      size: AdSize.banner,
      listener: (MobileAdEvent event) {
        if(event == MobileAdEvent.loaded) {
          if(disposed) {
            myBanner.dispose();
          } else {
            myBanner..show(
                anchorType: AnchorType.bottom,
                anchorOffset: MediaQuery.of(context).size.height * 0.12
            );
          }
        }
      }
    );
  }

  @override
  void initState () {
    super.initState();

    FirebaseAdMob.instance.initialize(appId: 'ca-app-pub-9536494732518702~5301528021');
    myBanner =  buildBannerAd()..load();
  }

  void displayBanner() async {
    disposed = false;
    if(myBanner == null) myBanner = buildBannerAd();
    myBanner.load();
  }

  void hideBanner() async {
    try {
      await myBanner?.dispose();
      disposed = true;
      myBanner = null;
    } catch (err) {
      print(err);
    }

  }

  @override
  void dispose() {
    myBanner?.dispose();
    hideBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shape: appBarShape(20),
        title: Text('Add Notes'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InputCard(
                controller: _title,
                field: 'Title',
              ),
              InputCard(
                controller: _description,
                field: 'Description',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _handleSubmit(),
        child: Icon(Icons.check),
      ),
    );
  }
  
  void _handleSubmit () {
    if(_formKey.currentState.validate()) {
      context.bloc<NoteCubit>().addNote(_title.text, _description.text);
      Navigator.of(context).pop();
    }
  }
}
