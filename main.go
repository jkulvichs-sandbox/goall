package main

import (
	"database/sql"
	"fmt"
	tgbotapi "github.com/go-telegram-bot-api/telegram-bot-api"
	"rodb/app/build"
	"runtime"
)

func main() {
	fmt.Println(runtime.Version())
	fmt.Println(build.Version, build.Time, sql.Drivers())
	fmt.Println(tgbotapi.Audio{})
}
