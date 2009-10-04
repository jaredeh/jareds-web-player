require 'webrick'

require 'src/web_app/generic_servlet.rb'

class LandsafeCtrlServlet < GenericServlet
  
  def initialize(server,ctrl)
    super(server,ctrl)
  end
  
  def do_stuff_with(request,bin,fail)
    s = "<html><form method=\"post\">"
    s += "vao:<input type=\"text\" name=\"vao\" value=\"" + "\"><br>"
    s += "pass1:<input type=\"checkbox\" name=\"pass1\"><br>"
    s += "pass2:<input type=\"checkbox\" name=\"pass2\"><br>"
    s += "<input type=\"submit\" name=\"change\" value=\"change\"></form></html>"
    return s
  end
  
end
