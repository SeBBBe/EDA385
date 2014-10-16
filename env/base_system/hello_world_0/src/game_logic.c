#include <stdio.h>
#include <string.h>
#include "memmgr.h"
#include "vga.h"
#include "input.h"
#include "snd.h"

static const float rotate_amount = 0.07;
static const float ship_accel = 0.2;
static const float ship_fric = 0.02;
static float bullet_speed = 16;
int shoot_limit = 0;
int shoot_buffer = 0;
short pup1 = 0; // powerup1 = bullet
short pup_has_already_spawned = 0;

#include "graphics.h"
#include "game_objects.h"

typedef struct bullet
{
  f_vgapoint_t p1;
  f_vgapoint_t p2;
  float xvel;
  float yvel;
} bullet_t;

void game_over()
{
	vgapoint_t *poly = copy_poly(6, graphic_game_over);
	offset(6, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	MUS_PLAY(gameover);

	while(1)
	{
		vga_clear();
		snd_update();
		vga_addpoly_color(6, poly, 0b00000111);
		vga_sync();
	}

}


void win()
{
	vgapoint_t *poly = copy_poly(4, graphic_vict);
	offset(4, poly, vga_get_width()/2 - 150, vga_get_height()/2 - 150);

	MUS_PLAY(winsnd);

	while(1)
	{
		vga_clear();
		snd_update();
		vga_addpoly_color(4, poly, 0b00111000);
		vga_sync();
	}
//		int posx = 0;
//		int posy = 0;
//		int centerx = 350;
//		int centery = 250;
//		int scale = 0.01;
//		int scaleaccel = 0.01;
//		int angle = 3.14;
//		int anglespeed = 0.03;
//
//		game_object_t* LC = go_getempty();
//		LC->poly = CC;
//		LC->poly_points = 6;
//		LC->identifier = OI_LOGO;
//		LC->enabled = 1;
//		LC->anglespeed = anglespeed;
//		LC->angle = angle;
//		LC->scale = scale;
//		LC->scaleaccel = scaleaccel;
//		LC->center_point.x = centerx;
//		LC->center_point.y = centery;
//		LC->location.x = posx;
//		LC->location.y = posy;
//
//		vga_addpoly_color(4, LC->poly, 0);
//
//		game_object_t* LR = go_getempty();
//		LR->poly = RR;
//		LR->poly_points = 9;
//		LR->identifier = OI_LOGO;
//		LR->enabled = 1;
//		LR->scale = scale;
//		LR->location.x = posx;
//		LR->location.y = posy - 80;
//		LR->anglespeed = anglespeed;
//		LR->center_point.x = centerx;
//		LR->center_point.y = centery;
//		LR->scaleaccel = scaleaccel;
//		LR->angle = angle;
//
//		game_object_t* LE = go_getempty();
//		LE->poly = EE;
//		LE->poly_points = 9;
//		LE->identifier = OI_LOGO;
//		LE->enabled = 1;
//		LE->scale = scale;
//		LE->location.x = posx + 60;
//		LE->location.y = posy - 80;
//		LE->anglespeed = anglespeed;
//		LE->center_point.x = centerx;
//		LE->center_point.y = centery;
//		LE->scaleaccel = scaleaccel;
//		LE->angle = angle;
//
//		game_object_t* LD = go_getempty();
//		LD->poly = DD;
//		LD->poly_points = 6;
//		LD->identifier = OI_LOGO;
//		LD->enabled = 1;
//		LD->scale = scale;
//		LD->location.x = posx + 130;
//		LD->location.y = posy - 80;
//		LD->anglespeed = anglespeed;
//		LD->center_point.x = centerx;
//		LD->center_point.y = centery;
//		LD->scaleaccel = scaleaccel;
//		LD->angle = angle;
//
//		game_object_t* LI = go_getempty();
//		LI->poly = II;
//		LI->poly_points = 8;
//		LI->identifier = OI_LOGO;
//		LI->enabled = 1;
//		LI->scale = scale;
//		LI->location.x = posx + 190;
//		LI->location.y = posy - 100;
//		LI->anglespeed = anglespeed;
//		LI->center_point.x = centerx;
//		LI->center_point.y = centery;
//		LI->scaleaccel = scaleaccel;
//		LI->angle = angle;
//
//		game_object_t* LT = go_getempty();
//		LT->poly = TT;
//		LT->poly_points = 5;
//		LT->identifier = OI_LOGO;
//		LT->enabled = 1;
//		LT->scale = scale;
//		LT->location.x = posx+250;
//		LT->location.y = posy-100;
//		LT->anglespeed = anglespeed;
//		LT->center_point.x = centerx;
//		LT->center_point.y = centery;
//		LT->scaleaccel = scaleaccel;
//		LT->angle = angle;
//
//		game_object_t* LS = go_getempty();
//		LS->poly = SS;
//		LS->poly_points = 10;
//		LS->identifier = OI_LOGO;
//		LS->enabled = 1;
//		LS->scale = scale;
//		LS->location.x = posx+350;
//		LS->location.y = posy-59;
//		LS->anglespeed = anglespeed;
//		LS->center_point.x = centerx;
//		LS->center_point.y = centery;
//		LS->scaleaccel = scaleaccel;
//		LS->angle = angle;
//
//		int i;
//		for (i = 0; i < 60 * 3; i++)
//		{
//			snd_update();
//			vga_sync();
//			vga_clear();
//		}
//
//		for (i = 0; i < 60 * 5; i++)
//		{
//			go_tick();
//			vga_sync();
//
//			snd_update();
//
//			vga_clear();
//			go_draw();
//		}


	//	game_object_t* LTAO = go_getempty();
	//	LTAO->poly = TAO;
	//	LTAO->poly_points = 35;
	//	LTAO->identifier = OI_LOGO;
	//	LTAO->enabled = 1;
	//	LTAO->scale = scale;
	//	LTAO->location.x = posx;
	//	LTAO->location.y = posy+50;

	//	game_object_t* LFIG = go_getempty();
	//	LFIG->poly = FIGURE;
	//	LFIG->poly_points = 20;
	//	LFIG->identifier = OI_LOGO;
	//	LFIG->enabled = 1;
	//	LFIG->scale = scale;
	//	LFIG->location.x = posx+300;
	//	LFIG->location.y = posy;

	//	game_object_t* LAALI = go_getempty();
	//	LAALI->poly = AALI;
	//	LAALI->poly_points = 18;
	//	LAALI->identifier = OI_LOGO;
	//	LAALI->enabled = 1;
	//	LAALI->scale = scale;
	//	LAALI->location.x = posx+300;
	//	LAALI->location.y = posy+100;

	//	game_object_t* LFAB = go_getempty();
	//	LFAB->poly = FABIAN;
	//	LFAB->poly_points = 50;
	//	LFAB->identifier = OI_LOGO;
	//	LFAB->enabled = 1;
	//	LFAB->scale = scale;
	//	LFAB->location.x = posx;
	//	LFAB->location.y = posy;

	//	game_object_t* LZHAO = go_getempty();
	//	LZHAO->poly = ZHAO;
	//	LZHAO->poly_points = 32;
	//	LZHAO->identifier = OI_LOGO;
	//	LZHAO->enabled = 1;
	//	LZHAO->scale = scale;
	//	LZHAO->location.x = posx;
	//	LZHAO->location.y = posy;


//	LC->enabled = 0;
//	LR->enabled = 0;
//	LE->enabled = 0;
//	LD->enabled = 0;
//	LI->enabled = 0;
//	LT->enabled = 0;
//	LS->enabled = 0;

}

/*TODO BY JAW
*	BUGzgzgZ: STARZ OBJECT STILL EXISTS
*
*	Add credit song and animation.
*	Make credit display after game win, graphic is already fixed and prepared.
*	Add end game with mothership spawning bullets towards ship and spawning astroids.
*/
void game_main(int seed)
{
	int i;

	keymap_t keys;
	vga_init();
	snd_init();

	go_initialize();
	srand(*dip & 32 ? 1339 : seed);

	bullet_speed = 10;
	pup_has_already_spawned = 0;

	if(!(*dip & 16))
	{
		game_object_t* thelogo = go_getempty();
		thelogo->enabled = 1;
		thelogo->identifier = OI_LOGO;
		thelogo->poly_points = 51;
		thelogo->poly = logo;
		thelogo->anglespeed = 0.03;
		thelogo->center_point.x = 320 + 75;
		thelogo->location.x = 300;
		thelogo->angle = 3.14;
		thelogo->center_point.y = vga_get_height()/2;
		thelogo->scale = 0.01;
		thelogo->scaleaccel = 0.01;

		for (i = 0; i < 60 * 3; i++)
		{
			snd_update();
			vga_sync();
			vga_clear();
		}

		MUS_PLAY(zeldasecret);

		for (i = 0; i < 60 * 5; i++)
		{
			go_tick();
			vga_sync();

			snd_update();

			vga_clear();
			go_draw();
		}

		thelogo->enabled = 0;
	}

	game_object_t* ship_o = go_getempty();
	ship_o->enabled = 1;
	ship_o->poly_points = 4;
	ship_o->poly = ship;
	ship_o->center_point.x = 320;
	ship_o->center_point.y = 240;
	ship_o->location.x = vga_get_width()/2 - 320;
	ship_o->location.y = vga_get_height()/2 - 240;
	ship_o->identifier = OI_SHIP;

	for (i = 0; i < 5; i++){
		go_createasteroid(1);
	}

	//go_createpowerupn(1,600,650);

	snd_setvolume(1, 2);

	//MUS_PLAY(bgm);

	while(1)
	{
		go_tick();
		vga_sync();

		snd_update();

		keys = input_get_keys();
		float bullet2angle = 0.0;
		if(keys & KEY_SHOOT)
		{
			if (shoot_limit == 0)
			{
				if(pup1) // if powerup1 is active
				{
					bullet2angle = 0.1;
					go_createbullet(ship_o, -bullet2angle);
				}
				else bullet2angle = 0;

				shoot_limit = 20;
				if (shoot_buffer == 0) shoot_limit = 45;

				go_createbullet(ship_o, bullet2angle);

				SND_PLAY(shootsnd);
			}
		}
		if(keys & KEY_LEFT)
		{
		  ship_o->angle -= rotate_amount;
		}
		if(keys & KEY_RIGHT)
		{
			ship_o->angle += rotate_amount;
		}
		if(keys & KEY_UP)
		{
			shoot_buffer += 4;
			if (shoot_buffer > 300) shoot_buffer = 300;
			//TODO: lookup table
			ship_o->xvel += ship_accel * cosine(ship_o->angle + 4.71);
			ship_o->yvel += ship_accel * sine(ship_o->angle + 4.71);
		}

		ship_o->xvel += ship_fric * -ship_o->xvel;
		ship_o->yvel += ship_fric * -ship_o->yvel;
		if (shoot_buffer > 0) shoot_buffer--;

		/*if(keys & KEY_DOWN)
		{
			ship_o->angle += 3.14;
		}*/

		if (shoot_limit > 0) shoot_limit--;
		if (go_currentstate == STATE_DEAD) game_over();
		if (go_currentstate == STATE_VICT || (*dip & 8)){
			win();
		}
		vga_clear();
		go_draw();
	}
}
