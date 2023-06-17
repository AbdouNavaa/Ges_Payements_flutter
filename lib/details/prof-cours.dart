import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Methodes.dart';
import '../models/models.dart';

class ProfCours extends StatefulWidget {
  // final token;
  const ProfCours({Key? key, this.ProfId, required this.ProfName}) : super(key: key);
  final String? ProfId;
  final String ProfName;

  @override
  State<ProfCours> createState() => _ProfCoursState();
}

class _ProfCoursState extends State<ProfCours> {

  late String userId;
  TextEditingController _matiere = TextEditingController();
  TextEditingController _prof = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController _Deb = TextEditingController();
  TextEditingController _Fin = TextEditingController();
  TextEditingController _CM = TextEditingController();
  TextEditingController _TP = TextEditingController();
  TextEditingController _TD = TextEditingController();
  TextEditingController _total = TextEditingController();
  // TextEditingController _id = TextEditingController();
  List? items;
  late MyNewClass _myNewClass = MyNewClass();
  Prof? _selectedProf; // initialiser le type sélectionné à null
  Matiere? _selectedMatiere; //
  num? _selectedCM ;
  num? _selectedTP ;
  num? _selectedTD ;

  Future<void> selectDate(TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.utc(1,1,1,0,0,0),
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
  Future<void> selectDateCal(TextEditingController controller) async {
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
  Future<void> selectTime(TextEditingController controller) async {
    DateTime? selectedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );

    if (selectedDateTime != null) {
      TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        DateTime selectedDateTimeWithTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        String formattedDateTime = DateFormat('yyyy/MM/dd HH:mm').format(selectedDateTimeWithTime);
        setState(() {
          controller.text = formattedDateTime;
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    _myNewClass.ProfCours(widget.ProfId).then((data) {
      setState(() {
        items = data; // Assigner la liste renvoyée par Professeur à items
      });
    }).catchError((error) {
      print('Erreur: $error');
    });
  }

  TextEditingController startDateController = TextEditingController(text: '2023/01/01');
  TextEditingController endDateController = TextEditingController(text: '2023/05/30');
  // Future<void> selectDate(TextEditingController controller) async {
  //   DateTime? selectedDate = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.utc(1,1,1,0,0,0),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2030),
  //   );
  //
  //   if (selectedDate != null) {
  //     String formattedDate = DateFormat('yyyy/MM/dd').format(selectedDate);
  //     setState(() {
  //       controller.text = formattedDate;
  //     });
  //   }
  // }

  List? filteredItems;

  @override
  Widget build(BuildContext context) {

    if (items != null) {
      DateTime? startDate;
      DateTime? endDate;
      if (startDateController.text.isNotEmpty) {
        startDate = DateFormat('yyyy/MM/dd').parse(startDateController.text);
      }
      if (endDateController.text.isNotEmpty) {
        endDate = DateFormat('yyyy/MM/dd').parse(endDateController.text);
      }

      filteredItems = items!.where((item) {
        final itemDate = DateTime.parse(item['date']);
        return (startDate == null || itemDate.isAtSameMomentAs(startDate) || itemDate.isAfter(startDate)) &&
            (endDate == null || itemDate.isAtSameMomentAs(endDate) || itemDate.isBefore(endDate));
      }).toList();
    } else {
      filteredItems = null;
    }

    return Scaffold(
      backgroundColor: Colors.green[150],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    ' ${widget.ProfName} Cours: ${items?.length} ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: startDateController,
                        decoration: InputDecoration(
                          labelText: 'Date de début',
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
                        decoration: InputDecoration(
                          labelText: 'Date de fin',
                          border: OutlineInputBorder(),
                        ),
                        // readOnly: true,
                        onTap: () => selectDate(endDateController),
                      ),
                    ),
                    SizedBox(width: 5.0),
                    Expanded(
                      child: TextField(
                        readOnly: true,
                        controller: _total,
                        decoration: InputDecoration(
                          labelText: 'Total',
                          border: OutlineInputBorder(borderSide: BorderSide(width: 10)),
                        ),
                        // Handle date input for end date
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),
                // SizedBox(height: 5.0),
                ElevatedButton(
                  onPressed: () {
                    String id = widget.ProfId ?? '';
                    DateTime dateDeb = DateFormat('yyyy/MM/dd').parse(startDateController.text);
                    DateTime dateFin = DateFormat('yyyy/MM/dd').parse(endDateController.text);
                    _myNewClass.getTotal(id, dateDeb, dateFin).then((total) {
                      setState(() {
                        _total.text = total!.toStringAsFixed(2);
                      });
                    }).catchError((error) {
                      print('Erreur: $error');
                    });
                  },
                  style: ElevatedButton.styleFrom(
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: filteredItems == null
                  ? Text("Items is null")
                  : ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: filteredItems!.length,
                itemBuilder: (context, int index) {
                  // Tri des éléments par ordre croissant de date
                  filteredItems!.sort((a, b) => a['date'].compareTo(b['date']));

                  return SingleChildScrollView(
                    child: Container(
                      width: 200,height: 210,
                      margin: EdgeInsets.only(top: 5.0,right: 5),

                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                          side: BorderSide(
                            color: Colors.black38,
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        elevation: 20,
                        child: InkWell(
                          onTap: () async{List<Matiere> matieres =await  _myNewClass.MatieresList() ;
                          List<Prof> profs =await  _myNewClass.Profs() ;
                          _selectedProf = items![index]['prof']['id'];
                          _selectedMatiere = items![index]['matiere']['id'];
                          _date.text = items![index]['date'];

                          _Deb.text = items![index]['Deb'];
                          _Fin.text = items![index]['Fin'];

                          _selectedCM = items![index]['CM'];
                          _CM.text = _selectedCM.toString();

                          _selectedTP = items![index]['TP'];
                          _TP.text = _selectedTP.toString();

                          _selectedTD = items![index]['TD'];
                          _TD.text = _selectedTD.toString();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Mise à jour de la tâche"),
                                content: Form(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        DropdownButtonFormField<Matiere>(
                                          value: _selectedMatiere,
                                          items: matieres.map((matiere) {
                                            return DropdownMenuItem<Matiere>(
                                              value: matiere,
                                              child: Text(matiere.name ?? ''),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedMatiere = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Matiere",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),
                                        DropdownButtonFormField<Prof>(
                                          value: _selectedProf,
                                          items: profs.map((prof) {
                                            return DropdownMenuItem<Prof>(
                                              value: prof,
                                              child: Text(prof.nom ?? ''),
                                            );
                                          }).toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              _selectedProf = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white,
                                            hintText: "Prof",labelText: "Prof",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                            ),
                                          ),
                                        ),

                                        TextFormField(
                                          controller: _date,
                                          decoration:
                                          InputDecoration(labelText: 'Date'),
                                          onTap: () => selectDateCal(_date),

                                        ),
                                        TextFormField(
                                          controller: _Deb,
                                          decoration:
                                          InputDecoration(labelText: 'Date'),
                                          onTap: () => selectTime(_Deb),

                                        ),
                                        TextFormField(
                                          controller: _Fin,
                                          decoration:
                                          InputDecoration(labelText: 'Date'),
                                          onTap: () => selectTime(_Fin),

                                        ),
                                        TextFormField(
                                          controller: _CM,
                                          decoration:
                                          InputDecoration(labelText: 'CM'),

                                        ),
                                        TextFormField(
                                          controller: _TP,
                                          decoration:
                                          InputDecoration(labelText: 'TP'),

                                        ),
                                        TextFormField(
                                          controller: _TD,
                                          decoration:
                                          InputDecoration(labelText: 'TD'),

                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("ANNULER"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      "MISE À JOUR",
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // _taux.text = _selectedCoef.toString(); // ajout de cette ligne
                                      DateTime date = DateFormat('yyyy/MM/dd').parse(_date.text);
                                      DateTime Deb = DateFormat('yyyy/MM/dd HH:mm').parse(_Deb.text);
                                      DateTime Fin = DateFormat('yyyy/MM/dd HH:mm').parse(_Fin.text);
                                      _myNewClass.UpdateCours(items![index]['_id'],_selectedProf!.id!,_selectedMatiere!.id!,date,Deb,Fin,
                                          double.parse(_CM.text), double.parse(_TP.text), double.parse(_TD.text));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Le Type est  Update avec succès.')));
                                      // );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          },

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 10,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Prof: ',
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.lightBlue
                                    ),
                                  ),
                                  Text(
                                    ' ${filteredItems![index]['prof']['nom']} ',
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.lightBlue
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Matiere: ',
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.lightBlue
                                      // color: Colors.lightBlue
                                    ),
                                  ),
                                  Text(
                                    '${items![index]['matiere']['name']}',
                                    style: TextStyle(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.lightBlue
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:8.0),
                              Center(
                                child: Container(width: 150,
                                  child: Divider(thickness: 1.8,
                                    color: Colors.grey.shade900,
                                    height: 1,
                                  ),
                                ),
                              ),

                              // Text('Date:',style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                              Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Date: ", style: TextStyle(
                                    fontSize: 16.5,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                    // color: Colors.lightBlue
                                  ),),
                                  Text(
                                    DateFormat('yyyy/MM/dd').format(
                                      DateTime.parse(items![index]['date'].toString()).toLocal(),
                                    ),
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      // color: Colors.lightBlue
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Time: ',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      // color: Colors.lightBlue
                                    ),
                                  ),

                                  Text(
                                    '${DateFormat('HH:mm').format(DateTime.parse(items![index]['Deb'].toString()))} '
                                        'to ${DateFormat('HH:mm').format(DateTime.parse(items![index]['Fin'].toString()))}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height:10.0),
                              Center(
                                child: Container(width: 230,
                                  child: Divider(thickness: 1.8,
                                    color: Colors.grey.shade900,
                                    height: 1,
                                  ),
                                ),
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Types: ',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      // color: Colors.lightBlue
                                    ),
                                  ),
                                  Text(
                                    'CM: ${items![index]['CM']} ,TP: ${items![index]['TP']} ,TD: ${items![index]['TD']} ',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Equivalence: ',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                      // color: Colors.lightBlue
                                    ),
                                  ),
                                  Text(
                                    'EqCM: ${items![index]['total']!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:5.0),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text("Confirmer la suppression"),
                                            content: Text(
                                                "Êtes-vous sûr de vouloir supprimer cet élément ?"),
                                            actions: [
                                              TextButton(
                                                child: Text("ANNULER"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  "SUPPRIMER",
                                                  style: TextStyle(color: Colors.red),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _myNewClass.DeleteCours(items![index]['_id']);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Le Type a été Supprimer avec succès.')),
                                                  );
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('Delete',style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                      padding: EdgeInsets.only(left: 80, right: 80),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    ),
                                  ),


                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

            ),
          ),
        ],
      ),

      floatingActionButton: Container(margin:EdgeInsets.only(left: 30,right: 195),height: 55,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black,  elevation: 20,shadowColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: (){

            Navigator.pop(context);
          },
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios,size: 30,color: Colors.blue[900],),
              SizedBox(width: 15,),
              Text('Back', style: TextStyle(fontSize: 17,fontStyle: FontStyle.italic,color: Colors.blue[900]),)
            ],
          ),
          // tooltip: 'Add Prof',
        ),
      ),

    );
  }


}

