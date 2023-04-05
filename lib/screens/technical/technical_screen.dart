import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TechnicalScreen extends StatefulWidget {
  const TechnicalScreen({Key? key}) : super(key: key);

  @override
  State<TechnicalScreen> createState() => _TechnicalScreenState();
}

class _TechnicalScreenState extends State<TechnicalScreen> {

  static const CellInfoChannel = MethodChannel('com.example.projet_fin_annee_2gt/cell_info');
  String cellInfo ="";
  Future GetPhoneData() async{
    final arguments = {'RX' :'1'};
    final int newCellInfo = await CellInfoChannel.invokeMethod("getCellInfo",arguments);
    setState(() {
      cellInfo = '$newCellInfo' ;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Technical Services",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                cellInfo,
              ),
              MaterialButton(
                  onPressed: () => GetPhoneData(),
                  child: Text("Parameters"),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
