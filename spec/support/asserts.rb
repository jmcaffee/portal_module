##############################################################################
# File::    asserts.rb
# Purpose:: spec assertion helper methods
#
##############################################################################

def assert_file_contains filename, str
  result = `grep "#{str}" #{filename}`
  fail "'#{str}' not found in #{filename}" if result.empty?
end
