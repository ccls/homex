#	From `script/generate simply_authorized` ...
unless Gem.source_index.find_name('ccls-simply_authorized').empty?
gem 'ccls-simply_authorized'
require 'simply_authorized/test_tasks'
end
