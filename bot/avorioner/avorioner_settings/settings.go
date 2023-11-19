package avorioner_settings

import (
	"darklab_minecraft/bot/utils/logus"
	"darklab_minecraft/bot/utils/types"
	"os"
)

var DarkwindChannel types.DiscordChannelID
var OthersChannel types.DiscordChannelID

func init() {
	var is_defined bool
	var channel string

	channel, is_defined = os.LookupEnv("AVORIONER_DARKWIND_CHANNEL_ID")
	if !is_defined {
		logus.Fatal("AVORIONER_DARKWIND_CHANNEL_ID is not defined")
	}
	DarkwindChannel = types.DiscordChannelID(channel)

	channel, is_defined = os.LookupEnv("AVORIONER_OTHERS_CHANNEL_ID")
	if !is_defined {
		logus.Fatal("AVORIONER_OTHERS_CHANNEL_ID is not defined")
	}
	OthersChannel = types.DiscordChannelID(channel)
}
