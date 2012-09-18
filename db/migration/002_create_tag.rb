# encoding: utf-8
require 'sequel'
require 'mysql2'

Sequel.migration do
  change do
    create_table(:tags) do
      primary_key :id
      String :name,         :null=>false, :unique=>true
      Integer :quantity
    end
  end
end
