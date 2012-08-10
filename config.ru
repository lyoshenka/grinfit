require 'rubygems'
require 'bundler'
Bundler.require

#use Rack::EY::Solo::DomainRedirect


class MyHeaders
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    headers['Connection'] = 'keep-alive'
    if headers.has_key?('Content-Type') and headers['Content-Type'] == 'text/html'
      headers['Content-Type'] = 'text/html; charset=utf-8'
    end
#    puts headers
    return [status, headers, body]
  end
end


use Rack::Deflater
use Rack::ConditionalGet
#use Rack::ETag # this is broken

use MyHeaders

use Rack::TryStatic,
    :root => "_site",
    :urls => %w[/],
    :try => ['.html', 'index.html', '/index.html']

#use Rack::Static,
#    :root => "public",
#    :urls => %w[/]

run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
