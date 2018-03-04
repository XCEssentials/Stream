Pod::Spec.new do |s|

  s.name                      = 'XCEStream'
  s.summary                   = 'Stream of values.'
  s.version                   = '0.1.0'
  s.homepage                  = 'https://XCEssentials.github.io/Stream'

  s.source                    = { :git => 'https://github.com/XCEssentials/Stream.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  # === iOS

  s.ios.deployment_target     = '9.0'

  s.ios.source_files          = 'Sources/Stream/**/*.swift'

  # s.framework                 = 'UIKit'

  s.ios.dependency              'XCEViewEvents', '~> 1.1.0'

end