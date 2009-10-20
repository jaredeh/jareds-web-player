require File.join(File.dirname(__FILE__),'database.rb')
require 'uri'

class ConvertMe
  
  def self.parse_header(header)
    c = URI.decode(URI.decode(header))
    out = Hash.new
    h = c.slice!(2...-2)
    h.split('","').each do |p|
      d = p.split('":"')
      out[d[0]] = d[1]
    end
    return out
  end
  
  def self.print_header(header)
    print "\n\n----------------------------------------\n"
    header.each do |k,v|
      print "\tkey:  '" + k.to_s + "'\n"
      print "\tvalue:'" + v.to_s + "'\n"
    end
    print "\n"
  end
  
  def self.import(r,s)
    ra = r.find(:all)
    ra.each do |rs|
      req_header = parse_header(rs.Request_Header)
      resp_header = parse_header(rs.Response_Header)
      path = rs.URL.split(req_header['Host'] + "/")[1]
      if path == nil
        path = ""
      end
      n = s.new do |t|
        t.host = req_header['Host']
        t.path = path
        t.contents = URI.decode(rs.Content)
        t.request_header = URI.decode(URI.decode(rs.Request_Header))
        t.response_header = URI.decode(URI.decode(rs.Response_Header))
      end
      n.save!
    end
  end
  
  def self.import_jwr(file)
    Request.make_connection(file)
    import(Request,Static)
  end
  
end

