Pod::Spec.new do |s|
  s.name             = "Contract"
  s.summary          = "The easiest way to sign your soul away"
  s.version          = "0.2.0"
  s.homepage         = "https://github.com/hyperoslo/Contract"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = { :git => "https://github.com/hyperoslo/Contract.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/hyperoslo'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Source/**/*'
  s.resource_bundles = {
      'Contract' => ['Assets/*.{png}']
  }
  s.frameworks = 'UIKit'

  s.dependency 'Hex'
  s.dependency 'HYPWebView'
  s.dependency 'Signature'
  s.dependency 'UIButton-ANDYHighlighted'
  s.dependency 'UIViewController-HYPContainer'
end
