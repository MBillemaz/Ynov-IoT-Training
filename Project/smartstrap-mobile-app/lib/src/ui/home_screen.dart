import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartstrap/src/blocs/main_app_bloc.dart';
import 'package:smartstrap/src/blocs/person_bloc.dart';
import 'package:smartstrap/src/models/person.dart';
import 'package:smartstrap/src/ui/person_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainAppBloc mainAppBloc = BlocProvider.of<MainAppBloc>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            gradient:
                RadialGradient(center: Alignment(0, -1), radius: 2, colors: [
          Color(0xff51245E),
          Color(0xff1E0126),
        ])),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Text(
                'SMARTSTRAP',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 30),
              ),
              SizedBox(
                height: 250,
              ),
              Text(
                'Connected straps',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              StreamBuilder<Map<String, int>>(
                  stream: mainAppBloc.heartBeatControllers.stream,
                  builder: (context, AsyncSnapshot<Map<String, int>> snapshot) {
                    return Column(
                      children: MainAppBloc.persons.map((Person person) {
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) {
                                return BlocProvider<PersonBloc>(
                                  creator: (_context, _bag) => PersonBloc(
                                      person: person, mainAppBloc: mainAppBloc),
                                  child: PersonScreen(
                                    person: person,
                                  ),
                                );
                              }));
                            },
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color(0xff51245E),
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  person.gender == 'F'
                                      ? 'assets/old-woman.png'
                                      : 'assets/old-man.png',
                                  height: 30,
                                  width: 30,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(person.firstName,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                Expanded(
                                  child: snapshot.hasData &&
                                          snapshot.data[person.id] != null
                                      ? StreamBuilder<Map<String, bool>>(
                                          stream: mainAppBloc
                                              .alertControllers.stream,
                                          initialData: mainAppBloc
                                              .alertControllers.value,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<Map<String, bool>>
                                                  snapshot) {
                                            if (!snapshot.data[person.id]) {
                                              return SvgPicture.asset(
                                                'assets/good.svg',
                                                height: 20,
                                                alignment:
                                                    Alignment.centerRight,
                                              );
                                            } else {
                                              return SvgPicture.asset(
                                                'assets/warning.svg',
                                                height: 20,
                                                alignment:
                                                    Alignment.centerRight,
                                              );
                                            }
                                          },
                                        )
                                      : Text(
                                          'Not connected',
                                          style: TextStyle(
                                              color: Colors.redAccent),
                                          textAlign: TextAlign.right,
                                        ),
                                )
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
