##############################################################################
# File::    rake.rb
# Purpose:: Pull in all rake task classes
<<<<<<< HEAD
# 
# Author::    Jeff McAffee 03/19/2014
# Copyright:: Copyright (c) 2014, kTech Systems LLC. All rights reserved.
# Website::   http://ktechsystems.com
##############################################################################

module AdminModule::Rake
end

require_relative 'rake/gdl_tasks'
require_relative 'rake/stage_tasks'
require_relative 'rake/lock_tasks'
=======
#
# Author::    Jeff McAffee 2015-03-29
#
##############################################################################

module PortalModule::Rake
end

require_relative 'rake/dts_tasks'
require_relative 'rake/loan_entry_tasks'
>>>>>>> b947a5d3cfb546e2133836adecd77d0487b4ff77

