require File.join(File.dirname(__FILE__),'database.rb')
require File.join(File.dirname(__FILE__),'auto_generated/BotStatic.rb')
require 'cgi'

require 'webrick'

include WEBrick

class ControlServlet < HTTPServlet::AbstractServlet
  
  def initialize(server,ctrl)
    super(server)
    @ctrl = ctrl
    @botstatic = BotStatic.new
  end
  
  def host_list
    t = ""
    ihosts = @ctrl.hosts.invert
    ihosts.keys.sort.each do |port|
      t += "\t\t<option value='" + ihosts[port].to_s + "'>"
      t += ihosts[port].to_s
      t += "</option>\n"
    end
    return t
  end
  
  def path_list(host)
    t = ""
    port = @ctrl.hosts[host]
    if port == nil
      return ""
    end
    @ctrl.paths[port].keys.sort.each do |path|
      t += "\t\t<option value='" + path.to_s + "'>"
      t += path.to_s
      t += "</option>\n"
    end
    return t
  end
  
  def id_list(host,path)
    t = ""
    if @ctrl.ids[host] == nil
      return ""
    elsif @ctrl.ids[host][path] == nil
      return ""
    end
    @ctrl.ids[host][path].sort.each do |id|
      t += "\t\t<option value='" + id.to_s + "'>"
      t += id.to_s
      t += "</option>\n"
    end
    return t
  end
  
  def get_id(host,path)
    port = @ctrl.hosts[host]
    id = @ctrl.get_id(port,path)
    print "\n\n\n\nmy id ididid=" + id.to_s + "\n\n\n\n"
    return "(default:" + id.to_s + ")"
  end
  
  def blank
    t = ""
    t += "<script src='"
    t += "http://localhost:" + @ctrl.control_app_port.to_s + "/prototype.js"
    t += "'></script>\n"
    t += ""
    t += "<form method=\"get\">\n"
    t += "\t<label for=\"host_drop_down\">host</label>\n"
    t += "<select name=host id='host_drop_down' onchange=\"hostv = this.options[this.selectedIndex].value;\n new Ajax.Updater('path_drop_down', '/path_list?host=' + encodeURIComponent(hostv), { method: 'get' });\" value = \"\">\n"
    t += host_list
    t += "\t</select></br>\n"
    t += "\t<label for=\"path_drop_down\">path</label>\n"
    t += "<select name=path id='path_drop_down' onchange=\"pathv = this.options[this.selectedIndex].value;\n new Ajax.Updater('id_drop_down', '/id_list?host=' + encodeURIComponent(hostv) + '&path=' + encodeURIComponent(pathv), { method: 'get' });\n new Ajax.Updater('default_id', '/get_id?host=' + encodeURIComponent(hostv) + '&path=' + encodeURIComponent(pathv), { method: 'get' });\n \" value = \"\">\n"
    t += "\t</select></br>\n"
    t += "\t<label for=\"id_drop_down\">id</label>"
    t += "\t<select name=id id='id_drop_down' onchange=\"new Ajax.Updater('selected_map', '/selected_map?host=' + encodeURIComponent(hostv) + '&path=' + encodeURIComponent(pathv), { method: 'get' });\">\n"
    t += "\t</select></br>\n"
    t += "\t<div id='default_id'></div></br></br>"
    t += "\tview selected page:<div id='selected_map'></div></br>\n"
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
  
  def selected_map(host,path)
    t = ""
    t += "<a href='http://localhost:"
    t += @ctrl.hosts[host].to_s
    t += "'>http://"
    t += host + "/" + path
    t += "</a>\n"
  end
  
  def do_process(request, response)
    print request
    print "path=" + request.path.to_s + "\n"
    if request.path == "/prototype.js"
      return @botstatic.contents("./prototype.js")
    elsif request.path == "/path_list"
      return path_list(request.query['host'])
    elsif request.path == "/id_list"
      return id_list(request.query['host'],request.query['path'])
    elsif request.path == "/get_id"
      print request.query['path']
      return get_id(request.query['host'],request.query['path'])
    elsif request.path == "/selected_map"
      return selected_map(request.query['host'],request.query['path'])
    end
    


    if request.query['host'] != nil and request.query['path'] != nil and request.query['id'] != nil
      host = request.query['host']
      path = request.query['path']
      id = request.query['id']

      @ctrl.set_custom(host,path,id)

      return refresh("Changed mapping of 'http://" + host + "/" + path + "' to '" + id + "'\n")
    end
    
    return blank
    
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