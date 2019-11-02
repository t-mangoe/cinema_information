class CreateCinemaShowings < ActiveRecord::Migration[6.0]
  def change
    create_table :cinema_showings do |t|
      t.string :title
      t.date :date
      t.time :start
      t.time :end

      t.timestamps
    end
  end
end
