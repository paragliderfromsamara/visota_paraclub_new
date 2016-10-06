# Be sure to restart your server when you modify this file.

# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf

$redis_onlines = Redis.new path: "/tmp/redis.sock", db: 15, driver: :hiredis
$redis_views = Redis.new path: "/tmp/redis.sock", db: 15, driver: :hiredis