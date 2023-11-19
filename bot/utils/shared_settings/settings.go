package shared_settings

import (
	"darklab_minecraft/bot/utils/logus"
	"darklab_minecraft/bot/utils/types"
	"os"
)

var Channel types.DiscordChannelID

var DiscordBotToken string

func init() {

	channel, is_defined := os.LookupEnv("DISCORD_CHANNEL_ID")
	if !is_defined {
		logus.Fatal("DISCORD_CHANNEL_ID is not defined")
	}

	Channel = types.DiscordChannelID(channel)

	bot_token, is_token_defined := os.LookupEnv("DISCORD_BOT_TOKEN")
	if !is_token_defined {
		logus.Fatal("discord bot token is not defined")
	}
	DiscordBotToken = bot_token
}
