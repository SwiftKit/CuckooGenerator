require 'aruba/cucumber'
%x'rm -rf ../Build/log'
%x'mkdir ../Build/log'

After do |scenario|
	%x'cp -R ../Build/tmp ../Build/log/"#{scenario.name}"'
end