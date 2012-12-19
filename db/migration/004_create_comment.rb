# encoding:UTF-8
require 'sequel'
require 'mysql2'

Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :article_id
      String :comment, :null => false, :limit => 1024
      String :email, :null => false
      String :website, :defalut => ""
      Integer :parent_id
      Integer :lft
      Integer :rgt
      timestamp :updated_at, :null => false
    end
  end
end
