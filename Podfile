# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'WishApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
 
  pod 'SDWebImage', '~> 4.0'
  pod 'SwiftyUserDefaults', '4.0.0-alpha.1'
  pod 'MBProgressHUD', '~> 1.1.0'

  target 'ImportExtension' do
	inherit! :search_paths
  end

  target 'WishAppUITests' do
    pod 'SimulatorStatusMagic', :configurations => ['Debug']
  end
  
end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-WishApp/Pods-WishApp-acknowledgements.plist', 'WishApp/Acknowledgements.plist', :remove_destination => true)
end
