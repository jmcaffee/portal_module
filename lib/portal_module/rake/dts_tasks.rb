##############################################################################
# File::    dts_tasks.rb
# Purpose:: DtsTasks definition
#
# Author::    Jeff McAffee 2015-03-29
#
##############################################################################

require 'portal_module'
require 'rake/dsl_definition'
require 'rake'

module PortalModule::Rake

  class DtsTasks
    include ::Rake::DSL if defined?(::Rake::DSL)

    attr_accessor :env
    attr_accessor :org
    attr_accessor :path
    attr_reader   :action
    attr_reader   :valid_actions
    attr_reader   :stop_on_exception

    def initialize(task_name = 'dts_task', desc = "Modify a DTS configuration")
      @valid_actions = ['upload', 'download']
      @task_name, @desc = task_name, desc

      @stop_on_exception = true

      yield self if block_given?

      define_task
    end

    def define_task #:nodoc:
      desc @desc
      task(@task_name, required_args_for_action) do |t,args|
        set_vars args
        commit  # Call method to perform when invoked.
      end
    end

    def set_vars args
      args.each do |arg,val|
        instance_variable_set "@#{arg}", val
      end

      args
    end

    def action=(task_action)
      raise "action must be one of #{valid_types.join(', ')}" unless valid_actions.include?(task_action.downcase)
      @action = task_action
    end

    def stop_on_exception=(do_stop)
      raise ArgumentError, 'Expecting true or false' unless do_stop === true || do_stop === false
      @stop_on_exception = do_stop
    end

    def commit
      validate_params

      client = PortalModule::Client.new
      client.env = env

      if self.respond_to? action
        self.send(action, client)
        return
      else
        raise "Unknown action - #{action}"
      end

    rescue Exception => e
      raise e if stop_on_exception == true
    ensure
      client.quit unless client.nil?
    end

    def upload client
      client.dts.upload org, path
    end

    def download client
      client.dts.download org, path
    end

    def default_params
    end

    def validate_params
      assert_provided env, 'Missing "env"'
      assert_provided action, 'Missing "action"'

      default_params

      assert_provided path, 'Missing "path"'
      assert_provided org, 'Missing "org"'

      assert_env_is_configured env
      assert_org_is_configured org
    end

    def assert_provided value, msg
      if value.nil? || value.empty?
        raise msg
      end
    end

    def assert_env_is_configured arg
      unless PortalModule.configuration.credentials.key? arg
        init_msg = "Have you initialized your config file?\n Try: portal_module config init <filedir>"
        env_msg = "Have you configured your environments?\n Try: portal_module config add env <envname> <url>"
        raise "Unknown environment: #{arg}\n#{init_msg}\n\n#{env_msg}"
      end
    end

    def assert_org_is_configured arg
      unless PortalModule.configuration.orgs.key? arg
        init_msg = "Have you initialized your config file?\n Try: portal_module config init <filedir>"
        env_msg = "Have you configured your orgs?\n Try: portal_module config add org <orgname> <orgid>"
        raise "Unknown org: #{arg}\n#{init_msg}\n\n#{env_msg}"
      end
    end

    def required_args_for_action
      args = []

      case action
      when 'upload'
        args << :org
        args << :path

      when 'download'
        args << :org
        args << :path

      else
        # Noop
      end

      args
    end

    class << self
      def install
        new.install
      end
    end

    def install
      PortalModule.configuration.credentials.keys.each do |e|
        valid_actions.each do |action|
          PortalModule::Rake::DtsTasks.new("pm:#{e}:dts:#{action}", "#{action} a #{e} DTS configuration") do |t|
            t.env = e
            t.action = action
          end
        end
      end
    end
  end # class
end # module

PortalModule::Rake::DtsTasks.install

