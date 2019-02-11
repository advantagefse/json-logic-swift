import jsonlogic_swift

//Example parsing
let jsonLogic = JsonLogic()

let rule =
"""
{ "var" : "name" }
"""
let data =
"""
{ "name" : "Jon" }
"""

let result: String? = try? jsonLogic.applyRule(rule, to: data)

print("result = \(String(describing: result))")
