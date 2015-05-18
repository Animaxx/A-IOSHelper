Pod::Spec.new do |s|
  s.name         = "A_IOSHelper"
  s.version      = "0.9.1"
  s.summary      = "A_IOSHelper provides rapid and easy way to handle basic functions included: controls event, task chain, KVO binding, Data Model, JSON, Sqlite, Networking, Animation, and so on. "
  s.homepage     = "http://animaxx.github.io/A-IOSHelper/"
  s.license      = "MIT"
  s.authors      = { 'Animax' => 'Animax.deng@gmail.com'}
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Animaxx/A-IOSHelper", :tag => s.version }
  s.source_files = "A_IOSHelper/**/*.{h,m}"
  s.requires_arc = true
end