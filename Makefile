build:
	nim c --passL:"-static -no-pie" ens.nim

run:
	nim c -r --verbosity:0 ens.nim

dbuild:
	docker build -t ens-scan .

drun:
	docker run -it -v `pwd`:/in/ ens-scan