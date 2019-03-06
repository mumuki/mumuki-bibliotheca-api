logger = Mumukit::Nuntius::Logger
namespace :bibliotheca do
  namespace :events do
    task listen: :environment do
      logger.info 'Loading event handlers....'
      require_relative '../mumuki/bibliotheca/events/events'
      logger.info "Loaded handlers #{Mumukit::Nuntius::EventConsumer.handled_events}!"

      logger.info 'Listening to events...'
      Mumukit::Nuntius::EventConsumer.start!
    end
  end
end
