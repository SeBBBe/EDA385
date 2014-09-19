typedef struct game_object {
	f_vgapoint_t location;
	double xvel;
	double yvel;
	double xaccel;
	double yaccel;
	double angle;
	short enabled;
	vgapoint_t** poly;
} game_object_t;

game_object_t* objects;

void go_initialize()
{
	objects =  malloc(64 * sizeof(game_object_t));
	int i;
	for (i = 0; i < 64; i++)
	{
		objects[i].location.x = 0;
		objects[i].location.y = 0;
		objects[i].xvel = 0;
		objects[i].yvel = 0;
		objects[i].xaccel = 0;
		objects[i].yaccel = 0;
		objects[i].angle = 0;
		objects[i].enabled = 0;
	}
}

void go_tick()
{
	int i;
	for (i = 0; i < 64; i++)
	{
		objects[i].location.x += objects[i].xvel;
		objects[i].location.y += objects[i].yvel;
		objects[i].xvel += objects[i].xaccel;
		objects[i].yvel += objects[i].yaccel;
	}
}

/*game_object_t* go_getempty(){
	return objects[0];
}*/
