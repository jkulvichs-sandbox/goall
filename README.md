# RODB :: Recruit Office DataBase

> Инструмент управления базами данных сборного пункта

# 💻 Минимальные систеные требования

- WindowsXP x32 SP1
- Linux x32 Any actual Kernel
- Linux ARM x32 Any actual Kernel

# 📦 Сборка проекта

Установите любую актуальную версию [GoLang 1.11+](https://golang.org/doc/install)  
Если планируется сборка под устаревшие системы, установите [Versioned Go](https://pkg.go.dev/golang.org/x/vgo)

Дополнительно потребуются инструменты:

- [go-bindata](https://github.com/go-bindata/go-bindata)

## 🏗 Автоматическая сборка

Проводится только на Unix-like системах через make.

Для Ubuntu-based систем выполните `sudo make install`
чтобы установить все необходимые инструменты сборки.

В файле make укажите параметры для переменных **GO, VGO, GOROOT, VGOROOT** в соответствии с вашими настройками.

Выполните `make build`.  
После компиляции вы получите дистрибутив в dist для всех доступных ОС.

## ✍ Ручная сборка

Подготовьте ассеты `go-bindata -o app/assets/bindata.go -pkg assets assets`

Сборка для актуальных систем `go build`  
Сборка для устаревших систем `vgo build`