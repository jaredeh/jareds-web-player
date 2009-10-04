require 'webrick'
require 'webrick/https'

include WEBrick

class WebApp
  
  def initialize(ctrl,port,servlet,https)
    if https
      @server = HTTPServer.new(
        :Port=>port,
        :AccessLog => [],
        :SSLEnable => true,
        :SSLVerifyClient => ::OpenSSL::SSL::VERIFY_NONE,
        :SSLCertName => [ ["C","JP"], ["O","WEBrick.Org"], ["CN", "WWW"] ]
      )
    else
      @server = HTTPServer.new(:Port=>port, :AccessLog => [], :SSLEnable => false)
    end
    @server.mount("",servlet,ctrl)
  end
  
  def run
    trap("INT","TERM") do
      @server.shutdown
    end
    Thread.new { @server.start }
  end
  
end
