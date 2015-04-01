##############################################################################
# File::    asserts.rb
# Purpose:: spec assertion helper methods
#
<<<<<<< HEAD
# Author::    Jeff McAffee 07/05/2014
# Copyright:: Copyright (c) 2014, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
=======
# Author::    Jeff McAffee 2015-03-29
#
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77
##############################################################################

def assert_file_contains filename, str
  result = `grep "#{str}" #{filename}`
  fail "'#{str}' not found in #{filename}" if result.empty?
end
