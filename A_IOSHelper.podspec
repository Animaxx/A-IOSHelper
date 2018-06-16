Pod::Spec.new do |s|
  s.name         = "A_IOSHelper"
  s.version      = "1.2.0"
  s.summary      = "IOSHelper provides various helping functions included: animation, controls event, task chain, KVO binding, data model, network, and so on."
  s.homepage     = "https://github.com/Animaxx/A-IOSHelper"
  s.license      = "MIT"
  s.authors      = { 'Animax Deng' => 'Animax.deng@gmail.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Animaxx/A-IOSHelper.git", :tag => s.version }
  s.library      = 'sqlite3'
  s.source_files = "A_IOSHelper/**/*.{h,m}"
  s.requires_arc = true
end