source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem "mysql2", "~> 0.3.13"

rails = case version
        when "master"
          { github: "rails/rails" }
        else
          "~> #{version}"
        end

gem "rails", rails

