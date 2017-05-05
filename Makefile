FILENAME=downloader.go
DIST_FOLDER=dist
COMPILE_FLAG="-s -w"

all:
	go get ./...

compileForPlatforms:

	# build for all platforms
	GOOS=windows GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_win_i386.exe $(FILENAME)
	GOOS=windows GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_win_amd64.exe $(FILENAME)
	GOOS=darwin GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_mac_i386 $(FILENAME)
	GOOS=darwin GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_mac_amd64 $(FILENAME)
	GOOS=linux GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_linux_i386 $(FILENAME)
	GOOS=linux GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_linux_amd64 $(FILENAME)
	GOOS=freebsd GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_freebsd_i386 $(FILENAME)
	GOOS=freebsd GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_freebsd_amd64 $(FILENAME)
	GOOS=netbsd GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_netbsd_i386 $(FILENAME)
	GOOS=netbsd GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_netbsd_amd64 $(FILENAME)
	GOOS=plan9 GOARCH=386 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_plan9_i386 $(FILENAME)
	GOOS=plan9 GOARCH=amd64 go build -ldflags=$(COMPILE_FLAG) -o $(DIST_FOLDER)/go-download_plan9_amd64 $(FILENAME)
	# compress them
	find dist/ -type f -exec zip {}.zip {} \; -exec rm -f {} \;

clean:
	rm -f dist/*

download:
	@echo "Download started"
	go-downloader
