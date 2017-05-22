threads_count = Integer(ENV['MUMUKI_BIBLIOTHECA_API_THREADS'] || 2)

threads threads_count, threads_count

rackup      DefaultRackup
port        ENV['MUMUKI_BIBLIOTHECA_API_PORT'] || 3004
environment ENV['RACK_ENV']                    || 'development'