namespace :db do
  task :migrate, [:migration_name] do |_t, args|
    require_relative "../../migrations/migrate_#{args[:migration_name]}"
    do_migrate!
  end
end
