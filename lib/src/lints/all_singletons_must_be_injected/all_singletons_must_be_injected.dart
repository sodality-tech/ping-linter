import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

class AllSingletonsMustBeInjected extends DartLintRule {
  const AllSingletonsMustBeInjected() : super(code: _code);

  static const _code = LintCode(
    name: 'all_singletons_must_be_injected',
    problemMessage:
        'Singletons from the service locator must be injected in throught the constructor than being accessed directly',
    errorSeverity: ErrorSeverity.WARNING,
  );

  // static const _serviceLocator

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    // This will mark every method invocation chained off of sl()
    context.registry.addMethodInvocation((node) {
      if (_containsSlInvocation(node)) {
        reporter.reportErrorForNode(_code, node);
      }
    });

    // This will mark every property access chained off of sl()
    context.registry.addPropertyAccess((node) {
      if (_containsSlInvocation(node)) {
        reporter.reportErrorForNode(_code, node);
      }
    });

    // This will hit every access to sl() and verify if its a constructor
    // argument or not
    context.registry.addFunctionExpressionInvocation((node) {
      if (_isSlCall(node)) {
        final parent = node.parent;

        // If used as a named argument
        if (parent is NamedExpression) {
          final expressionParent = parent.parent;
          if (expressionParent is ArgumentList) {
            final executableElement = expressionParent.parent;
            if (executableElement is! InstanceCreationExpression)
              reporter.reportErrorForNode(_code, node);
          }
        }

        if (parent is ArgumentList) {
          final executableElement = parent.parent;
          if (executableElement is! InstanceCreationExpression)
            reporter.reportErrorForNode(_code, node);
        }
      }
    });
  }

  // Traverse up the chained function call to check if it contains
  // a call to sl
  bool _containsSlInvocation(AstNode node) {
    AstNode? current = node;

    while (current != null) {
      // print('Current: $current');
      // if (current is MethodInvocation) {
      //   print(current.methodName.name);
      //   if (current.methodName.name == 'sl') return true;
      // }
      if (current.toString().endsWith('()')) {
        // print('DEBUG CURRENT: $current');
        if (current is FunctionExpressionInvocation) {
          final function = current.function;
          // print(function);
          if (function is SimpleIdentifier && function.name == 'sl') {
            return true;
          }
          // print(function is PrefixedIdentifier);
        }
      }
      if (current is MethodInvocation) {
        // print('MethodInvocation: $current');
        // print('Target ${current.target}');
        current = current.target;
      } else if (current is PropertyAccess) {
        current = current.target;
      } else {
        current = null;
      }
    }

    return false;
  }

  bool _isSlCall(FunctionExpressionInvocation node) {
    final function = node.function;
    if (function is SimpleIdentifier && function.name == 'sl') {
      return true;
    }

    return false;
  }
}
