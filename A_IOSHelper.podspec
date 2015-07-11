Pod::Spec.new do |s|
  s.name         = "A_IOSHelper"
  s.version      = "0.9.3"
  s.summary      = "IOSHelper provides various helping functions included: animation, controls event, task chain, KVO binding, data model, network, and so on."
  s.homepage     = "http://animaxx.github.io/A-IOSHelper/"
  s.license      = "MIT"
  s.authors      = { 'Animax Deng' => 'Animax.deng@gmail.com'}
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Animaxx/A-IOSHelper.git", :tag => s.version }
  s.library      = 'sqlite3'
  s.source_files = "A_IOSHelper/**/*"
  s.requires_arc = true
end