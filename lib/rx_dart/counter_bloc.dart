import 'package:rxdart/rxdart.dart';

class CounterBloc {
  //if the data is not passed by paramether it initializes with 0
  int initialCount = 0;
  late BehaviorSubject<int> _subjectCounter;

  CounterBloc({required this.initialCount}) {
    //initializes the subject with element already
    _subjectCounter = BehaviorSubject<int>.seeded(initialCount);
  }

  Stream<int> get counterObservable => _subjectCounter.stream;

  void increment() {
    initialCount++;
    _subjectCounter.sink.add(initialCount);
  }

  void decrement() {
    initialCount--;
    _subjectCounter.sink.add(initialCount);
  }

  void dispose() {
    _subjectCounter.close();
  }
}
