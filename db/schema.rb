# This file contains the schema for the database.
# Under most circumstances, you shouldn't need to run this file directly.
require 'sequel'

module Schema
  Sequel.sqlite(ENV['DB_PATH']) do |db|
    db.create_table?(:pastas) do
      primary_key :id
      String :trigger, :size=>255
      String :text, :size=>255
    end
  end
end