require File.join(File.dirname(__FILE__),'src/database.rb')
require File.join(File.dirname(__FILE__),'src/controller.rb')
require File.join(File.dirname(__FILE__),'src/servlet.rb')
require File.join(File.dirname(__FILE__),'src/control_servlet.rb')
require File.join(File.dirname(__FILE__),'src/webapp.rb')
require File.join(File.dirname(__FILE__),'src/convert.rb')
require File.join(File.dirname(__FILE__),'src/host.rb')
require File.join(File.dirname(__FILE__),'src/shoes_helpers.rb')

class JWP
  
  attr_accessor :hosts, :started, :control_app_port, :port
  
  def initialize(port = 3000)
    @hosts = Hash.new
    @started = false
    @port = port
    @control_app_port = 0
  end
  
  def run
    Static.connect_to_yml_file("db/database.yml")
    
    ctrl = Controller.new(@port,@hosts)

    servers = Hash.new
    ctrl.hosts.each do |hostname,port|
      @hosts[port] = Host.new(hostname,port,@port)
      servers[port] = WebApp.new(ctrl,port,JWPServlet,false)
    end

    if servers.length == 0
      exit
    end

    @control_app_port = ctrl.hosts.values.max + 1
    servers[@control_app_port] = WebApp.new(ctrl,@control_app_port,ControlServlet,false)
    ctrl.control_app_port = @control_app_port

    servers.keys.sort.each do |port|
      servers[port].run
    end
    
    @started = true
    
    Thread.list.each {|t| t.join}
  end

  def import
    if ARGV[0] == "--import"
      if ARGV[1] != nil
        file = ARGV[1]
        print "importing file '" + file + "'\n"
        ConvertMe.import_jwr(file)
      end
    end
  end

end



class Fun
  
  def start_serving
    sleep(1)
    Thread.new {@j.run}
  end
    
  def initialize
  @j = JWP.new
  @hosts = Hash.new
  
  start_serving
  
  until @j.started do
    sleep(0.01)
  end
  
  print "Start here"
  print "http://" + @j.hosts[@j.port].hostname.to_s
  
  print "\n"
  print "Control Interface" + "http://localhost:" + @j.control_app_port.to_s
  
  
  end
  
end

Fun.new
    Thread.list.each {|t| t.join}
