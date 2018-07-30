require 'sinatra'
require_relative '../lib/skeleton/root'

server_port = ARGV[0]
set :port, server_port

File.open("#{Base::ROOT_DIR}/server/port", 'w+') { |f| f.write(server_port) }

get '/' do
  redirect "skeleton"
end

get '/:file' do
  domain = params[:file].split('.').last
  file = domain == params[:file] ? "#{domain}.server" : params[:file]
  send_file "#{Base::ROOT_DIR}/server/#{file}"
end

post '/:file' do
  domain = params[:file].split('.').last
  file = domain == params[:file] ? "#{domain}.server" : params[:file]
  send_file "#{Base::ROOT_DIR}/server/#{file}"
end