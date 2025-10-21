import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:turnaround_mobile/features/users/domain/entities/user.dart';
import 'package:turnaround_mobile/features/users/domain/repositories/user_repository.dart';

import '../../../shared/shared.dart';
import 'user_repository_provider.dart';

// Provider

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return (UserNotifier(userRepository: userRepository));
});

// notifier

class UserNotifier extends StateNotifier<UserState> {
  UserRepository userRepository;
  UserNotifier({required this.userRepository}) : super(UserState.initial());

  void setUser(User user) {
    state = state.copyWith(user: user);
  }

  void clearUser() {
    state = UserState.initial();
  }

  getUserById(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await userRepository.getUserById(id);
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      debugPrint(e.toString());
    }
  }

  Future<SimpleApiResponse> updateUser(Map<String, dynamic> body) async {
    FormData formData = FormData.fromMap({
      'formato': null,
      'nombre': null,
      'formato_firma': null,
      'type': null,
      'cliente': false,
      'encryptedBody': EncryptDecrypt().encryptUsingAES256(json.encode(body))
    });

    state = state.copyWith(isLoading: true);
    try {
      SimpleApiResponse response = await userRepository.updateUser(formData);
      state = state.copyWith( isLoading: false);
      return response;
      // if (response.success && response.data != null) {
      //   final updatedUser = User.fromJson(response.data!);
      //   state = state.copyWith(user: updatedUser);

      // }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return SimpleApiResponse(
          success: false, message: 'Error de conexion');
      debugPrint(e.toString());
    }
  }
}

// state

class UserState {
  final User? user;
  final bool isLoading;

  UserState({this.user, this.isLoading = false});

  factory UserState.initial() {
    return UserState(user: null, isLoading: false);
  }

  UserState copyWith({User? user, bool? isLoading}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
