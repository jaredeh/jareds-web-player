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

Shoes.setup do
  gem "activerecord"
end


Shoes.app :width => 400, :margin => 10 do
  
  def start_serving
    sleep(1)
    Thread.new {@j.run}
  end
  
  def do_colors
    @hosts.each do |port,v|
      r,g,b = JSH.color_it(@j.hosts[port].heat)
      v.fill = rgb(r,g,b)
    end
  end
  
  def add_hosts
    flow do
      @j.hosts.each_value do |host|
        s = host.hostname.to_s + "[" + host.port.to_s + "]"
        v = para s
        v.size = "xx-small"
        v.margin_top = 0
        v.margin_bottom = 0
        v.leading = 0
        v.fill = rgb(0,0,255)
        @hosts[host.port] = v
      end
    end
  end
  
  @j = JWP.new
  @hosts = Hash.new
  
  start_serving
  
  until @j.started do
    sleep(0.01)
  end
  
  para "Start here"
  para ( link "http://" + @j.hosts[@j.port].hostname.to_s, :click => "http://localhost:" + @j.port.to_s )
  
  para "\n"
  para ( link "Control Interface", :click => "http://localhost:" + @j.control_app_port.to_s )
  
  add_hosts
  animate(100) do
    do_colors
  end
  
end
