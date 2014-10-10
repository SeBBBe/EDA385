/*
 * snd.h
 *
 *  Created on: 10 okt 2014
 *      Author: dt09ma2
 */

#ifndef SND_H_
#define SND_H_

typedef struct sample
{
	int period;
	int duration;
	int wave;
} sample_t;

int volatile *snd = (int *)0x7F400000;

sample_t boot[] = {
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
};

sample_t *current_loop;
int looplen;
int loopctr;

void snd_init()
{
	current_loop = 0;
	looplen = 0;
	loopctr = 0;

	snd_play(boot, sizeof(boot) / sizeof(*boot));
}

void snd_update()
{
	if(current_loop && *snd)
	{
		if(loopctr < looplen)
		{
			xil_printf("advance loop\r\n");

			*snd = (current_loop[loopctr].period) | (current_loop[loopctr].duration << 15) | (current_loop[loopctr].wave << 30);
			loopctr++;
		}
		else
		{
			xil_printf("end loop\r\n");

			current_loop = 0;
			looplen = 0;
			loopctr = 0;
		}
	}
}

void snd_play(sample_t *loop, int len)
{
	current_loop = loop;
	looplen = len;
	loopctr = 0;

	xil_printf("start loop\r\n");

	*snd = (current_loop[loopctr].period) | (current_loop[loopctr].duration << 15) | (current_loop[loopctr].wave << 30);
	loopctr++;
}

#endif /* SND_H_ */
