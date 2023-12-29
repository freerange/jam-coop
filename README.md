# README

## Development

This is a Rails app running on the version of ruby specified in `.ruby-version`. There's also a `.tool-versions` file, so if you're using `asdf` you can install the correct version of ruby locally with

    asdf install

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

## Credentials

Environment specific API keys etc. are stored in environment variables. The file `.env.example` should be copied to `.env` so that `Dotenv` can find these in development. You may only need to set these to real values if you need a particular third party service for the code you're working on. For example, Rollbar credentials are only needed if for some reason you need to use rollbar in development.

## Sending email in development

If you need to send email via Postmark in development you can set the `USE_POSTMARK_IN_DEVELOPMENT` variable to `true` in `.env`.

## Using Stripe in development

To receive events from Stripe webhooks in your local environment you need to run the Stripe CLI with:

    stripe listen --forward-to localhost:3000/stripe_webhook_events

When you first run this command it will show a value for the "webhook signing secret". Copy this value and set `ENDPOINT_SECRET` to this value in `StripeWebhookEventsController` (either using the development credentials file or by temporarily editing the code).

## Deployment

All commits to `main` are deployed to [render](https://dashboard.render.com/) (the login credentials for which are available in 1P). They're not currently gated by the CI build that runs in a github action.

## Troubleshooting

### Generating image varients fails locally

I saw this error locally on my M2 Macbook Air

    [__NSCFConstantString initialize] may have been in progress in another thread when fork() was called

The [solution](https://dev.to/wusher/active-storage-variants-failing-locally-1glm) was to add the following to my `.zshrc`

    export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
