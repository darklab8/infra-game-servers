package minecrafter

import (
	"darklab_minecraft/minecrafter/discorder"
	"darklab_minecraft/minecrafter/settings"
	"darklab_minecraft/minecrafter/settings/logus"
	"darklab_minecraft/minecrafter/utils"
	"fmt"
	"os/exec"
	"regexp"
	"strings"
)

type LogCapturer struct {
}

func (l LogCapturer) Write(p []byte) (n int, err error) {
	line := string(p)
	fmt.Printf("captured=" + line)
	reactToEvent(line)
	return len(p), nil
}

func sendMessage(msg string) {
	logus.Info("captured= " + msg)

	msgs, err := dg.GetLatestMessages(settings.Channel)

	logus.CheckError(err, "failed to get discord latest msgs")
	if err != nil {
		return
	}

	for _, message := range msgs {
		if strings.Contains(message.Content, msg) {
			return
		}
	}

	dg.SengMessage(settings.Channel, msg)
}

func reactToEvent(line string) {
	logus.Info("sending= " + line)

	if player_joined := RegexPlayerJoined.FindStringSubmatch(line); len(player_joined) > 0 {
		sendMessage(fmt.Sprintf("[%s] player %s joined the server", player_joined[1], player_joined[2]))
	}

	if player_message := RegexPlayerMessage.FindStringSubmatch(line); len(player_message) > 0 {
		sendMessage(fmt.Sprintf("[%s] player=%s said msg=%s", player_message[1], player_message[2], player_message[3]))
	}

	if player_left := RegexPlayerLeft.FindStringSubmatch(line); len(player_left) > 0 {
		sendMessage(fmt.Sprintf("[%s] player %s left the server", player_left[1], player_left[2]))
	}

	if achivement := RegexPlayerAchievement.FindStringSubmatch(line); len(achivement) > 0 {
		sendMessage(fmt.Sprintf("[%s] player %s has just earned the achievement %s", achivement[1], achivement[2], achivement[3]))
	}
}

func ShellRunArgs(program string, args ...string) {
	// we are allowed breaking logging rules for code not related to application.
	logus.Debug(fmt.Sprintf("attempting to run: %s %s\n", program, args))
	executable, _ := exec.LookPath(program)

	args = append([]string{""}, args...)
	command := exec.Cmd{
		Path:   executable,
		Args:   args,
		Stdout: LogCapturer{},
		Stderr: LogCapturer{},
	}
	err := command.Run()

	logus.CheckFatal(err, "unable to run command")
}

var RegexPlayerJoined *regexp.Regexp
var RegexPlayerLeft *regexp.Regexp
var RegexPlayerMessage *regexp.Regexp
var RegexPlayerAchievement *regexp.Regexp

var dg *discorder.Discorder

func init() {
	RegexPlayerJoined = utils.InitRegexExpression(`\[([0-9-:]+)\] \[Server thread\/INFO\]\: (\w+) joined the game`)
	RegexPlayerMessage = utils.InitRegexExpression(`\[([0-9-:]+)\] \[Server thread\/INFO\]\: <(\w+)> ([\w+\s+]+)$`)
	RegexPlayerLeft = utils.InitRegexExpression(`\[([0-9-:]+)\] \[Server thread\/INFO\]\: (\w+) left the game`)
	RegexPlayerAchievement = utils.InitRegexExpression(`\[([0-9-:]+)\] \[Server thread\/INFO\]\: (\w+) has just earned the achievement ([\[\]\w\s]+)$`)

	dg = discorder.NewClient()
}

func RunBot() {
	ShellRunArgs("docker", "logs", "minecraft", "-f")
}

// captured=[18:35:31] [Server thread/INFO]: darkwind left the game
// captured=[18:35:28] [Server thread/INFO]: darkwind joined the game
// captured=[18:39:57] [Server thread/INFO]: darkwind has just earned the achievement [Taking Inventory]
// captured=[18:40:21] [Server thread/INFO]: <darkwind> writing something
// captured=[18:40:38] [Server thread/INFO]: <darkwind> bla bla bla
