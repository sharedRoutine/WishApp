# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WishApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'RealmSwift'
  pod 'FLEX', '~> 2.0', :configurations => ['Debug']
  pod 'SDWebImage', '~> 4.0'
  pod "SUBLicenseViewController"
 
  post_install do | installer |
	require 'fileutils'
	FileUtils.cp_r('Pods/Target Support Files/Pods-WishApp/Pods-WishApp-acknowledgements.plist', 'WishApp/Acknowledgements.plist', 
:remove_destination => true)
end

  target 'ImportExtension' do
    inherit! :search_paths
  end
  
end
