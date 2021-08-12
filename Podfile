platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

workspace 'Zoo.xcworkspace'

source 'https://cdn.cocoapods.org/'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        
        target.build_configurations.each do |config|

            if config.name == 'Debug'
                config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-Onone']
                config.build_settings['SWIFT_COMPILATION_MODE'] = 'wholemodule'
            end

            # Align the development target in pod targets
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end

def promiseKit
    pod 'PromiseKit'
end

target 'Zoo' do
    project 'Zoo.xcodeproj'

    promiseKit
    pod 'Kingfisher'
    pod 'JGProgressHUD'
    
    target 'ZooTests'
end

target 'WebAPI' do
    project 'WebAPI/WebAPI.xcodeproj'
    promiseKit
    target 'WebAPITests'
end
