class CreateYoutubes < ActiveRecord::Migration[5.2]
  def change
    create_table :youtubes do |t|
      t.string :artist
      t.string :song

      t.timestamps
    end
  end
end
