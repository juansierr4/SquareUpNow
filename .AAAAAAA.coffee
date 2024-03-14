source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.4'

use_frameworks! :linkage => :static

require File.join(File.dirname(`node --print "require.resolve('expo/package.json')"`), "scripts/autolinking")
require File.join(File.dirname(`node --print "require.resolve('react-native/package.json')"`), "scripts/react_native_pods")
require File.join(File.dirname(`node --print "require.resolve('@react-native-community/cli-platform-ios/package.json')"`), "native_modules")

target 'FriendlyFades' do
  use_expo_modules!
  config = use_native_modules!

  pre_install do |installer|
    Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies){}

  installer.pod_targets.each do |pod|
    if pod.name.eql?('RNPermissions') || pod.name.start_with?('Permission-')
      def pod.build_type;
        Pod::BuildType.static_library
      end
    end
  end
end



  # Firebase Pods
  pod 'Firebase/CoreOnly', '10.22.0'
  pod 'FirebaseAuth', '10.22.0'
  pod 'FirebaseFirestore', '10.22.0'
  pod 'FirebaseMessaging', '10.22.0'
  pod 'FirebaseStorage', '10.22.0'
  # No need to specify modular_headers for individual pods now

  # React Native and Expo autolinking
  use_react_native!(
    :path => config[:reactNativePath],
    :hermes_enabled => false, # Modify as needed for Hermes
    :fabric_enabled => flags[:fabric_enabled],
  )

  permissions_path = '../node_modules/react-native-permissions/ios'
  pod 'Permission-LocationAccuracy', :path => "#{permissions_path}/LocationAccuracy"
  pod 'Permission-LocationWhenInUse', :path => "#{permissions_path}/LocationWhenInUse"


  post_install do |installer|
    react_native_post_install(installer)
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        #config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
