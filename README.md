### DESCRIPTION

multi threaded downloader on go language. You can install package like this:

`go -get github.com/ProgramYazar/go-downloader`

If you havent installed golang on your computer, you can use compiled binaries under dist folder

### USAGE

`go-downloader -file links_file.txt -j cpu_count -w worker_count_per_cpu`

`j`: Active cpu count
`w`: Active worker count per cpu

File format must be like this
> download file location 1 <br/>
> download link 1 <br/>
> download file location 2 <br/>
> download link 2

empty lines aren't important...



### example
`go-downloader -file links_file.txt -j 4 -w 2`

If you want to use this program with `youtube-dl`, you must to extract file infos and links without download file.
