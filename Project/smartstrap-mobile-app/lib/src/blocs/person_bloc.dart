import 'package:bloc_provider/bloc_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:smartstrap/src/blocs/main_app_bloc.dart';
import 'package:smartstrap/src/models/person.dart';

class PersonBloc extends Bloc {
  final Person person;
  final MainAppBloc mainAppBloc;

  PersonBloc({this.person, this.mainAppBloc}) {
    mainAppBloc.alertControllers.listen((Map<String, bool> alertMap) {
      inFall.add(alertMap[person.id]);
    });

    mainAppBloc.heartBeatControllers.listen((Map<String, int> heartBeatMap) {
      inHeartRate.add(heartBeatMap[person.id]);
    });
  }

  BehaviorSubject<bool> _strapConnectedController =
      BehaviorSubject<bool>.seeded(true);
  Sink<bool> get inIsStrapConnected => _strapConnectedController.sink;
  Stream<bool> get outIsStrapConnected => _strapConnectedController.stream;

  BehaviorSubject<bool> _fallController = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get inFall => _fallController.sink;
  Stream<bool> get outFall => _fallController.stream;

  ReplaySubject<int> _heartRateController = ReplaySubject<int>();
  Sink<int> get inHeartRate => _heartRateController.sink;
  Stream<int> get outHeartRate => _heartRateController.stream;

  @override
  void dispose() async {
    await _strapConnectedController?.drain();
    _strapConnectedController?.close();
    await _heartRateController?.drain();
    _heartRateController?.close();
    await _fallController?.drain();
    _fallController?.close();
  }
}
