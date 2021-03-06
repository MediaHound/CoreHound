Pod::Spec.new do |s|
  s.name             = "CoreHound"
  s.version          = "0.3.1"
  s.summary          = "The MediaHound iOS SDK"
  s.homepage         = "https://github.com/MediaHound/CoreHound"
  s.license          = 'Apache'
  s.author           = "MediaHound"
  s.social_media_url = 'https://twitter.com/mediahound'
  s.source           = { :git => "https://github.com/MediaHound/CoreHound.git", :tag => s.version.to_s }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/**/*.{h,m}'
  s.private_header_files = "Pod/Model/Internal/**/*.h", "Pod/**/*+Internal.h", "Pod/Network/Internal/**/*.h"

  s.dependency 'AFNetworking', '~> 2.6'
  s.dependency 'AtSugar', '~> 0.1'
  s.dependency 'Avenue', '~> 0.4'
  s.dependency 'AvenueFetcher', '~> 0.4'
  s.dependency 'JSONModel', '~> 1.1.2'
  s.dependency 'PromiseKit/CorePromise', '~> 3.0'
  s.dependency 'UICKeyChainStore', '~> 2.0'
end
