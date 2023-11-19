package utils

import (
	"context"
	"darklab_minecraft/bot/utils/logus"
	"fmt"
	"os/exec"
	"strings"
	"time"
)

type logCapturer struct {
	eventReactingCallback func(line string)
}

func NewLogCapturer(eventReactingCallback func(line string)) logCapturer {
	return logCapturer{eventReactingCallback: eventReactingCallback}
}

func (l logCapturer) Write(p []byte) (n int, err error) {
	lines := string(p)
	fmt.Printf("captured_lines=" + lines)
	for _, line := range strings.Split(lines, "\n") {
		l.eventReactingCallback(line)
	}
	return len(p), nil
}

func ShellRunArgs(eventReactingCallback func(line string), timeout time.Duration, program string, args ...string) {
	// we are allowed breaking logging rules for code not related to application.
	logus.Debug(fmt.Sprintf("attempting to run: %s %s\n", program, args))
	executable, _ := exec.LookPath(program)

	ctx := context.Background()
	if timeout > 0 {
		var cancel context.CancelFunc
		ctx, cancel = context.WithTimeout(context.Background(), timeout)
		defer cancel()
	}
	// args = append([]string{""}, args...)
	cmd := exec.CommandContext(ctx, executable, args...)
	cmd.Stdout = NewLogCapturer(eventReactingCallback)
	cmd.Stderr = NewLogCapturer(eventReactingCallback)
	err := cmd.Run()

	logus.CheckWarn(err, "unable to run command")
}
