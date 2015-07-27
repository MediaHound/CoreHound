Pod::Spec.new do |s|
  s.name             = "CoreHound"
  s.version          = "0.2.0"
  s.summary          = "The MediaHound iOS SDK"
  s.homepage         = "https://github.com/MediaHound/CoreHound"
  s.license          = 'Apache'
  s.author           = { "Dustin Bachrach" => "dustin@mediahound.com" }
  s.source           = { :git => "https://github.com/MediaHound/CoreHound.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*.{h,m}'
  s.private_header_files = "{Pod/Model/Internal/**/*.h,Pod/**/*+Internal.h,Pod/Network/Internal/**/*.h}"

  s.resources = ['Pod/Resources/*.cer']

  s.dependency 'AFNetworking'
  s.dependency 'AtSugar', '~> 0.1'
  s.dependency 'Avenue', '~> 0.2'
  s.dependency 'AvenueFetcher', '~> 0.2'
  s.dependency 'JSONModel', '~> 1.1'
  s.dependency 'PromiseKit', '~> 2.0'
  s.dependency 'UICKeyChainStore'
end
