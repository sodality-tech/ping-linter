import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';
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
            print('topLevelOnPressed: $onPressedExpression');
            // final debugVisitor = DebugRecursiveAstVisitor();
            // onPressedExpression.accept(debugVisitor);
            final visitor = _LogEventCallFinder();
            onPressedExpression.accept(visitor);
            // onPressedExpression.visitChildren(visitor);
            // if (!visitor.foundLogEventCall) {
            //   // print('*********** NO LOG EVENT FOUND ************');
            reporter.reportErrorForNode(_code, node);
            // }
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
    print('visiting ${node.methodName}');
    if (node.methodName.name == 'logEvent') {
      foundLogEventCall = true;
      return;
    }
    final invokedElement = node.methodName.staticElement;
    print('Associated element: $invokedElement');

    if (invokedElement is FunctionElement &&
        invokedElement.name == 'logEvent') {
      foundLogEventCall = true;
      return;
    }

    node.visitChildren(this);
    // super.visitMethodInvocation(node);
    if (invokedElement is ExecutableElement) {
      final declaration = invokedElement.declaration;
      // print(declaration.augmentation);
      // print('runtimeType element ${invokedElement.runtimeType}');
      // print('runtimeType declaration ${declaration.runtimeType}');

      // print('resolved element $declaration');

      // Resolve the called method and visit its declaration
      // print(invokedElement is FunctionDeclaration);
      // print(invokedElement is MethodDeclaration);
      // print(invokedElement is ConstructorDeclaration);

      // print(declaration is FunctionDeclaration);
      // print(declaration is MethodDeclaration);
      // print(declaration is ConstructorDeclaration);

      // print(declaration is FunctionExpression);

      if (declaration is FunctionDeclaration) {
        final functionDeclaration = declaration as FunctionDeclaration;
        print(functionDeclaration.functionExpression.body);
        functionDeclaration.functionExpression.body.accept(this);
      } else if (declaration is MethodDeclaration) {
        final methodDeclaration = declaration as MethodDeclaration;
        print(methodDeclaration.body);
        methodDeclaration.body.accept(this);
      } else if (declaration is ConstructorDeclaration) {
        final constructorDeclaration = declaration as ConstructorDeclaration;
        print(constructorDeclaration.body);
        constructorDeclaration.body.accept(this);
      } else if (declaration is MethodElement) {
        print('methodElement');
      }
    }
  }

  // @override
  // void visitBlockFunctionBody(BlockFunctionBody node) {
  //   print('visited');
  //   print(node);
  //   print(node.runtimeType);
  //   super.visitBlockFunctionBody(node);
  // }
}

class _LogEventElementVisitor extends RecursiveElementVisitor<void> {
  @override
  void visitMethodElement(MethodElement element) {
    print('visited');
    print(element);
    print('visited');
    super.visitMethodElement(element);
  }
}

class DebugRecursiveElementVisitor extends RecursiveElementVisitor {
  void visitAugmentationImportElement(AugmentationImportElement element) {
    print('visited AugmentationImportElement');
    print(element);
    super.visitAugmentationImportElement(element);
  }

  void visitClassElement(ClassElement element) {
    print('visited ClassElement');
    print(element);
    super.visitClassElement(element);
  }

  void visitCompilationUnitElement(CompilationUnitElement element) {
    print('visited CompilationUnitElement');
    print(element);
    super.visitCompilationUnitElement(element);
  }

  void visitConstructorElement(ConstructorElement element) {
    print('visited ConstructorElement');
    print(element);
    super.visitConstructorElement(element);
  }

  void visitEnumElement(EnumElement element) {
    print('visited EnumElement');
    print(element);
    super.visitEnumElement(element);
  }

  void visitExtensionElement(ExtensionElement element) {
    print('visited ExtensionElement');
    print(element);
    super.visitExtensionElement(element);
  }

  void visitExtensionTypeElement(ExtensionTypeElement element) {
    print('visited ExtensionTypeElement');
    print(element);
    super.visitExtensionTypeElement(element);
  }

  void visitFieldElement(FieldElement element) {
    print('visited FieldElement');
    print(element);
    super.visitFieldElement(element);
  }

