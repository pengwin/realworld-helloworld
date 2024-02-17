#! /bin/bash

# Run application
ASPNETCORE_URLS=http://::5080 dotnet run --project ./src/HelloWorld/HelloWorld.csproj --configuration Release
