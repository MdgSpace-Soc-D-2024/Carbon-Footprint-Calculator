import 'package:flutter/material.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import 'package:cfpc_frontend/constants/api.dart';

import 'package:cfpc_frontend/pages/login.dart';

import 'package:cfpc_frontend/models/footprints.dart';

// import 'package:syncfusion_flutter_charts/charts.dart';

// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ViewFootprintsPage extends StatefulWidget {
  const ViewFootprintsPage({super.key});

  @override
  State<ViewFootprintsPage> createState() => _ViewFootprintsPageState();
}

class _ViewFootprintsPageState extends State<ViewFootprintsPage> {
  bool _loggedIn = false;
  Activity _activity = Activity.electricity;
  DateTime? _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime? _endDate = DateTime.now();
  List<FootprintEntries> entries = [];

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _startDate = args.value.startDate ?? _startDate;
        _endDate = args.value.endDate ?? _endDate;
      }
    });
  }

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
    final url = Uri.parse(viewFootprintsURL);
    try {
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        setState(() {
          _loggedIn = true;
        });
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        if (data['detail'] == 'Missing required parameters!') {
          setState(() {
            _loggedIn = true;
          });
        } else {
          _showError('Error: ${response.statusCode} ${response.body}');
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
        _showError('Error: ${response.statusCode} ${response.body}');
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

  Future<void> _fetchData(ViewFootprints viewfootprints) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token == null) {
      setState(() {
        _loggedIn = false;
      });
      return;
    }
    final url = Uri.parse(viewFootprintsURL)
        .replace(queryParameters: viewfootprints.toJson());
    try {
      final response = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          List<dynamic> entriesJson = data['entries'];
          entries = entriesJson
              .map((json) => FootprintEntries.fromJson(json))
              .toList();
        });
      } else {
        _showError('Error: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      _showError('Failed to connect to the server!');
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
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.shortestSide *
                                          0.005),
                                  child: DropdownMenu<Activity>(
                                    initialSelection: _activity,
                                    requestFocusOnTap: true,
                                    label: const Text(
                                      'Activity',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onSelected: (Activity? selectedActivity) {
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
                              Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.shortestSide *
                                          0.005),
                                  child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: SfDateRangePicker(
                                        selectionColor: Colors.green,
                                        backgroundColor: Colors.black,
                                        rangeSelectionColor: Colors.black,
                                        onSelectionChanged: _onSelectionChanged,
                                        selectionMode:
                                            DateRangePickerSelectionMode.range,
                                        initialSelectedRange: PickerDateRange(
                                            _startDate!, _endDate!),
                                      ))),
                              entries.isEmpty
                                  ? ElevatedButton(
                                      onPressed: () {
                                        _fetchData(ViewFootprints(
                                            activity: (_activity.index + 1)
                                                .toString(),
                                            start: DateTime(
                                                    _startDate!.year,
                                                    _startDate!.month,
                                                    _startDate!.day)
                                                .toIso8601String(),
                                            end: DateTime(
                                                    _endDate!.year,
                                                    _endDate!.month,
                                                    _endDate!.day,
                                                    23,
                                                    59,
                                                    59,
                                                    999,
                                                    999)
                                                .toIso8601String()));
                                      },
                                      child: Text('Submit!'))
                                  : SingleChildScrollView(
                                      child: Padding(
                                          padding: EdgeInsets.all(
                                              MediaQuery.of(context)
                                                      .size
                                                      .shortestSide *
                                                  0.005),
                                          child: Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              child: Column(children: [
                                                Table(
                                                  border: TableBorder.all(
                                                      color: Colors.black),
                                                  children: [
                                                    TableRow(
                                                      decoration: BoxDecoration(
                                                          color: Colors.black),
                                                      children: [
                                                        tableCell('Activity',
                                                            isHeader: true),
                                                        tableCell('Type',
                                                            isHeader: true),
                                                        tableCell(
                                                            'Carbon Footprint',
                                                            isHeader: true),
                                                        tableCell(
                                                            'Number of Trees',
                                                            isHeader: true),
                                                      ],
                                                    ),
                                                    ...entries.map(
                                                        (entry) => TableRow(
                                                              children: [
                                                                tableCell(Activity.values[entry
                                                                    .activity
                                                                    .toInt()-1].label.toString()),
                                                                tableCell((((activityTypeMap[entry.activity.toInt()]?[entry.type.toInt()-1] as dynamic)?.label).toString())),
                                                                tableCell(entry
                                                                    .carbonFootprint
                                                                    .toStringAsFixed(
                                                                        2)),
                                                                tableCell(entry
                                                                    .numberOfTrees
                                                                    .toStringAsFixed(
                                                                        2)),])
                                                                
                                                          ),
                                                  ],
                                                ),
                                              ]))))
                            ])),
                      ))
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

  Widget tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          fontSize: isHeader ? 16 : 14,
        ),
      ),
    );
  }
}
