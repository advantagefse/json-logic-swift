# jsonlogic-swift

A JsonLogic implementation in Swift. JsonLogic is a way to write rules that involve computations in JSON format, these can be applied on JSON data with consistent results. So you can share between server and clients rules in a common format. Original JS [JsonLogic](http://jsonlogic.com/) implementation is developed by Jeremy Wadhams.

## Instalation

### Using CocoaPods

To use the pod in your project add in the Podfile:

    pod jsonlogic
    
To run the example project, just run:

    pod try jsonlogic    

### Using Swift Package Manager

if you use Swift Package Manager add the following in dependencies:

        dependencies: [
        .package(
            url: "https://github.com/advantagefse/json-logic-swift", from: "1.0.0"
        )
    ]

## Usage

You can look at the main.swift for an example:

```swift
import jsonlogic

let rule =
"""
{ "var" : "name" }
"""
let data =
"""
{ "name" : "Jon" }
"""

//Example parsing
let jsonLogic = JsonLogic()

let result: String? = try? jsonLogic.applyRule(rule, to: data)

print("result = \(String(describing: result))")
```

## Requirements

Currently it supports iOS 10 and above.

## Author

Christos Koninis, c.koninis@afse.eu

## License

JsonLogic for Swift is available under the LGPL license. See the LICENSE file for more info.
