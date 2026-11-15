# Lets browsers cache fingerprinted assets for a year without revalidating.
#
# config.public_file_server.headers would apply to everything in public/, including
# files whose names never change (favicons, /fonts, robots.txt), so this only touches
# the digest-stamped files under /assets.
class AssetCacheControl
  CACHE_CONTROL = "public, max-age=#{1.year.to_i}, immutable".freeze

  def initialize(app, prefix)
    @app = app
    @prefix = "#{prefix}/"
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['cache-control'] = CACHE_CONTROL if status == 200 && env['PATH_INFO'].start_with?(@prefix)
    [status, headers, body]
  end
end

unless Rails.application.config.assets.compile
  Rails.application.config.middleware.insert_before 0, AssetCacheControl, Rails.application.config.assets.prefix
end
