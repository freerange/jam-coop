# README [![CI](https://github.com/freerange/jam-coop/actions/workflows/ci.yml/badge.svg)](https://github.com/freerange/jam-coop/actions/workflows/ci.yml)

## Development

This is a Rails app running on the version of Ruby specified in `.ruby-version` and the version of Node specified in `.node-version`. If you're using `asdf` you can install the correct versions of Ruby and Node locally with `asdf install`. If you're using `mise` you can install the correct versions of Ruby and Node locally with `mise install`.

We're using PostgreSQL 15 in production, so it's recommended you run that in development too. On OS X you can use homebrew

    brew install postgresql@15

We're using Rails 7's default image processor library `vips`, which you need to install

    brew install libvips

Copy the example `.env` file

    cp `.env.example .env`

From there proceed as usual for local rails app development

    rails db:setup
    ./bin/dev

The app should be running on [http://localhost:3000/](http://localhost:3000/)

## Testing

Linters and test can be run using the default `rake` task.

To run the system tests in a visible/headed browser set the `HEADLESS` environment variable to false. For example: to run all system tests in a visible browser, execute `HEADLESS=false rails test test/system`.

## Credentials

Environment specific API keys etc. are stored in environment variables. The file `.env.example` should be copied to `.env` so that `Dotenv` can find these in development. You may only need to set these to real values if you need a particular third party service for the code you're working on. For example, Rollbar credentials are only needed if for some reason you need to use rollbar in development.

## Sending email in development

If you need to send email via Postmark in development you can set the `USE_POSTMARK_IN_DEVELOPMENT` variable to `true` in `.env`.

## Using Stripe in development

To receive events from Stripe webhooks in your local environment you need to run the Stripe CLI with:

    stripe listen --forward-to localhost:3000/stripe_webhook_events

When you first run this command it will show a value for the "webhook signing secret". Copy this value and set `STRIPE_ENDPOINT_SECRET` to this value in your local `.env` file.

## Deployment

When a CI build on the `main` branch succeeds the commits are promoted to the `production` branch. [Render](https://dashboard.render.com/) is configured to automatically deploy the latest changes from the `production` branch. The login credentials for Render are available in the shared 1Password vault.

## Downloading production data

This requires you to store the Render database credentials (host, username and password) in environment variables (e.g. in .envrc if using direnv). Get the values from render.com.

```
# Create a backup of the production database
PGPASSWORD=${RENDER_DB_PASSWORD} pg_dump -h ${RENDER_DB_HOST} -U ${RENDER_DB_USER} musiccoop > tmp/jam-production-db.sql

# Drop and create the local database
rails db:drop
rails db:create

# Restore the production database locally
rails db -p < tmp/jam-production-db.sql

# Set the environment to development so that we don't see scary warnings about modifying the production database when we attempt to drop it
echo "update ar_internal_metadata set value = 'development' where key = 'environment' and value = 'production'" | rails db -p
```

## Troubleshooting

### Generating image varients fails locally

I saw this error locally on my M2 Macbook Air

    [__NSCFConstantString initialize] may have been in progress in another thread when fork() was called

The [solution](https://dev.to/wusher/active-storage-variants-failing-locally-1glm) was to add the following to my `.zshrc`

    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
