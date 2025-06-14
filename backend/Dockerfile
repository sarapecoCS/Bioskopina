# Use ASP.NET 8 runtime base image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use .NET 8 SDK for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files and restore dependencies
COPY ["Bioskopina/Bioskopina.csproj", "Bioskopina/"]
RUN dotnet restore "Bioskopina/Bioskopina.csproj"

# Copy everything else and publish app
COPY . .
WORKDIR "/src/Bioskopina"
RUN dotnet publish "Bioskopina.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Final stage: runtime image
FROM base AS final
WORKDIR /app

# Copy published app from build stage
COPY --from=build /app/publish .

# Copy the UserPicture folder into the runtime image
COPY UserPicture /app/UserPicture

ENTRYPOINT ["dotnet", "Bioskopina.dll"]