  void visitFieldFormalParameterElement(FieldFormalParameterElement element) {
    print('visited FieldFormalParameterElement');
    print(element);
    super.visitFieldFormalParameterElement(element);
  }

  void visitFunctionElement(FunctionElement element) {
    print('visited FunctionElement');
    print(element);
    super.visitFunctionElement(element);
  }

  void visitGenericFunctionTypeElement(GenericFunctionTypeElement element) {
    print('visited GenericFunctionTypeElement');
    print(element);
    super.visitGenericFunctionTypeElement(element);
  }

  void visitLabelElement(LabelElement element) {
    print('visited LabelElement');
    print(element);
    super.visitLabelElement(element);
  }

  void visitLibraryAugmentationElement(LibraryAugmentationElement element) {
    print('visited LibraryAugmentationElement');
    print(element);
    super.visitLibraryAugmentationElement(element);
  }

  void visitLibraryElement(LibraryElement element) {
    print('visited LibraryElement');
    print(element);
    super.visitLibraryElement(element);
  }

  void visitLibraryExportElement(LibraryExportElement element) {
    print('visited LibraryExportElement');
    print(element);
    super.visitLibraryExportElement(element);
  }

  void visitLibraryImportElement(LibraryImportElement element) {
    print('visited LibraryImportElement');
    print(element);
    super.visitLibraryImportElement(element);
  }

  void visitLocalVariableElement(LocalVariableElement element) {
    print('visited LocalVariableElement');
    print(element);
    super.visitLocalVariableElement(element);
  }

  void visitMethodElement(MethodElement element) {
    print('visited MethodElement');
    print(element);
    super.visitMethodElement(element);
  }

  void visitMixinElement(MixinElement element) {
    print('visited MixinElement');
    print(element);
    super.visitMixinElement(element);
  }

  void visitMultiplyDefinedElement(MultiplyDefinedElement element) {
    print('visited MultiplyDefinedElement');
    print(element);
    super.visitMultiplyDefinedElement(element);
  }

  void visitParameterElement(ParameterElement element) {
    print('visited ParameterElement');
    print(element);
    super.visitParameterElement(element);
  }

  void visitPartElement(PartElement element) {
    print('visited PartElement');
    print(element);
    super.visitPartElement(element);
  }

  void visitPrefixElement(PrefixElement element) {
    print('visited PrefixElement');
    print(element);
    super.visitPrefixElement(element);
  }

  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    print('visited PropertyAccessorElement');
    print(element);
    super.visitPropertyAccessorElement(element);
  }

  void visitSuperFormalParameterElement(SuperFormalParameterElement element) {
    print('visited SuperFormalParameterElement');
    print(element);
    super.visitSuperFormalParameterElement(element);
  }

  void visitTopLevelVariableElement(TopLevelVariableElement element) {
    print('visited TopLevelVariableElement');
    print(element);
    super.visitTopLevelVariableElement(element);
  }

  void visitTypeAliasElement(TypeAliasElement element) {
    print('visited TypeAliasElement');
    print(element);
    super.visitTypeAliasElement(element);
  }

  void visitTypeParameterElement(TypeParameterElement element) {
    print('visited TypeParameterElement');
    print(element);
    super.visitTypeParameterElement(element);
  }
}

class DebugRecursiveAstVisitor extends RecursiveAstVisitor {
  const DebugRecursiveAstVisitor();

  @override
  void visitAdjacentStrings(AdjacentStrings node) {
    print('visited AdjacentStrings');
    print(node);
    return super.visitAdjacentStrings(node);
  }

  @override
  void visitAnnotation(Annotation node) {
    print('visited Annotation');
    print(node);
    return super.visitAnnotation(node);
  }

  @override
  void visitArgumentList(ArgumentList node) {
    print('visited ArgumentList');
    print(node);
    return super.visitArgumentList(node);
  }

  @override
  void visitAsExpression(AsExpression node) {
    print('visited AsExpression');
    print(node);
    return super.visitAsExpression(node);
  }

  @override
  void visitAssertInitializer(AssertInitializer node) {
    print('visited AssertInitializer');
    print(node);
    return super.visitAssertInitializer(node);
  }

  @override
  void visitAssertStatement(AssertStatement node) {
    print('visited AssertStatement');
    print(node);
    return super.visitAssertStatement(node);
  }

