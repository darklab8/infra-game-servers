package settings

import (
	"darklab_minecraft/minecrafter/settings/logus"
	"darklab_minecraft/minecrafter/settings/types"
	"os"
)

var Channel types.DiscordChannelID

var DiscordBotToken string

func init() {

	channel, is_defined := os.LookupEnv("MINECRAFTER_CHANNEL_ID")
	if !is_defined {
		logus.Fatal("MINECRAFTER_CHANNEL_ID is not defined")
	}

	Channel = types.DiscordChannelID(channel)

	bot_token, is_token_defined := os.LookupEnv("DISCORD_BOT_TOKEN")
	if !is_token_defined {
		logus.Fatal("discord bot token is not defined")
	}
	DiscordBotToken = bot_token
}
