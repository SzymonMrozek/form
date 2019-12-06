# Uncomment this line to define a global platform for your project
platform :ios, "10"
source 'https://cdn.cocoapods.org/'

# Disable sending stats
ENV['COCOAPODS_DISABLE_STATS'] = 'true'

inhibit_all_warnings!
use_frameworks!

install! 'cocoapods', :integrate_targets => false

def tools
  pod 'Sourcery'
end

target :FormApproaching do
  tools
end
