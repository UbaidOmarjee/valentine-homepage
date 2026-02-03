# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy csproj and restore dependencies
COPY *.sln .
COPY ValentineSite/*.csproj ./ValentineSite/
RUN dotnet restore

# Copy everything else and build the release
COPY ValentineSite/. ./ValentineSite/
WORKDIR /app/ValentineSite
RUN dotnet publish -c Release -o out

# Use the official ASP.NET Core runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/ValentineSite/out ./

# Expose the port Render provides
ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE ${PORT}

# Run the app
ENTRYPOINT ["dotnet", "ValentineSite.dll"]
