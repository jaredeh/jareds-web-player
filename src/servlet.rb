require File.join(File.dirname(__FILE__),'database.rb')
require 'webrick'

include WEBrick

class JWPServlet < HTTPServlet::AbstractServlet
  
  def initialize(server,ctrl)
    super(server)
    @ctrl = ctrl
  end
  
  def pull_host(path)
    host = path.split('/')[1]
    if host == nil
      return ""
    end
    return host
  end
  
  def pull_path(path)
    if path.split('/')[1] == nil
      return ""
    end
    print "path.split: " + path.split('/')[1] + " path: " + path + "\n"
    start = path.split('/')[1].length + 2
    send = path.length
    print "path: " + path[start,send].to_s + " start: " + start.to_s + " end: " + send.to_s + "\n"
    return path[start,send]
  end
  
  def do_GET(request, response)
    if request.path == nil
      return response.body = "not found"
    end
    host = pull_host(request.path)
    path = pull_path(request.path)
    if @ctrl.hosts[host] == nil
      return response.body = "'" + host.to_s + "' not found\n"
    elsif @ctrl.hosts[host][path] == nil
      return response.body = "'" + host + "/" + path + "' not found\n"
    end
    
    id = @ctrl.hosts[host][path]
    
    s = Static.find(id)
    print "id: " + id.to_s + "\n"
    print "body '" + s.contents + "'\n"
    response.body = s.contents
    
  end
  
  def do_POST(request, response)
    return do_GET(request, response)
  end

end