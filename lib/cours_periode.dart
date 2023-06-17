import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Methodes.dart';
import 'package:collection/collection.dart';


class CoursPeriode extends StatefulWidget {
  const CoursPeriode({Key? key}) : super(key: key);

  @override
  State<CoursPeriode> createState() => _CoursPeriodeState();
}

class _CoursPeriodeState extends State<CoursPeriode> {

  List? items;
  late MyNewClass _myNewClass = MyNewClass();
  TextEditingController startDateController = TextEditingController(text: '2023/01/01');
  TextEditingController endDateController = TextEditingController(text: '2023/05/30');
  Future<void> selectDate(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
      setState(() {
        controller.text = formattedDate;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[150],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 268,
            padding: EdgeInsets.only(top: 50.0,left: 30.0,right: 30.0,bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // CircleAvatar(child: Drawer(child: Icon(Icons.list),),backgroundColor: Colors.white,radius: 30.0,),
                Row(
                  children: [
                    Icon(Icons.date_range,size: 35,), SizedBox(width: 10,),
                    Text('Etat de Payement',style: TextStyle(fontSize: 25.0,fontWeight: FontWeight.w900,fontStyle: FontStyle.italic),),
                  ],
                ),
                SizedBox(height: 8.0),
                Center(child: Text('Il y a ${items?.length} Cours',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,),)),

                SizedBox(height: 10.0),
                Container(height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: startDateController,
                          decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black45)),
                            labelText: 'Date de début',labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                          // readOnly: true,
                          onTap: () => selectDate(startDateController),
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Expanded(
                        child: TextFormField(
                          controller: endDateController ,
                          decoration: InputDecoration(focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black45,),),
                            labelText: 'Date de fin',labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                            border: OutlineInputBorder(),
                          ),
                          // readOnly: true,
                          onTap: () => selectDate(endDateController),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {

                      DateTime dateDeb = DateFormat('yyyy/MM/dd').parse(startDateController.text);
                      DateTime dateFin = DateFormat('yyyy/MM/dd').parse(endDateController.text);


                    _myNewClass.getCours( dateDeb, dateFin).then((total) {
                      setState(() {
                        items = total;
                      });
                    }).catchError((error) {
                      print('Erreur: $error');
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black54,foregroundColor: Colors.white,
                    elevation: 10,
                    padding: EdgeInsets.only(left: 120, right: 130),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text('Valider'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0,right: 16),
                child: items == null
                    ? Text("Items is null")
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: items!.length,
                  itemBuilder: (context, int index) {
                    // Tri des éléments par ordre croissant de date
                    // items!.sort((a, b) => a['date'].compareTo(b['date']));

                    return Container(
                      width: 200,height: 170,
                      margin: EdgeInsets.all(0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: Colors.black38,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        elevation: 20,
                        child: InkWell(
                          onTap: () {
                            // handle onTap
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 5,),
                              // Text('Prof Infos' ,style: TextStyle(fontSize: 20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.green),),
                              // SizedBox(height: 10,),
                              Text(
                                '${items![index]['nom']} ${items![index]['prenom']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Banque: ${items![index]['Banque']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Compte: ${items![index]['Compte']}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 15.0),
                              Container(width: 150,
                                child: Divider(thickness: 1.8,
                                  color: Colors.grey.shade900,
                                  height: 1,
                                ),
                              ),
                              // Text('Horaire:',style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.green),),
                              // SizedBox(height: 10,),
                              Text(
                                'Volume Horaire: ${items![index]['total'].toStringAsFixed(2)} ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              // SizedBox(height: 5,),
                              // Text(
                              //   'Taux: ${items![index]['Taux']} ',
                              //   style: TextStyle(
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.w500,
                              //     fontStyle: FontStyle.italic,
                              //   ),
                              // ),
                              SizedBox(height: 5,),
                              Text(
                                'Montant : ${items![index]['totalAvecTaux'].toStringAsFixed(0)} ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              SizedBox(height: 15,),

                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }


}
