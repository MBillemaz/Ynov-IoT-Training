import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:smartstrap/src/blocs/person_bloc.dart';
import 'package:smartstrap/src/models/person.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PersonScreen extends StatelessWidget {
  final Person person;

  PersonScreen({this.person});

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<PersonBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
          gradient:
              RadialGradient(center: Alignment(0, -1), radius: 2, colors: [
            Color(0xff51245E),
            Color(0xff1E0126),
          ]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Stack(
                children: <Widget>[
                  Positioned.fill(
                    top: 12.5,
                    child: Text(
                      person.firstName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w200),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      'assets/left-arrow.svg',
                      height: 25,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            StreamBuilder<bool>(
                stream: bloc.outIsStrapConnected,
                builder: (context, snapshot) {
                  return Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/heart.svg',
                        height: 200,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          StreamBuilder<int>(
                              stream: bloc.outHeartRate,
                              builder: (context, heartSnapshot) {
                                return Text(
                                  heartSnapshot.data.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.w600),
                                );
                              }),
                          Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Text(
                              'BPM',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      StreamBuilder<Object>(
                          stream: bloc.outFall,
                          initialData: false,
                          builder: (context, fallSnapshot) {
                            if (fallSnapshot.data) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  SvgPicture.asset('assets/warning.svg'),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SvgPicture.asset('assets/fall.svg'),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        'ALERT !',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xffFE7059),
                                            fontSize: 30),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      onPressed: () {
                                        bloc.mainAppBloc
                                            .changeAlertStatusToCome(person.id);
                                      },
                                      color: Colors.redAccent,
                                      child: Text(
                                        'I COME!',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                ],
                              );
                            }
                            return Column(
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/good.svg',
                                  height: 150,
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  'Everything looks good for ${person.firstName}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xff93FFB7).withOpacity(0.8),
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            );
                          }),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
