# Use .NET 8.0 SDK for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ["ValentineSite.csproj", "."]
RUN dotnet restore "ValentineSite.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "ValentineSite.csproj" -c Release -o /app/build

# Publish
RUN dotnet publish "ValentineSite.csproj" -c Release -o /app/publish

# Use .NET 8.0 runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE ${PORT}
ENTRYPOINT ["dotnet", "ValentineSite.dll"]