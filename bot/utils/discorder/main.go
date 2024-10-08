/*
interface
- to capture message history from channel (internal)
- to create or replace message in channel (public?)
- delete message from channel (public?)
*/

package discorder

import (
	"fmt"
	"strings"
	"time"

	"github.com/darklab8/infra-game-servers/bot/utils/logus"
	"github.com/darklab8/infra-game-servers/bot/utils/shared_settings"
	"github.com/darklab8/infra-game-servers/bot/utils/types"

	"github.com/bwmarrin/discordgo"
)

type Discorder struct {
	dg *discordgo.Session
}

func NewClient() *Discorder {
	d := &Discorder{}

	dg, err := discordgo.New("Bot " + shared_settings.DiscordBotToken)
	logus.CheckFatal(err, "failed to init discord")
	dg.Identify.Intents = discordgo.IntentsGuildMessages

	d.dg = dg
	return d
}

func (d Discorder) SengMessage(channelID types.DiscordChannelID, content string) error {
	_, err := d.dg.ChannelMessageSend(string(channelID), content)
	logus.CheckWarn(err, "failed sending message in discorder", logus.ChannelID(channelID))
	return err
}

func (d Discorder) EditMessage(channelID types.DiscordChannelID, messageID types.DiscordMessageID, content string) error {
	_, err := d.dg.ChannelMessageEdit(string(channelID), string(messageID), content)
	logus.CheckWarn(err, "failed editing message in discorder", logus.ChannelID(channelID))
	return err
}

func (d Discorder) DeleteMessage(channelID types.DiscordChannelID, messageID types.DiscordMessageID) {
	err := d.dg.ChannelMessageDelete(string(channelID), string(messageID))
	logus.CheckWarn(err, "failed deleting message in discorder", logus.ChannelID(channelID))
}

type DiscordMessage struct {
	ID        types.DiscordMessageID
	Content   string
	Timestamp time.Time
}

func (d Discorder) GetLatestMessages(channelID types.DiscordChannelID) ([]DiscordMessage, error) {
	messagesLimitToGrab := 100 // max 100
	messages, err := d.dg.ChannelMessages(string(channelID), messagesLimitToGrab, "", "", "")
	if logus.CheckWarn(err, "Unable to get messages from channelId=", logus.ChannelID(channelID)) {
		return []DiscordMessage{}, err
	}

	result := []DiscordMessage{}

	for _, msg := range messages {
		result = append(result, DiscordMessage{
			ID:        types.DiscordMessageID(msg.ID),
			Content:   msg.Content,
			Timestamp: msg.Timestamp,
		})
	}

	// Just to be sure to have it deleted
	for index, _ := range messages {
		for index2, _ := range messages[index].Attachments {
			messages[index].Attachments[index2] = nil
		}
		for index2, _ := range messages[index].Embeds {
			messages[index].Embeds[index2] = nil
		}
		for index2, _ := range messages[index].MentionChannels {
			messages[index].MentionChannels[index2] = nil
		}
		for index2, _ := range messages[index].Mentions {
			messages[index].Mentions[index2] = nil
		}
		for index2, _ := range messages[index].Reactions {
			messages[index].Reactions[index2] = nil
		}
		for index2, _ := range messages[index].StickerItems {
			messages[index].StickerItems[index2] = nil
		}
		messages[index] = nil
	}
	messages = nil

	return result, nil
}

/////

type deduplicator struct {
	repeatCheckers []func(msgs []DiscordMessage) bool
}

type Stringable interface {
	ToString() string
}

func NewRepeatChecker[T Stringable](obj T) func(msgs []DiscordMessage) bool {
	DeduplicatorByTime := func(msgs []DiscordMessage) bool {
		for _, message := range msgs {
			if strings.Contains(message.Content, obj.ToString()) {
				return true
			}
		}

		if parsed_time1, err := time.Parse(time.RFC3339Nano, obj.ToString()); err == nil {
			fmt.Println("managed to parse time for repeat checker")
			if parsed_time1.Before(time.Now().Add(-10 * time.Minute)) {
				return true
			}
		}

		return false
	}
	return DeduplicatorByTime
}

func NewDeduplicater(repeatCheckers ...func(msgs []DiscordMessage) bool) *deduplicator {
	d := &deduplicator{
		repeatCheckers: repeatCheckers,
	}
	return d
}

func (d *deduplicator) isDuplicated(msgs []DiscordMessage) bool {
	for _, checker := range d.repeatCheckers {
		if checker(msgs) {
			return true
		}
	}
	return false
}

func (dg Discorder) SendDeduplicatedMsg(deduplicator *deduplicator, msg string, channels ...types.DiscordChannelID) {

	for _, channel := range channels {
		// Docker timestamp is having precise timestamp up to milliseconds
		// good enough for deduplicating
		logus.Info("sent_message= " + msg)

		msgs, err := dg.GetLatestMessages(channel)

		logus.CheckError(err, "failed to get discord latest msgs")
		if err != nil {
			continue
		}

		if deduplicator.isDuplicated(msgs) {
			continue
		}

		dg.SengMessage(channel, msg)
	}
}
