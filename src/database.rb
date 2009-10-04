require 'rubygems'
require 'uri'
require 'activerecord'

class Request < ActiveRecord::Base
  def self.make_connection(file)
    establish_connection(:adapter => "sqlite3", :database => file)
  end
end

class Static < ActiveRecord::Base
  def self.connect_to_yml_file(path)
    db_yml = File.join(File.dirname(__FILE__),File.join('..',path))
    yml = YAML::load(File.open(db_yml))
    establish_connection(yml)
  end
end

class Dynamic < ActiveRecord::Base
  def self.make_connection(file)
    establish_connection(:adapter => "sqlite3", :database => file)
  end
end

class Testcase < ActiveRecord::Base
  def self.make_connection(file)
    establish_connection(:adapter => "sqlite3", :database => file)
  end
end
