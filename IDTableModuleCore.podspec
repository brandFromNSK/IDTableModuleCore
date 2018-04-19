#
# Be sure to run `pod lib lint IDTableModuleCore.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IDTableModuleCore'
  s.version          = '0.0.5'
  s.summary          = 'IDTableModuleCore created for easy module configuration based on UITableView'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Detailed description...'
  s.homepage         = 'https://github.com/improvedigital-ios/IDTableModuleCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Andrey Bronnikov' => 'brand_nsk@mail.ru' }
  s.source           = { :git => 'https://github.com/improvedigital-ios/IDTableModuleCore.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'Classes/**/*.{h,m}'
  s.resource_bundles = 'Classes/**/*.xib'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ReactiveObjC'
  s.dependency 'Masonry'
end
