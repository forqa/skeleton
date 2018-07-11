require 'sinatra'

get '/:file' do
  send_file params[:file]
end

post '/:file' do
  send_file params[:file]
end