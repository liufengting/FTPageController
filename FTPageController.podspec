
Pod::Spec.new do |s|

  s.name         = "FTPageController"
  s.version      = "0.0.8"
  s.summary      = "FTPageController makes UIPageViewController much easier to use."
  s.description  = <<-DESC
    FTPageController makes UIPageViewController much easier to use. It is just a resource for my future projects. Feel welcome to use anyway.
                   DESC
  s.homepage     = "https://github.com/liufengting"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.platform     = :ios, "8.0"
  s.author       = { "liufengting" => "wo157121900@me.com" }
  s.source       = { :git => "https://github.com/liufengting/FTPageController.git", :tag => "#{s.version}" }
  s.source_files  = "FTPageController", "FTPageController/**/*.{h,m,xib,swift}"
  s.swift_version = '5.0'

end
