module Bibliotheca::Collection::WithSlug
  def allowed(permissions)
    project { |it| permissions&.writer?(it.slug) }
  end

  def visible(permissions)
    project { |it| !it.private || permissions&.writer?(it.slug) }
  end

  def find_by_slug!(slug)
    find_by!(slug: slug)
  end

  def upsert_by_slug!(slug, document)
    document.consistent_slug! slug
    upsert_by! :slug, document
  end
  alias upsert_by_slug upsert_by_slug!
end
