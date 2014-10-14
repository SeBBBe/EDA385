test: vga_sim
	gcc test.c vga_sim.o -o test -lSDL

game: vga
	gcc game_logic.c vga.o -o test -lSDL -lm

game_sim: vga_sim
	gcc game_logic.c vga_sim.o -o test -lSDL -lm

vga:
	gcc -c vga.c -o vga.o

vga_sim:
	gcc -c vga_sim.c -o vga_sim.o

clean:
	rm vga_sim.o
	rm vga.o
	rm test
