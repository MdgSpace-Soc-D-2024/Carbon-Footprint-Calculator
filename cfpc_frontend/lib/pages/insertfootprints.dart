import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cfpc_frontend/constants/api.dart';

import 'package:cfpc_frontend/models/footprints.dart';

import 'package:cfpc_frontend/pages/login.dart';

class InsertFootprintsPage extends StatefulWidget {
  const InsertFootprintsPage({super.key});

  @override
  State<InsertFootprintsPage> createState() => _InsertFootprintsPageState();
}

class _InsertFootprintsPageState extends State<InsertFootprintsPage> {
  Activity _activity = Activity.electricity;
  Type1 _type1 = Type1.coal;
  Type2 _type2 = Type2.ale;
  Type3 _type3 = Type3.dataStored;
  Type4 _type4 = Type4.bus;
  int type = 1;
  String _content = '';
  final TextEditingController _parameterController = TextEditingController();

  bool _loggedIn = false;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _verifyLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    if (token == null) {
      setState(() {
        _loggedIn = false;
      });
      return;
    }
    final url = Uri.parse(insertFootprintsURL);
    try {
      final response = await http.post(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        setState(() {
          _loggedIn = true;
        });
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (data['detail'] == 'Activity is required!') {
          setState(() {
            _loggedIn = true;
          });
        } else {
          _showError('Error: ${response.statusCode}');
          setState(() {
            _loggedIn = false;
          });
        }
      } else if (response.statusCode == 401) {
        // Unauthorized
        token = await refreshToken();
        if (token != null) {
          _verifyLogin();
        } else {
          setState(() {
            _loggedIn = false;
          });
        }
      } else {
        _showError('Error: ${response.statusCode}');
        setState(() {
          _loggedIn = false;
        });
      }
    } catch (e) {
      _showError('Failed to connect to the server!');
      setState(() {
        _loggedIn = false;
      });
    }
  }

  Future<void> _sendData(Footprint footprint) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      setState(() {
        _loggedIn = false;
      });
      return;
    }

    final url = Uri.parse(insertFootprintsURL);

    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(footprint.toJson()),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _loggedIn = true;
          _content =
              'Carbon footprint recorded successfully!\nCarbon Footprint: ${data['carbon_footprint']}\nNumber of Trees: ${data['number_of_trees']}';
        });
      } else if (response.statusCode == 401) {
        // Unauthorized
        token = await refreshToken();
        if (token != null) {
          _sendData(footprint);
        } else {
          setState(() {
            _loggedIn = false;
          });
        }
      } else {
        _showError('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      _showError('Failed to connect to the server!');
      setState(() {
        _loggedIn = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _verifyLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('./assets/images/logo.png',
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.05),
              SizedBox(width: MediaQuery.of(context).size.width * 0.01),
              Text('CARBON FOOTPRINT CALCULATOR',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.width * 0.03)),
            ],
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.08,
        ),
        body: Column(children: [
          Expanded(
              child: _loggedIn
                  ? Container(
                      color: Colors.green,
                      child: Center(
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Column(children: [
                                Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(
                                            MediaQuery.of(context)
                                                    .size
                                                    .shortestSide *
                                                0.005),
                                        child: DropdownMenu<Activity>(
                                          initialSelection: _activity,
                                          requestFocusOnTap: true,
                                          label: const Text(
                                            'Activity',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          onSelected:
                                              (Activity? selectedActivity) {
                                            setState(() {
                                              _activity = selectedActivity ??
                                                  Activity.electricity;
                                            });
                                          },
                                          dropdownMenuEntries: Activity.values
                                              .map<DropdownMenuEntry<Activity>>(
                                                  (Activity item) {
                                            return DropdownMenuEntry<Activity>(
                                              value: item,
                                              label: item.label,
                                            );
                                          }).toList(),
                                        )),
                                    _activity == Activity.electricity
                                        ? Column(children: [
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .shortestSide *
                                                        0.005),
                                                child: DropdownMenu<Type1>(
                                                  initialSelection: _type1,
                                                  requestFocusOnTap: true,
                                                  label: const Text(
                                                    'Source of Power',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  onSelected:
                                                      (Type1? selectedType) {
                                                    setState(() {
                                                      _type1 = selectedType!;
                                                      type = _type1.index + 1;
                                                    });
                                                  },
                                                  dropdownMenuEntries:
                                                      Type1.values.map<
                                                              DropdownMenuEntry<
                                                                  Type1>>(
                                                          (Type1 item) {
                                                    return DropdownMenuEntry<
                                                        Type1>(
                                                      value: item,
                                                      label: item.label,
                                                    );
                                                  }).toList(),
                                                )),
                                            Padding(
                                                padding: EdgeInsets.all(
                                                    MediaQuery.of(context)
                                                            .size
                                                            .shortestSide *
                                                        0.005),
                                                child: TextField(
                                                    controller:
                                                        _parameterController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'kWh of Power Used',
                                                      labelStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 4)),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                    ),
                                                    minLines: 1,
                                                    maxLines: 1))
                                          ])
                                        : _activity == Activity.food
                                            ? Column(children: [
                                                Padding(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .shortestSide *
                                                            0.005),
                                                    child: DropdownMenu<Type2>(
                                                      initialSelection: _type2,
                                                      requestFocusOnTap: true,
                                                      label: const Text(
                                                        'Type of Food',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      onSelected: (Type2?
                                                          selectedType) {
                                                        setState(() {
                                                          _type2 =
                                                              selectedType!;
                                                          type =
                                                              _type2.index + 1;
                                                        });
                                                      },
                                                      dropdownMenuEntries:
                                                          Type2.values.map<
                                                              DropdownMenuEntry<
                                                                  Type2>>((Type2
                                                              item) {
                                                        return DropdownMenuEntry<
                                                            Type2>(
                                                          value: item,
                                                          label: item.label,
                                                        );
                                                      }).toList(),
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.all(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .shortestSide *
                                                            0.005),
                                                    child: TextField(
                                                        controller:
                                                            _parameterController,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Grams of Food Consumed',
                                                          labelStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                          ),
                                                          border: OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          4)),
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                        ),
                                                        minLines: 1,
                                                        maxLines: 1))
                                              ])
                                            : _activity == Activity.internet
                                                ? Column(children: [
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .shortestSide *
                                                                0.005),
                                                        child:
                                                            DropdownMenu<Type3>(
                                                          initialSelection:
                                                              _type3,
                                                          requestFocusOnTap:
                                                              true,
                                                          label: const Text(
                                                            'Type of Internet Activity',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                          onSelected: (Type3?
                                                              selectedType) {
                                                            setState(() {
                                                              _type3 =
                                                                  selectedType!;
                                                              type =
                                                                  _type3.index +
                                                                      1;
                                                            });
                                                          },
                                                          dropdownMenuEntries:
                                                              Type3.values.map<
                                                                  DropdownMenuEntry<
                                                                      Type3>>((Type3
                                                                  item) {
                                                            return DropdownMenuEntry<
                                                                Type3>(
                                                              value: item,
                                                              label: item.label,
                                                            );
                                                          }).toList(),
                                                        )),
                                                    Padding(
                                                        padding: EdgeInsets.all(
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .shortestSide *
                                                                0.005),
                                                        child: TextField(
                                                            controller:
                                                                _parameterController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  type3ToParameter3[
                                                                          _type3]!
                                                                      .label,
                                                              labelStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.02,
                                                              ),
                                                              border: OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .black,
                                                                      width:
                                                                          4)),
                                                            ),
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                            ),
                                                            minLines: 1,
                                                            maxLines: 1))
                                                  ])
                                                : _activity == Activity.travel
                                                    ? Column(children: [
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .all(MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .shortestSide *
                                                                    0.005),
                                                            child: DropdownMenu<
                                                                Type4>(
                                                              initialSelection:
                                                                  _type4,
                                                              requestFocusOnTap:
                                                                  true,
                                                              label: const Text(
                                                                'Mode of Transport',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                              onSelected: (Type4?
                                                                  selectedType) {
                                                                setState(() {
                                                                  _type4 =
                                                                      selectedType!;
                                                                  type = _type4
                                                                          .index +
                                                                      1;
                                                                });
                                                              },
                                                              dropdownMenuEntries:
                                                                  Type4.values.map<
                                                                      DropdownMenuEntry<
                                                                          Type4>>((Type4
                                                                      item) {
                                                                return DropdownMenuEntry<
                                                                    Type4>(
                                                                  value: item,
                                                                  label: item
                                                                      .label,
                                                                );
                                                              }).toList(),
                                                            )),
                                                        Padding(
                                                            padding: EdgeInsets
                                                                .all(MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .shortestSide *
                                                                    0.005),
                                                            child: TextField(
                                                                controller:
                                                                    _parameterController,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Distance Travelled (kilometres)',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.02,
                                                                  ),
                                                                  border: OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .black,
                                                                          width:
                                                                              4)),
                                                                ),
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .height *
                                                                      0.02,
                                                                ),
                                                                minLines: 1,
                                                                maxLines: 1))
                                                      ])
                                                    : Text('Choose activity')
                                  ],
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      _sendData(Footprint(
                                        activity: (_activity.index).toInt() + 1,
                                        type: type.toInt(),
                                        parameter: double.parse(
                                                _parameterController.text)
                                            .toDouble(),
                                      ));
                                    },
                                    child: Text('Submit!')),
                                if (_content != '')
                                  Text(_content, style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.height * 0.02))]))))
                  : Text('Login to view this page.')),
          // Footer
          Container(
            color: Colors.black,
            width: double.infinity,
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Text(
              'Carbon Footprint Calculator - © 2025 All Rights Reserved',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        ]));
  }
}
