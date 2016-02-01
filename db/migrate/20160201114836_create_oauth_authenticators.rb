class CreateOauthAuthenticators < ActiveRecord::Migration
  def change
    create_table :oauth_authenticators do |t|
      t.timestamps null: false
    end
  end
end
