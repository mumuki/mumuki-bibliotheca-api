module Mumukit::Service
  module Collection

    def all
      project
    end

    def count
      mongo_collection.find.count
    end

    def exists?(id)
      mongo_collection.find(id: id).count > 0
    end

    def delete!(id)
      mongo_collection.delete_one(id: id)
    end

    def find(id)
      find_by(id: id)
    end

    def find_by(args)
      first = mongo_collection.find(args).projection(_id: 0).first

      raise Mumukit::Service::DocumentNotFoundError, "document #{args.to_json} not found" unless first

      wrap first
    end

    def insert!(guide)
      guide.validate!

      with_id new_id do |id|
        mongo_collection.insert_one guide.raw.merge(id)
      end
    end

    private

    def mongo_collection
      mongo_database.client[mongo_collection_name]
    end

    def project(&block)
      raw = mongo_collection.find.projection(_id: 0).map { |it| wrap it }

      raw = raw.select(&block) if block_given?

      wrap_array raw
    end

    def wrap(mongo_document)
      Mumukit::Service::JsonWrapper.new mongo_document
    end

    def wrap_array(array)
      Mumukit::Service::JsonArrayWrapper.new array
    end

    def new_id
      Mumukit::Service::IdGenerator.next
    end

    def with_id(id)
      id_object = {id: id}
      yield id_object
      id_object
    end
  end
end