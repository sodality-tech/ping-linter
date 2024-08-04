library ping_linter;

import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:ping_lints/src/lints/all_singletons_must_be_injected/all_singletons_must_be_injected.dart';

// import 'src/lints/button_callback_must_log/button_callback_must_log.dart';

PluginBase createPlugin() => _PingLints();

/// The class listing all the [LintRule]s and [Assist]s defined by our plugin.
class _PingLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => [
        // const ButtonCallbackMustLog(),
        const AllSingletonsMustBeInjected(),
      ];

  // @override
  // List<Assist> getAssists() => [_ConvertToStreamProvider()];
}
