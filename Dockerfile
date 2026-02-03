FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy csproj and restore
COPY ["ValentineSite.csproj", "."]
RUN dotnet restore "ValentineSite.csproj"

# Copy everything else and build
COPY . .
RUN dotnet build "ValentineSite.csproj" -c Release -o /app/build

# Publish
RUN dotnet publish "ValentineSite.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .
ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE ${PORT}
ENTRYPOINT ["dotnet", "ValentineSite.dll"]