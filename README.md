
<h1 style="text-align: center;"> GO DOWNLOADER </h1><br/>
<center>
<img src="https://github.com/ProgramYazar/go-downloader/blob/master/go_downloader.png?raw=true"/>
</center>
### DESCRIPTION

Multi thread downloader on go language. You can install this package like this:

$ ` go get -u github.com/ProgramYazar/go-downloader`

If you haven't installed Go Language on your computer, you can use compiled binaries under dist/ folder.

### USAGE

	go-downloader -file links_file.txt -j cpu_count -w worker_count_per_cpu

* j: Active cpu count
* w: Active worker count per cpu

File format must be like this

	filename-1
	link-1
	filename-2
	link-2
	...

empty lines aren't important...



### EXAMPLE

Download videos from youtube as parallel...

	wget https://raw.githubusercontent.com/ProgramYazar/go-downloader/master/create_links.sh
	chmod +x create_links.sh
	./create_links.sh http://youtube-link....
	go-downloader -file playlist.txt -j 4 -w 2

Note: create_links.sh use [youtube-dl](https://github.com/rg3/youtube-dl) project.
