#
# Be sure to run `pod lib lint GLCKeychainWrapper.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "GLCKeychainWrapper"
  s.version          = "0.1.0"
  s.summary          = "An easy to use wrapper for the iOS Keychain."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = <<-DESC
  An easy to use wrapper for the iOS Keychain in Objective-C.
                       DESC

  s.homepage         = "https://github.com/glucode/GLCKeychainWrapper"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Nico du Plessis" => "duplessis.nico@gmail.com" }
  s.source           = { :git => "https://github.com/glucode/GLCKeychainWrapper.git", :branch => 'master' }
#s.source           = { :git => "https://github.com/glucode/GLCKeychainWrapper.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/glucode'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'

  s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'Security'
end
