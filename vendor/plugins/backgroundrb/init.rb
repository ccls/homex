# Include hook code here
%w{ controller }.each do |code_dir|
  $:.unshift File.join(directory,"app",code_dir)
end

config.gem 'packet'
#	allow required gems to be loaded via rake gems:install
config.after_initialize do
require 'backgroundrb'
#require "backgroundrb_status_controller"
end
