
class CreateDefault < ActiveRecord::Migration

  def self.up
    create_table :defaults do |t|
      t.text    :host
      t.text    :path
      t.integer :id
    end
  end

  def self.down
    drop_table :defaults
  end
  
end
