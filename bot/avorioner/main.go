package main

import (
	"darklab_minecraft/bot/avorioner/avorioner_settings"
	"darklab_minecraft/bot/utils"
	"darklab_minecraft/bot/utils/discorder"
	"darklab_minecraft/bot/utils/logus"
	"darklab_minecraft/bot/utils/shared_settings"
	"darklab_minecraft/bot/utils/types"
	"fmt"
	"regexp"
	"strings"
	"time"
)

func reactToEvent(line string) {
	// // logus.Info("sending= " + line)
	if player_joined := RegexPlayerJoined.FindStringSubmatch(line); len(player_joined) > 0 {
		dg.SendDecoupledMsg(types.DockerTimestamp(player_joined[1]), fmt.Sprintf("[%s] player %s joined the server", player_joined[1], player_joined[2]), shared_settings.Channel)
	}

	if player_message := RegexPlayerMessage.FindStringSubmatch(line); len(player_message) > 0 && player_message[2] != "Server" {
		dg.SendDecoupledMsg(types.DockerTimestamp(player_message[1]), fmt.Sprintf("[%s] <%s>: %s", player_message[1], player_message[2], player_message[3]), shared_settings.Channel)
	}

	if player_left := RegexPlayerLeft.FindStringSubmatch(line); len(player_left) > 0 {
		dg.SendDecoupledMsg(types.DockerTimestamp(player_left[1]), fmt.Sprintf("[%s] player %s left the server", player_left[1], player_left[2]), shared_settings.Channel)
	}

	if captain := RegexCaptainFinished.FindStringSubmatch(line); len(captain) > 0 {
		shipname := captain[2]

		if strings.Contains(shipname, "LAW-") {
			logus.Info("Recognized as lawey's ship")
			dg.SendDecoupledMsg(types.DockerTimestamp(captain[1]), fmt.Sprintf("<@302481451973214209> [%s] ship %s finished its job", captain[1], captain[2]), avorioner_settings.OthersChannel)
		} else if strings.Contains(shipname, "DARK-") || strings.Contains(shipname, "Explorer") || strings.Contains(shipname, "Miner") || strings.Contains(shipname, "Trader") || strings.Contains(shipname, "Scavenger") {
			logus.Info("Recognized as darkwind's ship")
			dg.SendDecoupledMsg(types.DockerTimestamp(captain[1]), fmt.Sprintf("<@370435997974134785> [%s] ship %s finished its job", captain[1], captain[2]), avorioner_settings.DarkwindChannel)
		} else {
			logus.Info("Ship is not recognized")
			dg.SendDecoupledMsg(types.DockerTimestamp(captain[1]), fmt.Sprintf("[%s] ship %s finished its job", captain[1], captain[2]), avorioner_settings.OthersChannel)
		}
	}
}

var RegexPlayerJoined *regexp.Regexp
var RegexPlayerLeft *regexp.Regexp
var RegexPlayerMessage *regexp.Regexp
var RegexCaptainFinished *regexp.Regexp

var dg *discorder.Discorder

func init() {
	// 2023-11-19T14:47:40.550983131Z <Server> Player Anarchist joined the galaxy
	RegexPlayerJoined = utils.InitRegexExpression(`([0-9-:Z.T]+) <Server> Player ([^ ]+) joined the galaxy`)

	// 2023-11-19T16:45:12.858565589Z <Anarchist> some msg
	RegexPlayerMessage = utils.InitRegexExpression(`([0-9-:Z.T]+) <([^ ]+)> (.*)`)

	// 2023-11-19T03:04:10.619815347Z <Server> Player Anarchist left the galaxy
	RegexPlayerLeft = utils.InitRegexExpression(`([0-9-:Z.T]+) <Server> Player ([^ ]+) left the galaxy`)

	// 2023-11-19T15:36:14.547639396Z Server: finishing Miner05 ...
	RegexCaptainFinished = utils.InitRegexExpression(`([0-9-:Z.T]+) Server\: finishing ([^ ]+) \.\.\.`)

	dg = discorder.NewClient()
}

func main() {
	loopDelay := time.Second * 30
	for {
		logus.Info("next RunBot loop for avorioner")
		utils.ShellRunArgs(reactToEvent, loopDelay, "docker", "logs", "avorion", "--timestamps", "--tail", "100", "-f")
	}
}
