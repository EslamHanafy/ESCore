# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'ESCore' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ESCore
    pod 'IQKeyboardManagerSwift'
    pod 'IBAnimatable'
    pod 'Alamofire'
    pod 'NVActivityIndicatorView'
    pod 'SDWebImage'
    pod 'SwiftDate'
    pod "ImageSlideshow/SDWebImage"
    pod 'FontBlaster'
    pod "TTGSnackbar"
    pod 'SwiftyJSON'
    pod 'Connectivity'
    pod 'SkyFloatingLabelTextField'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxRelay'
    pod 'RxDataSources'
    pod 'RxSwiftExt'
    pod 'SwiftyGif'
    pod "FlagPhoneNumber"
    pod 'NSObject+Rx'
    pod "InitialsImageView"
    

  target 'ESCoreTests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
    end
  end
end
