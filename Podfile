# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'TOFileKitExample' do

  # UI
  pod 'TODocumentPickerViewController'
  pod 'TORoundedButton'
  pod 'TORoundedTableView'

  # Networking
  pod 'GoldRaccoon', :git => 'https://github.com/iComics/GoldRaccoon.git'
  pod 'NMSSH'
  pod 'TOReachability'
  pod 'TOSMBClient'

  # Data Management
  pod 'Realm'
  pod 'Mantle'
  pod '1PasswordExtension'

  # Development
  pod 'Reveal-SDK', :configurations => ['Debug']

  target "TOFileKitTests" do
    inherit! :search_paths

  end

end

post_install do |installer|

  puts 'Determining pod project minimal deployment target'

  pods_project = installer.pods_project
  deployment_target_key = 'IPHONEOS_DEPLOYMENT_TARGET'
  deployment_targets = pods_project.build_configurations.map{ |config| config.build_settings[deployment_target_key] }
  minimal_deployment_target = deployment_targets.min_by{ |version| Gem::Version.new(version) }

  puts 'Minimal deployment target is ' + minimal_deployment_target
  puts 'Setting each pod deployment target to ' + minimal_deployment_target
  
  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
          config.build_settings[deployment_target_key] = minimal_deployment_target
      end
  end

  # Disable Code Coverage for Pods projects
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
        config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = 'NO'
    end
  end
end

