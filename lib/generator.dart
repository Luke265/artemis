import 'dart:async';
import 'package:build/build.dart';
import 'package:dart_style/dart_style.dart';
import 'package:graphql_builder/helpers.dart';

final DartFormatter _dartFormatter = DartFormatter();

/// Supports `package:build_runner` creation and configuration of
/// `graphql_builder`.
///
/// Not meant to be invoked by hand-authored code.
Builder graphQLTypesBuilder(BuilderOptions options) => GraphQLTypesBuilder();

class GraphQLTypesBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => const {
        '.schema.json': ['.api.dart']
      };

  @override
  Future<void> build(BuildStep buildStep) async {
    final src = await buildStep.readAsString(buildStep.inputId);
    final schema = schemaFromJsonString(src);
    final path =
        buildStep.inputId.path.replaceAll(RegExp(r'\.schema\.json$'), '');

    final outputAssetId =
        AssetId(buildStep.inputId.package, path).addExtension('.api.dart');

    await buildStep.writeAsString(
        outputAssetId, _dartFormatter.format(await generate(schema, path)));
  }
}