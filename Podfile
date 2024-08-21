platform :ios, '17.0'
use_frameworks!

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
    end
  end
end

def common_pods
  pod 'RxSwift', '~> 6.2.0'
  pod 'RxCocoa', '~> 6.2.0'
  pod 'RxDataSources', '~> 5.0.0'
  pod 'RxGesture', '~> 4.0.0'

  pod 'BetterSegmentedControl', '~> 2.0'


  pod 'RealmSwift', '~> 10.48.1'

  pod 'SnapKit', '~> 5.7.1'
  pod 'ApphudSDK'
end

target :RingSizer do
  common_pods
end
