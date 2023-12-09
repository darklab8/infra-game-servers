package types

type RegexExpression string

type LogLevel string

type FilePath string

type DiscordChannelID string

type DiscordMessageID string

type DockerTimestamp string

func (d DockerTimestamp) ToString() string { return string(d) }

type Stringing string

func (d Stringing) ToString() string { return string(d) }
