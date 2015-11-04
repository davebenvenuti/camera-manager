# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'camera_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "camera-manager"
  spec.version       = CameraManager::VERSION
  spec.authors       = ["Dave Benvenuti"]
  spec.email         = ["davebenvenuti@gmail.com"]
  spec.summary       = %q{Sync photos from a digital camera to the local hard drive as well as Amazon Cloud Drive}
  spec.description   = %q{Sync photos from a digital camera to the local hard drive as well as Amazon Cloud Drive}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "settingslogic"
  
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
