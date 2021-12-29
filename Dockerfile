FROM nimlang/nim as build
COPY ens.nim .
RUN nim c -d:release ens.nim
RUN mkdir in
ENTRYPOINT [ "./ens" ]

# TODO: make static
# FROM scratch
# COPY --from=build /ens ens
# CMD ["./ens"]