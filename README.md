# ConsoleAccessCheck

This gem operates as a wrapper around ActiveRecord queries executed from Rails Console.\
For every ActiveRecord query, it checks if the user who is logged in the Console has the correct permissions to execute a Read or Write operation for the table in question.\
If the user does not have permissions, it logs the unauthorised access attempt and/or throws a PermissionsError.\

To use this gem in you application, add in your Gemfile:

```ruby
gem 'console_access_check', :git => 'https://github.com/siwS/rails-console-access-check'

```

## Configuration

In order to configure the `ConsoleAccessCheck` for your application you need to set the following options:

- sensitive_tables_model: the model that contains the Sensitive Tables to be protected

- user_permissions_model: the model that contains the mapping for the User Permissions for the `sensitive_tables_model`

- raise_error: enable raising a PermissionsError on unauthorised access

- use_group_access: enable checking users' groups permissions instead of individual permissions

- log_to_db: enable logging unauthorised access attempts to the DB

- logging_table: logging table

The configuration can be added in the application.rb file:

```ruby
  ConsoleAccessCheck.configure do |config|
    config.raise_error = true
    config.sensitive_tables_model = "SensitiveModel"
    config.user_permissions_model = "UserPermission"
    config.use_group_access = false
    config.log_to_db = true
    config.logging_table = "UnauthorisedAccessLog"
  end
```

- If a `user_permissions_model` is not specified all models are treated in the same way for all users.\
- If a `user_permissions_model` is specified but there is no entry for a certain user / sensitive model combination, the user does not have access to this model.

## Development

To develop check out the latest code from github

```shell
git clone git@github.com:siwS/rails-console-access-check.git
```

To install the gem locally:

    $ rake install
    $ gem install pkg/console_access_check-0.0.2.gem

To include the gem in your applications, add in your Gemfile 

```ruby
gem 'console_access_check'

```

## TODO

- [ ] Write tests
- [ ] Add support for DynamoDB
- [ ] Allow more granular configuration of check_permissions behavior
