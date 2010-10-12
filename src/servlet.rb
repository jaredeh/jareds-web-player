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
    filter.push("Content-Length")
    #filter.push("Cache-Control")
    #filter.push("Connection")
    #filter.push("Set-Cookie")
    #filter.push("X-Content-Type-Options")
    return filter
  end
  
  def replace_hosts(original)
    content = original.gsub('https://','http://')
    @ctrl.hosts.keys.each do |h|
      find = 'http://' + h +'/'
      replace = 'http://localhost:' + @ctrl.hosts[h].to_s + '/'
      #print find + "  " + replace + "\n"
      content.gsub!(find,replace)
    end
    return content
  end
  
  def filter_header(response,row)
    filter = set_filter
    header = parse_header(row.response_header)
    #printme(header)    
    header.each do |key,value|
      if filter.include?(key)
        next
      end
      response[key] = value
    end
  end
  
  def clean_hosts_from_response(response,row)
    if response["Content-Type"] =~ /text\/html/
      response.body = replace_hosts(row.contents)
    elsif response["Content-Type"] =~ /text\/css/
      response.body = replace_hosts(row.contents)
    elsif response["Content-Type"] =~ /text\/plain/
      response.body = replace_hosts(row.contents)
    else
      response.body = row.contents
    end
  end
  
  def do_process(request, response)  
    if request.path == nil
      return response.body = "not found"
    end
    port = request.port.to_i
    host = format_host(port)
    path = clean_path(host,request.request_uri.to_s)
    
    id = @ctrl.get_id(port,path)
    print "served '" + host + "/" + path + "' id=" + id.to_s + "\n"
    
    s = Static.find(id)
    filter_header(response,s)
    clean_hosts_from_response(response,s)
    return response.body
  end
  
  def do_POST(request, response)
    start = Time.now
    ret = do_process(request, response)
    stop = Time.now
    elapsed = stop - start
    #print "\ttime elapsed: " + elapsed.to_s + " sec\n"
    return ret
  end
  
  def do_GET(request, response)
    start = Time.now
    ret = do_process(request, response)
    stop = Time.now
    elapsed = stop - start
    #print "\ttime elapsed: " + elapsed.to_s + " sec\n"
    return ret
  end
  
end