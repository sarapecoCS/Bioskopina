# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy project files
COPY ["Bioskopina/BioskopinaAPI.csproj", "Bioskopina/"]
COPY ["Bioskopina.Model/Bioskopina.Model.csproj", "Bioskopina.Model/"]
COPY ["Bioskopina.Services/Bioskopina.Services.csproj", "Bioskopina.Services/"]

# Restore dependencies
RUN dotnet restore "Bioskopina/BioskopinaAPI.csproj"

# Copy everything else
COPY . .

# Build and publish
WORKDIR "/src/Bioskopina"
RUN dotnet publish "BioskopinaAPI.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["dotnet", "BioskopinaAPI.dll"]