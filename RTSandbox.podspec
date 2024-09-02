#
#  Be sure to run `pod spec lint RTSandbox.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "RTSandbox"
  spec.version      = "1.0.0"
  spec.summary      = "A simple sandbox tool"
  spec.description  = "sandbox is a simple utility class for sandbox"

  spec.homepage     = "https://www.baidu.com/"
  spec.license      = "MIT"

  spec.author             = { "a892780582" => "892780582@qq.com" }

  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/a892780582/RTSandbox.git", :tag => "1.0.0" }

  spec.source_files  = "source/*.swift"
  spec.resources = "source/RTSanboxBundle.bundle"
  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
