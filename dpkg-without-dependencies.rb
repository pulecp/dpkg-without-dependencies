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
      i.sub!(/  PreDepends: /,"")
      i.sub!(/\(.*/,"")
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
  dependencies = Set.new
  packages_input = Set.new
  file = File.new( filename, "r" )

  begin
    counter = 0
    while package = file.gets
      packages_input.add(package.chomp)
    end

    packages_input.each do |package|
      packages_input -= find_dependence(package.chomp)
      STDOUT.write "\r#{counter += 1}"
    end
    puts

  ensure
    file.close
  end

  return packages_input
end

# main

if ARGV.length != 2
  warn "Bad number of parameters!!!\n\nUsing: ruby dpkg-without-dependencies.rb file_name_input file_name_output"
  exit 1
end

# run method result
result = leaves(ARGV[0])

# output
begin
  file_out = File.new( ARGV[1], "w")
  result.each do |i|
    file_out.puts i.chomp
  end
ensure
  file_out.close
end
puts "Done"
