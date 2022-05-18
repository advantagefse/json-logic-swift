Pod::Spec.new do |s|
  s.name = "JsonLogic"
  s.version = "1.1.0"
  s.summary = "A JsonLogic Swift library"
  s.description = "A JsonLogic implementation in Swift. JsonLogic is a way to write rules that involve computations in JSON format, these can be applied on JSON data with consistent results. So you can share between server and clients rules in a common format."
  s.homepage = "https://github.com/advantagefse/json-logic-swift"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Christos Koninis" => "c.koninis@afse.eu" }
  s.source = { :git => "https://github.com/advantagefse/json-logic-swift.git", :tag => s.version }
  
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.12'
  
  s.cocoapods_version = '>= 1.6.1'
#  s.swift_version = '4.2.1'
  
  s.frameworks = 'Foundation'
  
  s.source_files = 'Sources/JsonLogic/*.swift'
  s.module_name = 'JsonLogic'
  s.dependency 'json-enum', '~> 1.1' 

end
