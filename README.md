# PortalModule

PortalModule is a tool to allow maintenance and configuration of AMS
Portal environments through the command line or Rake tasks.

Because it is scriptable, it can be used to create efficient and repeatable
migrations resulting in low risk deployments.

## Installation

Add this line to your application's Gemfile:

    gem 'portal_module'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install portal_module

## Usage

### Command Line Help

Thor's usage help is messed up related to subcommands (ie. subcommand help is
sometimes listed without the subcommand's parent). For this reason, the 'help'
is listed here.

    $ portal_module help

    Commands:
      portal_module help [COMMAND]        # Describe available commands or one specific command
      portal_module config [COMMAND]      # modify configuration values
      portal_module dts [COMMAND]         # run a dts command
      portal_module loan_entry [COMMAND]  # run a Loan Entry command


#### Config Commands

    $ portal_module config help

    Commands:
      portal_module config help [COMMAND]          # Describe subcommands or one specific subcommand
      portal_module config defenv <envname>        # show or set the default environment
      portal_module config download_dir <dir>      # show or set the system download directory
      portal_module config init <filedir>          # create a configuration file
      portal_module config timeout <seconds>       # show or set the browser timeout period
      portal_module config show [CATEGORY]         # display configuration values for [CATEGORY]
      portal_module config add [CATEGORY]          # add a configuration value
      portal_module config del [CATEGORY]          # delete a configuration value for [CATEGORY]


##### Config Show Commands

    $ portal_module config show help

    Commands:
      portal_module config show help [COMMAND]         # Describe subcommands or one specific subcommand
      portal_module config show credentials <envname>  # display configured credentials for an environment
      portal_module config show envs                   # display configured environments
      portal_module config show orgs                   # display configured Org Units


##### Config Add Commands

    $ portal_module config add help

    Commands:
      portal_module config add help [COMMAND]                           # Describe subcommands or one specific subcommand
      portal_module config add credentials <envname> <username> <pass>  # add login credentials for an environment
      portal_module config add env <envname> <url>                      # add a environment url
      portal_module config add org <orgname> <orgid>                    # add an Org Unit and ID


##### Config Del Commands

    $ portal_module config del help

    Commands:
      portal_module config del help [COMMAND]         # Describe subcommands or one specific subcommand
      portal_module config del credentials <envname>  # delete credentials for an environment
      portal_module config del env <envname>          # delete an environment configuration
      portal_module config del org <orgname>          # delete an Org Unit


#### DTS Commands

    $ portal_module dts help

    Commands:
      portal_module dts help [COMMAND]             # Describe subcommands or one specific subcommand
      portal_module dts download <org> <filepath>  # Export a DTS configuration file from the environment
      portal_module dts upload <org> <filepath>    # Upload a DTS configuration file into the environment

    Options:
      e, [--environment=dev]


#### Loan Entry Commands

    $ portal_module loan_entry help

    Commands:
      portal_module loan_entry help [COMMAND]             # Describe subcommands or one specific subcommand
      portal_module loan_entry download <org> <filepath>  # Download a Loan Entry configuration file from the environment
      portal_module loan_entry upload <org> <filepath>    # Upload a Loan Entry configuration file into the environment

    Options:
      e, [--environment=dev]






### Tasks

PortalModule provides tasks you can use in your rake file.

#### DTS Tasks

Add `require 'portal_module/rake/dts_tasks'` to your rake file and
`portal_module` will add a set of `dts` tasks for each configured
environment. All tasks are prefixed with `am:ENV_NAME:`.

Task options are displayed within brackets like so: `am:dev:dts:upload[org,filepath]`.
If the option contains spaces, surround the option, or the entire task name
with single or double quotes:

    rake am:dev:dts:upload['Some Org Name','file/path with/spaces/file.xml']

    # or

    rake 'am:dev:dts:upload[Some Org Name,file/path with/spaces/file.xml]'


Tasks include:

- `dts:upload` uploads a DTS configuration file
- `dts:download` downloads a DTS configuration file

#### Loan Entry Tasks

Add `require 'portal_module/rake/loan_entry_tasks'` to your rake file and
`portal_module` will add a set of `loan_entry` tasks for each configured
environment. All tasks are prefixed with `am:ENV_NAME:`.

Task options are displayed within brackets like so: `am:dev:loan_entry:upload[org,filepath]`.
If the option contains spaces, surround the option, or the entire task name
with single or double quotes:

    rake am:dev:loan_entry:upload['Some Org Name','file/path with/spaces/file.xml']

    # or

    rake 'am:dev:loan_entry:upload[Some Org Name,file/path with/spaces/file.xml]'


Tasks include:

- `loan_entry:upload` uploads a Loan Entry configuration file
- `loan_entry:download` downloads a Loan Entry configuration file


## Scripting

You can use the Client for scripting.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Create your tests (you do have tests, don't you?)
4. Write your code
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## ToDo

* document CLI

## Process Flow (CLI)

- Command entered in console
- `lib/portal_module/cli.rb` processes args
- `cli.rb` hands command off to `lib/portal_module/command/dts.rb`
- `dts.rb` validates command and hands off to `lib/portal_module/dts.rb`
- `dts.rb` processes command and uses `lib/portal_module/page_factory.rb`
  to get instance of web page objects needed to fulfill command request
- `dts.rb` completes command

## Process Flow (Rake Task)

- Rake imports/requires `lib/portal_module/rake/dts_task.rb`
- Rake task requires API object `lib/portal_module/dts.rb`
- API object processes task request, gets needed page objects from `page_factory.rb`
- API object completes task request, returns control to task

## Testing

All tests can be run with

    bundle exec rspec spec/

There's an included `Guardfile` that can be started with

    bundle exec guard

### Creating a Command Spec

Create a new spec file `spec/lib/portal_module/command/dts_spec.rb`.

Create a new Command object `lib/portal_module/command/dts.rb`.

Edit `lib/portal_module/cli.rb` creating new base command pointing to new object
(`PortalModule::Command::Dts` in this case).

Create `lib/portal_module/dts.rb` which is an object that provides an API
interface to the actual DTS (DataTransformationPage) page object.

- The DataTransformationPage page object only contains functionality that the actual webpage
  contains, ie. Activate, Save, Loan Org Unit
- The Dts API object contains functionality that manipulates the webpage
  object to provide results. Maybe this means it uses the page object to lookup
  the available org units, or throw an error if a org doesn't exist.
- The API object also hides the fact that the app may need to go to a multiple
  pages to accomplish the request.


