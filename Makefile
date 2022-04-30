OUTPUT=output

n=\e[0m
g=\e[1;32m
r=\e[1;31m

TEST_DIRS = $(wildcard test/**/)
ASM = $(wildcard test/**/*.s)
MEM = $(ASM:%.s=%.mem)

# binutils-mips-linux-gnu is needed for assembleing.
%.elf: %.s
	mips-linux-gnu-as -march=r6000 $< -o $@

%.bin: %.elf
	dd skip=64 bs=1 if=$< of=$@ count=$$(expr $$(stat --printf="%s" $<) - 788)

%.mem: %.bin
	xxd -p -c1 $< $@

assemble: $(MEM)

INPUT ?= test/default/addiu

obj_dir/Vmips_machine: src/*.sv 323src/*.sv 323src/sim_main.cpp
	docker run -ti -v ${PWD}:/work												\
			verilator/verilator:latest --exe --build --cc --top mips_machine	\
					-Wno-BLKLOOPINIT											\
					`find src 323src -iname '*.v' -o -iname '*.sv'`				\
					323src/sim_main.cpp

compile: obj_dir/Vmips_machine

sim: compile assemble
	cp ${INPUT}.mem output/instructions.mem
	./obj_dir/Vmips_machine

verify: sim
	diff -u ${INPUT}.reg output/regdump.reg 1>&2

verify-all: compile assemble
	@fail=0;																				\
	for test in `find test -iname '*.mem'`; do												\
		if ! make verify INPUT=$${test%".mem"}; then fail=$$(expr $$fail + 1); fi;			\
	done; 																					\
	if [ $$fail -ne 0 ]; then 																\
		echo "$r$$fail test failed from $$(find test -iname '*.mem' | wc -l) tests :($n"; 	\
	else 																					\
		echo "$gAll tests passed! ($$(find test -iname '*.mem' | wc -l) tests)$n";			\
	fi

.PHONY: clean
.PHONY: clean-mem

clean:
	rm -rf obj_dir

clean-mem:
	rm -rf $(MEM)
