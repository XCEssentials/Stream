Pod::Spec.new do |s|

  s.name                      = 'XCEStream'
  s.summary                   = 'Stream of values.'
  s.version                   = '0.1.0'
  s.homepage                  = 'https://XCEssentials.github.io/Stream'

  s.source                    = { :git => 'https://github.com/XCEssentials/Stream.git', :tag => s.version }

  s.requires_arc              = true

  s.license                   = { :type => 'MIT', :file => 'LICENSE' }
  s.author                    = { 'Maxim Khatskevich' => 'maxim@khatskevi.ch' }

  s.ios.deployment_target     = '9.0'

  s.source_files              = 'Sources/**/*.swift'

end