import XCTest

extension AllTests {
    static let __allTests = [
        ("testAll_withCurrentArrayElement", testAll_withCurrentArrayElement),
        ("testAll_withEmptyDataArray", testAll_withEmptyDataArray),
        ("testAll_withNestedArrayElement", testAll_withNestedArrayElement),
    ]
}

extension AndTests {
    static let __allTests = [
        ("testAnd_mixedArguments", testAnd_mixedArguments),
        ("testAnd_twoBooleans", testAnd_twoBooleans),
    ]
}

extension Arithmetic {
    static let __allTests = [
        ("testAddition", testAddition),
        ("testDivision", testDivision),
        ("testModulo", testModulo),
        ("testMultiplication", testMultiplication),
        ("testMultiplication_TypeCoercion", testMultiplication_TypeCoercion),
        ("testSubtraction", testSubtraction),
        ("testUnaryMinus", testUnaryMinus),
    ]
}

extension ArrayMapTests {
    static let __allTests = [
        ("testFilter", testFilter),
        ("testMap", testMap),
        ("testReduce", testReduce),
    ]
}

extension BetweenTests {
    static let __allTests = [
        ("testBetween_withNumberConstants", testBetween_withNumberConstants),
        ("testBetween_withVariables", testBetween_withVariables),
    ]
}

extension CatTests {
    static let __allTests = [
        ("testCat", testCat),
        ("testCat_WithArrays", testCat_WithArrays),
        ("testCat_WithBoolean", testCat_WithBoolean),
        ("testCat_WithNullOrEmpty", testCat_WithNullOrEmpty),
    ]
}

extension CompoundTests {
    static let __allTests = [
        ("testCompound", testCompound),
    ]
}

extension DoubleNegationTests {
    static let __allTests = [
        ("testDoubleNegation_withArrays", testDoubleNegation_withArrays),
        ("testDoubleNegation_withBooleans", testDoubleNegation_withBooleans),
        ("testDoubleNegation_withNull", testDoubleNegation_withNull),
        ("testDoubleNegation_withNumbers", testDoubleNegation_withNumbers),
        ("testDoubleNegation_withStrings", testDoubleNegation_withStrings),
    ]
}

extension EqualsTests {
    static let __allTests = [
        ("testEquals", testEquals),
        ("testEquals_WithTypeCoercion", testEquals_WithTypeCoercion),
        ("testNotEquals", testNotEquals),
        ("testNotEquals_WithTypeCoersion", testNotEquals_WithTypeCoersion),
    ]
}

extension GreaterThanOrEqualTests {
    static let __allTests = [
        ("testGreaterThan_withMixedArgumentTypes", testGreaterThan_withMixedArgumentTypes),
        ("testGreaterThan_withNonNumbericConstants", testGreaterThan_withNonNumbericConstants),
        ("testGreaterThan_withNumberConstants", testGreaterThan_withNumberConstants),
        ("testGreaterThan_withVariables", testGreaterThan_withVariables),
    ]
}

extension GreaterThanTests {
    static let __allTests = [
        ("testGreaterThan_withMixedArguments", testGreaterThan_withMixedArguments),
        ("testGreaterThan_withNonNumbericConstants", testGreaterThan_withNonNumbericConstants),
        ("testGreaterThan_withNumberConstants", testGreaterThan_withNumberConstants),
        ("testGreaterThan_withVariables", testGreaterThan_withVariables),
    ]
}

extension IfTests {
    static let __allTests = [
        ("testIf_EmptyArraysAreFalsey", testIf_EmptyArraysAreFalsey),
        ("testIf_FizzBuzz", testIf_FizzBuzz),
        ("testIf_IfThenElseIfThenCases", testIf_IfThenElseIfThenCases),
        ("testIf_NonEmptyOtherStringsAreTruthy", testIf_NonEmptyOtherStringsAreTruthy),
        ("testIf_SimpleCases", testIf_SimpleCases),
        ("testIf_ToofewArgs", testIf_ToofewArgs),
    ]
}

extension InTests {
    static let __allTests = [
        ("testIn_ArrayArgument", testIn_ArrayArgument),
        ("testIn_StringArgument", testIn_StringArgument),
    ]
}

extension JsonLogicTests {
    static let __allTests = [
        ("testAddTwoIntsFromVariables", testAddTwoIntsFromVariables),
        ("testEqualsWithDifferentSameConstants", testEqualsWithDifferentSameConstants),
        ("testEqualsWithTwoSameConstants", testEqualsWithTwoSameConstants),
        ("testNestedStrictEqualsWithVar", testNestedStrictEqualsWithVar),
        ("testNestedVar", testNestedVar),
        ("testNestedVarWithStrictEquals", testNestedVarWithStrictEquals),
        ("testNotSupportedResultType", testNotSupportedResultType),
        ("testSetOneBoolVariableFromData", testSetOneBoolVariableFromData),
        ("testSetOneIntegerVariableFromData", testSetOneIntegerVariableFromData),
        ("testSetOneStringArrayVariableFromData", testSetOneStringArrayVariableFromData),
        ("testSetOneStringNestedVariableFromData", testSetOneStringNestedVariableFromData),
        ("testSetOneStringVariableFromData", testSetOneStringVariableFromData),
        ("testSetTwoStringVariablesFromData", testSetTwoStringVariablesFromData),
    ]
}

