require File.join(File.dirname(__FILE__),'src/database.rb')
require File.join(File.dirname(__FILE__),'src/controller.rb')
require File.join(File.dirname(__FILE__),'src/servlet.rb')
require File.join(File.dirname(__FILE__),'src/control_servlet.rb')
require File.join(File.dirname(__FILE__),'src/webapp.rb')
require File.join(File.dirname(__FILE__),'src/convert.rb')
#require File.join(File.dirname(__FILE__),'src/toying.rb')

class JWP
  
  def initialize
    Static.connect_to_yml_file("db/database.yml")

    if ARGV[0] == "--import"
      if ARGV[1] != nil
        file = ARGV[1]
        print "importing file '" + file + "'\n"
        ConvertMe.import_jwr(file)
      end
    end

    ctrl = Controller.new

    servers = Hash.new
    ctrl.hosts.values.sort.each do |port|
      servers[port] = WebApp.new(ctrl,port,JWPServlet,false)
    end

    if servers.length == 0
      exit
    end

    port = 2600
    servers[port] = WebApp.new(ctrl,port,ControlServlet,false)

    servers.keys.sort.each do |port|
      servers[port].run
    end

    Thread.list.each {|t| t.join}
  end
end



