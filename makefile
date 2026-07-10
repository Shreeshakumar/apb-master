QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= apb_master_test

.ONESHELL:	
all:
	make com
	make sim
	make cov
	make pu

com:
	@echo "\t\t\t\t........................................................ COMPILING CODE ........................................................."
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l src/simulation/log_file.log src/verification/apb_top.sv |& sed 's/Error/\x1b[1;31m&\x1b[0m/g'

sim:
	@echo "\t\t\t\t................................................... SIMULATING TEST = $(TEST) ..................................................."
	source $(QUESTA)
	vsim -vopt work.apb_top -voptargs=+acc=npr -assertdebug -l src/simulation/log_file.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll src/simulation/ucdb_file.ucdb; run -all; exit"

cov:
	@echo "\t\t\t\t.................................................... CREATING COVERAGE REPORT ..................................................."
	source $(QUESTA)
	vcover report -html src/simulation/ucdb_file.ucdb -htmldir src/simulation/covReport -details
	
pu:
	@echo "\t\t\t\t..........................................................COMPILING CODE........................................................."
	git add .
	git commit -m 'commiting'
	git push


