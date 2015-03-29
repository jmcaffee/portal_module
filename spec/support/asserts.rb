##############################################################################
# File::    asserts.rb
# Purpose:: spec assertion helper methods
#
# Author::    Jeff McAffee 2015-03-29
#
##############################################################################

def assert_file_contains filename, str
  result = `grep "#{str}" #{filename}`
  fail "'#{str}' not found in #{filename}" if result.empty?
end
