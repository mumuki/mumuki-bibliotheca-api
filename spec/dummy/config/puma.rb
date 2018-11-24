workers Integer(ENV['MUMUKI_BIBLIOTHECA_WORKERS'] || 2)
threads_count = Integer(ENV['MUMUKI_BIBLIOTHECA_THREADS'] || 1)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['MUMUKI_BIBLIOTHECA_PORT']      || 3004
environment ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
  Mumukit::Nuntius.establish_connection
end