  @override
  void visitAssignedVariablePattern(AssignedVariablePattern node) {
    print('visited AssignedVariablePattern');
    print(node);
    return super.visitAssignedVariablePattern(node);
  }

  @override
  void visitAssignmentExpression(AssignmentExpression node) {
    print('visited AssignmentExpression');
    print(node);
    return super.visitAssignmentExpression(node);
  }

  @override
  void visitAugmentationImportDirective(AugmentationImportDirective node) {
    print('visited AugmentationImportDirective');
    print(node);
    return super.visitAugmentationImportDirective(node);
  }

  // @override
  // void visitAugmentedExpression(AugmentedExpression node) {
  //   print('visited AugmentedExpression');
  //   print(node);
  //   return super.visitAugmentedExpression(node);
  // }

  // @override
  // void visitAugmentedInvocation(AugmentedInvocation node) {
  //   print('visited AugmentedInvocation');
  //   print(node);
  //   return super.visitAugmentedInvocation(node);
  // }

  @override
  void visitAwaitExpression(AwaitExpression node) {
    print('visited AwaitExpression');
    print(node);
    return super.visitAwaitExpression(node);
  }

  @override
  void visitBinaryExpression(BinaryExpression node) {
    print('visited BinaryExpression');
    print(node);
    return super.visitBinaryExpression(node);
  }

  @override
  void visitBlock(Block node) {
    print('visited Block');
    print(node);
    // Visit each statement in the block
    node.statements.forEach((statement) {
      statement.accept(this);
    });
    return super.visitBlock(node);
  }

  @override
  void visitBlockFunctionBody(BlockFunctionBody node) {
    print('visited BlockFunctionBody');
    print(node);
    return super.visitBlockFunctionBody(node);
  }

  @override
  void visitBooleanLiteral(BooleanLiteral node) {
    print('visited BooleanLiteral');
    print(node);
    return super.visitBooleanLiteral(node);
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    print('visited BreakStatement');
    print(node);
    return super.visitBreakStatement(node);
  }

  @override
  void visitCascadeExpression(CascadeExpression node) {
    print('visited CascadeExpression');
    print(node);
    return super.visitCascadeExpression(node);
  }

  @override
  void visitCaseClause(CaseClause node) {
    print('visited CaseClause');
    print(node);
    return super.visitCaseClause(node);
  }

  @override
  void visitCastPattern(CastPattern node) {
    print('visited CastPattern');
    print(node);
    return super.visitCastPattern(node);
  }

  @override
  void visitCatchClause(CatchClause node) {
    print('visited CatchClause');
    print(node);
    return super.visitCatchClause(node);
  }

