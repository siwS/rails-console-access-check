# ConsoleAccessCheck

(WIP)

This gem operates as a wrapper around ActiveRecord queries. 
It checks if the running user has the permissions to execute the query. 
If the user is not in the list of allowed users, it throws a PermissionsError.

To use this gem in you application, add in your Gemfile:

```ruby
gem 'console_access_check', :git => 'https://github.com/siwS/rails-console-access-check'

```

## Configuration

In order to configure the access checker for your application you have to set these options:

-sensitive_tables_model
-user_permissions_model
-raise_error
-use_group_access

You can add the following code in your application.rb file:

```ruby
  ConsoleAccessCheck.configure do |config|
    config.sensitive_tables_model = "SensitiveModels"
    config.user_permissions_model = "UserPermissions"
    config.raise_error = true
    config.use_group_access = false
  end
```

If user_permissions_model is not specified all models are treating the same way for all users. 
If user_permissions_model is specified but there is no particular entry for a certain user for a model,
we consider that the user does not have access to this model.

## Development

To develop check out latest code from github

```shell
git clone git@github.com:siwS/rails-console-access-check.git
```
To install gem locally:

    $ rake install
    $ gem install pkg/console_access_check-0.0.2.gem

Then you can include the gem in your applications, adding in your Gemfile 

```ruby
gem 'console_access_check'

```

## To do list

1. write tests
2. add dynamo sourc444444444444xs