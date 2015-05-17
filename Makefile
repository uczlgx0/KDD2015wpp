WORKING_DIR=$(shell pwd)
DOCKER_RUN=docker run --rm -v $(WORKING_DIR):/var/local/KDD2015wpp kdd2015wpp

all :

ipinyou.contest.dataset.zip :
	echo "please download the \"ipinyou.contest.dataset.zip\" from \"http://data.computational-advertising.org/\""

.ipinyou.contest.dataset : ipinyou.contest.dataset.zip
	unzip ipinyou.contest.dataset.zip && touch .ipinyou.contest.dataset

.dockerbuild : Dockerfile
	docker build -t kdd2015wpp . && touch .dockerbuild

.decompress : .ipinyou.contest.dataset
	$(DOCKER_RUN) find ipinyou.contest.dataset/training2nd -name "*.bz2" -exec bunzip2 -f {} \;
	$(DOCKER_RUN) find ipinyou.contest.dataset/training3rd -name "*.bz2" -exec bunzip2 -f {} \;
	touch .decompress

.preparedata : .dockerbuild .decompress
	-mkdir -p cache/
	$(DOCKER_RUN) Rscript PrepareData.R