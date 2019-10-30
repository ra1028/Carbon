Pod::Spec.new do |spec|
  spec.name = 'Carbon'
  spec.version  = '1.0.0-rc.6'
  spec.author = { 'ra1028' => 'r.fe51028.r@gmail.com' }
  spec.homepage = 'https://github.com/ra1028/Carbon'
  spec.documentation_url = 'https://ra1028.github.io/Carbon'
  spec.summary = 'A declarative library for building component-based user interfaces in UITableView and UICollectionView.'
  spec.source = { :git => 'https://github.com/ra1028/Carbon.git', :tag => spec.version.to_s }
  spec.source_files = 'Sources/**/*.swift'
  spec.license = { :type => 'Apache 2.0', :file => 'LICENSE' }
  spec.requires_arc = true
  spec.swift_versions = ['5.1']
  spec.ios.deployment_target = '10.0'
  spec.dependency 'DifferenceKit/Core', "~> 1.1"
  spec.ios.frameworks = 'UIKit'
  spec.ios.weak_frameworks = 'SwiftUI'
end
