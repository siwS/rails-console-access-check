# ConsoleAccessCheck

(WIP)

This gem operates as a wrapper around ActiveRecord queries. 
It checks if the running user has the permissions to execute this query. 
If the user is not in the list of allowed users, it throws a PermissionsError

## Installation

To install execute:

    $ rake install
    $ gem install pkg/console_access_check-0.0.1.gem


The you can add it to your application's Gemfile:

```ruby
gem 'console_access_check'
```

## Development

It's still under development, so wouldn't really recommend developing on it :P

