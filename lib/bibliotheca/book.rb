module Bibliotheca
  class Book < Bibliotheca::SchemaDocument
    def schema
      Bibliotheca::Schema::Book
    end

    def errors
      [
        ("Name must be present" unless name.present?),
        ("Locale must be present" unless locale.present?),
        ("Description must be present" unless description.present?)
      ].compact
    end

    def fork_to!(organization, bot)
      rebased_copy(organization).tap do |it|
        (chapters || []).map! do |chapter|
          Bibliotheca::Collection::Topics.find_by!(slug: chapter).fork_to!(organization, bot).slug
        end

        (complements || []).each do |complement|
          Bibliotheca::Collection::Topics.find_by!(slug: complement).fork_to!(organization, bot).slug
        end

        Bibliotheca::Collection::Books.insert! it
        Mumukit::Nuntius.notify_content_change_event! Bibliotheca::Book, it
      end
    end
  end
end
