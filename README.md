# Code challenge

## Requirements

- ruby 2.4
- mysql
- redis

## Setup project

```bash
bundle install

# edit .env.development according to your needs

rake db:create

./bin/rails s
```

## Running tests

```bash
bundle install

# edit .env.test according to your needs

RAILS_ENV=test rake db:create

./bin/rake spec
```

## Testing the application:

Start rails and run './examples/rate_limit.sh'
