require 'sinatra'
require_relative '../lib/skeleton/root'

server_port = ARGV[0]
set :port, server_port

File.open("#{Base::ROOT_DIR}/html/port", 'w+') { |f| f.write(server_port) }

get '/:file' do
  send_file "#{Base::ROOT_DIR}/html/#{params[:file]}"
end

post '/:file' do
  send_file "#{Base::ROOT_DIR}/html/#{params[:file]}"
end