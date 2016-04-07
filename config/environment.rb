# Load the Rails application.
require File.expand_path('../application', __FILE__)
Time::DATE_FORMATS[:ru_datetime] = "%d.%m.%Y в %k:%M:%S"

# Initialize the Rails application.
Rails.application.initialize!
