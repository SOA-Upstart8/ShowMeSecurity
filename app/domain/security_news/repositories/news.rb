# frozen_string_literal: true

module SMS
  module Repository
    # Repository to News Entity
    class News
      def self.all
        Database::NewsOrm.all.map { |news| rebuild_entity(news) }
      end

      def self.find_id(id)
        rebuild_entity Database::NewsOrm.first(id: id)
      end

      def self.find_title(title)
        db_news = Database::NewsOrm
          .where(Sequel.like(:title, "%#{title}%"))
          .all
        rebuild_entity db_news
      end

      def self.find_source(source)
        db_news = Database::NewsOrm
          .where(Sequel.like(:source, "%#{source}%"))
          .all
        rebuild_entity db_news
      end

      def self.find(entity)
        find_id(entity.id)
      end

      def self.create(entity)
        Database::NewsOrm.find_or_create(entity.to_attr_hash)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::News.new(
          id: db_record.id,
          source: db_record.source,
          title: db_record.title,
          url: db_record.url,
          image: db_record.image,
          time: db_record.time,
          content: db_record.content
        )
      end

      private_class_method :rebuild_entity
    end
  end
end
