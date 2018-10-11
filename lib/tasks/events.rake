logger = Mumuki::Bibliotheca::Nuntius.logger
namespace :events do
  task :listen do
    logger.info 'Loading event handlers....'
    require_relative '../events'
    logger.info "Loaded handlers #{Mumuki::Bibliotheca::Nuntius.event_consumer.handled_events}!"

    logger.info 'Listening to events...'
    Mumuki::Bibliotheca::Nuntius.event_consumer.start!
  end
end
