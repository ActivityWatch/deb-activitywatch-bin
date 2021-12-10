VERSION ?= "0.11.0"

build:
	bash debian-package.sh $(VERSION)

clean:
	rm -r activitywatch_v* activitywatch_0* *.zip 2> /dev/null
