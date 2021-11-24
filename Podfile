# Uncomment the next line to define a global platform for your project
# platform :ios, '12.0'

target 'KocYKS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for KocYKS
	pod 'FoldingCell'
	pod 'AnimatedTabBar'
	pod 'SwiftEntryKit'
	pod 'UIFontComplete'
	pod 'NVActivityIndicatorView'
	pod 'SwiftSoup'
	pod 'DTTextField'
	pod 'LTMorphingLabel'
	pod "SearchTextField"
	pod 'Spring', :git => 'https://github.com/MussaCharles/Spring.git'
	pod 'Datez'
	pod 'CountdownLabel'
	pod "FSInteractiveMap"

	pod 'Blueprints'
	pod 'GravitySliderFlowLayout'
	pod 'CarLensCollectionViewLayout'
	pod 'Firebase/Database'
	pod 'Firebase'
	pod 'Firebase/Auth'
	pod 'Firebase/Storage'
	pod 'Firebase/Firestore'
	pod 'FirebaseFirestoreSwift'

end
platform :ios, '12.0'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end