  @override
  void visitCatchClauseParameter(CatchClauseParameter node) {
    print('visited CatchClauseParameter');
    print(node);
    return super.visitCatchClauseParameter(node);
  }

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    print('visited ClassDeclaration');
    print(node);
    return super.visitClassDeclaration(node);
  }

  @override
  void visitClassTypeAlias(ClassTypeAlias node) {
    print('visited ClassTypeAlias');
    print(node);
    return super.visitClassTypeAlias(node);
  }

  @override
  void visitComment(Comment node) {
    print('visited Comment');
    print(node);
    return super.visitComment(node);
  }

  @override
  void visitCommentReference(CommentReference node) {
    print('visited CommentReference');
    print(node);
    return super.visitCommentReference(node);
  }

  @override
  void visitCompilationUnit(CompilationUnit node) {
    print('visited CompilationUnit');
    print(node);
    return super.visitCompilationUnit(node);
  }

  @override
  void visitConditionalExpression(ConditionalExpression node) {
    print('visited ConditionalExpression');
    print(node);
    return super.visitConditionalExpression(node);
  }

  @override
  void visitConfiguration(Configuration node) {
    print('visited Configuration');
    print(node);
    return super.visitConfiguration(node);
  }

  @override
  void visitConstantPattern(ConstantPattern node) {
    print('visited ConstantPattern');
    print(node);
    return super.visitConstantPattern(node);
  }

  @override
  void visitConstructorDeclaration(ConstructorDeclaration node) {
    print('visited ConstructorDeclaration');
    print(node);
    return super.visitConstructorDeclaration(node);
  }

  @override
  void visitConstructorFieldInitializer(ConstructorFieldInitializer node) {
    print('visited ConstructorFieldInitializer');
    print(node);
    return super.visitConstructorFieldInitializer(node);
  }

  @override
  void visitConstructorName(ConstructorName node) {
    print('visited ConstructorName');
    print(node);
    return super.visitConstructorName(node);
  }

  @override
  void visitConstructorReference(ConstructorReference node) {
    print('visited ConstructorReference');
    print(node);
    return super.visitConstructorReference(node);
  }

  @override
  void visitConstructorSelector(ConstructorSelector node) {
    print('visited ConstructorSelector');
    print(node);
    return super.visitConstructorSelector(node);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    print('visited ContinueStatement');
    print(node);
    return super.visitContinueStatement(node);
  }

  @override
  void visitDeclaredIdentifier(DeclaredIdentifier node) {
    print('visited DeclaredIdentifier');
    print(node);
    return super.visitDeclaredIdentifier(node);
  }

  @override
  void visitDeclaredVariablePattern(DeclaredVariablePattern node) {
    print('visited DeclaredVariablePattern');
    print(node);
    return super.visitDeclaredVariablePattern(node);
  }

  @override
  void visitDefaultFormalParameter(DefaultFormalParameter node) {
    print('visited DefaultFormalParameter');
    print(node);
    return super.visitDefaultFormalParameter(node);
  }

  @override
  void visitDoStatement(DoStatement node) {
    print('visited DoStatement');
    print(node);
    return super.visitDoStatement(node);
  }

  @override
  void visitDottedName(DottedName node) {
    print('visited DottedName');
    print(node);
    return super.visitDottedName(node);
  }

  @override
  void visitDoubleLiteral(DoubleLiteral node) {
    print('visited DoubleLiteral');
    print(node);
    return super.visitDoubleLiteral(node);
  }

  @override
  void visitEmptyFunctionBody(EmptyFunctionBody node) {
    print('visited EmptyFunctionBody');
    print(node);
    return super.visitEmptyFunctionBody(node);
  }

  @override
  void visitEmptyStatement(EmptyStatement node) {
    print('visited EmptyStatement');
    print(node);
    return super.visitEmptyStatement(node);
  }

  @override
  void visitEnumConstantArguments(EnumConstantArguments node) {
    print('visited EnumConstantArguments');
    print(node);
    return super.visitEnumConstantArguments(node);
  }

  @override
  void visitEnumConstantDeclaration(EnumConstantDeclaration node) {
    print('visited EnumConstantDeclaration');
    print(node);
    return super.visitEnumConstantDeclaration(node);
  }

  @override
  void visitEnumDeclaration(EnumDeclaration node) {
    print('visited EnumDeclaration');
    print(node);
    return super.visitEnumDeclaration(node);
  }

  @override
  void visitExportDirective(ExportDirective node) {
    print('visited ExportDirective');
    print(node);
    return super.visitExportDirective(node);
  }

  @override
  void visitExpressionFunctionBody(ExpressionFunctionBody node) {
    print('visited ExpressionFunctionBody');
    print(node);
    return super.visitExpressionFunctionBody(node);
  }

  @override
  void visitExpressionStatement(ExpressionStatement node) {
    print('visited ExpressionStatement');
    print(node);
    return super.visitExpressionStatement(node);
  }

  @override
  void visitExtendsClause(ExtendsClause node) {
    print('visited ExtendsClause');
    print(node);
    return super.visitExtendsClause(node);
  }

  @override
  void visitExtensionDeclaration(ExtensionDeclaration node) {
    print('visited ExtensionDeclaration');
    print(node);
    return super.visitExtensionDeclaration(node);
  }

  // @override
  // void visitExtensionOnClause(ExtensionOnClause node) {
  //   print('visited ExtensionOnClause');
  //   print(node);
  //   return super.visitExtensionOnClause(node);
  // }

  @override
  void visitFieldDeclaration(FieldDeclaration node) {
    print('visited FieldDeclaration');
    print(node);
    return super.visitFieldDeclaration(node);
  }

  @override
  void visitFieldFormalParameter(FieldFormalParameter node) {
    print('visited FieldFormalParameter');
    print(node);
    return super.visitFieldFormalParameter(node);
  }

  @override
  void visitForEachPartsWithDeclaration(ForEachPartsWithDeclaration node) {
    print('visited ForEachPartsWithDeclaration');
    print(node);
    return super.visitForEachPartsWithDeclaration(node);
  }

  @override
  void visitForEachPartsWithIdentifier(ForEachPartsWithIdentifier node) {
    print('visited ForEachPartsWithIdentifier');
    print(node);
    return super.visitForEachPartsWithIdentifier(node);
  }

  @override
  void visitForElement(ForElement node) {
    print('visited ForElement');
    print(node);
    return super.visitForElement(node);
  }

  @override
  void visitFormalParameterList(FormalParameterList node) {
    print('visited FormalParameterList');
    print(node);
    return super.visitFormalParameterList(node);
  }

  @override
  void visitForPartsWithDeclarations(ForPartsWithDeclarations node) {
    print('visited ForPartsWithDeclarations');
    print(node);
    return super.visitForPartsWithDeclarations(node);
  }

  @override
  void visitForPartsWithExpression(ForPartsWithExpression node) {
    print('visited ForPartsWithExpression');
    print(node);
    return super.visitForPartsWithExpression(node);
  }

  @override
  void visitForStatement(ForStatement node) {
    print('visited ForStatement');
    print(node);
    return super.visitForStatement(node);
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    print('visited FunctionDeclaration');
    print(node);
    print('FunctionDeclaration: ${node.name}');
    node.functionExpression.accept(this);
    return super.visitFunctionDeclaration(node);
  }

  @override
  void visitFunctionDeclarationStatement(FunctionDeclarationStatement node) {
    print('visited FunctionDeclarationStatement');
    print(node);
    return super.visitFunctionDeclarationStatement(node);
  }

  @override
  void visitFunctionExpression(FunctionExpression node) {
    print('visited FunctionExpression');
    print(node);
    // Visit the body of the function
    node.body.accept(this);
    return super.visitFunctionExpression(node);
  }

  @override
  void visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    print('visited FunctionExpressionInvocation');
    print(node);
    return super.visitFunctionExpressionInvocation(node);
  }

  @override
  void visitFunctionReference(FunctionReference node) {
    print('visited FunctionReference');
    print(node);
    return super.visitFunctionReference(node);
  }

  @override
  void visitFunctionTypeAlias(FunctionTypeAlias node) {
    print('visited FunctionTypeAlias');
    print(node);
    return super.visitFunctionTypeAlias(node);
  }

  @override
  void visitFunctionTypedFormalParameter(FunctionTypedFormalParameter node) {
    print('visited FunctionTypedFormalParameter');
    print(node);
    return super.visitFunctionTypedFormalParameter(node);
  }

  @override
  void visitGenericFunctionType(GenericFunctionType node) {
    print('visited GenericFunctionType');
    print(node);
    return super.visitGenericFunctionType(node);
  }

  @override
  void visitGenericTypeAlias(GenericTypeAlias node) {
    print('visited GenericTypeAlias');
    print(node);
    return super.visitGenericTypeAlias(node);
  }

  @override
  void visitGuardedPattern(GuardedPattern node) {
    print('visited GuardedPattern');
    print(node);
    return super.visitGuardedPattern(node);
  }

  @override
  void visitHideCombinator(HideCombinator node) {
    print('visited HideCombinator');
    print(node);
    return super.visitHideCombinator(node);
  }

  @override
  void visitIfElement(IfElement node) {
    print('visited IfElement');
    print(node);
    return super.visitIfElement(node);
  }

  @override
  void visitIfStatement(IfStatement node) {
    print('visited IfStatement');
    print(node);
    return super.visitIfStatement(node);
  }

  @override
  void visitImplementsClause(ImplementsClause node) {
    print('visited ImplementsClause');
    print(node);
    return super.visitImplementsClause(node);
  }

  @override
  void visitImportDirective(ImportDirective node) {
    print('visited ImportDirective');
    print(node);
    return super.visitImportDirective(node);
  }

  @override
  void visitIndexExpression(IndexExpression node) {
    print('visited IndexExpression');
    print(node);
    return super.visitIndexExpression(node);
  }

  @override
  void visitInstanceCreationExpression(InstanceCreationExpression node) {
    print('visited InstanceCreationExpression');
    print(node);
    return super.visitInstanceCreationExpression(node);
  }

  @override
  void visitIntegerLiteral(IntegerLiteral node) {
    print('visited IntegerLiteral');
    print(node);
    return super.visitIntegerLiteral(node);
  }

  @override
  void visitInterpolationExpression(InterpolationExpression node) {
    print('visited InterpolationExpression');
    print(node);
    return super.visitInterpolationExpression(node);
  }

  @override
  void visitInterpolationString(InterpolationString node) {
    print('visited InterpolationString');
    print(node);
    return super.visitInterpolationString(node);
  }

  @override
  void visitIsExpression(IsExpression node) {
    print('visited IsExpression');
    print(node);
    return super.visitIsExpression(node);
  }

  @override
  void visitLabel(Label node) {
    print('visited Label');
    print(node);
    return super.visitLabel(node);
  }

  @override
  void visitLabeledStatement(LabeledStatement node) {
    print('visited LabeledStatement');
    print(node);
    return super.visitLabeledStatement(node);
  }

  @override
  void visitLibraryAugmentationDirective(LibraryAugmentationDirective node) {
    print('visited LibraryAugmentationDirective');
    print(node);
    return super.visitLibraryAugmentationDirective(node);
  }

  @override
  void visitLibraryDirective(LibraryDirective node) {
    print('visited LibraryDirective');
    print(node);
    return super.visitLibraryDirective(node);
  }

  @override
  void visitLibraryIdentifier(LibraryIdentifier node) {
    print('visited LibraryIdentifier');
    print(node);
    return super.visitLibraryIdentifier(node);
  }

  @override
  void visitListLiteral(ListLiteral node) {
    print('visited ListLiteral');
    print(node);
    return super.visitListLiteral(node);
  }

  @override
  void visitListPattern(ListPattern node) {
    print('visited ListPattern');
    print(node);
    return super.visitListPattern(node);
  }

  @override
  void visitLogicalAndPattern(LogicalAndPattern node) {
    print('visited LogicalAndPattern');
    print(node);
    return super.visitLogicalAndPattern(node);
  }

  @override
  void visitLogicalOrPattern(LogicalOrPattern node) {
    print('visited LogicalOrPattern');
    print(node);
    return super.visitLogicalOrPattern(node);
  }

  @override
  void visitMapLiteralEntry(MapLiteralEntry node) {
    print('visited MapLiteralEntry');
    print(node);
    return super.visitMapLiteralEntry(node);
  }

  @override
  void visitMapPattern(MapPattern node) {
    print('visited MapPattern');
    print(node);
    return super.visitMapPattern(node);
  }

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    print('visited MethodDeclaration');
    print(node);
    return super.visitMethodDeclaration(node);
  }

  @override
  void visitMethodInvocation(MethodInvocation node) {
    print('visited MethodInvocation');
    print(node);
    // print(node.target);
    // node.target?.accept(this);
    // // Visit the method name
    // print(node.methodName);
    // node.methodName.accept(this);
    return super.visitMethodInvocation(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    print('visited MixinDeclaration');
    print(node);
    return super.visitMixinDeclaration(node);
  }

  @override
  void visitNamedExpression(NamedExpression node) {
    print('visited NamedExpression');
    print(node);
    return super.visitNamedExpression(node);
  }

  @override
  void visitNamedType(NamedType node) {
    print('visited NamedType');
    print(node);
    return super.visitNamedType(node);
  }

  @override
  void visitNativeClause(NativeClause node) {
    print('visited NativeClause');
    print(node);
    return super.visitNativeClause(node);
  }

  @override
  void visitNativeFunctionBody(NativeFunctionBody node) {
    print('visited NativeFunctionBody');
    print(node);
    return super.visitNativeFunctionBody(node);
  }

  @override
  void visitNullLiteral(NullLiteral node) {
    print('visited NullLiteral');
    print(node);
    return super.visitNullLiteral(node);
  }

  @override
  void visitObjectPattern(ObjectPattern node) {
    print('visited ObjectPattern');
    print(node);
    return super.visitObjectPattern(node);
  }

  @override
  void visitOnClause(OnClause node) {
    print('visited OnClause');
    print(node);
    return super.visitOnClause(node);
  }

  @override
  void visitParenthesizedExpression(ParenthesizedExpression node) {
    print('visited ParenthesizedExpression');
    print(node);
    return super.visitParenthesizedExpression(node);
  }

  @override
  void visitParenthesizedPattern(ParenthesizedPattern node) {
    print('visited ParenthesizedPattern');
    print(node);
    return super.visitParenthesizedPattern(node);
  }

  @override
  void visitPartDirective(PartDirective node) {
    print('visited PartDirective');
    print(node);
    return super.visitPartDirective(node);
  }

  @override
  void visitPartOfDirective(PartOfDirective node) {
    print('visited PartOfDirective');
    print(node);
    return super.visitPartOfDirective(node);
  }

  @override
  void visitPatternAssignment(PatternAssignment node) {
    print('visited PatternAssignment');
    print(node);
    return super.visitPatternAssignment(node);
  }

  @override
  void visitPatternField(PatternField node) {
    print('visited PatternField');
    print(node);
    return super.visitPatternField(node);
  }

  @override
  void visitPatternVariableDeclaration(PatternVariableDeclaration node) {
    print('visited PatternVariableDeclaration');
    print(node);
    return super.visitPatternVariableDeclaration(node);
  }

  @override
  void visitPatternVariableDeclarationStatement(
      PatternVariableDeclarationStatement node) {
    print('visited PatternVariableDeclarationStatement');
    print(node);
    return super.visitPatternVariableDeclarationStatement(node);
  }

  @override
  void visitPostfixExpression(PostfixExpression node) {
    print('visited PostfixExpression');
    print(node);
    return super.visitPostfixExpression(node);
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    print('visited PrefixedIdentifier');
    print(node);
    return super.visitPrefixedIdentifier(node);
  }

  @override
  void visitPrefixExpression(PrefixExpression node) {
    print('visited PrefixExpression');
    print(node);
    return super.visitPrefixExpression(node);
  }

  @override
  void visitPropertyAccess(PropertyAccess node) {
    print('visited PropertyAccess');
    print(node);
    return super.visitPropertyAccess(node);
  }

  @override
  void visitRecordLiteral(RecordLiteral node) {
    print('visited RecordLiteral');
    print(node);
    return super.visitRecordLiteral(node);
  }

  @override
  void visitRecordPattern(RecordPattern node) {
    print('visited RecordPattern');
    print(node);
    return super.visitRecordPattern(node);
  }

  @override
  void visitRedirectingConstructorInvocation(
      RedirectingConstructorInvocation node) {
    print('visited RedirectingConstructorInvocation');
    print(node);
    return super.visitRedirectingConstructorInvocation(node);
  }

  @override
  void visitRelationalPattern(RelationalPattern node) {
    print('visited RelationalPattern');
    print(node);
    return super.visitRelationalPattern(node);
  }

  @override
  void visitRestPatternElement(RestPatternElement node) {
    print('visited RestPatternElement');
    print(node);
    return super.visitRestPatternElement(node);
  }

  @override
  void visitReturnStatement(ReturnStatement node) {
    print('visited ReturnStatement');
    print(node);
    return super.visitReturnStatement(node);
  }

  @override
  void visitScriptTag(ScriptTag node) {
    print('visited ScriptTag');
    print(node);
    return super.visitScriptTag(node);
  }

  @override
  void visitSetOrMapLiteral(SetOrMapLiteral node) {
    print('visited SetOrMapLiteral');
    print(node);
    return super.visitSetOrMapLiteral(node);
  }

  @override
  void visitShowCombinator(ShowCombinator node) {
    print('visited ShowCombinator');
    print(node);
    return super.visitShowCombinator(node);
  }

  @override
  void visitSimpleFormalParameter(SimpleFormalParameter node) {
    print('visited SimpleFormalParameter');
    print(node);
    return super.visitSimpleFormalParameter(node);
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    print('visited SimpleIdentifier');
    print(node);
    return super.visitSimpleIdentifier(node);
  }

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    print('visited SimpleStringLiteral');
    print(node);
    return super.visitSimpleStringLiteral(node);
  }

  @override
  void visitSpreadElement(SpreadElement node) {
    print('visited SpreadElement');
    print(node);
    return super.visitSpreadElement(node);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    print('visited StringInterpolation');
    print(node);
    return super.visitStringInterpolation(node);
  }

  @override
  void visitSuperConstructorInvocation(SuperConstructorInvocation node) {
    print('visited SuperConstructorInvocation');
    print(node);
    return super.visitSuperConstructorInvocation(node);
  }

  @override
  void visitSuperExpression(SuperExpression node) {
    print('visited SuperExpression');
    print(node);
    return super.visitSuperExpression(node);
  }

  @override
  void visitSwitchCase(SwitchCase node) {
    print('visited SwitchCase');
    print(node);
    return super.visitSwitchCase(node);
  }

  @override
  void visitSwitchDefault(SwitchDefault node) {
    print('visited SwitchDefault');
    print(node);
    return super.visitSwitchDefault(node);
  }

  @override
  void visitSwitchExpression(SwitchExpression node) {
    print('visited SwitchExpression');
    print(node);
    return super.visitSwitchExpression(node);
  }

  @override
  void visitSwitchExpressionCase(SwitchExpressionCase node) {
    print('visited SwitchExpressionCase');
    print(node);
    return super.visitSwitchExpressionCase(node);
  }

  @override
  void visitSwitchPatternCase(SwitchPatternCase node) {
    print('visited SwitchPatternCase');
    print(node);
    return super.visitSwitchPatternCase(node);
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    print('visited SwitchStatement');
    print(node);
    return super.visitSwitchStatement(node);
  }

  @override
  void visitSymbolLiteral(SymbolLiteral node) {
    print('visited SymbolLiteral');
    print(node);
    return super.visitSymbolLiteral(node);
  }

  @override
  void visitThisExpression(ThisExpression node) {
    print('visited ThisExpression');
    print(node);
    return super.visitThisExpression(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    print('visited ThrowExpression');
    print(node);
    return super.visitThrowExpression(node);
  }

  @override
  void visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    print('visited TopLevelVariableDeclaration');
    print(node);
    return super.visitTopLevelVariableDeclaration(node);
  }

  @override
  void visitTryStatement(TryStatement node) {
    print('visited TryStatement');
    print(node);
    return super.visitTryStatement(node);
  }

  @override
  void visitTypeArgumentList(TypeArgumentList node) {
    print('visited TypeArgumentList');
    print(node);
    return super.visitTypeArgumentList(node);
  }

  @override
  void visitTypeLiteral(TypeLiteral node) {
    print('visited TypeLiteral');
    print(node);
    return super.visitTypeLiteral(node);
  }

  @override
  void visitTypeParameter(TypeParameter node) {
    print('visited TypeParameter');
    print(node);
    return super.visitTypeParameter(node);
  }

  @override
  void visitTypeParameterList(TypeParameterList node) {
    print('visited TypeParameterList');
    print(node);
    return super.visitTypeParameterList(node);
  }

  @override
  void visitVariableDeclaration(VariableDeclaration node) {
    print('visited VariableDeclaration');
    print(node);
    return super.visitVariableDeclaration(node);
  }

  @override
  void visitVariableDeclarationList(VariableDeclarationList node) {
    print('visited VariableDeclarationList');
    print(node);
    return super.visitVariableDeclarationList(node);
  }

  @override
  void visitVariableDeclarationStatement(VariableDeclarationStatement node) {
    print('visited VariableDeclarationStatement');
    print(node);
    return super.visitVariableDeclarationStatement(node);
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    print('visited WhileStatement');
    print(node);
    return super.visitWhileStatement(node);
  }

  @override
  void visitWildcardPattern(WildcardPattern node) {
    print('visited WildcardPattern');
    print(node);
    return super.visitWildcardPattern(node);
  }

  @override
  void visitWithClause(WithClause node) {
    print('visited WithClause');
    print(node);
    return super.visitWithClause(node);
  }

  @override
  void visitYieldStatement(YieldStatement node) {
    print('visited YieldStatement');
    print(node);
    return super.visitYieldStatement(node);
  }
}
