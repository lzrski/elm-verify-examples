module VerifyExamples.Parser exposing (parse)

import VerifyExamples.Comment as Comment exposing (Comment)
import VerifyExamples.GroupedAst as GroupedAst exposing (GroupedAst)
import VerifyExamples.IntermediateAst as IntermediateAst exposing (IntermediateAst)
import VerifyExamples.TestSuite as TestSuite exposing (TestSuite)


parse : String -> List TestSuite
parse =
    Comment.parse
        >> List.map toTestSuite
        >> TestSuite.group


toTestSuite : Comment -> TestSuite
toTestSuite comment =
    case comment of
        Comment.FunctionDoc { functionName, comment } ->
            comment
                |> IntermediateAst.fromString
                |> IntermediateAst.toAst
                |> GroupedAst.fromAst
                |> TestSuite.fromAst (Just functionName)

        Comment.ModuleDoc comment ->
            comment
                |> IntermediateAst.fromString
                |> IntermediateAst.toAst
                |> GroupedAst.fromAst
                |> TestSuite.fromAst Nothing
