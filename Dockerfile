FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim as publish
ARG APP_NAME
WORKDIR /src
COPY ["src", "src/"]
RUN dotnet restore "src/${APP_NAME}/${APP_NAME}.csproj"

WORKDIR "/src/${APP_NAME}"
COPY /src .
RUN dotnet build "${APP_NAME}/${APP_NAME}.csproj" --configuration Release --output /app/build
RUN dotnet publish "${APP_NAME}/${APP_NAME}.csproj" \
  --configuration Release \
  --output /app/publish

FROM base AS final
ARG APP_NAME
WORKDIR /var/task
COPY --from=publish /app/publish .

# Install the agent
RUN apt-get update && apt-get install -y wget ca-certificates gnupg \
  && echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
  && wget https://download.newrelic.com/548C16BF.gpg \
  && apt-key add 548C16BF.gpg \
  && apt-get update \
  && apt-get install -y newrelic-netcore20-agent

# Enable the agent
ENV CORECLR_ENABLE_PROFILING=1 \
  CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
  CORECLR_NEWRELIC_HOME=/usr/local/newrelic-netcore20-agent \
  CORECLR_PROFILER_PATH=/usr/local/newrelic-netcore20-agent/libNewRelicProfiler.so

RUN ln -s ./${APP_NAME}.dll main.dll

ENTRYPOINT ["dotnet", "main.dll"]
