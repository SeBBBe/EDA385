#include <math.h>

static const short OI_SHIP = 1;
static const short OI_BULLET = 2;
static const short OI_AST1 = 3;
static const short OI_AST2 = 3;
static const short OI_AST3 = 3;
static const short OI_AST4 = 3;

vgapoint_t ship[4] = 
{
  { 320, 230 },
  { 310, 250 },
  { 320, 245 },
  { 330, 250 },
};

vgapoint_t asteroid[5] = 
{
  { 70, 20 },
  { 30, 40 },
  { 50, 70 },
  { 80, 70 },
  { 100, 40 },
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

//TODO: fixed point
double fastsin[] = {0.000000,0.010000,0.019999,0.029996,0.039989,0.049979,0.059964,0.069943,0.079915,0.089879,0.099833,0.109778,0.119712,0.129634,0.139543,0.149438,0.159318,0.169182,0.179030,0.188859,0.198669,0.208460,0.218230,0.227978,0.237703,0.247404,0.257081,0.266731,0.276356,0.285952,0.295520,0.305059,0.314567,0.324043,0.333487,0.342898,0.352274,0.361615,0.370920,0.380188,0.389418,0.398609,0.407760,0.416871,0.425939,0.434966,0.443948,0.452886,0.461779,0.470626,0.479426,0.488177,0.496880,0.505533,0.514136,0.522687,0.531186,0.539632,0.548024,0.556361,0.564642,0.572867,0.581035,0.589145,0.597195,0.605186,0.613117,0.620986,0.628793,0.636537,0.644218,0.651834,0.659385,0.666870,0.674288,0.681639,0.688921,0.696135,0.703279,0.710353,0.717356,0.724287,0.731146,0.737931,0.744643,0.751280,0.757843,0.764329,0.770739,0.777072,0.783327,0.789504,0.795602,0.801620,0.807558,0.813416,0.819192,0.824886,0.830497,0.836026,0.841471,0.846832,0.852108,0.857299,0.862404,0.867423,0.872355,0.877201,0.881958,0.886627,0.891207,0.895699,0.900100,0.904412,0.908633,0.912764,0.916803,0.920751,0.924606,0.928369,0.932039,0.935616,0.939099,0.942489,0.945784,0.948985,0.952090,0.955101,0.958016,0.960835,0.963558,0.966185,0.968715,0.971148,0.973485,0.975723,0.977865,0.979908,0.981854,0.983701,0.985450,0.987100,0.988652,0.990105,0.991458,0.992713,0.993868,0.994924,0.995881,0.996738,0.997495,0.998152,0.998710,0.999168,0.999526,0.999784,0.999942,1.000000,0.999958,0.999816,0.999574,0.999232,0.998790,0.998248,0.997606,0.996865,0.996024,0.995083,0.994043,0.992904,0.991665,0.990327,0.988890,0.987354,0.985719,0.983986,0.982154,0.980224,0.978197,0.976071,0.973848,0.971527,0.969109,0.966594,0.963983,0.961275,0.958471,0.955572,0.952576,0.949486,0.946300,0.943020,0.939645,0.936177,0.932615,0.928960,0.925212,0.921371,0.917438,0.913413,0.909297,0.905091,0.900793,0.896406,0.891929,0.887362,0.882707,0.877964,0.873133,0.868215,0.863209,0.858118,0.852940,0.847678,0.842330,0.836899,0.831383,0.825785,0.820104,0.814341,0.808496,0.802571,0.796565,0.790480,0.784316,0.778073,0.771753,0.765355,0.758881,0.752331,0.745705,0.739005,0.732231,0.725384,0.718465,0.711473,0.704411,0.697278,0.690075,0.682803,0.675463,0.668056,0.660581,0.653041,0.645435,0.637765,0.630031,0.622234,0.614374,0.606454,0.598472,0.590431,0.582331,0.574172,0.565956,0.557684,0.549355,0.540972,0.532535,0.524044,0.515501,0.506907,0.498262,0.489567,0.480823,0.472031,0.463191,0.454306,0.445375,0.436399,0.427380,0.418318,0.409214,0.400069,0.390885,0.381661,0.372399,0.363100,0.353764,0.344393,0.334988,0.325549,0.316078,0.306575,0.297041,0.287478,0.277886,0.268266,0.258619,0.248947,0.239249,0.229528,0.219784,0.210017,0.200230,0.190423,0.180596,0.170752,0.160890,0.151013,0.141120,0.131213,0.121293,0.111361,0.101418,0.091465,0.081502,0.071532,0.061554,0.051570,0.041581,0.031587,0.021591,0.011592,0.001593,-0.008407,-0.018406,-0.028404,-0.038398,-0.048388,-0.058374,-0.068354,-0.078327,-0.088292,-0.098249,-0.108195,-0.118131,-0.128055,-0.137966,-0.147863,-0.157746,-0.167612,-0.177462,-0.187295,-0.197108,-0.206902,-0.216675,-0.226427,-0.236155,-0.245861,-0.255541,-0.265196,-0.274825,-0.284426,-0.293998,-0.303542,-0.313054,-0.322536,-0.331985,-0.341401,-0.350783,-0.360130,-0.369441,-0.378715,-0.387951,-0.397148,-0.406306,-0.415423,-0.424498,-0.433531,-0.442520,-0.451466,-0.460366,-0.469220,-0.478027,-0.486787,-0.495497,-0.504159,-0.512769,-0.521329,-0.529836,-0.538291,-0.546691,-0.555037,-0.563327,-0.571561,-0.579738,-0.587857,-0.595917,-0.603918,-0.611858,-0.619737,-0.627554,-0.635308,-0.642999,-0.650625,-0.658186,-0.665682,-0.673111,-0.680473,-0.687766,-0.694991,-0.702146,-0.709231,-0.716246,-0.723188,-0.730058,-0.736856,-0.743579,-0.750228,-0.756802,-0.763301,-0.769723,-0.776068,-0.782336,-0.788525,-0.794636,-0.800667,-0.806618,-0.812488,-0.818277,-0.823984,-0.829609,-0.835151,-0.840609,-0.845984,-0.851273,-0.856478,-0.861597,-0.866630,-0.871576,-0.876435,-0.881206,-0.885889,-0.890484,-0.894989,-0.899405,-0.903732,-0.907967,-0.912112,-0.916166,-0.920128,-0.923998,-0.927776,-0.931461,-0.935053,-0.938551,-0.941955,-0.945266,-0.948481,-0.951602,-0.954628,-0.957558,-0.960392,-0.963131,-0.965773,-0.968319,-0.970767,-0.973119,-0.975373,-0.977530,-0.979589,-0.981550,-0.983413,-0.985178,-0.986844,-0.988411,-0.989880,-0.991249,-0.992520,-0.993691,-0.994763,-0.995735,-0.996608,-0.997381,-0.998054,-0.998628,-0.999102,-0.999476,-0.999749,-0.999923,-0.999997,-0.999971,-0.999845,-0.999619,-0.999293,-0.998867,-0.998341,-0.997715,-0.996990,-0.996165,-0.995240,-0.994216,-0.993092,-0.991869,-0.990547,-0.989125,-0.987605,-0.985986,-0.984269,-0.982453,-0.980538,-0.978526,-0.976416,-0.974208,-0.971903,-0.969501,-0.967001,-0.964405,-0.961713,-0.958924,-0.956040,-0.953060,-0.949984,-0.946814,-0.943549,-0.940189,-0.936736,-0.933189,-0.929548,-0.925815,-0.921989,-0.918070,-0.914060,-0.909959,-0.905767,-0.901484,-0.897111,-0.892648,-0.888096,-0.883455,-0.878725,-0.873908,-0.869004,-0.864012,-0.858934,-0.853771,-0.848522,-0.843188,-0.837769,-0.832267,-0.826682,-0.821014,-0.815264,-0.809433,-0.803520,-0.797527,-0.791455,-0.785303,-0.779073,-0.772764,-0.766379,-0.759917,-0.753379,-0.746765,-0.740077,-0.733315,-0.726480,-0.719572,-0.712592,-0.705540,-0.698418,-0.691227,-0.683966,-0.676637,-0.669240,-0.661776,-0.654246,-0.646651,-0.638991,-0.631267,-0.623480,-0.615630,-0.607719,-0.599747,-0.591716,-0.583625,-0.575475,-0.567269,-0.559005,-0.550686,-0.542311,-0.533882,-0.525400,-0.516865,-0.508279,-0.499642,-0.490955,-0.482218,-0.473434,-0.464602,-0.455724,-0.446800,-0.437832,-0.428819,-0.419764,-0.410667,-0.401529,-0.392350,-0.383133,-0.373877,-0.364583,-0.355254,-0.345888,-0.336488,-0.327055,-0.317589,-0.308091,-0.298562,-0.289003,-0.279415,-0.269800,-0.260157,-0.250489,-0.240795,-0.231078,-0.221337,-0.211574,-0.201790,-0.191986,-0.182163,-0.172321,-0.162462,-0.152587,-0.142697,-0.132792,-0.122874,-0.112944,-0.103002,-0.093051,-0.083089,-0.073120,-0.063143,-0.053160,-0.043172,-0.033179,-0.023183,-0.013185,-0.003185,0.006815};
double fastcos[] = {1.000000,0.999950,0.999800,0.999550,0.999200,0.998750,0.998201,0.997551,0.996802,0.995953,0.995004,0.993956,0.992809,0.991562,0.990216,0.988771,0.987227,0.985585,0.983844,0.982004,0.980067,0.978031,0.975897,0.973666,0.971338,0.968912,0.966390,0.963771,0.961055,0.958244,0.955336,0.952334,0.949235,0.946042,0.942755,0.939373,0.935897,0.932327,0.928665,0.924909,0.921061,0.917121,0.913089,0.908966,0.904752,0.900447,0.896052,0.891568,0.886995,0.882333,0.877583,0.872745,0.867819,0.862807,0.857709,0.852525,0.847255,0.841901,0.836463,0.830941,0.825336,0.819648,0.813878,0.808028,0.802096,0.796084,0.789992,0.783822,0.777573,0.771246,0.764842,0.758362,0.751806,0.745174,0.738469,0.731689,0.724836,0.717911,0.710914,0.703845,0.696707,0.689498,0.682221,0.674876,0.667463,0.659983,0.652437,0.644827,0.637151,0.629412,0.621610,0.613746,0.605820,0.597834,0.589788,0.581683,0.573520,0.565300,0.557023,0.548690,0.540302,0.531861,0.523366,0.514819,0.506220,0.497571,0.488872,0.480124,0.471328,0.462485,0.453596,0.444662,0.435682,0.426660,0.417595,0.408487,0.399340,0.390152,0.380925,0.371660,0.362358,0.353019,0.343646,0.334238,0.324796,0.315322,0.305817,0.296281,0.286715,0.277121,0.267499,0.257850,0.248175,0.238476,0.228753,0.219007,0.209239,0.199450,0.189641,0.179813,0.169967,0.160104,0.150225,0.140332,0.130424,0.120503,0.110570,0.100626,0.090672,0.080708,0.070737,0.060759,0.050774,0.040785,0.030791,0.020795,0.010796,0.000796,-0.009204,-0.019202,-0.029200,-0.039194,-0.049184,-0.059169,-0.069148,-0.079121,-0.089085,-0.099041,-0.108987,-0.118922,-0.128844,-0.138755,-0.148651,-0.158532,-0.168397,-0.178246,-0.188077,-0.197889,-0.207681,-0.217452,-0.227202,-0.236929,-0.246632,-0.256311,-0.265964,-0.275590,-0.285189,-0.294759,-0.304300,-0.313811,-0.323290,-0.332736,-0.342150,-0.351529,-0.360873,-0.370181,-0.379452,-0.388685,-0.397879,-0.407033,-0.416147,-0.425219,-0.434248,-0.443234,-0.452176,-0.461073,-0.469923,-0.478727,-0.487482,-0.496189,-0.504846,-0.513453,-0.522008,-0.530511,-0.538961,-0.547358,-0.555699,-0.563985,-0.572215,-0.580387,-0.588501,-0.596557,-0.604552,-0.612488,-0.620362,-0.628174,-0.635923,-0.643608,-0.651230,-0.658786,-0.666276,-0.673700,-0.681056,-0.688344,-0.695563,-0.702713,-0.709793,-0.716801,-0.723738,-0.730602,-0.737394,-0.744111,-0.750755,-0.757323,-0.763815,-0.770231,-0.776570,-0.782832,-0.789015,-0.795119,-0.801144,-0.807088,-0.812952,-0.818735,-0.824435,-0.830054,-0.835589,-0.841040,-0.846408,-0.851691,-0.856889,-0.862001,-0.867027,-0.871966,-0.876818,-0.881582,-0.886258,-0.890846,-0.895344,-0.899753,-0.904072,-0.908301,-0.912438,-0.916485,-0.920440,-0.924302,-0.928073,-0.931750,-0.935335,-0.938825,-0.942222,-0.945525,-0.948733,-0.951847,-0.954865,-0.957787,-0.960614,-0.963345,-0.965979,-0.968517,-0.970958,-0.973302,-0.975549,-0.977698,-0.979749,-0.981702,-0.983557,-0.985314,-0.986972,-0.988532,-0.989992,-0.991354,-0.992617,-0.993780,-0.994844,-0.995808,-0.996673,-0.997438,-0.998104,-0.998669,-0.999135,-0.999501,-0.999767,-0.999933,-0.999999,-0.999965,-0.999831,-0.999597,-0.999263,-0.998829,-0.998295,-0.997661,-0.996928,-0.996095,-0.995162,-0.994130,-0.992998,-0.991767,-0.990437,-0.989008,-0.987480,-0.985853,-0.984128,-0.982304,-0.980382,-0.978362,-0.976244,-0.974028,-0.971715,-0.969305,-0.966798,-0.964194,-0.961494,-0.958698,-0.955806,-0.952818,-0.949735,-0.946557,-0.943285,-0.939918,-0.936457,-0.932902,-0.929254,-0.925513,-0.921680,-0.917755,-0.913737,-0.909629,-0.905429,-0.901139,-0.896758,-0.892288,-0.887729,-0.883081,-0.878345,-0.873521,-0.868609,-0.863611,-0.858526,-0.853356,-0.848100,-0.842759,-0.837334,-0.831826,-0.826234,-0.820559,-0.814803,-0.808965,-0.803046,-0.797047,-0.790968,-0.784810,-0.778573,-0.772259,-0.765867,-0.759399,-0.752855,-0.746236,-0.739542,-0.732774,-0.725932,-0.719018,-0.712033,-0.704976,-0.697848,-0.690651,-0.683385,-0.676050,-0.668648,-0.661179,-0.653644,-0.646043,-0.638378,-0.630649,-0.622857,-0.615002,-0.607087,-0.599110,-0.591073,-0.582978,-0.574824,-0.566613,-0.558345,-0.550021,-0.541642,-0.533209,-0.524722,-0.516184,-0.507593,-0.498952,-0.490261,-0.481521,-0.472732,-0.463897,-0.455015,-0.446087,-0.437115,-0.428100,-0.419041,-0.409941,-0.400799,-0.391618,-0.382397,-0.373138,-0.363842,-0.354509,-0.345141,-0.335738,-0.326302,-0.316833,-0.307333,-0.297802,-0.288241,-0.278651,-0.269033,-0.259389,-0.249718,-0.240022,-0.230303,-0.220560,-0.210796,-0.201010,-0.191204,-0.181379,-0.171536,-0.161676,-0.151800,-0.141908,-0.132003,-0.122084,-0.112153,-0.102210,-0.092258,-0.082296,-0.072326,-0.062349,-0.052365,-0.042376,-0.032383,-0.022387,-0.012389,-0.002389,0.007611,0.017610,0.027608,0.037602,0.047593,0.057579,0.067560,0.077533,0.087499,0.097456,0.107403,0.117340,0.127265,0.137177,0.147076,0.156959,0.166827,0.176679,0.186512,0.196327,0.206123,0.215898,0.225651,0.235381,0.245089,0.254771,0.264428,0.274059,0.283662,0.293237,0.302783,0.312298,0.321782,0.331234,0.340653,0.350037,0.359387,0.368701,0.377978,0.387217,0.396417,0.405578,0.414698,0.423777,0.432813,0.441806,0.450755,0.459659,0.468517,0.477328,0.486091,0.494806,0.503471,0.512085,0.520649,0.529161,0.537619,0.546024,0.554374,0.562669,0.570908,0.579089,0.587213,0.595278,0.603283,0.611228,0.619112,0.626934,0.634693,0.642389,0.650020,0.657587,0.665088,0.672522,0.679889,0.687188,0.694418,0.701579,0.708670,0.715690,0.722638,0.729514,0.736317,0.743046,0.749702,0.756282,0.762786,0.769215,0.775566,0.781840,0.788035,0.794152,0.800189,0.806147,0.812024,0.817819,0.823533,0.829164,0.834713,0.840178,0.845559,0.850855,0.856067,0.861192,0.866232,0.871185,0.876051,0.880829,0.885520,0.890121,0.894634,0.899057,0.903390,0.907633,0.911785,0.915846,0.919816,0.923693,0.927478,0.931171,0.934770,0.938276,0.941688,0.945005,0.948229,0.951357,0.954390,0.957328,0.960170,0.962916,0.965566,0.968119,0.970576,0.972935,0.975197,0.977362,0.979429,0.981398,0.983268,0.985041,0.986715,0.988290,0.989766,0.991144,0.992422,0.993601,0.994681,0.995661,0.996542,0.997323,0.998004,0.998586,0.999068,0.999449,0.999731,0.999913,0.999995,0.999977};

//Rotate the polygon poly of n points, rad radians around the point (x_pivot, y_pivot)
vgapoint_t* rotate(int n, vgapoint_t *poly, double rad, int x_pivot, int y_pivot)
{
	vgapoint_t* newpoly = malloc(sizeof(short) * 2 * n);
	int i;
	for (i = 0; i < n; i++)
	{
		double x = (double)poly[i].x - x_pivot; // Translate to origin
		double y = (double)poly[i].y - y_pivot;
		double c = fastcos[(int)(rad*100)];
		double s = fastsin[(int)(rad*100)];
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
