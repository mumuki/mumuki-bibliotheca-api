module Bibliotheca
  class Topic < Bibliotheca::SchemaDocument
    def schema
      Bibliotheca::Schema::Topic
    end

    def errors
      [
        ('Name must be present' unless name.present?),
        ('Locale must be present' unless locale.present?),
        ('Description must be present' unless description.present?)
      ].compact
    end

    def fork_to!(organization, bot)
      rebased_copy(organization).tap do |it|
        (lessons || []).map! do |lesson|
          Bibliotheca::Collection::Guides.find_by!(slug: lesson).fork_to!(organization, bot).slug
        end

        Bibliotheca::Collection::Topics.insert! it
      end

    end
  end
end
