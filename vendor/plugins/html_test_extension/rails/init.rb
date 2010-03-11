require 'html_test'
require 'html_test_extension'

#	Assertions is a Module not a class, so I'm not sure how this'll go
Html::Test::Assertions.send(:include, HtmlTestExtension::Assertions)
Html::Test::Validator.send(:include, HtmlTestExtension::Validator)
Html::Test::ValidateFilter.send(:include, HtmlTestExtension::ValidateFilter)
