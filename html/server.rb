require 'sinatra'
require_relative '../lib/skeleton/root'

set :port, ARGV[0]

get '/:file' do
  send_file "#{Base::ROOT_DIR}/html/#{params[:file]}"
end

post '/:file' do
  send_file "#{Base::ROOT_DIR}/html/#{params[:file]}"
end