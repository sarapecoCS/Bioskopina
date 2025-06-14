# Dockerfile za API (Bioskopina)

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["Bioskopina/Bioskopina.csproj", "Bioskopina/"]
RUN dotnet restore "Bioskopina/Bioskopina.csproj"
COPY . .
WORKDIR "/src/Bioskopina"
RUN dotnet build "Bioskopina.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Bioskopina.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "Bioskopina.dll"]
