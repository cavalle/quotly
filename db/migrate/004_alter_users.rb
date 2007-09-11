class AlterUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :nickname,        :login
    rename_column :users, :hashed_password, :crypted_password
    
    change_column :users, :crypted_password,          :string, :limit => 40
    add_column    :users, :salt,                      :string, :limit => 40
    add_column    :users, :remember_token,            :string
    add_column    :users, :remember_token_expires_at, :datetime
    
    add_column    :users, :activation_code,           :string, :limit => 40
    add_column    :users, :activated_at,              :datetime
    
    User.find(:all).each{ |user| user.activate }
  end

  def self.down
    rename_column :users, :login,             :nickname
    rename_column :users, :crypted_password,  :hashed_password
    
    change_column :users, :hashed_password,   :string
    
    remove_column :users, :salt
    remove_column :users, :remember_token
    remove_column :users, :remember_token_expires_at    
    remove_column :users, :activation_code
    remove_column :users, :activated_at
  end
end
