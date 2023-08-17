# README

## Development

This is a Rails app running on the version of ruby specified in `.ruby-version`. There's also a `.tool-versions` file, so if you're using `asdf` you can install the correct version of ruby locally with

    asdf install

We're using PostgreSQL 15 in production, so it's recommended you run that in development too. On OS X you can use homebrew

    brew install postgresql@15

We're using Rails 7's default image processor library `vips`, which you need to install

    brew install libvips

From there proceed as usual for local rails app development

    rails db:setup
    ./bin/dev

The app should be running on [http://localhost:3000/](http://localhost:3000/)

## Testing

Linters and test can be run using the default `rake` task.

## Credentials

Environment specific API keys etc. are stored under `/config/credentials/{development,production}.yml.enc`. You'll need to create `config/credentials/{development,production}.key` to encrypt and decrypt them. The contents of these two key files are in our 1P vault.

## Sending email in development

If you need to send email via Postmark in development you can set the `USE_POSTMARK_IN_DEVELOPMENT` variable to `true` in `.env`.

## Deployment

All commits to `main` are deployed to [render](https://dashboard.render.com/) (the login credentials for which are available in 1P). They're not currently gated by the CI build that runs in a github action.
