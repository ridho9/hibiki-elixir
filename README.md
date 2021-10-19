# Hibiki Elixir


## Running in Local

### Prerequisite

1. Create a line bot account and get the channel access token and channel secret (https://developers.line.biz/en/docs/messaging-api/getting-started/#using-oa-manager).
2. Install Elixir (https://elixir-lang.org/install.html).
3. Setup local postgres db.

### Setup

1. Copy `config/dev.sample.exs` to `config/dev.exs` and fill in the environment variables.
2. Run `mix deps.get` in the root folder.
3. Run `iex -S mix`

### Webhook URL

I usually use ngrok, feel free to use whatever if you know how to.

1. Install ngrok (https://ngrok.com/).
2. After running hibiki, run `ngrok http 8080` on another terminal.
3. Copy the https forwarding url (eg. https://something.ngrok.io)
4. Go to line dev console (https://developers.line.biz/console/)
5. Open your bot provider, and bot channel account.
6. Go to messaging API tab, enable `Use Webhook` if haven't, and set the webhook url to the ngrok https url + "/hibiki" (eg. "https://something.ngrok.io/hibiki")
7. The ngrok url will change everytime you restart the process, unless you get a premium account.
8. Send "!call" to your line bot account.