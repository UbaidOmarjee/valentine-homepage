# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copy solution file if exists
COPY *.sln ./

# Create directory and copy csproj (handles missing dirs)
RUN mkdir -p ValentineSite
COPY *.csproj ./ValentineSite/ 2>/dev/null || true
COPY ValentineSite/*.csproj ./ValentineSite/ 2>/dev/null || true

RUN dotnet restore

# Copy everything else
COPY . ./
WORKDIR /src/ValentineSite
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

# For Render.com
ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE ${PORT}

ENTRYPOINT ["dotnet", "ValentineSite.dll"]