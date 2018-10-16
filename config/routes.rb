Rails.application.routes.draw do
  mount Sinatra::Application.new => '/'
end
