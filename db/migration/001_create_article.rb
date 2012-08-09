# encoding: utf-8
require 'sequel'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      String :title, :null=>false
      String :author, :null=>false
    end
  end
end
