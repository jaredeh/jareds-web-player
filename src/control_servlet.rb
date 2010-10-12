require File.join(File.dirname(__FILE__),'database.rb')
require 'webrick'

include WEBrick

class ControlServlet < HTTPServlet::AbstractServlet
  
  def initialize(server,ctrl)
    super(server)
    @ctrl = ctrl
  end
  
  def blank
    t = ""
    t += "<form method=\"get\">\n"
    t += "\t<label for=\"host\">host</label><input name=\"host\" type=\"text\" value=\"\" /><br>\n"
    t += "\t<label for=\"path\">path</label><input name=\"path\" type=\"text\" value=\"\" /><br>\n"
    t += "\t<label for=\"id\">id</label><input name=\"id\" type=\"text\" value=\"\" /><br>\n"
    t += "\t<input type=\"submit\" value=\"set map\" />\n"    
    t += "</form>\n"
    return t
  end
  
  def refresh(content)
    t = ""
    t += "<META HTTP-EQUIV=\"Refresh\" CONTENT=\"5; URL=/\">\n"
    t += content
    return t
  end
  
  def do_process(request, response)
    if request.query['host'] == nil
      return blank
    end
    if request.query['path'] == nil
      return blank
    end
    if request.query['id'] == nil
      return blank
    end
    
    host = request.query['host']
    path = request.query['path']
    id = request.query['id']
    
    @ctrl.set_custom(host,path,id)
    
    return refresh("Changed mapping of 'http://" + host + "/" + path + "' to '" + id + "'\n")
  end
  
  def do_POST(request, response)
    response["Content-Type"] = "text/html"
    response.body = do_process(request, response)
  end
  
  def do_GET(request, response)
    response["Content-Type"] = "text/html"
    response.body = do_process(request, response)
  end
  
end