FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Copy the .csproj file and restore the project's dependencies
COPY *.csproj ./
# Specify your DevExpress NuGet Feed URL as the package source
RUN dotnet nuget add source https://nuget.devexpress.com/NlzWh5nEU3W2DYBdfY4OXnOUmccW37hy6ATyYVQWwUDGrN59IG/api
RUN dotnet restore

# Copy project files and build the application
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Install the latest version of the libgdiplus library to use System.Drawing in the application
RUN apt update
RUN apt install -y libgdiplus libc6 libc6-dev libfontconfig1 
RUN apt install -y fontconfig libharfbuzz0b libfreetype6 libjpeg-turbo8 libskiasharp

# Optional. Install the ttf-mscorefonts-installer package 
# to use Microsoft TrueType core fonts in the application
RUN echo "deb http://ftp.debian.org/debian/ bullseye contrib" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y ttf-mscorefonts-installer  

FROM build-env AS final
WORKDIR /app
COPY --from=build-env /app/publish .
# Define the entry point for the application
ENTRYPOINT ["dotnet", "run"]
