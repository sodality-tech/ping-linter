import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

const _buttonTypeChecker = TypeChecker.fromName(
  'FilledPrimaryButton',
);

/// A custom lint rule.
/// In our case, we want a lint rule which analyzes a Dart file. Therefore we
/// subclass [DartLintRule].
///
/// For emitting lints on non-Dart files, subclass [LintRule].
class ButtonCallbackMustLog extends DartLintRule {
  const ButtonCallbackMustLog() : super(code: _code);

  /// Metadata about the lint define. This is the code which will show-up in the IDE,
  /// and its description..
  static const _code = LintCode(
    name: 'button_callback_must_log',
    problemMessage: 'Callbacks on buttons must log',
    errorSeverity: ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addInstanceCreationExpression((node) {
      final classType = node.staticType;
      if (classType != null &&
          _buttonTypeChecker.isAssignableFromType(classType)) {
        // print('----------------------');
        final argumentList = node.argumentList;
        for (final argument in argumentList.arguments) {
          if (argument is NamedExpression &&
              argument.name.label.name == 'onPressed') {
            final onPressedExpression = argument.expression;
            // print('topLevelOnPressed: $onPressedExpression');
            final visitor = _LogEventCallFinder();
            onPressedExpression.visitChildren(visitor);
            if (!visitor.foundLogEventCall) {
              // print('*********** NO LOG EVENT FOUND ************');
              reporter.reportErrorForNode(_code, node);
            }
          }
        }
      }
    });
  }

  // /// [LintRule]s can optionally specify a list of quick-fixes.
  // ///
  // /// Fixes will show-up in the IDE when the cursor is above the warning. And it
  // /// should contain a message explaining how the warning will be fixed.
  // @override
  // List<Fix> getFixes() => [_MakeProviderFinalFix()];
}

class _LogEventCallFinder extends RecursiveAstVisitor<void> {
  bool foundLogEventCall = false;
  final List<FunctionElement> invokedFunctions = [];

  @override
  void visitMethodInvocation(MethodInvocation node) {
    // print('visiting ${node.methodName}');
    if (node.methodName.name == 'logEvent') {
      foundLogEventCall = true;
    }
    final invokedElement = node.methodName.staticElement;
    // print('Associated element: $invokedElement');

    if (invokedElement is FunctionElement &&
        invokedElement.name == 'logEvent') {
      foundLogEventCall = true;
    } else if (invokedElement is ExecutableElement) {
      final declaration = invokedElement.declaration;
      // print(declaration.type);
      // print('resolved element $declaration');

      // Resolve the called method and visit its declaration
      if (declaration is FunctionDeclaration) {
        final functionDeclaration = declaration as FunctionDeclaration;
        // print(functionDeclaration.functionExpression.body);
        functionDeclaration.functionExpression.body.accept(this);
      } else if (declaration is MethodDeclaration) {
        final methodDeclaration = declaration as MethodDeclaration;
        // print(methodDeclaration.body);
        methodDeclaration.body.accept(this);
      } else if (declaration is ConstructorDeclaration) {
        final constuctorDeclaration = declaration as ConstructorDeclaration;
        // print(constuctorDeclaration.body);
        constuctorDeclaration.body.accept(this);
      }
    }
  }
}
