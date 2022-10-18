import 'package:edse_app/src/models/transport.dart';
import 'package:edse_app/src/widgets/spinner.dart';
import 'package:edse_app/src/widgets/transport_refresh.dart';
import 'package:flutter/material.dart';
import '../../blocs/providers/transport.dart';

class Transport extends StatelessWidget {
  const Transport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final transportBloc = TransportProvider.of(context);
    return StreamBuilder(
        stream: transportBloc.transportStream,
        builder: (context, AsyncSnapshot<List<TransportModel>> snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return LoadingContainer();
          } else {
            return Refresh(
                child: Column(
              children: <Widget>[
                searchBar(transportBloc), // Container
                Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(8),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return transportTile(snapshot.data![index]);
                        }))
              ],
            ));
          }
        });
  }

  Widget searchBar(transportBloc) {
    return Row(children: [
      Container(
        margin: EdgeInsets.all(20.0),
        child: SizedBox(
          width: 250,
          height: 40,
          child: TextField(
              decoration: const InputDecoration(hintText: 'Enter pincode'),
              onChanged: transportBloc.addTransportPinCode),
        ),
      ),
      StreamBuilder(
          stream: transportBloc.searchTransport,
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.all(5.0),
              child: ElevatedButton(
                onPressed: transportBloc.fetchTransportByPincode,
                child: Text('Search'),
              ),
            );
          })
    ]);
  }

  Widget transportTile(TransportModel model) {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Address : ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height:
                        2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height //font color //background color //letter spacing //make underline
                    decorationStyle:
                        TextDecorationStyle.double, //double underline
                    decorationColor:
                        Colors.brown, //text decoration 'underline' color
                    decorationThickness: 1.5, //decoration 'underline' thickness
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(model.address,
                    style: const TextStyle(
                      fontSize: 16,
                      height:
                          2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height //font color //background color //letter spacing //make underline
                      decorationStyle:
                          TextDecorationStyle.double, //double underline
                      decorationColor:
                          Colors.brown, //text decoration 'underline' color
                      decorationThickness:
                          1.5, //decoration 'underline' thickness
                    )),
              )
            ],
          ),
          Row(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Pincode : ",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height:
                        2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height //font color //background color //letter spacing //make underline
                    decorationStyle:
                        TextDecorationStyle.double, //double underline
                    decorationColor:
                        Colors.brown, //text decoration 'underline' color
                    decorationThickness: 1.5, //decoration 'underline' thickness
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(model.pinCode,
                    style: const TextStyle(
                      fontSize: 16,
                      height:
                          2, //line height 200%, 1= 100%, were 0.9 = 90% of actual line height //font color //background color //letter spacing //make underline
                      decorationStyle:
                          TextDecorationStyle.double, //double underline
                      decorationColor:
                          Colors.brown, //text decoration 'underline' color
                      decorationThickness:
                          1.5, //decoration 'underline' thickness
                    )),
              )
            ],
          )
        ],
        // children: [Text(model.address), Text(model.pinCode)],
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
    );
  }
}
