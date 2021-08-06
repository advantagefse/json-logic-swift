Pod::Spec.new do |s|
  s.name = "json-enum"
  s.version = "1.1.0"
  s.summary = "Parsing JSON to Swift enum parsing library"
  s.description = "Representing a JSON using a enumerated type makes it easy and type safe."
  s.homepage = "https://github.com/advantagefse/json-logic-swift"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Christos Koninis" => "c.koninis@afse.eu" }
  s.source = { :git => "https://github.com/advantagefse/json-logic-swift.git", :tag => 'json-enum-1.1.0' }
  
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '10.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.12'
  
  s.cocoapods_version = '>= 1.6.1'
#  s.swift_version = '4.2.1'
  
  s.frameworks = 'Foundation'
  
  s.source_files = 'Sources/JSON/*.swift'
  s.module_name = 'JSON'

end
