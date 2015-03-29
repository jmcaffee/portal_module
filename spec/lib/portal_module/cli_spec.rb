require 'pathname'
require Pathname(__FILE__).ascend{|d| h=d+'spec_helper.rb'; break h if h.file?}

require 'portal_module/cli'

describe 'portal_module executable' do

  let(:cli) { PortalModule::CLI }

  it "returns help info" do
    output = capture_output do
      cli.start %w(help)
    end

    expect( output ).to include "help [COMMAND]"
    expect( output ).to include "config [COMMAND]"
    expect( output ).to include "dts [COMMAND]"
    expect( output ).to include "loan_entry [COMMAND]"
  end

=begin
  it "returns non-zero exit status when passed unrecognized options" do
    pending
    #portal_module '--invalid_argument', :exitstatus => true
    portal_module '--invalid_argument'
    expect(exitstatus).to_not be_zero
  end

  it "returns non-zero exit status when passed unrecognized task" do
    pending
    portal_module 'unrecognized-task'#, :exitstatus => true
    expect(exitstatus).to_not be_zero
  end
=end
end
