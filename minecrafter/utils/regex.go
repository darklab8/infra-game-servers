package utils

import (
	"darklab_minecraft/minecrafter/settings/logus"
	"darklab_minecraft/minecrafter/settings/types"
	"regexp"
	"runtime"
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
