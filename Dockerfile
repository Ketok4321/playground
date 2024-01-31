FROM mcr.microsoft.com/dotnet/sdk:8.0 as whereso
RUN apt-get update && apt-get -y install git clang zlib1g-dev
WORKDIR /src
RUN git clone https://github.com/Ketok4321/WhereEsolang --branch v0.2.2 --single-branch
WORKDIR /src/WhereEsolang
RUN cd src && dotnet publish WhereEsolang.Cli -c Release

FROM mcr.microsoft.com/dotnet/sdk:8.0 as advancedeso
RUN apt-get update && apt-get -y install git clang zlib1g-dev
WORKDIR /src
RUN git clone https://github.com/Ketok4321/AdvancedEsolang --single-branch
WORKDIR /src/AdvancedEsolang
RUN dotnet publish AdvancedEsolang.Cli -c Release -r linux-x64 --self-contained -p:PublishAot=true -p:InvariantGlobalization=true

FROM debian:bookworm-slim
RUN apt-get update && apt-get -y --no-install-recommends install vim-tiny curl less && apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /root
COPY --from=whereso /src/WhereEsolang/src/WhereEsolang.Cli/bin/Release/net8.0/linux-x64/publish/WhereEsolang.Cli /usr/local/bin/whereso
COPY --from=whereso /src/WhereEsolang/samples whereso/samples
COPY --from=advancedeso /src/AdvancedEsolang/AdvancedEsolang.Cli/bin/Release/net8.0/linux-x64/publish/AdvancedEsolang.Cli /usr/local/bin/adv
COPY --from=advancedeso /src/AdvancedEsolang/extra adv/extra
COPY --from=advancedeso /src/AdvancedEsolang/samples adv/samples
COPY --from=advancedeso /src/AdvancedEsolang/std adv/std
COPY --from=advancedeso /src/AdvancedEsolang/tests adv/tests
COPY home . 
ENV TERM=xterm-256color
CMD [ "/bin/bash" ]
