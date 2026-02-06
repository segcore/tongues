input <- file("README.md", "rb")
output <- file("/dev/stdout", "wb", raw=TRUE)
open(input)
repeat {
    data <- readBin(input, what="raw", n=1024);
    writeBin(data, output);
    if (length(data) == 0) break;
}
close(input)
close(output)
