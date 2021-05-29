# New release: make build v=1.0.0

# Install all building dependencies by command:
# sudo apt install upx zip && go get -u golang.org/x/vgo && go get -u github.com/go-bindata/go-bindata/...

# Detailed dependencies
# Install upx and zip tool to use this script
# Install go tools:
# - vgo // https://pkg.go.dev/golang.org/x/vgo
# - go-bindata // https://github.com/go-bindata/go-bindata

###################################
##### CONFIGURATION ###############
###################################

# The app build version
# This flag is required for release versions because a specific version-depended folder will be created inside ./dist/
# In other way, the VERSION value will be equal "dev"
VERSION = $(if $(strip $(v)),$(v),dev)

# Build time in format "DAY.MONTH.YEAR HOURS.MINUTES"
BUILD = $(shell date "+%d.%m.%y %H:%M")

# Go actual version to compile for modern systems
GO=/snap/go/current/bin/go
GOROOT=/snap/go/current
# Go 1.10 (vgo) compiler to compile for legacy systems
VGO=~/go/bin/vgo
VGOROOT=~/go/go1.10.8

# Compiler LDFLAGS to optimize binary and inject some information
LDFLAGS=-s -w -X 'rodb/app/build.Version=${VERSION}' -X 'rodb/app/build.Time=${BUILD}'

# App out path
NAME=rodb

# Build destination folder
DIST_F=./dist
# Assets folder which will be embedded in binary
ASSETS_F=./assets

# Distro folder for legacy versions of windows
WINLEGACY=windows-legacy
WINLEGACY_F=${DIST_F}/${WINLEGACY}
# Distro folder for modern versions of x32 windows
WIN32=windows-32
WIN32_F=${DIST_F}/${WIN32}
# Distro folder for modern versions of x64 windows
WIN64=windows-64
WIN64_F=${DIST_F}/${WIN64}
# Distro folder for modern versions of x32 linux
LIN32=linux-32
LIN32_F=${DIST_F}/${LIN32}
# Distro folder for modern versions of x64 linux
LIN64=linux-64
LIN64_F=${DIST_F}/${LIN64}
# Distro folder for modern versions of x32 ARM linux
LINARM32=linux-arm-32
LINARM32_F=${DIST_F}/${LINARM32}
# Distro folder for modern versions of x64 ARM linux
LINARM64=linux-arm-64
LINARM64_F=${DIST_F}/${LINARM64}

###################################
##### LOCAL HELPERS ###############
###################################

# Build info
help:
	@echo "help            - This help"
	@echo "run             - Run the app with vgo (go1.10)"
	@echo "run-modern      - Run the app with actual go version"
	@echo "build [v={VER}] - Start building for all systems & make a distro"
.PHONY: help

# Prepare resources before building
_prepare:
	@mkdir -p ${DIST_F}
	@go-bindata -o app/assets/bindata.go -pkg assets ${ASSETS_F}
.PHONY: _prepare

###################################
##### BUILDERS ####################
###################################

# Installs all build toolchain
install:
	apt install golang-go upx zip && go get -u golang.org/x/vgo && vgo get -u github.com/go-bindata/go-bindata/...
.PHONY: install

# Runs the app for current system in legacy mode due compatibility
run: _prepare
	@GO111MODULE=on VGOROOT=${VGOROOT} ${VGO} run -ldflags="${LDFLAGS}" .
.PHONY: run

# Runs the app for current system in modern mode
run-modern: _prepare
	@GOROOT=${GOROOT} ${GO} run -ldflags="${LDFLAGS}" .
.PHONY: run-modern

