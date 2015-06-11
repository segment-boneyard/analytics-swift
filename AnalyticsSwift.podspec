Pod::Spec.new do |spec|
  spec.name             = 'AnalyticsSwift'
  spec.version          = '0.1.0'

  spec.license          =  { :type => 'MIT' }

  spec.homepage         = 'https://github.com/segmentio/analytics-swift'
  spec.authors          = { 'Segment' => 'friends@segment.com' }
  spec.summary          = 'The hassle-free way to add analytics to your Swift app.'

  spec.source           =  { :git => 'https://github.com/segmentio/analytics-swift.git', :tag => spec.version }

  spec.source_files     = 'AnalyticsSwift/*.swift'

  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.requires_arc     = true
end