extension LessThanOrEqualTests {
    static let __allTests = [
        ("testLessThan_withMixedArgumentTypes", testLessThan_withMixedArgumentTypes),
        ("testLessThan_withNonNumericConstants", testLessThan_withNonNumericConstants),
        ("testLessThan_withNumberConstants", testLessThan_withNumberConstants),
        ("testLessThan_withVariables", testLessThan_withVariables),
    ]
}

extension LessThanTests {
    static let __allTests = [
        ("testLessThan_withMixedArgumentsTypes", testLessThan_withMixedArgumentsTypes),
        ("testLessThan_withNonNumbericConstants", testLessThan_withNonNumbericConstants),
        ("testLessThan_withNumberConstants", testLessThan_withNumberConstants),
        ("testLessThan_withVariables", testLessThan_withVariables),
    ]
}

extension LogTests {
    static let __allTests = [
        ("testLog", testLog),
        ("testLog_nestedInOtherExpressions", testLog_nestedInOtherExpressions),
        ("testLog_withComplexExpression", testLog_withComplexExpression),
    ]
}

extension MergeTests {
    static let __allTests = [
        ("testMerge", testMerge),
        ("testMerge_withNonArrayArguments", testMerge_withNonArrayArguments),
    ]
}

extension MinMaxTests {
    static let __allTests = [
        ("testMax_MultipleNegativeValues", testMax_MultipleNegativeValues),
        ("testMax_MultiplePositiveValues", testMax_MultiplePositiveValues),
        ("testMax_SinglePositiveItem", testMax_SinglePositiveItem),
        ("testMin_MultipleNegativeValues", testMin_MultipleNegativeValues),
        ("testMin_MultiplePositiveValues", testMin_MultiplePositiveValues),
        ("testMin_SinglePositiveItem", testMin_SinglePositiveItem),
    ]
}

extension MissingTests {
    static let __allTests = [
        ("testMissing", testMissing),
        ("testMissing_NestedKeys", testMissing_NestedKeys),
        ("testMissing_some", testMissing_some),
        ("testVar_withEmptyVarName", testVar_withEmptyVarName),
    ]
}

extension NoneTests {
    static let __allTests = [
        ("testNone", testNone),
        ("testNone_WithEmptyDataArray", testNone_WithEmptyDataArray),
        ("testNone_WithNestedDataItems", testNone_WithNestedDataItems),
    ]
}

extension NotStrictEquals {
    static let __allTests = [
        ("testLogicalNot_withArrays", testLogicalNot_withArrays),
        ("testLogicalNot_withBooleanConstants", testLogicalNot_withBooleanConstants),
        ("testLogicalNot_withNull", testLogicalNot_withNull),
        ("testLogicalNot_withNumbers", testLogicalNot_withNumbers),
        ("testLogicalNot_withStrings", testLogicalNot_withStrings),
        ("testLogicalNot_withVariables", testLogicalNot_withVariables),
        ("testNot_StrictEquals_withConstants", testNot_StrictEquals_withConstants),
        ("testNot_StrictEquals_withConstants1", testNot_StrictEquals_withConstants1),
        ("testNot_StrictEquals_withConstants2", testNot_StrictEquals_withConstants2),
        ("testNot_StrictEquals_withConstants3", testNot_StrictEquals_withConstants3),
        ("testNotStringEquals_NestedVar", testNotStringEquals_NestedVar),
    ]
}

extension OrTests {
    static let __allTests = [
        ("testOr_mixedArguments", testOr_mixedArguments),
        ("testOr_twoBooleans", testOr_twoBooleans),
    ]
}

extension SomeTests {
    static let __allTests = [
        ("testNone_WithNestedDataItems", testNone_WithNestedDataItems),
        ("testSome", testSome),
        ("testSome_WithEmptyDataArray", testSome_WithEmptyDataArray),
    ]
}

extension SubstringTests {
    static let __allTests = [
        ("testSubstring", testSubstring),
        ("testSubstring_withRange", testSubstring_withRange),
        ("testSunString_withInvalidLength", testSunString_withInvalidLength),
        ("testSunString_withInvalidStart", testSunString_withInvalidStart),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AllTests.__allTests),
        testCase(AndTests.__allTests),
        testCase(Arithmetic.__allTests),
        testCase(ArrayMapTests.__allTests),
        testCase(BetweenTests.__allTests),
        testCase(CatTests.__allTests),
        testCase(CompoundTests.__allTests),
        testCase(DoubleNegationTests.__allTests),
        testCase(EqualsTests.__allTests),
        testCase(GreaterThanOrEqualTests.__allTests),
        testCase(GreaterThanTests.__allTests),
        testCase(IfTests.__allTests),
        testCase(InTests.__allTests),
        testCase(JsonLogicTests.__allTests),
        testCase(LessThanOrEqualTests.__allTests),
        testCase(LessThanTests.__allTests),
        testCase(LogTests.__allTests),
        testCase(MergeTests.__allTests),
        testCase(MinMaxTests.__allTests),
        testCase(MissingTests.__allTests),
        testCase(NoneTests.__allTests),
        testCase(NotStrictEquals.__allTests),
        testCase(OrTests.__allTests),
        testCase(SomeTests.__allTests),
        testCase(SubstringTests.__allTests),
    ]
}
#endif
