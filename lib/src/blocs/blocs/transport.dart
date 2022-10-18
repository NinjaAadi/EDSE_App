import 'package:edse_app/src/models/transport.dart';
import 'package:edse_app/src/resources/transport/transport_api_provider.dart';
import 'package:rxdart/rxdart.dart';

class TransportBloc {
  final transportApiProvider = TransportApiProvider();
  //Stream controller for transport fetching
  final _transportController = BehaviorSubject<List<TransportModel>>();
  final _transportSearch = BehaviorSubject<String>();
  //Getters
  get addTransport => _transportController.sink.add;
  get addTransportPinCode => _transportSearch.sink.add;

  //Streams
  get transportStream => _transportController.stream;
  get searchTransport => _transportSearch.stream;
  //listen to the transportSearch stream

  fetchTransport() async {
    final allTransports = await transportApiProvider.fetchTransports();
    await addTransport(allTransports);
  }

  fetchTransportByPincode() async {
    if (_transportSearch.value == "") return;

    String pinCode = _transportSearch.value;
    final allTransports =
        await transportApiProvider.fetchTransportByPincode(pinCode);
    await addTransport(allTransports);
  }
}
