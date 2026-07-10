QUESTA := /home/share/questa.csh
SHELL := /bin/csh
TEST ?= apb_master_test

# ANSI Colors
RED     := \033[1;31m
GREEN   := \033[1;32m
YELLOW  := \033[1;33m
BLUE    := \033[1;34m
MAGENTA := \033[1;35m
CYAN    := \033[1;36m
RESET   := \033[0m

COLORIZE = perl -pe '\
s/Error/\e[1;31m$$&\e[0m/g; \
s/ERROR/\e[1;31m$$&\e[0m/g; \
s/Warning/\e[1;33m$$&\e[0m/g; \
s/WARNING/\e[1;33m$$&\e[0m/g; \
s/Fatal/\e[1;35m$$&\e[0m/g; \
s/FATAL/\e[1;35m$$&\e[0m/g;'

.ONESHELL:	
all:
	make com
	make sim
	make cov
	make pu

com:
	@echo "\t\t\t\t$(RED)........................................................ COMPILING CODE .........................................................$(RESET)"
	source $(QUESTA)
	vlog -sv +acc +cover +fcover -l src/simulation/log_file.log src/verification/apb_top.sv |& $(COLORIZE)
	
sim:
	@echo "\t\t\t\t$(GREEN)................................................... SIMULATING TEST = $(TEST) ...................................................$(RESET)"
	source $(QUESTA)
	vsim -vopt work.apb_top -voptargs=+acc=npr -assertdebug -l src/simulation/log_file.log -coverage -c -do "coverage save -onexit -assert -directive -cvg -codeAll src/simulation/ucdb_file.ucdb; run -all; exit" |& $(COLORIZE)

cov:
	@echo "\t\t\t\t$(MAGENTA).................................................... CREATING COVERAGE REPORT ...................................................$(RESET)"
	source $(QUESTA)
	vcover report -html src/simulation/ucdb_file.ucdb -htmldir src/simulation/covReport -details |& $(COLORIZE)
	
pu:
	@echo "\t\t\t\t$(GREEN)....................................................... PUSHING TO GIT REPO ......................................................$(RESET)"
	git add .
	git commit -m 'commiting'
	git push |& $(COLORIZE)


