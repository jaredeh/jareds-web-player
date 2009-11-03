require File.join(File.dirname(__FILE__),'database.rb')

class Controller
  
  attr_accessor :hosts, :paths
  
  def initialize(port = 3000)
    @hosts = Hash.new
    @paths = Hash.new
    @port = port
    Static.find(:all).each do |s|
      initialize_host(s.host)
      initialize_path(s.host,s.path,s.id)
    end
    print_url(1)
    print_url(2)
    print_url(3)
    print_url(4)
    print_url(5)
  end
  
  def print_url(id)
    txt = "goto: http://localhost:"
    if not Static.exists?(id)
      txt += @port.to_s
      txt += "\n"
      print txt
    else
      s = Static.find(id)
      txt += @hosts[s.host].to_s
      txt += "/"
      if s.path != nil
        txt += s.path
      end
      txt += "\n"
      print txt
    end
  end
  
  def initialize_host(host)
    #print "initialize_host(" + host.to_s + ")\n"
    if @hosts[host] == nil
      #print "@port = " + @port.to_s + "\n"
      @hosts[host] = @port
      @port += 1
    end
  end
  
  def initialize_path(host,path,id)
    if path == nil
      path = ""
    end
    port = @hosts[host]
    if @paths[port] == nil
      @paths[port] = Hash.new
    end
    txt = "initialize_path('" + host
    txt += "=" + port.to_s
    txt += "','" + path
    txt += "','" + id.to_s + "')\n"
    #print txt
    @paths[port][path] = id
  end
  
end
