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

# for i in `find _site/ -type f -not -iregex '.*\.gz$'`; do gzip -c $i > $i.gz; done
class MyTryStatic
  def initialize(app, options)
    @app = app
    @try = ['', *options.delete(:try)]
    @options = options
    @static = ::Rack::Static.new(
      lambda { [404, {}, []] }, 
      options)
  end

  def call(env)
    orig_path = env['PATH_INFO']
    found = nil
    full_path = nil
    @try.each do |path|
      full_path = orig_path + path
      resp = @static.call(env.merge!({'PATH_INFO' => full_path}))
      break if 404 != resp[0] && found = resp
    end
    if found && File.exists?(@options[:root] + '/' + full_path + '.gz') 
      gz = @static.call(env.merge!({'PATH_INFO' => full_path + '.gz'}))
      if 404 != gz[0]
        puts 'gz found - ' + full_path
        headers = found[1]
        headers['Content-Encoding'] = 'gzip'
        headers['Content-Length'] = gz[1]['Content-Length']
        headers['Vary'] = 'Accept-Encoding'
        return [found[0], headers, gz[2]]
      end
    end
    found or @app.call(env.merge!('PATH_INFO' => orig_path))
  end
end


#use Rack::Deflater
use Rack::ConditionalGet
#use Rack::ETag # this is broken
use MyHeaders
use MyTryStatic, :root => "_site", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']
#use Rack::TryStatic, :root => "_site", :urls => %w[/], :try => ['.html', 'index.html', '/index.html']


run lambda { [404, {'Content-Type' => 'text/html'}, ['Not Found']]}
