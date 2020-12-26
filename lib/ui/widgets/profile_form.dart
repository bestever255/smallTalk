import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tinder_clone/bloc/bloc/authentication/authentication_bloc.dart';
import 'package:tinder_clone/bloc/bloc/profile/bloc/profile_bloc.dart';
import 'dart:io';

import 'package:tinder_clone/ui/constants.dart';
import 'package:tinder_clone/ui/widgets/gender.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  String gender, interestedIn;
  DateTime age;
  File photo;
  GeoPoint location;
  ProfileBloc _profileBloc;

  TextEditingController _nameController = new TextEditingController();

  bool get isPopulatet =>
      _nameController.text.isNotEmpty &&
      gender != null &&
      interestedIn != null &&
      age != null &&
      photo != null;

  Future<void> _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
  }

  void _onSubmited() async {
    await _getLocation();
    _profileBloc.add(Submitted(
        name: _nameController.text,
        gender: gender,
        interestedIn: interestedIn,
        age: age,
        location: location,
        photo: photo));
  }

  bool isButtonEnabled(ProfileState state) {
    // if all forms are populated and the button is not already pressed then it will be enabled
    return isPopulatet && !state.isSubmitting;
  }

  @override
  void initState() {
    _getLocation();
    _profileBloc = BlocProvider.of<ProfileBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        // Now you have state and build the widget depend on it
        if (state.isFailure) {
          print('Failed');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Creation Failed!',
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(Icons.error),
                ],
              ),
            ));
        }
        if (state.isSubmitting) {
          print('Submitting');
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Submitting',
                    style: TextStyle(color: Colors.white),
                  ),
                  CircularProgressIndicator(),
                ],
              ),
            ));
        }
        if (state.isSuccess) {
          print('Success');
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedIn());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              color: kBackGroundColor,
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    child: CircleAvatar(
                        radius: width * .3,
                        backgroundColor: Colors.transparent,
                        child: photo == null
                            ? GestureDetector(
                                onTap: () async {
                                  FilePickerResult getPic = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.image);
                                  if (getPic != null) {
                                    File file = File(getPic.files.single.path);

                                    setState(() {
                                      photo = file;
                                    });
                                  }
                                },
                                child: Image.asset('assets/profilephoto.png'),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  FilePickerResult getPic = await FilePicker
                                      .platform
                                      .pickFiles(type: FileType.image);
                                  if (getPic != null) {
                                    File file = File(getPic.files.single.path);
                                    setState(() {
                                      photo = file;
                                    });
                                  }
                                },
                                child: CircleAvatar(
                                  radius: width * .3,
                                  backgroundImage: FileImage(photo),
                                ),
                              )),
                  ),
                  Padding(
                    padding: EdgeInsets.all(height * 0.02),
                    child: TextField(
                      keyboardType: TextInputType.name,
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Enter Your Name',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: height * .03,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(1900, 1, 1),
                          maxTime: DateTime(DateTime.now().year - 19, 1, 1),
                          onConfirm: (date) {
                        setState(() {
                          age = date;
                        });
                        print(age);
                      });
                    },
                    child: age == null
                        ? Text(
                            'Enter Birthday',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: width * .09,
                            ),
                          )
                        : Text(
                            'Birthday entered',
                            style: TextStyle(
                                color: Colors.grey, fontSize: width * .09),
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: height * 0.02,
                        ),
                        child: Text(
                          'You are',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.09,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Gender(
                              icon: FontAwesomeIcons.venus,
                              selected: gender,
                              text: 'Female',
                              onTab: () {
                                setState(() {
                                  gender = 'Female';
                                });
                              }),
                          Gender(
                              icon: FontAwesomeIcons.mars,
                              selected: gender,
                              text: 'Male',
                              onTab: () {
                                setState(() {
                                  gender = 'Male';
                                });
                              }),
                          Gender(
                              icon: FontAwesomeIcons.transgender,
                              selected: gender,
                              text: 'TransGender',
                              onTab: () {
                                setState(() {
                                  gender = 'TransGender';
                                });
                              }),
                        ],
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: height * 0.02,
                        ),
                        child: Text(
                          'Looking for',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: width * 0.09,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Gender(
                              icon: FontAwesomeIcons.venus,
                              selected: interestedIn,
                              text: 'Female',
                              onTab: () {
                                setState(() {
                                  interestedIn = 'Female';
                                });
                              }),
                          Gender(
                              icon: FontAwesomeIcons.mars,
                              selected: interestedIn,
                              text: 'Male',
                              onTab: () {
                                setState(() {
                                  interestedIn = 'Male';
                                });
                              }),
                          Gender(
                              icon: FontAwesomeIcons.transgender,
                              selected: interestedIn,
                              text: 'TransGender',
                              onTab: () {
                                setState(() {
                                  interestedIn = 'TransGender';
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                      padding: EdgeInsets.symmetric(vertical: height * .02),
                      child: Container(
                        width: width * .6,
                        child: RaisedButton(
                          child: Text(
                            'Save',
                            style: TextStyle(
                                fontSize: height * .025, color: Colors.blue),
                          ),
                          color: isButtonEnabled(state)
                              ? Colors.white
                              : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () {
                            if (isButtonEnabled(state)) {
                              _onSubmited();
                            } else {}
                          },
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
