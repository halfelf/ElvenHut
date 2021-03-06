# encoding: utf-8

require 'sequel'

Sequel.migration do
  transaction
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :article_id
      String :author, :null => false
      String :comment, :null => false, :limit => 4096
      String :email
      String :website, :defalut => ""
      Integer :parent_id
      Integer :children_id
      String :ip
      timestamp :updated_at, :null => false
    end
  end
end
