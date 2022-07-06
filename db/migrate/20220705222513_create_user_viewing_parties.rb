# frozen_string_literal: true

class CreateUserViewingParties < ActiveRecord::Migration[5.2]
  def change
    create_table :user_viewing_parties do |t|
      t.references :user, foreign_key: true
      t.references :viewing_party, foreign_key: true
      t.boolean :hosting
    end
  end
end
