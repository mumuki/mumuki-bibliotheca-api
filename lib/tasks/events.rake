namespace :events do
  task :listen do
    Mumukit::Nuntius::EventConsumer.start 'bibliotheca'
  end
end
