import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/query_by_example/query_by_example.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_path/json_path.dart';
import 'package:secure_storage/secure_storage.dart';

part 'missing_credentials_cubit.g.dart';
part 'missing_credentials_state.dart';

class MissingCredentialsCubit extends Cubit<MissingCredentialsState> {
  MissingCredentialsCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.credentialManifest,
    required this.query,
    required this.profileCubit,
  }) : super(MissingCredentialsState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final CredentialManifest? credentialManifest;
  final Query? query;
  final ProfileCubit profileCubit;

  Future<void> initialize() async {
    emit(state.loading());

    final List<DiscoverDummyCredential> dummyCredentials = [];

    final vcFormatType = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType;

    if (credentialManifest != null) {
      final PresentationDefinition? presentationDefinition =
          credentialManifest!.presentationDefinition;

      if (presentationDefinition != null) {
        for (final descriptor in presentationDefinition.inputDescriptors) {
          /// using JsonPath to find credential Name
          final dynamic json = jsonDecode(jsonEncode(descriptor.constraints));
          final dynamic credentialField =
              (JsonPath(r'$..fields').read(json).first.value as List)
                  .toList()
                  .first;

          if (credentialField['filter'] == null) {
            continue;
          }

          final Filter filter = Filter.fromJson(
            credentialField['filter'] as Map<String, dynamic>,
          );

          final credentialName =
              filter.pattern ?? filter.contains!.containsConst;

          final isPresentable = await isCredentialPresentable(credentialName);

          if (!isPresentable) {
            final credentialSubjectType = getCredTypeFromName(credentialName);

            if (credentialSubjectType != null) {
              dummyCredentials.add(
                credentialSubjectType.dummyCredential(vcFormatType),
              );
            }
          }
        }
      }
    }

    if (query != null) {
      for (final credentialQuery in query!.credentialQuery) {
        final String? credentialName = credentialQuery.example?.type;

        if (credentialName == null) {
          continue;
        }

        final isPresentable = await isCredentialPresentable(credentialName);

        if (!isPresentable) {
          final credentialSubjectType = getCredTypeFromName(credentialName);

          if (credentialSubjectType != null) {
            dummyCredentials
                .add(credentialSubjectType.dummyCredential(vcFormatType));
          }
        }
      }
    }

    emit(
      state.copyWith(
        status: AppStatus.idle,
        dummyCredentials: dummyCredentials,
      ),
    );
  }
}
