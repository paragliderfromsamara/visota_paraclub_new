# Load the Rails application.
require File.expand_path('../application', __FILE__)
Time::DATE_FORMATS[:ru_datetime] = "%d.%m.%Y в %k:%M:%S"

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.delivery_method = :smtp

ActionMailer::Base.smtp_settings = {
  :address              => "smtp.yandex.ru",
  :port                 => 465,
  :domain               => 'visota63.ru',
  :user_name            => 'noreply@visota63.ru',
  :password             => 'koz13onin',
  :authentication       => 'plain',
  :enable_starttls_auto => true  }