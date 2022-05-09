//
//  JSON.swift
//  JSON
//
//  Created by Christos Koninis on 09/03/2019.
//  Licensed under MIT
//

import JsonLogic

//Example parsing

let rule =
"""
{ "var" : "name" }
"""
let data =
"""
{ "name" : "Jon" }
"""

let result: String? = try? applyRule(rule, to: data)

print("result = \(String(describing: result))")
