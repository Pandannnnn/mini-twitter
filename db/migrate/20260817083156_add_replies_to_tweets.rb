class AddRepliesToTweets < ActiveRecord::Migration[8.1]
  def change
    add_reference :tweets,
                  :parent,
                  null: true,
                  foreign_key: { to_table: :tweets},
                  index: true
  end
end
