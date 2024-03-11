package avorioner_settings

import (
	"os"

	"github.com/darklab8/infra-game-servers/bot/utils/logus"
	"github.com/darklab8/infra-game-servers/bot/utils/types"
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
