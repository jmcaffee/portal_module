##############################################################################
# File::    helpers.rb
# Purpose:: Spec helper methods
#
# Author::    Jeff McAffee 2015-03-29
##############################################################################

def run_with_args(args, client = nil, exitcode = false)
    PortalModule::Runner.new(args, client, exitcode).execute!
end

##
# Write a data structure to a yml file
#
def write_yaml_data_file filename, data
  File.open(filename, 'w') { |f| f << YAML.dump(data) }
end

##
# Read a data from a yml file
#
def read_yaml_data_file filename
  data = {}
  File.open(filename, 'r') do |f|
    data = YAML.load(f)
  end
  data
end

def load_yml filename
  YAML::load_file(filename)
end

def capture_output
  fake_stdout = StringIO.new
  actual_stdout = $stdout
  $stdout = fake_stdout
  yield
  fake_stdout.rewind
  fake_stdout.read
ensure
  $stdout = actual_stdout
end

