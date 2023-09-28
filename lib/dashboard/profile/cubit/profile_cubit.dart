import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/polygon_id/cubit/polygon_id_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:secure_storage/secure_storage.dart';

part 'profile_cubit.g.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.secureStorageProvider})
      : super(ProfileState(model: ProfileModel.empty())) {
    load();
  }

  final SecureStorageProvider secureStorageProvider;

  Timer? _timer;

  int loginAttemptCount = 0;

  void passcodeEntered() {
    loginAttemptCount++;
    if (loginAttemptCount > 3) return;

    if (loginAttemptCount == 3) {
      setActionAllowValue(value: false);
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        resetloginAttemptCount();
        _timer?.cancel();
      });
    }
  }

  void resetloginAttemptCount() {
    loginAttemptCount = 0;
    setActionAllowValue(value: true);
  }

  void setActionAllowValue({required bool value}) {
    emit(state.copyWith(status: AppStatus.idle, allowLogin: value));
  }

  Future<void> load() async {
    emit(state.loading());

    final log = getLogger('ProfileCubit - load');
    try {
      final firstName =
          await secureStorageProvider.get(SecureStorageKeys.firstNameKey) ?? '';
      final lastName =
          await secureStorageProvider.get(SecureStorageKeys.lastNameKey) ?? '';
      final phone =
          await secureStorageProvider.get(SecureStorageKeys.phoneKey) ?? '';
      final location =
          await secureStorageProvider.get(SecureStorageKeys.locationKey) ?? '';
      final email =
          await secureStorageProvider.get(SecureStorageKeys.emailKey) ?? '';
      final companyName =
          await secureStorageProvider.get(SecureStorageKeys.companyName) ?? '';
      final companyWebsite =
          await secureStorageProvider.get(SecureStorageKeys.companyWebsite) ??
              '';
      final jobTitle =
          await secureStorageProvider.get(SecureStorageKeys.jobTitle) ?? '';

      final polygonIdNetwork = (await secureStorageProvider
              .get(SecureStorageKeys.polygonIdNetwork)) ??
          PolygonIdNetwork.PolygonMainnet.toString();

      final tezosNetworkJson = await secureStorageProvider
          .get(SecureStorageKeys.blockchainNetworkKey);
      final tezosNetwork = tezosNetworkJson != null
          ? TezosNetwork.fromJson(
              json.decode(tezosNetworkJson) as Map<String, dynamic>,
            )
          : TezosNetwork.mainNet();
      final isEnterprise = (await secureStorageProvider
              .get(SecureStorageKeys.isEnterpriseUser)) ==
          'true';

      final isBiometricEnabled = (await secureStorageProvider
              .get(SecureStorageKeys.isBiometricEnabled)) ==
          'true';

      final alertValue =
          await secureStorageProvider.get(SecureStorageKeys.alertEnabled);
      final isAlertEnabled = alertValue == null || alertValue == 'true';

      final userConsentForIssuerAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForIssuerAccess)) ==
          'true';

      final userConsentForVerifierAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForVerifierAccess)) ==
          'true';

      final isSecurityLowValue =
          await secureStorageProvider.get(SecureStorageKeys.isSecurityLow);

      final isSecurityLow =
          isSecurityLowValue == null || isSecurityLowValue == 'true';

      final userPINCodeForAuthenticationValue = await secureStorageProvider
          .get(SecureStorageKeys.userPINCodeForAuthentication);
      final userPINCodeForAuthentication =
          userPINCodeForAuthenticationValue == null ||
              userPINCodeForAuthenticationValue == 'true';

      final userPinDigitsLengthString =
          await secureStorageProvider.get(SecureStorageKeys.isSecurityLow);

      final int userPinDigitsLength = userPinDigitsLengthString != null
          ? int.parse(userPinDigitsLengthString)
          : 6;

      final profileModel = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
        polygonIdNetwork: polygonIdNetwork,
        tezosNetwork: tezosNetwork,
        companyName: companyName,
        companyWebsite: companyWebsite,
        jobTitle: jobTitle,
        isEnterprise: isEnterprise,
        isBiometricEnabled: isBiometricEnabled,
        isAlertEnabled: isAlertEnabled,
        userConsentForIssuerAccess: userConsentForIssuerAccess,
        userConsentForVerifierAccess: userConsentForVerifierAccess,
        userPINCodeForAuthentication: userPINCodeForAuthentication,
        isSecurityLow: isSecurityLow,
        userPinDigitsLength: userPinDigitsLength,
      );

      emit(
        state.copyWith(
          model: profileModel,
          status: AppStatus.success,
        ),
      );
    } catch (e, s) {
      log.e(
        'something went wrong',
        error: e,
        stackTrace: s,
      );
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE,
          ),
        ),
      );
    }
  }

  Future<void> update(ProfileModel profileModel) async {
    emit(state.loading());
    final log = getLogger('ProfileCubit - update');

    try {
      await secureStorageProvider.set(
        SecureStorageKeys.firstNameKey,
        profileModel.firstName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.lastNameKey,
        profileModel.lastName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.phoneKey,
        profileModel.phone,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.locationKey,
        profileModel.location,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.emailKey,
        profileModel.email,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyName,
        profileModel.companyName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyWebsite,
        profileModel.companyWebsite,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.jobTitle,
        profileModel.jobTitle,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.polygonIdNetwork,
        profileModel.polygonIdNetwork,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isEnterpriseUser,
        profileModel.isEnterprise.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isBiometricEnabled,
        profileModel.isBiometricEnabled.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.alertEnabled,
        profileModel.isAlertEnabled.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userConsentForIssuerAccess,
        profileModel.userConsentForIssuerAccess.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userConsentForVerifierAccess,
        profileModel.userConsentForVerifierAccess.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userPINCodeForAuthentication,
        profileModel.userPINCodeForAuthentication.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isSecurityLow,
        profileModel.isSecurityLow.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userPinDigitsLength,
        profileModel.userPinDigitsLength.toString(),
      );

      emit(
        state.copyWith(
          model: profileModel,
          status: AppStatus.success,
        ),
      );
    } catch (e, s) {
      log.e(
        'something went wrong',
        error: e,
        stackTrace: s,
      );

      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE,
          ),
        ),
      );
    }
  }

  Future<void> setFingerprintEnabled({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isBiometricEnabled: enabled);
    await update(profileModel);
  }

  Future<void> setAlertEnabled({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isAlertEnabled: enabled);
    await update(profileModel);
  }

  Future<void> setUserConsentForIssuerAccess({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userConsentForIssuerAccess: enabled);
    await update(profileModel);
  }

  Future<void> setUserConsentForVerifierAccess({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userConsentForVerifierAccess: enabled);
    await update(profileModel);
  }

  Future<void> setUserPINCodeForAuthentication({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userPINCodeForAuthentication: enabled);
    await update(profileModel);
  }

  Future<void> updatePolygonIdNetwork({
    required PolygonIdNetwork polygonIdNetwork,
    required PolygonIdCubit polygonIdCubit,
  }) async {
    emit(state.copyWith(status: AppStatus.loading));
    final profileModel =
        state.model.copyWith(polygonIdNetwork: polygonIdNetwork.toString());

    await polygonIdCubit.setEnv(polygonIdNetwork);

    await update(profileModel);
  }

  Future<void> setSecurityLevel({bool isSecurityLow = true}) async {
    final profileModel = state.model.copyWith(isSecurityLow: isSecurityLow);
    await update(profileModel);
  }

  Future<void> setUserPinDigitLength(int value) async {
    final profileModel = state.model.copyWith(userPinDigitsLength: value);
    await update(profileModel);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
