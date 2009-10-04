require 'src/web_app/master_webapp.rb'
require 'src/web_app/landsafe_ctrl_servlet.rb'

class Ctrl
end

ctrl = Ctrl.new

a = Array.new
a.push(WebApp.new(ctrl,3333,LandsafeCtrlServlet,false))


a.each { |d| d.run }

Thread.list.each {|t| t.join}

