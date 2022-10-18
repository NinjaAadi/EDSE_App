import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class AddReviewBloc {
  final _addReviewController = BehaviorSubject<Map<String, dynamic>>();
  final _submitButtonContrller = BehaviorSubject<String>();

  Map<String, dynamic> finalResponse = {};

  //Sink and stream for data
  get addReview => _addReviewController.sink.add;
  get addReviewStream => _addReviewController.stream;

  //Sink and stream for the button
  get addButtonState => _submitButtonContrller.sink.add;
  get addButtonStream => _submitButtonContrller.stream;

  //transformer function
  _addReviewTransformer() {
    return ScanStreamTransformer(
        (Map<String, String> cache, Map<String, String> data, index) {
      data.forEach((key, value) {
        cache[key] = value;
      });
      finalResponse = cache;
      return cache;
    }, <String, String>{});
  }
}
