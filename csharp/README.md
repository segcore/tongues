# C#

## Using Mono

### Installation

```sh
sudo apt install mono-devel
```

### Running

```sh
# mcs may be named csc in newer versions of mono
mcs cat.cs -out:cat
./cat < README.md
```

## Using dotnet

### Installation

```sh
sudo apt install dotnet-sdk-8.0
# and possibly
sudo apt install dotnet-runtime-8.0
```

### New projects the dotnet build system way

It does not seem to have an option to just build a file. You need to use an XML
file to define the build!

```sh
mkdir xxx
cd xxx
dotnet new console
dotnet build
dotnet run
```
