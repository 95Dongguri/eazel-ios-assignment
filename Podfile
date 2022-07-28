# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'eazel-ios-assignment' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'Firebase/Auth'
  pod 'Firebase/Database'
  pod 'GoogleSignIn', '5.0.2'
  # Pods for eazel-ios-assignment

  target 'eazel-ios-assignmentTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'eazel-ios-assignmentUITests' do
    # Pods for testing
  end

end

 post_install do |pi|
     pi.pods_project.targets.each do |t|
         t.build_configurations.each do |bc|
            bc.build_settings['ARCHS[sdk=iphonesimulator*]'] =  `uname -m`
         end
     end
  end
