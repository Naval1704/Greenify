/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the LeafInfo type in your schema. */
class LeafInfo extends amplify_core.Model {
  static const classType = const _LeafInfoModelType();
  final String id;
  final String? _leaf_name;
  final String? _leaf_problem;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  LeafInfoModelIdentifier get modelIdentifier {
      return LeafInfoModelIdentifier(
        id: id
      );
  }
  
  String get leaf_name {
    try {
      return _leaf_name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get leaf_problem {
    return _leaf_problem;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const LeafInfo._internal({required this.id, required leaf_name, leaf_problem, createdAt, updatedAt}): _leaf_name = leaf_name, _leaf_problem = leaf_problem, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory LeafInfo({String? id, required String leaf_name, String? leaf_problem}) {
    return LeafInfo._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      leaf_name: leaf_name,
      leaf_problem: leaf_problem);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LeafInfo &&
      id == other.id &&
      _leaf_name == other._leaf_name &&
      _leaf_problem == other._leaf_problem;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("LeafInfo {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("leaf_name=" + "$_leaf_name" + ", ");
    buffer.write("leaf_problem=" + "$_leaf_problem" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  LeafInfo copyWith({String? leaf_name, String? leaf_problem}) {
    return LeafInfo._internal(
      id: id,
      leaf_name: leaf_name ?? this.leaf_name,
      leaf_problem: leaf_problem ?? this.leaf_problem);
  }
  
  LeafInfo copyWithModelFieldValues({
    ModelFieldValue<String>? leaf_name,
    ModelFieldValue<String?>? leaf_problem
  }) {
    return LeafInfo._internal(
      id: id,
      leaf_name: leaf_name == null ? this.leaf_name : leaf_name.value,
      leaf_problem: leaf_problem == null ? this.leaf_problem : leaf_problem.value
    );
  }
  
  LeafInfo.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _leaf_name = json['leaf_name'],
      _leaf_problem = json['leaf_problem'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'leaf_name': _leaf_name, 'leaf_problem': _leaf_problem, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'leaf_name': _leaf_name,
    'leaf_problem': _leaf_problem,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<LeafInfoModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<LeafInfoModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final LEAF_NAME = amplify_core.QueryField(fieldName: "leaf_name");
  static final LEAF_PROBLEM = amplify_core.QueryField(fieldName: "leaf_problem");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "LeafInfo";
    modelSchemaDefinition.pluralName = "LeafInfos";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: LeafInfo.LEAF_NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: LeafInfo.LEAF_PROBLEM,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _LeafInfoModelType extends amplify_core.ModelType<LeafInfo> {
  const _LeafInfoModelType();
  
  @override
  LeafInfo fromJson(Map<String, dynamic> jsonData) {
    return LeafInfo.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'LeafInfo';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [LeafInfo] in your schema.
 */
class LeafInfoModelIdentifier implements amplify_core.ModelIdentifier<LeafInfo> {
  final String id;

  /** Create an instance of LeafInfoModelIdentifier using [id] the primary key. */
  const LeafInfoModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'LeafInfoModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is LeafInfoModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}