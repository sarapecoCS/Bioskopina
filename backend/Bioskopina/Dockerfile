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

# Copy the published app
COPY --from=publish /app/publish .

# Copy UserPicture folder explicitly so images are inside container
COPY UserPicture /app/UserPicture

ENTRYPOINT ["dotnet", "Bioskopina.dll"]
