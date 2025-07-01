# Build stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 5000


FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Bioskopina/BioskopinaAPI.csproj", "Bioskopina/"]
RUN dotnet restore "Bioskopina/BioskopinaAPI.csproj"
COPY . .
WORKDIR "/src/Bioskopina"
RUN dotnet build "BioskopinaAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BioskopinaAPI.csproj" -c Release -o /app/publish /p:UseAppMost=false

# Build and publish
WORKDIR "/src/Bioskopina"
RUN dotnet publish "BioskopinaAPI.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "BioskopinaAPI.dll"]