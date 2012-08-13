# encoding: utf-8
require 'sequel'
require 'mysql2'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      String :title,         :null=>false
      String :author,        :null=>false
      timestamp :created_at, :null=>false
      timestamp :update_at,  :null=>false
    end
  end
end
