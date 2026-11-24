FROM swipl:latest

WORKDIR /workspace

RUN swipl -g "pack_install(lsp_server, [interactive(false)])" -t halt

CMD ["swipl"]
