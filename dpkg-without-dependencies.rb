#this script is for gain only packages without dependencies from list of packages

require 'set'

#return set of dependencies from string with output from "apt-cache rdepends <package>"
def find_dependence(package)
  dependencies = Set.new
  package_name_found = false
  
  dependence = `apt-rdepends #{package} 2>/dev/null`
  
  #p "dependence #{dependence}"
  
  dependence.each_line do |i|
    if package_name_found
      i.sub!(/  Depends: /,"")
      #p "1 ", i
      i.sub!(/  PreDepends: /,"")
      #p "2 ", i
      i.sub!(/\(.*/,"")
      #p "3 ", i
      dependencies.add(i.strip.chomp)
    end

    if i.chomp == package
      package_name_found = true
    end
  end
  return dependencies
end

#return leaves from tree of dependences
def leaves(filename)
  all_dependencies = Set.new
  file = File.new( filename, "r" )

  begin
    while package = file.gets
          all_dependencies.merge(find_dependence(package.chomp))
    end
  ensure
    file.close
  end

  return all_dependencies
end

if ARGV.length != 1
  p "Using: ruby dpkg-without-dependencies.rb file_name"
  exit 1
end

#run function and print result

result = leaves(ARGV[0])
result.each do |i|
  p i
end
