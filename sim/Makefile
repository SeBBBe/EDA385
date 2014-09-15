test: vga_sim
	gcc test.c vga_sim.o -o test -lSDL

game:
	make vga_sim
	gcc game_logic.c vga_sim.o -o test -lSDL -lm

vga_sim:
	gcc -c vga_sim.c -o vga_sim.o

clean:
	rm vga_sim.o
	rm test