# Make build for all systems
build: _prepare build-win-legacy build-win-32 build-win-64 build-lin-32 build-lin-64 build-lin-arm-32 build-lin-arm-64
	@mkdir -p ${DIST_F}/${VERSION}
	@mv ${DIST_F}/*.zip ${DIST_F}/${VERSION}
	@cd ${DIST_F}/${VERSION} && zip -9 dist.zip ./* > /dev/null
	@mv ${DIST_F}/${VERSION}/dist.zip ${DIST_F}/${VERSION}.zip
	@rm -rf ${DIST_F}/${VERSION}
	@echo "Build finished!"
.PHONY: build

# Make build for legacy windows versions
# Support starts with Windows XP x32
build-win-legacy:
	@echo "Building for Windows Legacy x32"
	@mkdir -p ${WINLEGACY_F}
	@GO111MODULE=on GOOS=windows GOARCH=386 VGOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${WINLEGACY_F}/${NAME}.exe .
	@upx ${WINLEGACY_F}/${NAME}.exe > /dev/null
	@cd ${WINLEGACY_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${WINLEGACY_F}/dist.zip ${DIST_F}/${WINLEGACY}.zip
	@rm -rf ${WINLEGACY_F}
.PHONY: build-win-leagcy

# Make build for modern windows versions x32
# Support starts with Windows 7 x32
build-win-32:
	@echo "Building for Windows x32"
	@mkdir -p ${WIN32_F}
	@GOOS=windows GOARCH=386 GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${WIN32_F}/${NAME}.exe .
	@upx ${WIN32_F}/${NAME}.exe > /dev/null
	@cd ${WIN32_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${WIN32_F}/dist.zip ${DIST_F}/${WIN32}.zip
	@rm -rf ${WIN32_F}
.PHONY: build-win-32

# Make build for modern windows versions x64
# Support starts with Windows 7 x64
build-win-64:
	@echo "Building for Windows x64"
	@mkdir -p ${WIN64_F}
	@GOOS=windows GOARCH=amd64 GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${WIN64_F}/${NAME}.exe .
	@upx ${WIN64_F}/${NAME}.exe > /dev/null
	@cd ${WIN64_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${WIN64_F}/dist.zip ${DIST_F}/${WIN64}.zip
	@rm -rf ${WIN64_F}
.PHONY: build-win-32

# Make build for modern linux versions x32
build-lin-32:
	@echo "Building for Linux x32"
	@mkdir -p ${LIN32_F}
	@GOOS=linux GOARCH=386 GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${LIN32_F}/${NAME} .
	@upx ${LIN32_F}/${NAME} > /dev/null
	@cd ${LIN32_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${LIN32_F}/dist.zip ${DIST_F}/${LIN32}.zip
	@rm -rf ${LIN32_F}
.PHONY: build-lin-32

# Make build for modern linux versions x64
build-lin-64:
	@echo "Building for Linux x64"
	@mkdir -p ${LIN64_F}
	@GOOS=linux GOARCH=amd64 GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${LIN64_F}/${NAME} .
	@upx ${LIN64_F}/${NAME} > /dev/null
	@cd ${LIN64_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${LIN64_F}/dist.zip ${DIST_F}/${LIN64}.zip
	@rm -rf ${LIN64_F}
.PHONY: build-lin-64

# Make build for modern linux ARM versions x32
build-lin-arm-32:
	@echo "Building for Linux ARM x32"
	@mkdir -p ${LINARM32_F}
	@GOOS=linux GOARCH=arm GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${LINARM32_F}/${NAME} .
	@upx ${LINARM32_F}/${NAME} > /dev/null
	@cd ${LINARM32_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${LINARM32_F}/dist.zip ${DIST_F}/${LINARM32}.zip
	@rm -rf ${LINARM32_F}
.PHONY: build-lin-arm-32

# Make build for modern linux ARM versions x64
build-lin-arm-64:
	@echo "Building for Linux ARM x64"
	@mkdir -p ${LINARM64_F}
	@GOOS=linux GOARCH=arm64 GOROOT=${GOROOT} ${GO} build -ldflags="${LDFLAGS}" -o ${LINARM64_F}/${NAME} .
	@upx ${LINARM64_F}/${NAME} > /dev/null
	@cd ${LINARM64_F} && zip -9 dist.zip ./* > /dev/null
	@mv ${LINARM64_F}/dist.zip ${DIST_F}/${LINARM64}.zip
	@rm -rf ${LINARM64_F}
.PHONY: build-lin-arm-64