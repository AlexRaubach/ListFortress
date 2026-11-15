require 'test_helper'

class ResponseHeadersTest < ActionDispatch::IntegrationTest
  test 'responses are gzipped for clients that accept it' do
    get api_v1_tournaments_url, headers: { 'Accept-Encoding' => 'gzip' }

    assert_response :success
    assert_equal 'gzip', response.headers['content-encoding']
    json = ActiveSupport::Gzip.decompress(response.body)
    assert_kind_of Array, JSON.parse(json)
  end

  test 'responses are left alone for clients that do not accept gzip' do
    get api_v1_tournaments_url

    assert_nil response.headers['content-encoding']
  end

  test 'fingerprinted assets get a far-future cache header and other paths do not' do
    app = ->(env) { [env['PATH_INFO'].include?('missing') ? 404 : 200, {}, []] }
    middleware = AssetCacheControl.new(app, '/assets')

    _, asset_headers, = middleware.call('PATH_INFO' => '/assets/application-abc123.css')
    _, favicon_headers, = middleware.call('PATH_INFO' => '/favicon.ico')
    _, missing_headers, = middleware.call('PATH_INFO' => '/assets/missing.css')

    assert_match(/max-age=31\d{6}, immutable/, asset_headers['cache-control'])
    assert_nil favicon_headers['cache-control']
    assert_nil missing_headers['cache-control']
  end
end
