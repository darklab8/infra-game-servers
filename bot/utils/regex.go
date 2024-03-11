package utils

import (
	"regexp"
	"runtime"

	"github.com/darklab8/infra-game-servers/bot/utils/logus"
	"github.com/darklab8/infra-game-servers/bot/utils/types"
)

func GetCurrentFile() types.FilePath {
	_, filename, _, _ := runtime.Caller(1)
	return types.FilePath(filename)
}

func InitRegexExpression(expression types.RegexExpression) *regexp.Regexp {
	regex, err := regexp.Compile(string(expression))
	logus.CheckFatal(err, "failed to init regex={%s} in ", logus.Regex(expression), logus.FilePath(GetCurrentFile()))
	return regex
}
