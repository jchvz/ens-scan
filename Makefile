build:
	nim c --passL:"-static -no-pie" -d:ssl ens.nim

run:
	nim c -r -d:ssl --verbosity:0 ens.nim

dbuild:
	docker build -t ens-scan .

drun:
	docker run -v `pwd`:/in/ ens-scan