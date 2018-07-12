require 'sinatra'

set :port, ARGV[0]

get '/:file' do
  send_file params[:file]
end

post '/:file' do
  send_file params[:file]
end