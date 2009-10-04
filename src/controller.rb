require File.join(File.dirname(__FILE__),'database.rb')

class Controller
  
  attr_accessor :hosts
  
  def initialize
    @hosts = Hash.new
    Static.find(:all).each do |s|
      if @hosts[s.host] == nil
        @hosts[s.host] = Hash.new
      end
      @hosts[s.host][s.path] = s.id
    end
    s = Static.find(1)
    print "goto: http://localhost:3000/" + s.host + "/" + s.path + "\n"
  end
  
  
end
