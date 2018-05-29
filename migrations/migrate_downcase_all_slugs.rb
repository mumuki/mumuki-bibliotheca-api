def do_migrate!
  Bibliotheca::Collection::Guides.migrate! do |guide|
    puts "migrating #{guide.name}..."

    guide.slug = guide.slug.downcase
  end

  Bibliotheca::Collection::Topics.migrate! do |topic|
    puts "migrating #{topic.name}..."

    topic.slug = topic.slug.downcase

    topic.lessons = topic.lessons.map { |lesson| lesson.downcase }
  end

  Bibliotheca::Collection::Books.migrate! do |book|
    puts "migrating #{book.name}..."

    book.slug = book.slug.downcase

    book.chapters = book.chapters.map { |chapter| chapter.downcase }

    book.complements = book.complements&.map { |complement| complement.downcase }
  end
end


