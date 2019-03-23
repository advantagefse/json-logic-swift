//
//  JSON.swift
//  JSON
//
//  Created by Christos Koninis on 09/03/2019.
//  Licensed under LGPL
//

import jsonlogic

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
