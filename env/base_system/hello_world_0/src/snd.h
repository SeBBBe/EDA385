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
		SQR(C4, EIGHT),
		SQR(D4, EIGHT),
		SQR(E4, EIGHT),
		SQR(F4, EIGHT),
		SQR(G4, EIGHT),
		SQR(A4, EIGHT),
		SQR(B4, EIGHT),
		SQR(C5, EIGHT),
};

sample_t shootsnd[] = {
		SQR(G5, SIXTEEN),
		SQR(B5, SIXTEEN),
		SQR(D6, SIXTEEN),
};

sample_t pup1snd[] = {
		SQR(C4, QUART),
		SQR(C5, QUART),
};

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
		SQR(B1, SIXTEEN),
		SQR(E2, SIXTEEN),
		SQR(B2, SIXTEEN),
		SQR(E2, SIXTEEN),
		SQR(B1, SIXTEEN),
		SQR(E2, SIXTEEN),
		SQR(B2, SIXTEEN),
		SQR(E3, SIXTEEN),
		SQR(B1, SIXTEEN),
		SQR(B1, SIXTEEN),
		SQR(E2, SIXTEEN),
		SQR(G1, SIXTEEN),
		SQR(E1, SIXTEEN),
		SQR(C1s, SIXTEEN),
		SQR(G1, SIXTEEN),
		SQR(E1, SIXTEEN),
};

sample_t kaboom_short[] = {
		SQR(G1, SIXTEEN),
		SQR(B1, SIXTEEN),
		SQR(E2, SIXTEEN),
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
		SQR(G4, HALF),
		SQR(F4s, HALF),
		SQR(D4s, HALF),
		SQR(A3, HALF),
		SQR(G3s, HALF),
		SQR(E4, HALF),
		SQR(G4s, HALF),
		SQR(C5, WHOLE),
};

sample_t bgm[] = {
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
	SAW(A2, WHOLE),
	SAW(D2, WHOLE),
};

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

	*mix = 0x00010001;

	MUS_PLAY(boot);
}

void snd_setvolume(int snd_att, int mus_att)
{
	*mix = snd_att | mus_att << 16;
}

void snd_update()
{
	while(snd_current_loop && *snd)
	{
		if(snd_loopctr < snd_looplen)
		{
			*snd = (snd_current_loop[snd_loopctr].period) | (snd_current_loop[snd_loopctr].duration << 15) | (snd_current_loop[snd_loopctr].wave << 30);
			snd_loopctr++;
		}
		else
		{
			snd_current_loop = 0;
			snd_looplen = 0;
			snd_loopctr = 0;
		}
	}

	while(mus_current_loop && *mus)
	{
		if(mus_loopctr < mus_looplen)
		{
			*mus = (mus_current_loop[mus_loopctr].period) | (mus_current_loop[mus_loopctr].duration << 15) | (mus_current_loop[mus_loopctr].wave << 30);
			mus_loopctr++;
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
	int i;

	snd_current_loop = loop;
	snd_looplen = len;
	snd_loopctr = 0;

	for(i = 0; i < 16; i++) *snd = 0;

	*snd = (snd_current_loop[snd_loopctr].period) | (snd_current_loop[snd_loopctr].duration << 15) | (snd_current_loop[snd_loopctr].wave << 30);
	snd_loopctr++;
}

void mus_play(sample_t *loop, int len)
{
	int i;

	mus_current_loop = loop;
	mus_looplen = len;
	mus_loopctr = 0;

	for(i = 0; i < 16; i++) *mus = 0;

	*mus = (mus_current_loop[mus_loopctr].period) | (mus_current_loop[mus_loopctr].duration << 15) | (mus_current_loop[mus_loopctr].wave << 30);
	mus_loopctr++;
}

#endif /* SND_H_ */
