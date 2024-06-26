library ping_linter;

import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'lints/button_callback_must_log/button_callback_must_log.dart';

/// Creates a plugin for our custom linter
PluginBase createPlugin() => _PingLints();

/// The class listing all the [LintRule]s and [Assist]s defined by our plugin.
class _PingLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        const ButtonCallbackMustLog(),
      ];

  // @override
  // List<Assist> getAssists() => [_ConvertToStreamProvider()];
}
