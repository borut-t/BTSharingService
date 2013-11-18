Pod::Spec.new do |s|
  s.name         = "BTSharingService"
  s.version      = "1.1"
  s.summary      = "Nice and simple sharing service."
  s.homepage     = "https://github.com/borut-t/BTSharingService"
  s.license      = { :type => 'zlib', :file => 'LICENCE.md' }
  s.author       = { "Borut Tomažin" => "borut.tomazin@icloud.com" }
  s.platform     = :ios, '5.0'
  s.source       = { :git => "https://github.com/borut-t/BTSharingService.git", :tag => "1.1" }
  s.source_files = 'BTSharingService', 'Facebook'
  s.frameworks   = 'Twitter', 'MessageUI', 'Social'
  s.requires_arc = true
end
 
