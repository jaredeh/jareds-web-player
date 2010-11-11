def dump_file(file)
  i = File.new(file)
  s = i.read
  i.close
  return s.dump
end

def create_static_contents(input,files)
  if not FileTest.directory?("./src/auto_generated")
    Dir.mkdir("./src/auto_generated")
  end
  filename = "./src/auto_generated/" + input + ".rb"
  f = File.new(filename,"w")
  f.write("class " + input + "\n\n")
  f.write("  def initialize\n")
  f.write("    @c = Hash.new\n")
  files.each do |path,file|
    f.write("    @c[\"" + path + "\"] = " + file + "\n")
  end
  f.write("  end\n\n")
  f.write("  def contents(path)\n")
  f.write("    if @c.include?(path)\n")
  f.write("      return @c[path]\n")
  f.write("    end\n")
  f.write("    retval = \"File not found '\" + path + \"'\\n\"\n")
  f.write("    print retval\n")
  f.write("    return retval\n")
  f.write("  end\n\n")
  f.write("end\n")
end

def recurse_directory(files,path)
  Dir.foreach(path) do |entry|
    name = File.join(path,entry) 
    if entry[0] == "."[0]
       next
    elsif FileTest.directory?(name)
      recurse_directory(files,name)
    elsif FileTest.file?(name)
      print "file=" + name + "\n"
      files[name] = dump_file(name)
    end
  end
end

homedir = Dir.pwd
files = Hash.new
Dir.chdir("content/support_files")
recurse_directory(files,".")
Dir.chdir(homedir)

create_static_contents("BotStatic",files)
