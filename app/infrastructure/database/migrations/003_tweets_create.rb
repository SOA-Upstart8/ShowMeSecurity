# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:tweets) do
      primary_key :id
      foreign_key :cve_id, :cves
      String      :content
      Integer     :reply_count
      Integer     :favorite_count
      Integer     :retweet_count
      DateTime    :time
      Integer     :owner_id
      String      :owner_image
      String      :owner_name
      String      :owner_page

      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
