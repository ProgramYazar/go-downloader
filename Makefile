FILENAME=downloader.go
DIST_FOLDER=dist
COMPILE_FLAG="-s -w"

all:
	go get ./...

compileForPlatforms:
	# parallel -j+0 --eta

	GOOS=windows GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/download_i386.exe $(FILENAME)
	GOOS=windows GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/download_amd64.exe $(FILENAME)
	GOOS=darwin GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/mac_i386 $(FILENAME)
	GOOS=darwin GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/mac_amd64 $(FILENAME)
	GOOS=linux GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/linux_i386 $(FILENAME)
	GOOS=linux GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/linux_amd64 $(FILENAME)
	GOOS=freebsd GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/freebsd_i386 $(FILENAME)
	GOOS=freebsd GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/freebsd_amd64 $(FILENAME)
	GOOS=netbsd GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/netbsd_i386 $(FILENAME)
	GOOS=netbsd GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/netbsd_amd64 $(FILENAME)
	GOOS=plan9 GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/plan9_i386 $(FILENAME)
	GOOS=plan9 GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/plan9_amd64 $(FILENAME)

download:
	@echo "Download started"
	go-downloader
