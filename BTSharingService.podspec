Pod::Spec.new do |s|
  s.name         = "BTSharingService"
  s.version      = "1.0.0"
  s.summary      = "Nice and simple sharing service."
  s.homepage     = "https://github.com/borut-t/BTSharingService"
  s.screenshots  = "https://raw.github.com/borut-t/BTButton/master/Screenshots/preview.png"
  s.license      = { :type => 'zlib', :file => 'LICENCE.md' }
  s.author       = { "Borut Tomažin" => "borut.tomazin@gmail.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/borut-t/BTSharingService.git", :tag => "1.0.0" }
  s.source_files = 'BTSharingService', 'Facebook'
  s.frameworks   = 'UIKit', 'Foundation', 'CoreGraphics'
  s.requires_arc = true
end
 
