FROM nimlang/nim
COPY ens.nim .
RUN nim c --passL:"-static -no-pie" -d:ssl -d:release ens.nim
RUN mkdir in
CMD ["./ens"]