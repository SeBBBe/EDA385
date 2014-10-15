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
int volatile *mus = (int *)0x7FC00000;
int volatile *mix = (int *)0x7FC10000;

#define SND_PLAY(X) snd_play(X, sizeof(X) / sizeof(*X))
#define MUS_PLAY(X) mus_play(X, sizeof(X) / sizeof(*X))

#define SAMPLE_RATE 24415
#define BPM 160
#define WHOLE (SAMPLE_RATE * 60) / BPM
#define HALF WHOLE/2
#define QUART HALF/2
#define EIGHT QUART/2
#define SIXTEEN EIGHT/2

#define REST 0

#include "notes.h"

#define SQR_WAVE 0b00
#define SAW_WAVE 0b01
#define TRI_WAVE 0b10
#define NSE_WAVE 0b11

sample_t boot[] = {
		{C4, QUART, SQR_WAVE},
		{D4, QUART, SQR_WAVE},
		{E4, QUART, SQR_WAVE},
		{F4, QUART, SQR_WAVE},
		{G4, QUART, SQR_WAVE},
		{A4, QUART, SQR_WAVE},
		{B4, QUART, SQR_WAVE},
		{C5, QUART, SQR_WAVE},
};

sample_t shootsnd[] = {
		{30, 400, 0},
		{25, 400, 0},
		{20, 400, 0},
};

sample_t pup1snd[] = {
		{168, 2000, 0},
		{84, 2000, 0},
};

//sample_t shootsnd[] = {
//		{168, 2, 0},
//		{150, 2, 0},
//		{134, 2, 0},
//		{126, 2, 0},
//		{113, 2, 0},
//		{100, 2, 0},
//		{89, 2, 0},
//		{84, 2, 0},
//};

#define INTRO_REST {0, 11025, 0}
#define INTRO_PIP {20, 300, 0}, \
	{25, 300, 0}, \
	{30, 300, 0}

#define INTRO_BEAT {500, 500, 0},\
{400, 500, 0},\
{300, 500, 0},\
{400, 500, 0},\
{500, 500, 0},\
{400, 500, 0},\
{300, 500, 0},\
{200, 500, 0}

sample_t intro[] = {
		INTRO_PIP,
		INTRO_REST,
		INTRO_PIP,
		INTRO_REST,
		INTRO_BEAT,
		INTRO_REST,
		INTRO_REST,

		INTRO_PIP,
		INTRO_REST,
		INTRO_PIP,
		INTRO_REST,
		INTRO_BEAT,
		INTRO_REST,
		INTRO_REST,

		INTRO_PIP,
		INTRO_REST,
		INTRO_PIP,
		INTRO_REST,
		INTRO_BEAT,
};

sample_t gameover[] = {
		{168, 10000, 0},
		{200, 10000, 0},
		{300, 10000, 0},
		{400, 10000, 0},
		{500, 15000, 0},
		{600, 15000, 0},
		{700, 20000, 0},
		{800, 20000, 0},
};

sample_t kaboom[] = {
		{400, 500, 0},
		{300, 500, 0},
		{200, 500, 0},
		{300, 500, 0},
		{400, 500, 0},
		{300, 500, 0},
		{200, 500, 0},
		{150, 500, 0},
		{400, 500, 0},
		{400, 500, 0},
		{300, 500, 0},
		{500, 500, 0},
		{600, 500, 0},
		{700, 500, 0},
		{500, 500, 0},
		{600, 500, 0},
};

sample_t kaboom_short[] = {
		{500, 500, 0},
		{400, 500, 0},
		{300, 500, 0},
};

sample_t winsnd[] = {
		{400, 10000, 0},
		{300, 10000, 0},
		{200, 10000, 0},
		{168, 10000, 0},
		{100, 10000, 0},
		{84, 10000, 0},
		{70, 30000, 0},
};

sample_t zeldasecret[] = {
		{G4, HALF, SQR_WAVE},
		{F4s, HALF, SQR_WAVE},
		{D4s, HALF, SQR_WAVE},
		{A3, HALF, SQR_WAVE},
		{G3s, HALF, SQR_WAVE},
		{E4, HALF, SQR_WAVE},
		{G4s, HALF, SQR_WAVE},
		{C5, WHOLE, SQR_WAVE},
};

#include "bman.h"

sample_t *snd_current_loop;
int snd_looplen;
int snd_loopctr;

sample_t *mus_current_loop;
int mus_looplen;
int mus_loopctr;

void mus_play(sample_t *loop, int len);

void snd_init()
{
	snd_current_loop = 0;
	snd_looplen = 0;
	snd_loopctr = 0;

	mus_current_loop = 0;
	mus_looplen = 0;
	mus_loopctr = 0;

	*mix = 0x00000101;

	MUS_PLAY(boot);
}

void snd_update()
{
	xil_printf("update\r\n");

	while(snd_current_loop && *snd)
	{
		if(snd_loopctr < snd_looplen)
		{
			*snd = (snd_current_loop[snd_loopctr].period) | (snd_current_loop[snd_loopctr].duration << 15) | (snd_current_loop[snd_loopctr].wave << 30);
			snd_loopctr++;

			xil_printf("snd advance\r\n");
		}
		else
		{
			snd_current_loop = 0;
			snd_looplen = 0;
			snd_loopctr = 0;
		}
	}

	while(mus_current_loop && *snd)
	{
		if(mus_loopctr < mus_looplen)
		{
			*snd = (mus_current_loop[mus_loopctr].period) | (mus_current_loop[mus_loopctr].duration << 15) | (mus_current_loop[mus_loopctr].wave << 30);
			mus_loopctr++;

			xil_printf("mus advance\r\n");
		}
		else
		{
			mus_current_loop = 0;
			mus_looplen = 0;
			mus_loopctr = 0;
		}
	}
}

void snd_play(sample_t *loop, int len)
{
	snd_current_loop = loop;
	snd_looplen = len;
	snd_loopctr = 0;

	*snd = (snd_current_loop[snd_loopctr].period) | (snd_current_loop[snd_loopctr].duration << 15) | (snd_current_loop[snd_loopctr].wave << 30);
	snd_loopctr++;
}

void mus_play(sample_t *loop, int len)
{
	mus_current_loop = loop;
	mus_looplen = len;
	mus_loopctr = 0;

	*snd = (mus_current_loop[mus_loopctr].period) | (mus_current_loop[mus_loopctr].duration << 15) | (mus_current_loop[mus_loopctr].wave << 30);
	mus_loopctr++;
}

#endif /* SND_H_ */
