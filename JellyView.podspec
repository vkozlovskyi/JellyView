Pod::Spec.new do |s|
  s.name         = 'JellyView'
  s.version      = '1.0.2'
  s.summary      = 'Simple pull-to-refresh pattern with spring animation'
  s.homepage     = 'https://github.com/vkozlovskyi/JellyView'
  s.license      = 'MIT'
  s.author = { 'Vladimir Kozlovskyi' => 'vlad.kozlovskyi@gmail.com' }
  s.ios.deployment_target = '10.0'
  s.source = { :git => 'https://github.com/vkozlovskyi/JellyView.git', :tag => s.version.to_s }
  s.source_files  = 'JellyView-Example/JellyView/**/*'
  s.swift_version = '4.0'
end
