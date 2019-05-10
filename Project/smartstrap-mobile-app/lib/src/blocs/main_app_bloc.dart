import 'dart:convert';

import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartstrap/src/models/person.dart';
import 'package:web_socket_channel/io.dart';

class MainAppBloc extends Bloc {
  final alarmChannel =
      IOWebSocketChannel.connect('ws://10.69.3.82:1880/alarm/setState');

  final heartChannel =
      IOWebSocketChannel.connect('ws://10.69.3.82:1880/heartbeat');

  static final List<Person> persons = [
    Person(firstName: 'Martine', gender: 'F', id: '0280e1003402'),
    Person(firstName: 'Jean-Mi', gender: 'M', id: '0280e10034f1'),
    Person(firstName: 'Georgette', gender: 'F', id: 'test'),
  ];

  final BehaviorSubject<Map<String, bool>> alertControllers =
      BehaviorSubject<Map<String, bool>>.seeded(Map.fromIterable(persons,
          key: (person) => person.id, value: (_) => false));

  final BehaviorSubject<Map<String, int>> heartBeatControllers =
      BehaviorSubject<Map<String, int>>.seeded(Map.fromIterable(persons,
          key: (person) => person.id, value: (_) => null));

  MainAppBloc() {
    alarmChannel.stream.listen((jsonResponse) {
      Map<String, dynamic> response = jsonDecode(jsonResponse);
      Map<String, bool> alertMap = alertControllers.value;
      print(response['status']);
      if (response['status'] == 0) {
        alertMap[response['uuid']] = false;
      } else if (response['status'] == 1) {
        alertMap[response['uuid']] = true;
      } else {
        print(response['status']);
        alertMap[response['uuid']] = false;
      }
      print(alertMap);

      alertControllers.sink.add(alertMap);
    });

    heartChannel.stream.listen((res) {
      Map<String, dynamic> response = jsonDecode(res);
      Map<String, int> heartBeatMap = heartBeatControllers.value;
      heartBeatMap[response['uuid']] = response['value'];
      heartBeatControllers.sink.add(heartBeatMap);
    });
  }

  void changeAlertStatusToCome(String userId) {
    var statusToSend = '{"uuid":"$userId","status":2}';
    return alarmChannel.sink.add(statusToSend);
  }

  @override
  void dispose() async {
    await alertControllers?.drain();
    alertControllers?.close();

    await heartBeatControllers?.drain();
    heartBeatControllers?.close();
  }
}
