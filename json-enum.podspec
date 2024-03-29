Pod::Spec.new do |s|
  s.name = "json-enum"
  s.version = "1.2.3"
  s.summary = "Parsing JSON to Swift enum parsing library"
  s.description = "Representing a JSON using an enumerated type makes it easy and type safe."
  s.homepage = "https://github.com/advantagefse/json-logic-swift"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Christos Koninis" => "c.koninis@afse.eu" }
  s.source = { :git => "https://github.com/advantagefse/json-logic-swift.git", :tag => 'json-enum-1.2.3' }
  
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'
  s.watchos.deployment_target = '4.0'
  s.osx.deployment_target = '10.13'
  
  s.cocoapods_version = '>= 1.6.1'
  s.swift_version = '5'
  
  s.frameworks = 'Foundation'
  
  s.source_files = 'Sources/JSON/*.swift'
  s.module_name = 'JSON'

end
