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

#define C4 168
#define D4 150
#define E4 134
#define F4 126
#define G4 113
#define A4 100
#define B4 89
#define C5 84

#define SQR_WAVE 0b00
#define SAW_WAVE 0b01
#define TRI_WAVE 0b10
#define NSE_WAVE 0b11

sample_t boot[] = {
		{168, 20, SQR_WAVE},
		{150, 20, SQR_WAVE},
		{134, 20, SQR_WAVE},
		{126, 20, SQR_WAVE},
		{113, 20, SQR_WAVE},
		{100, 20, SQR_WAVE},
		{89, 20, SQR_WAVE},
		{84, 20, SQR_WAVE},
};

sample_t shootsnd[] = {
		{30, 15, 0},
		{25, 15, 0},
		{20, 15, 0},
};

sample_t pup1snd[] = {
		{168, 20, 0},
		{84, 40, 0},
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

sample_t intro[] = {
		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{400, 2, 0},
		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{200, 2, 0},

		{5525, 2, 0},

		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{400, 2, 0},
		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{200, 2, 0},

		{5525, 2, 0},

		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{20, 15, 0}, //pip
		{25, 15, 0},
		{30, 15, 0},

		{5525, 2, 0},

		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{400, 2, 0},
		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{200, 2, 0},
};

sample_t gameover[] = {
		{168, 100, 0},
		{200, 100, 0},
		{300, 100, 0},
		{400, 100, 0},
		{500, 100, 0},
		{600, 100, 0},
		{700, 100, 0},
		{800, 100, 0},
};

sample_t kaboom[] = {
		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{400, 2, 0},
		{500, 2, 0},
		{400, 2, 0},
		{300, 2, 0},
		{200, 2, 0},
};

sample_t winsnd[] = {
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{134, 20, 0},
		{126, 20, 0},
		{113, 20, 0},
		{100, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{100, 20, 0},
		{113, 20, 0},
		{126, 20, 0},
		{134, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{150, 20, 0},
		{168, 20, 0},
		{168, 20, 0},
		{20000, 4, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{20000, 4, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{20000, 2, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
		{84, 20, 0},
		{89, 20, 0},
};

sample_t *snd_current_loop;
int snd_looplen;
int snd_loopctr;

sample_t *mus_current_loop;
int mus_looplen;
int mus_loopctr;

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
	if(snd_current_loop && *snd)
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

	if(mus_current_loop && *snd)
	{
		if(mus_loopctr < mus_looplen)
		{
			*snd = (mus_current_loop[mus_loopctr].period) | (mus_current_loop[mus_loopctr].duration << 15) | (mus_current_loop[mus_loopctr].wave << 30);
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
