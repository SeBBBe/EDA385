static const short OI_LOGO = 0;
static const short OI_SHIP = 1;
static const short OI_BULLET = 2;
static const short OI_AST1 = 3;
static const short OI_AST2 = 4;
static const short OI_AST3 = 5;
static const short OI_AST4 = 6;
static const short OI_PUP1 = 7;


vgapoint_t ship[4] = 
{
  { 320, 230 },
  { 310, 250 },
  { 320, 245 },
  { 330, 250 },
};

vgapoint_t asteroid_r3[8] = 
{
  { 10, 10 },
  { 20, 0 },
  { 30, 10 },
  { 40, 20 },
  { 30, 30 },
  { 20, 40 },
  { 10, 30 },
  { 0, 20 },
};

vgapoint_t asteroid_r2[8] = 
{
  { 12, 12 },
  { 40, 0 },
  { 68, 12 },
  { 80, 40 },
  { 68, 68 },
  { 40, 80 },
  { 12, 68 },
  { 0, 40 },
};

vgapoint_t asteroid_r1[8] = 
{
  { 40, 40 },
  { 80, 0 },
  { 120, 40 },
  { 160, 80 },
  { 120, 120 },
  { 80, 160 },
  { 40, 120 },
  { 0, 80 },
};

vgapoint_t bullet_p[2] = 
{
  { 320, 240 },
  { 320, 250 },
};

vgapoint_t graphic_game_over[6] = 
{
  { 0, 0 },
  { 300, 300 },
  { 150, 150 },
  { 300, 0 },
  { 0, 300 },
  { 150, 150 },
};

vgapoint_t graphic_vict[6] = 
{
  { 0, 200 },
  { 150, 300 },
  { 300, 0 },
  { 150, 300 },
};

//Weapon upgrade
vgapoint_t powerup_1[4] =
{
  { 0, 0 },
  { 50, 0 },
  { 50, 50 },
  { 0, 0 },
};

vgapoint_t logo[51] = {{310,535},{200,300},{100,530},{195,465},{305,525},{435,385},{340,385},{340,460},{445,460},{445,535},{325,535},{490,385},{605,385},{555,385},{555,530},{665,385},{770,385},{665,385},{665,445},{780,445},{660,445},{660,530},{790,530},{835,385},{835,530},{835,380},{910,410},{835,440},{920,520},{960,390},{1045,390},{1045,530},{970,530},{970,395},{1085,395},{1155,395},{1120,395},{1120,525},{1075,525},{1160,525},{1200,390},{1200,530},{1260,465},{1205,385},{1285,385},{1375,385},{1280,385},{1280,455},{1355,455},{1355,535},{1275,535}};


//Temporary God mode

//Movement upgrade


float sinlookup[] = {0.000000,0.029995,0.059964,0.089879,0.119712,0.149438,0.179030,0.208460,0.237703,0.266731,0.295520,0.324043,0.352274,0.380188,0.407760,0.434966,0.461779,0.488177,0.514136,0.539632,0.564642,0.589145,0.613117,0.636537,0.659384,0.681639,0.703279,0.724287,0.744643,0.764329,0.783327,0.801620,0.819191,0.836026,0.852108,0.867423,0.881958,0.895698,0.908633,0.920750,0.932039,0.942489,0.952090,0.960835,0.968715,0.975723,0.981853,0.987100,0.991458,0.994924,0.997495,0.999168,0.999942,0.999816,0.998790,0.996865,0.994043,0.990327,0.985719,0.980225,0.973848,0.966595,0.958472,0.949486,0.939646,0.928960,0.917439,0.905091,0.891929,0.877965,0.863210,0.847679,0.831384,0.814342,0.796566,0.778074,0.758882,0.739006,0.718466,0.697279,0.675465,0.653042,0.630032,0.606455,0.582332,0.557685,0.532537,0.506909,0.480824,0.454308,0.427382,0.400071,0.372401,0.344396,0.316080,0.287480,0.258622,0.229530,0.200232,0.170754,0.141122,0.111364,0.081505,0.051572,0.021593,-0.008405,-0.038395,-0.068351,-0.098246,-0.128052,-0.157743,-0.187292,-0.216672,-0.245858,-0.274822,-0.303539,-0.331982,-0.360127,-0.387948,-0.415420,-0.442518,-0.469217,-0.495495,-0.521326,-0.546688,-0.571559,-0.595915,-0.619734,-0.642996,-0.665680,-0.687764,-0.709229,-0.730056,-0.750226,-0.769721,-0.788523,-0.806616,-0.823983,-0.840608,-0.856477,-0.871575,-0.885888,-0.899405,-0.912112,-0.923998,-0.935052,-0.945265,-0.954628,-0.963131,-0.970767,-0.977530,-0.983413,-0.988411,-0.992520,-0.995735,-0.998055,-0.999476,-0.999997,-0.999619,-0.998341,-0.996164,-0.993092,-0.989125,-0.984268,-0.978526,-0.971902,-0.964404,-0.956039,-0.946813,-0.936734,-0.925813,-0.914059,-0.901482,-0.888093,-0.873906,-0.858932,-0.843185,-0.826679,-0.809429,-0.791451,-0.772761,-0.753375,-0.733311,-0.712587,-0.691222,-0.669234,-0.646645,-0.623473,-0.599741,-0.575469,-0.550679,-0.525393,-0.499634,-0.473426,-0.446792,-0.419755,-0.392341,-0.364574,-0.336479,-0.308081,-0.279405,-0.250479,-0.221326,-0.191975,-0.162451,-0.132780,-0.102991,-0.073108,-0.043160,-0.013173};

float sine(float angle){
	int cmpangle = (int)(angle * 100);
	cmpangle %= 628;
	cmpangle /= 3;
	return sinlookup[cmpangle];
}

float cosine(float angle){
	return sine(angle + 1.57);
}

//Rotate the polygon poly of n points, rad radians around the point (x_pivot, y_pivot)
vgapoint_t* rotate(int n, vgapoint_t *poly, float rad, int x_pivot, int y_pivot)
{
	vgapoint_t* newpoly = memmgr_alloc(sizeof(*newpoly) * n);
	int i;
	for (i = 0; i < n; i++)
	{
		float x = (float)poly[i].x - x_pivot; // Translate to origin
		float y = (float)poly[i].y - y_pivot;
		float c = cosine(rad);
		float s = sine(rad);
		int newx = x * c - y * s + 0.5;
		int newy = x * s + y * c + 0.5;
		newx += x_pivot; // Reset position
		newy += y_pivot;
		newpoly[i].x = newx;
		newpoly[i].y = newy;
	}
	return newpoly;
}

void offset(int n, vgapoint_t *poly, int x, int y)
{
	int i;
	for (i = 0; i < n; i++)
	{
		poly[i].x += x;
		poly[i].y += y;
	}
}

vgapoint_t *copy_poly(int n, vgapoint_t *poly)
{
	vgapoint_t* newpoly = memmgr_alloc(sizeof(*newpoly) * n);
	memcpy(newpoly, poly, sizeof(*newpoly) * n);

	return newpoly;
}

void scale(int n, vgapoint_t *poly, float factor, float cx, float cy)
{
	int i;
	for (i = 0; i < n; i++)
	{
		poly[i].x -= cx;
		poly[i].y -= cy;
		poly[i].x *= factor;
		poly[i].y *= factor;
		poly[i].x += cx;
		poly[i].y += cy;
	}
}

