package main

import (
	"bufio"
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"runtime"
	"strings"
	"sync"
	"time"
)

var (
	wg               sync.WaitGroup
	downloadTokens   chan *DownloadToken
	errorMessageLock sync.Mutex
)

// DownloadToken cover download info
type DownloadToken struct {
	filename string
	link     string
}

func checkErr(err error) {
	if err != nil {
		panic(err.Error())
	}
}

func showErrorAndExit(format string, args ...interface{}) {
	errorMessageLock.Lock()
	fmt.Fprintln(os.Stderr, "\n--------------------- ERROR ---------------------")
	fmt.Print("  ")
	if len(args) > 0 {
		fmt.Fprintf(os.Stderr, format, args...)
	} else {
		fmt.Fprintln(os.Stderr, format)
	}
	fmt.Fprintln(os.Stderr, "-------------------------------------------------")
	errorMessageLock.Unlock()
	os.Exit(2)
}

func (dt DownloadToken) outputFilename() string {
	outputFilename := dt.filename
	if !strings.HasSuffix(outputFilename, ".mp4") {
		outputFilename += ".mp4"
	}
	return outputFilename
}

func (t *DownloadToken) show() {
	fmt.Printf("Link: %s...\nDownload Location: %s\nStarted...\n", t.link[:20], t.outputFilename())
}

func (t *DownloadToken) download() {
	start := time.Now()
	outputFilename := t.outputFilename()

	if fileExists(outputFilename) {
		fmt.Printf("File: %s already exists! So i dont download it again...\n", outputFilename)
		return
	}
	file, err := os.Create(outputFilename)
	if err != nil {
		showErrorAndExit(err.Error())
	}
	defer file.Close()

	resp, err := http.Get(t.link)
	checkErr(err)
	defer resp.Body.Close()
	// show info label
	t.show()
	_, err = io.Copy(file, resp.Body)
	if err != nil {
		showErrorAndExit(err.Error())
	}
	deltaSecond := time.Now().Sub(start).Seconds()
	fmt.Printf("%s downloaded in %d seconds\n", t.outputFilename(), int(deltaSecond))
}

func downloadWorker() {
	for dt := range downloadTokens {
		dt.download()
		wg.Done()
	}
}

func fileExists(filename string) bool {
	_, err := os.Stat(filename)
	return err == nil
}

func getLine(s *bufio.Scanner) (string, error) {
	hasLine := s.Scan()
	if !hasLine {
		return "", io.EOF
	}
	line := strings.TrimSpace(s.Text())
	if line == "" { // if line is empty, get next line
		return getLine(s)
	}

	return line, nil

}

func main() {
	var (
		linksFile     string
		parallelCount int
		workerCount   int
	)

	cpuCount := runtime.NumCPU()
	if cpuCount > 2 {
		cpuCount /= 2
	}

	flag.StringVar(&linksFile, "file", "", "links file location")
	flag.IntVar(&parallelCount, "j", cpuCount, "parallel jobs count")
	flag.IntVar(&workerCount, "w", 1, "worker count")
	flag.Parse()

	if linksFile == "" || !fileExists(linksFile) {
		flag.Usage()
		showErrorAndExit("File: %s not found\n", linksFile)

	}

	downloadTokens = make(chan *DownloadToken)

	runtime.GOMAXPROCS(parallelCount)
	for i := 0; i < parallelCount*workerCount; i++ {
		go downloadWorker()
	}

	file, err := os.Open(linksFile)
	if err != nil {
		showErrorAndExit("link file couldnt opened")
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for {
		filename, err1 := getLine(scanner)
		link, err2 := getLine(scanner)

		if err1 != nil || err2 != nil {
			break
		}
		wg.Add(1)
		downloadTokens <- &DownloadToken{
			filename: filename,
			link:     link,
		}
	}

	wg.Wait()
	close(downloadTokens)

}
