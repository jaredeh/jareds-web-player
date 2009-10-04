require File.join(File.dirname(__FILE__),'src/database.rb')
require File.join(File.dirname(__FILE__),'src/controller.rb')
require File.join(File.dirname(__FILE__),'src/servlet.rb')
require File.join(File.dirname(__FILE__),'src/webapp.rb')
require File.join(File.dirname(__FILE__),'src/convert.rb')
#require File.join(File.dirname(__FILE__),'src/toying.rb')

Static.connect_to_yml_file("db/database.yml")

#file = '../JWR_2009-09-10-03-51-51.sqlite'
#ConvertMe.import_jwr(file)

ctrl = Controller.new
web = WebApp.new(ctrl,3000,JWPServlet,false)

web.run

Thread.list.each {|t| t.join}



