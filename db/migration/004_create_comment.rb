# encoding:UTF-8
require 'sequel'
require 'mysql2'

Sequel.migration do
  transaction
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :article_id
      String :author, :null => false
      String :comment, :null => false, :limit => 1024
      String :email
      String :website, :defalut => ""
      Integer :parent_id
      Integer :children_id
      Integer :lft
      Integer :rgt
      timestamp :updated_at, :null => false
    end
  end
end
