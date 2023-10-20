FROM mcr.microsoft.com/dotnet/sdk:7.0 as whereso
RUN apt-get update && apt-get -y install curl tar clang zlib1g-dev
WORKDIR /src
RUN curl https://github.com/Ketok4321/WhereEsolang/archive/refs/tags/v0.2.1.tar.gz -Lo /src/whereso.tar.gz
WORKDIR /src/whereso/
RUN tar -C /src/whereso -xvf /src/whereso.tar.gz --strip-components=1
RUN sed -i 's/net6.0/net7.0/g' src/WhereEsolang.*/WhereEsolang.*.fsproj # A hack to set the framework version to .NET 7
RUN cd src && dotnet publish WhereEsolang.Cli -c Release -r linux-x64 --self-contained -p:PublishAot=true -p:PublishSingleFile=false -p:InvariantGlobalization=true

FROM mcr.microsoft.com/dotnet/sdk:7.0 as advancedeso
RUN apt-get update && apt-get -y install git clang zlib1g-dev
WORKDIR /src
RUN git clone https://github.com/Ketok4321/AdvancedEsolang
WORKDIR /src/AdvancedEsolang
RUN dotnet publish AdvancedEsolang.Cli -c Release -r linux-x64 --self-contained -p:PublishReadyToRun=true -p:PublishSingleFile=true -p:InvariantGlobalization=true

FROM debian:bookworm-slim
RUN apt-get update && apt-get -y install vim curl less
WORKDIR /root
COPY --from=whereso /src/whereso/src/WhereEsolang.Cli/bin/Release/net7.0/linux-x64/publish/WhereEsolang.Cli /usr/local/bin/whereso
COPY --from=whereso /src/whereso/samples whereso/samples
COPY --from=advancedeso /src/AdvancedEsolang/AdvancedEsolang.Cli/bin/Release/net7.0/linux-x64/publish/AdvancedEsolang.Cli /usr/local/bin/adv
COPY --from=advancedeso /src/AdvancedEsolang/samples adv/samples
COPY --from=advancedeso /src/AdvancedEsolang/std adv/std
COPY --from=advancedeso /src/AdvancedEsolang/tests adv/tests
COPY home . 
ENV TERM=xterm-256color
CMD [ "/bin/bash" ]
