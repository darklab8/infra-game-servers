package main

import (
	"fmt"
	"regexp"
	"time"

	"github.com/darklab8/infra-game-servers/bot/utils"
	"github.com/darklab8/infra-game-servers/bot/utils/discorder"
	"github.com/darklab8/infra-game-servers/bot/utils/logus"
	"github.com/darklab8/infra-game-servers/bot/utils/shared_settings"
	"github.com/darklab8/infra-game-servers/bot/utils/types"
)

func reactToEvent(line string) {
	// logus.Info("sending= " + line)

	if player_joined := RegexPlayerJoined.FindStringSubmatch(line); len(player_joined) > 0 {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(discorder.NewRepeatChecker(types.DockerTimestamp(player_joined[1]))), fmt.Sprintf("[%s] player %s joined the server", player_joined[1], player_joined[2]), shared_settings.Channel)
	}

	if player_message := RegexPlayerMessage.FindStringSubmatch(line); len(player_message) > 0 {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(discorder.NewRepeatChecker(types.DockerTimestamp(player_message[1]))), fmt.Sprintf("[%s] <%s> %s", player_message[1], player_message[2], player_message[3]), shared_settings.Channel)
	}

	if player_left := RegexPlayerLeft.FindStringSubmatch(line); len(player_left) > 0 {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(discorder.NewRepeatChecker(types.DockerTimestamp(player_left[1]))), fmt.Sprintf("[%s] player %s left the server", player_left[1], player_left[2]), shared_settings.Channel)
	}

	if achivement := RegexPlayerAchievement.FindStringSubmatch(line); len(achivement) > 0 {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(discorder.NewRepeatChecker(types.DockerTimestamp(achivement[1]))), fmt.Sprintf("[%s] player %s has just earned the achievement %s", achivement[1], achivement[2], achivement[3]), shared_settings.Channel)
	}
}

var RegexPlayerJoined *regexp.Regexp
var RegexPlayerLeft *regexp.Regexp
var RegexPlayerMessage *regexp.Regexp
var RegexPlayerAchievement *regexp.Regexp

var dg *discorder.Discorder

func init() {
	// [2023-11-19T17:46:44.985025057Z] [18:35:28] [Server thread/INFO]: darkwind joined the game
	RegexPlayerJoined = utils.InitRegexExpression(`([0-9-:Z.T]+) \[[0-9-:]+\] \[Server thread\/INFO\]\: ([^ ]+) joined the game`)

	// [2023-11-19T17:46:44.985025057Z] [18:40:21] [Server thread/INFO]: <darkwind> writing something
	// captured=[18:40:38] [Server thread/INFO]: <darkwind> bla bla bla
	RegexPlayerMessage = utils.InitRegexExpression(`([0-9-:Z.T]+) \[[0-9-:]+\] \[Server thread\/INFO\]\: <([^ ]+)> (.*)`)

	// [2023-11-19T17:46:44.985025057Z] [18:35:31] [Server thread/INFO]: darkwind left the game
	RegexPlayerLeft = utils.InitRegexExpression(`([0-9-:Z.T]+) \[[0-9-:]+\] \[Server thread\/INFO\]\: ([^ ]+) left the game`)

	// [2023-11-19T17:46:44.985025057Z] [18:39:57] [Server thread/INFO]: darkwind has just earned the achievement [Taking Inventory]
	RegexPlayerAchievement = utils.InitRegexExpression(`([0-9-:Z.T]+) \[[0-9-:]+\] \[Server thread\/INFO\]\: ([^ ]+) has just earned the achievement ([\[\]\w\s]+)`)

	dg = discorder.NewClient()
}

// Bot staging invite link
// https://discord.com/api/oauth2/authorize?client_id=1173347963536416838&permissions=68608&scope=bot

// Bot prod invite link
// https://discord.com/api/oauth2/authorize?client_id=1173352014076448818&permissions=68608&scope=bot

func main() {
	loopDelay := time.Second * 30
	for {
		logus.Info("next RunBot loop for minecrafter")
		utils.ShellRunArgs(reactToEvent, loopDelay, "docker", "logs", "minecraft", "--timestamps", "--tail", "100", "-f")
	}
}
