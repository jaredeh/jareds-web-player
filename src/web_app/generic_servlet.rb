require 'webrick'

include WEBrick

class GenericServlet < HTTPServlet::AbstractServlet
  
  def initialize(server,ctrl)
    super(server)
    @ctrl = ctrl
  end
  
  def do_GET(request, response)
    bin = false
    fail = false
    
    body = do_stuff_with(request,bin,fail)
    
    if fail
      response.status = 404
    else
      response.status = 200
    end
    
    if bin
      response['Content-Type'] = "binary/octet-stream"
    else
      response['Content-Type'] = "text/html"
    end
    
    if is_css?(request.path)
      response['Content-Type'] = "text/css"
    end
    
    response.body = body
  end
  
  def do_POST(request, response)
    return do_GET(request, response)
  end
  
  def do_stuff_with(request,bin,fail)
    return "you got a page"
  end 
  
  def is_css?(path)
    file = File.basename(path)
    parts = file.split('.')
    i = parts.length - 1
    if parts[i] == "css"
      return true
    end
    return false
  end
  
  def clean_path(path)
    return "." + path.gsub(/\\/,"/")
  end
  
end