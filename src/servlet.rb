require File.join(File.dirname(__FILE__),'database.rb')
require 'webrick'

include WEBrick

class JWPServlet < HTTPServlet::AbstractServlet
  
  def initialize(server,ctrl)
    super(server)
    @ctrl = ctrl
  end
  
  def format_host(port)
    return "http://localhost:" + port.to_s
  end
  
  def clean_path(host,uri)
    path = uri[host.length,uri.length]
    if path.split('/')[0] == nil
      return ""
    end
    start = path.split('/')[0].length + 1
    send = path.length
    return path[start,send]
  end
  
  def parse_header(header)
    out = Hash.new
    h = header.slice!(2...-2)
    h.split('","').each do |p|
      d = p.split('":"')
      out[d[0]] = d[1]
    end
    return out
  end
  
  def printme(data)
    data.each do |key,value|
      print "data[" + key.to_s + "]=" + value.to_s + "\n"
    end
  end
  
  def set_filter
    filter = Array.new
    #filter.push("Vary")
    filter.push("Transfer-Encoding")
    #filter.push("Content-Type")
    #filter.push("Date")
    #filter.push("Keep-Alive")
    #filter.push("Accept-Ranges")
    #filter.push("Server")
    filter.push("Expires")
    filter.push("Content-Encoding")
    #filter.push("Cache-Control")
    #filter.push("Connection")
    return filter
  end
  
  def replace_hosts(original)
    content = original.gsub('https://','http://')
    @ctrl.hosts.keys.each do |h|
      find = 'http://' + h +'/'
      replace = 'http://localhost:' + @ctrl.hosts[h].to_s + '/'
      print find + "  " + replace + "\n"
      content.gsub!(find,replace)
    end
    return content
  end
  
  def do_GET(request, response)
    if request.path == nil
      return response.body = "not found"
    end
    port = request.port.to_i
    host = format_host(port)
    path = clean_path(host,request.request_uri.to_s)
    
    if @ctrl.paths[port] == nil
      txt = "'" + host + "' is not found in the database\n"
      print "can't serve " + txt
      return response.body = txt
    elsif @ctrl.paths[port][path] == nil
      txt = "'" + host + "/" + path + "' is not found in the database\n"
      print "can't serve " + txt
      return response.body = txt
    end
    
    id = @ctrl.paths[port][path]
    print "served '" + host + "/" + path + "' id=" + id.to_s + "\n"
    
    s = Static.find(id)
    
    data = parse_header(s.response_header)
    
    #printme(data)
    
    filter = set_filter
    
    data.each do |key,value|
      if filter.include?(key)
        next
      end
      response[key] = value
    end
    
    if response["Content-Type"] =~ /text\/html/
      response.body = replace_hosts(s.contents)
    else
      response.body = s.contents
    end
        
  end
  
  def do_POST(request, response)
    return do_GET(request, response)
  end

end