#this script is for gain only packages without dependencies from list of packages

require 'set'

# return set of dependencies from string with output from "apt-cache rdepends <package>"
def find_dependence(package)
  dependencies = Set.new
  package_name_found = false
  
  dependence = `apt-rdepends #{package} 2>/dev/null`
  
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

# return leaves from tree of dependences
def leaves(filename)
  all_dependencies = Set.new
  packages_input = Set.new
  file = File.new( filename, "r" )

  begin
    counter = 0
    while package = file.gets
      all_dependencies.merge(find_dependence(package.chomp))
      packages_input.add(package)
      STDOUT.write "\r#{counter += 1}"
    end
  ensure
    file.close
  end

  return all_dependencies, packages_input
end

# main

if ARGV.length != 2
  warn "Bad number of parameters!!!\n\nUsing: ruby dpkg-without-dependencies.rb file_name_input file_name_output"
  exit 1
end

# result - set of all dependent packages on packages from set 'package_input'
# package_input - packages from file passed on as input parametr ARGV[0]
result, packages_input = leaves(ARGV[0])

# output
begin
  file_out = File.new (ARGV[1], "w")
  (packages_input - result).each do |i|
    file_out.puts i.chomp
  end
ensure
  file_out.close
end
