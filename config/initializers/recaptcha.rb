# config/initializers/recaptcha.rb
Recaptcha.configure do |config|
  config.site_key  = '6LfBtxIUAAAAAJYHDU2-iryCJc85iU4qQ39YkVYi'
  config.secret_key = '6LfBtxIUAAAAAHyJn6rLKShkhoX0bKNud7IOv72g'
  # Uncomment the following line if you are using a proxy server:
  # config.proxy = 'http://myproxy.com.au:8080'
end
