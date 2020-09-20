# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'GetStars' do

  use_frameworks!

  # Ignora los warnings
  inhibit_all_warnings!

  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'GoogleSignIn'
  
  pod 'Firebase/Messaging'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'

  pod 'Firebase/Storage'
  pod 'SDWebImageSwiftUI'

  pod 'CameraManager', '~> 5.1'

  # Elimina todos los targets
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end

end
