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
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(types.DockerTimestamp(player_joined[1])), fmt.Sprintf("[%s] player %s joined the server", player_joined[1], player_joined[2]), shared_settings.Channel)
	}

	if player_message := RegexPlayerMessage.FindStringSubmatch(line); len(player_message) > 0 && player_message[2] != "Server" {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(types.DockerTimestamp(player_message[1])), fmt.Sprintf("[%s] <%s>: %s", player_message[1], player_message[2], player_message[3]), shared_settings.Channel)
	}

	if player_left := RegexPlayerLeft.FindStringSubmatch(line); len(player_left) > 0 {
		dg.SendDeduplicatedMsg(discorder.NewDeduplicater(types.DockerTimestamp(player_left[1])), fmt.Sprintf("[%s] player %s left the server", player_left[1], player_left[2]), shared_settings.Channel)
	}

	if captain := RegexCaptainFinished.FindStringSubmatch(line); len(captain) > 0 {
		shipname := captain[2]
		timestamp := captain[1]
		msg := fmt.Sprintf("%s ship %s finished its job", captain[1], captain[2])

		logus.Debug("preparting deduplicater")
		deduplicate_jobs := func(msgs []discorder.DiscordMessage) bool {
			for _, msg := range msgs {
				if strings.Contains(msg.Content, "Miner05") {
					logus.Debug("checking msg=" + msg.Content)
				}

				if otherFinishedJob := RegexCaptainFinishedPrinted.FindStringSubmatch(msg.Content); len(otherFinishedJob) > 0 {
					other_timestamp := otherFinishedJob[1]
					other_shipname := otherFinishedJob[2]
					logus.Debug("found against what to match " + shipname + "," + other_shipname)

					parsed_time2, err := time.Parse(time.RFC3339Nano, other_timestamp)
					if logus.CheckWarn(err, "failed to parse other_timestamp") {
						return false
					}

					parsed_time1, err := time.Parse(time.RFC3339Nano, timestamp)
					if logus.CheckWarn(err, "failed to parse timestamp") {
						return false
					}

					difference := parsed_time1.Sub(parsed_time2)

					logus.Debug("parsed all preparations to decuple for " + shipname)
					if difference < time.Second*5 && shipname == other_shipname {
						logus.Debug("log duplicating by is true for shipname=" + shipname)
						return true
					}
				}
			}
			return false
		}
		dedup := discorder.NewDeduplicater(types.DockerTimestamp(timestamp), deduplicate_jobs)

		if strings.Contains(shipname, "LAW-") {
			logus.Info("Recognized as lawey's ship")
			dg.SendDeduplicatedMsg(dedup, fmt.Sprintf("<@302481451973214209> %s", msg), avorioner_settings.OthersChannel)
		} else if strings.Contains(shipname, "CPM-") {
			logus.Info("Recognized as couden's ship")
			dg.SendDeduplicatedMsg(dedup, fmt.Sprintf("<@328587807071272970> %s", msg), avorioner_settings.OthersChannel)
		} else if strings.Contains(shipname, "COM-") {
			logus.Info("Recognized as Сommandantt's ship")
			dg.SendDeduplicatedMsg(dedup, fmt.Sprintf("<@297460626576506881> %s", msg), avorioner_settings.OthersChannel)
		} else if strings.Contains(shipname, "GSS-") {
			logus.Info("Recognized as Groshyr's ship")
			dg.SendDeduplicatedMsg(dedup, fmt.Sprintf("<@1066759106377035907> %s", msg), avorioner_settings.OthersChannel)
		} else if strings.Contains(shipname, "DARK-") {
			logus.Info("Recognized as darkwind's ship")
			dg.SendDeduplicatedMsg(dedup, fmt.Sprintf("<@370435997974134785> %s", msg), avorioner_settings.DarkwindChannel)
		} else {
			logus.Info("Ship is not recognized")
			dg.SendDeduplicatedMsg(dedup, msg, avorioner_settings.OthersChannel)
		}
	}
}

var RegexPlayerJoined *regexp.Regexp
var RegexPlayerLeft *regexp.Regexp
var RegexPlayerMessage *regexp.Regexp
var RegexCaptainFinished *regexp.Regexp
var RegexCaptainFinishedPrinted *regexp.Regexp

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
	RegexCaptainFinishedPrinted = utils.InitRegexExpression(`([0-9-:Z.T]+) ship ([^ ]+) finished its job`)

	dg = discorder.NewClient()
}

func main() {
	loopDelay := time.Second * 30
	for {
		logus.Info("next RunBot loop for avorioner")
		utils.ShellRunArgs(reactToEvent, loopDelay, "docker", "logs", "avorion", "--timestamps", "--tail", "100", "-f")
	}
}
