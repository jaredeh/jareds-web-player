
class Host
  
  attr_accessor :hostname, :port, :log
  
  def initialize(hostname = "", port = 0, ttl = 300)
    @hostname = hostname
    @port = port
    @ttl = ttl
    @log = Array.new
    @heat = Array.new
  end
  
  def traffic
    t = t_to_ms(Time.now)
    clean(t)
    return @heat.length
  end
  
  def clean(t)
    j = 0
    @heat.each_index do |i|
      diff = t - @heat[i]
      if diff > @ttl
        j += 1
      end
    end
    j.times do |k|
      @log.delete_at(0)
      @heat.delete_at(0)
    end
  end
  
  def heat
    t = t_to_ms(Time.now)
    clean(t)
    if @heat.length == 0
      return 0
    end
    diff = t - @heat.last
    return (100 - (diff*100)/@ttl).to_i
  end
  
  def hit(path)
    @log.push(path)
    @heat.push(t_to_ms(Time.now))
  end
  
  def t_to_ms(t)
    return (t.to_f*1000).to_i
  end
  
end