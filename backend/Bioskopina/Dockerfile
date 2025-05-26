#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MAG/MAG.csproj", "MAG/"]
RUN dotnet restore "MAG/MAG.csproj"
COPY . .
WORKDIR "/src/MAG"
RUN dotnet build "MAG.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MAG.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "MAG.dll"]