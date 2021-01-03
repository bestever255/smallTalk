import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:tinder_clone/repository/user_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

// Convert events to states
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository _userRepository = new UserRepository();
  // Make Sure it is not null
  ProfileBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(ProfileState.empty());

  Future<void> getLocation(GeoPoint location) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    location = GeoPoint(position.latitude, position.longitude);
  }

  void onSubmited({
    GeoPoint location,
    ProfileBloc profileBloc,
    TextEditingController nameController,
    String gender,
    String interestedIn,
    DateTime age,
    File photo,
  }) async {
    await getLocation(location);
    profileBloc.add(Submitted(
        name: nameController.text,
        gender: gender,
        interestedIn: interestedIn,
        age: age,
        location: location,
        photo: photo));
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
    // yield* to yield recursivly
  ) async* {
    if (event is NameChanged) {
      yield* _mapNameChangedToState(event.name);
    } else if (event is AgeChanged) {
      yield* _mapAgeChangedToState(event.age);
    } else if (event is GenderChanged) {
      yield* _mapGenderChangedToState(event.gender);
    } else if (event is InterestedInChanged) {
      yield* _mapinterestedInChangedToState(event.interestedIn);
    } else if (event is LocationChanged) {
      yield* _mapLocationChangedToState(event.location);
    } else if (event is PhotoChanged) {
      yield* _mapPhotoChangedToState(event.photo);
    } else if (event is Submitted) {
      final uid = await _userRepository.getUser();
      yield* _mapSubmittedToState(
          name: event.name,
          age: event.age,
          gender: event.gender,
          interestedIn: event.interestedIn,
          location: event.location,
          photo: event.photo,
          userId: uid);
    }
  }

  // async* to use yield
  // yield is return but in stream
  Stream<ProfileState> _mapNameChangedToState(String name) async* {
    // if name is null it will return true if not it will return false
    yield state.update(isNameEmpty: name == null);
  }

  Stream<ProfileState> _mapAgeChangedToState(DateTime age) async* {
    yield state.update(isAgeEmpty: age == null);
  }

  Stream<ProfileState> _mapGenderChangedToState(String gender) async* {
    yield state.update(isGenderEmpty: gender == null);
  }

  Stream<ProfileState> _mapinterestedInChangedToState(
      String interestedIn) async* {
    yield state.update(isInterestedInEmpty: interestedIn == null);
  }

  Stream<ProfileState> _mapLocationChangedToState(GeoPoint location) async* {
    yield state.update(isLocationEmpty: location == null);
  }

  Stream<ProfileState> _mapPhotoChangedToState(File photo) async* {
    yield state.update(isPhotoEmpty: photo == null);
  }

  Stream<ProfileState> _mapSubmittedToState(
      {String name,
      DateTime age,
      String gender,
      String interestedIn,
      GeoPoint location,
      File photo,
      String userId}) async* {
    yield ProfileState.loading();
    try {
      await _userRepository.profileSetup(
          photo: photo,
          userId: userId,
          name: name,
          gender: gender,
          interestedIn: interestedIn,
          age: age,
          location: location);
      yield ProfileState.success();
    } catch (e) {
      yield ProfileState.failure();
      print(e);
      throw e;
    }
  }
}
