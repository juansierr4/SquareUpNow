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
  pod 'Permission-AppTrackingTransparency', :path => "#{permissions_path}/AppTrackingTransparency.podspec"
  pod 'Permission-BluetoothPeripheral', :path => "#{permissions_path}/BluetoothPeripheral.podspec"
  pod 'Permission-Calendars', :path => "#{permissions_path}/Calendars.podspec"
  pod 'Permission-Camera', :path => "#{permissions_path}/Camera.podspec"
  pod 'Permission-Contacts', :path => "#{permissions_path}/Contacts.podspec"
  pod 'Permission-FaceID', :path => "#{permissions_path}/FaceID.podspec"
  pod 'Permission-LocationAlways', :path => "#{permissions_path}/LocationAlways.podspec"
  pod 'Permission-LocationWhenInUse', :path => "#{permissions_path}/LocationWhenInUse.podspec"
  pod 'Permission-MediaLibrary', :path => "#{permissions_path}/MediaLibrary.podspec"
  pod 'Permission-Microphone', :path => "#{permissions_path}/Microphone.podspec"
  pod 'Permission-Motion', :path => "#{permissions_path}/Motion.podspec"
  pod 'Permission-Notifications', :path => "#{permissions_path}/Notifications.podspec"
  pod 'Permission-PhotoLibrary', :path => "#{permissions_path}/PhotoLibrary.podspec"
  pod 'Permission-Reminders', :path => "#{permissions_path}/Reminders.podspec"
  pod 'Permission-Siri', :path => "#{permissions_path}/Siri.podspec"
  pod 'Permission-SpeechRecognition', :path => "#{permissions_path}/SpeechRecognition.podspec"
  pod 'Permission-StoreKit', :path => "#{permissions_path}/StoreKit.podspec"


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
