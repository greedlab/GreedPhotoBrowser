Pod::Spec.new do |s|

  s.name         = "GreedPhotoBrowser"
  s.version      = "0.0.8"
  s.summary      = "a photo browser for iOS"
  s.description  = %{this is a photo browser for iOS }
  s.homepage     = "https://github.com/greedlab/GreedPhotoBrowser"
  s.license      = "MIT"
  s.author       = { "Bell" => "bell@greedlab.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/greedlab/GreedPhotoBrowser.git", :tag => s.version }
  s.source_files  = "GreedPhotoBrowser", "GreedPhotoBrowser/*.{h,m}"
  s.frameworks  = "Foundation","UIKit"
  s.dependency 'SDWebImage', '~> 4.0.0-beta2'
  s.dependency 'Masonry'
  s.requires_arc = true

end
