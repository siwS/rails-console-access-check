# ConsoleAccessCheck

(WIP)

This gem operates as a wrapper around ActiveRecord queries. 
It checks if the running user has the permissions to execute the query. 
If the user is not in the list of allowed users, it throws a PermissionsError.

## Installation

To install execute:

    $ rake install
    $ gem install pkg/console_access_check-0.0.1.gem


Then, you can add it to your application's Gemfile:

```ruby
gem 'console_access_check'
```

## Configuration

In order to configure the access checker for your application you have to set 3 options:

- sensitive_tables
- user_permissions_model (optional)
- raise_error

You can add the following code in your application:

```ruby
  ConsoleAccessCheck.configure do |config|
    config.sensitive_tables = ["model_1", "model_2", "model_3"]
    config.user_permissions_model = "UserPermissionModel"
    config.raise_error = true
  end
```

You can also do something like:

```ruby
  ConsoleAccessCheck.configuration.raise_error = false
```

In case user_permissions_model is not specified all models are treating the same way for all users. 


## Development

It's still under development, so wouldn't really recommend developing on it :P

## To-do list

1. check model that query is about
2. abstract the logic of permissions so that it can be implemented by whoever uses gem
