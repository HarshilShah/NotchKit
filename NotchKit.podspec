Pod::Spec.new do |spec|
  spec.name             = 'NotchKit'
  spec.version          = '0.4.0'
  spec.summary          = 'One line to hide the iPhone X notch'
  spec.description      = <<-DESC
                          A UIWindow subclass to limit your iOS apps to a roundrect frame
                          DESC
  spec.homepage         = 'https://github.com/HarshilShah/NotchKit'
  spec.license          = { type: 'MIT', file: 'LICENSE.md' }
  spec.author           = { 'Harshil Shah' => 'harshilshah1910@me.com' }
  spec.social_media_url = 'https://twitter.com/HarshilShah1910'

  spec.source           = { git: 'https://github.com/HarshilShah/NotchKit.git', tag: spec.version.to_s }
  spec.ios.source_files = 'Sources/**/*.{h,swift}'
  spec.ios.deployment_target = '8.0'
  spec.ios.frameworks = 'UIKit'
end
