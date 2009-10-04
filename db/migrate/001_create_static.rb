
class CreateStatic < ActiveRecord::Migration

  def self.up
    create_table :statics do |t|
      t.text    :host
      t.text    :path
      t.binary  :contents
      t.text    :request_header
      t.text    :response_header
    end
  end

  def self.down
    drop_table :statics
  end
  
end
