package logus

/*
Structured logging with slog. To provide more rich logging info.
Slightly modified for comfort

!NOTE: first msg is always text.
They keys and values are going in pairs//

Optionally as single value can be added slogGroup
*/

import (
	"fmt"
	"log/slog"
	"os"
	"path/filepath"
	"runtime"

	"github.com/darklab8/infra-game-servers/bot/utils/types"
)

var (
	Slogger *slog.Logger
)

func Debug(msg string, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	Slogger.Debug(msg, args...)
}

func Info(msg string, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	Slogger.Info(msg, args...)
}

func Warn(msg string, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	Slogger.Warn(msg, args...)
}

func Error(msg string, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	Slogger.Error(msg, args...)
}

func Fatal(msg string, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	Slogger.Error(msg, args...)
	panic(msg)
}

func CheckError(err error, msg string, opts ...slogParam) {
	if err == nil {
		return
	}
	args := append([]any{}, newSlogGroup(opts...))
	args = append(args, "error")
	args = append(args, fmt.Sprintf("%v", err))
	Slogger.Error(msg, args...)
	os.Exit(1)
}

func CheckFatal(err error, msg string, opts ...slogParam) {
	if err == nil {
		return
	}
	args := append([]any{}, newSlogGroup(opts...))
	args = append(args, "error")
	args = append(args, fmt.Sprintf("%v", err))
	Slogger.Error(msg, args...)
	panic(msg)
}

func CheckWarn(err error, msg string, opts ...slogParam) bool {
	if err == nil {
		return false
	}
	args := append([]any{}, newSlogGroup(opts...))
	args = append(args, "error")
	args = append(args, fmt.Sprintf("%v", err))
	Slogger.Warn(msg, args...)
	return true
}

func Debugf(msg string, varname string, value any, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	args = append(args, varname)
	args = append(args, fmt.Sprintf("%v", value))
	Slogger.Debug(msg, args...)
}

func Infof(msg string, varname string, value any, opts ...slogParam) {
	args := append([]any{}, newSlogGroup(opts...))
	if LOG_SHOW_FILE_LOCATIONS {
		args = append(args, logGroupFiles())
	}
	args = append(args, varname)
	args = append(args, fmt.Sprintf("%v", value))
	Slogger.Info(msg, args...)
}

var LOG_SHOW_FILE_LOCATIONS bool

func init() {
	LOG_SHOW_FILE_LOCATIONS = false

	var log_level types.LogLevel
	log_level_str, did_read := os.LookupEnv("GOLANG_LOG_LEVEL")
	if !did_read {
		log_level = LEVEL_INFO
	} else {
		log_level = types.LogLevel(log_level_str)
	}

	Slogger = NewLogger(log_level)
}

const (
	LEVEL_DEBUG types.LogLevel = "DEBUG"
	LEVEL_INFO  types.LogLevel = "INFO"
	LEVEL_WARN  types.LogLevel = "WARN"
	LEVEL_ERROR types.LogLevel = "ERROR"
)

func NewLogger(log_level_str types.LogLevel) *slog.Logger {
	var programLevel = new(slog.LevelVar) // Info by default

	switch log_level_str {
	case LEVEL_DEBUG:
		programLevel.Set(slog.LevelDebug)
	case LEVEL_INFO:
		programLevel.Set(slog.LevelInfo)
	case LEVEL_WARN:
		programLevel.Set(slog.LevelWarn)
	case LEVEL_ERROR:
		programLevel.Set(slog.LevelError)
	}

	turn_json := os.Getenv("GOLANG_LOG_JSON")
	if turn_json == "true" {
		return slog.New(slog.NewJSONHandler(os.Stdout, &slog.HandlerOptions{Level: programLevel}))
	}
	return slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{Level: programLevel}))
}

func GetCallingFile(level int) string {
	GetTwiceParentFunctionLocation := level
	_, filename, _, _ := runtime.Caller(GetTwiceParentFunctionLocation)
	filename = filepath.Base(filename)
	return fmt.Sprintf("f:%s ", filename)
}
