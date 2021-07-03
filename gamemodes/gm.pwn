#include <a_samp>
#include <a_players>
#include <a_http>
#include <streamer>
#include <dfile>
#include <kolory>
#include <Sscanf2>
#include <zcmd>
#include <geolocation>
#include <foreach>
#include <nametagicy>


#define COLOR_AXWELL "FFAF00"
native WP_Hash(buffer[], len, const str[]); 

//Ustawienia serwera
#define SERVER_NAME "ICY PARTY SERVER"
#define SERVER_VERSION "1.0a"

#define MODE_NAME "IPS"
//Dialogi
#define DIALOG_REJESTRACJA 0
#define DIALOG_LOGOWANIE 1
#define DIALOG_HELP 3
#define DIALOG_TELES 4
#define DIALOG_TELES2 5
#define DIALOG_TELES3 6
#define DIALOG_TELES4 7
#define DIALOG_DM 8
#define DIALOG_ZMIENRANGE 9
#define DIALOG_ACMDS1 10
#define DIALOG_ACMDS2 11
#define DIALOG_ACMDS3 12

//Sciezki folderow
#define FOLDER_KONT "/Konta/"

//vehspawn
#define MAX_SLOTS 30
new VehicleSpawned[MAX_SLOTS];


//ranga admina
#define RANGA_GRACZ 0
#define RANGA_VIP 1
#define RANGA_MODERATOR 2
#define RANGA_ADMIN 3
#define RANGA_HEAD 4


new Text:ipslogowelcome;
new Text:welcomenew1;
new Text:welcomenew2;
new Text:welcomenew3;
new Text:welcomenew4;



new Float:svx[MAX_PLAYERS];
new Float:svy[MAX_PLAYERS];
new Float:svz[MAX_PLAYERS];
new Float:s1[MAX_PLAYERS];
new s2[MAX_PLAYERS];
new s3[MAX_PLAYERS][256];
new PlayerText:sdisplay[MAX_PLAYERS];
new stimer[MAX_PLAYERS];
forward speedometer(playerid);


new PlayerText:hpbar[MAX_PLAYERS];



new Text:adminmsg1;
new Text:adminmsg2;
new Text:adminmsg3;
//IBIZA TD
new Text:DrawZabawy[2];
new Text:TDLogo[5];
new Text:DateAndTime[2];
new Text:PasekDraw[8];
new Text:TDRandomMSG;
new PlayerText:PacketPing[MAX_PLAYERS];
new PlayerText:PlayerPasek[7][MAX_PLAYERS];



new RandomMessages[][] =
{
	{"Remember to join our Discord"},
	{"You need help? use /help"},
	{"Invite your friends"},
	{"We recommend /dm"},
	{"want a car? use /veh"},
	{"change your skin with /skin"}
};

//SPAWNARENAawpindia
new Float:RandomSpawns[][] = {
    {81.9128,2517.3906,16.4844,133.9198},
    {82.3142,2495.8757,16.4844,35.7578},
    {64.5072,2505.4646,16.4844,180.5192},
    {64.4209,2507.5703,16.4844,1.8925},
    {43.0526,2517.1331,16.4922,205.6615},
    {43.1977,2496.0112,16.4844,327.0771}
};
//spawnonede
new Float:OneDe[][] = {
	{230.2287,141.0358,1003.0234},
	{248.6567,140.5351,1003.0234},
	{249.7405,167.5007,1003.0234},
	{251.6307,176.7617,1003.0234},
	{274.6095,186.7084,1007.1718},
	{301.1839,170.9804,1007.1718},
	{300.1098,191.1047,1007.1718},
	{267.6767,185.8972,1008.1718},
	{246.1263,185.0934,1008.1718},
	{237.6552,195.4151,1008.1718},
	{230.3415,183.9320,1003.0312},
	{219.4372,188.6361,1003.0312},
	{189.1423,180.2904,1003.0234},
	{189.2474,157.4839,1003.0234},
	{208.6718,142.0770,1003.0299},
	{217.8000,150.7339,1003.0234},
	{222.6867,151.6086,1003.0234},
	{188.7494,156.9470,1003.0234},
	{188.5090,177.8251,1003.0234}
};
//spawnmini
new Float:MiniSpawn[][] = {
	{202.1684,1858.5924,13.1406},
	{225.1218,1873.2874,13.7343},
	{197.3199,1874.3778,17.6406},
	{142.7879,1875.5710,17.8434},
	{117.8912,1870.6911,17.8359},
	{99.5237,1895.7354,18.0740},
	{127.9761,1938.2708,19.2881},
	{262.8418,1905.1951,17.6406},
	{282.4532,1840.2349,17.6480},
	{267.6824,1802.8845,17.6406},
	{213.9810,1805.1842,17.6406},
	{209.3716,1810.6752,21.8671},
	{187.4795,1833.6187,23.2421},
	{153.4587,1844.8542,17.6406},
	{141.3921,1875.8142,17.8434},
	{158.7537,1909.3345,18.7302}
};
//spawncaliguli
new Float:CaliSpawn[][] = {
	{2169.461181,1618.798339,999.976562},
	{2205.3752,1610.7854,999.9744},
	{2218.2583,1615.1359,999.9827},
	{2227.6104,1593.1724,999.9626},
	{2220.4353,1554.7821,1004.7241},
	{2205.2705,1581.4738,999.9818},
	{2181.4155,1579.5675,999.9713},
	{2171.7253,1586.5229,999.9753},
	{2171.5410,1623.8586,999.9739},
	{2194.0083,1611.9438,999.9711}
};

//spawnsawnoff
new Float:SoSpawn[][] ={
	{1414.9399,4.4321,1000.9268},
	{1362.4952,-45.3418,1000.9183},
	{1363.6895,1.8536,1000.9219},
	{1416.4829,-45.6389,1000.9270},
	{1390.8240,-46.7890,1000.9240},
	{1388.9939,1.6657,1000.9127},
	{1362.2169,-17.6287,1000.9219},
	{1415.2019,-18.2120,1000.9256}
};
//spawnantic
new Float:AntiSpawn[][] ={
	{-1292.0293,2553.1057,86.1887},
	{-1283.4886,2516.3948,87.1538},
	{-1290.2943,2513.0205,87.0397},
	{-1312.7424,2478.6619,87.1392},
	{-1316.0775,2499.6892,87.0420},
	{-1326.1831,2504.2461,87.0469},
	{-1339.1919,2523.6089,87.0469},
	{-1332.1841,2527.7161,87.1044},
	{-1318.1293,2546.6089,87.7422},
	{-1316.0164,2526.1841,87.5389},
	{-1308.2026,2541.8035,87.7422},
	{-1307.1095,2556.2473,87.1991},
	{-1299.4099,2526.7290,87.5604}
};
//spawnsniper

new Float:SniperSpawn[][] ={
	{-975.7005,1060.9900,1345.6719},
	{-975.0375,1090.4404,1344.9738},
	{-972.0090,1022.4880,1345.0612},
	{-996.5230,1034.7751,1341.9401},
	{-1047.6582,1023.8419,1343.0697},
	{-1022.4621,1088.4529,1343.5718},
	{-1055.8547,1097.3336,1343.0703},
	{-1086.8132,1035.0153,1343.1124},
	{-1105.0791,1083.4423,1342.1877},
	{-1131.8840,1094.8361,1345.7911},
	{-1129.6978,1057.4452,1346.4141},
	{-1130.8232,1029.1704,1345.7245}
};


new Float:RandomSpawnOW[][] = {
	{2504.8557,-1668.1201,13.3695,90.0},
    {2108.2048,1022.2280,10.8203,177.0},
    {-1972.8636,288.6777,35.1719,92.0},
    {-279.8016,1538.4362,75.3570,135.0},
    {1680.5010,1593.2078,10.8203,104.0},
	{1961.6454,-2255.9773,13.5469,176.0},
    {-1320.9324,-411.5818,14.1484,266.0},
    {2281.7026,-38.3575,26.4876,359.0},
    {1223.8655,-1815.7615,16.5938,190.0},
    {2844.5093,1291.1006,11.3906,89.0},
	{-1972.6777,137.9721,27.6875,90.0},
    {-2227.6858,2326.7825,7.5469,88.0},
    {-1552.7572,2647.7339,55.8359,271.0},
    {-846.4752,2741.0237,45.7801,185.0},
    {-251.8926,2603.7224,62.8582,185.0},
	{403.4505,2536.3401,16.5456,167.0},
    {-89.5088,1219.1871,19.7422,180.0},
    {-856.3732,1542.9072,22.8289,266.0},
    {-2172.6912,-2428.5659,30.6250,230.0},
    {-2320.5913,-1636.5212,483.7031,192.0},
	{1334.5803,288.0219,19.5615,245.0},
    {167.8942,-40.7553,1.5781,253.0},
    {-391.6147,2275.4690,40.9376,188.0},
	{-1297.1420,2501.3269,86.9221,11.0},
    {213.7717,1866.8424,13.1406,369.0}
};


//Enumy

enum Dgracza
{
	bool:Zalogowany,
	bool:Banned,
	Ranga,
	Kills,
	Deaths,
	WybranyGracz,
	IP[128],
	bool:Dead,
	bool:tdon,
	bool:Warenie,
};
new IsGod[MAX_PLAYERS];
new killstreak[MAX_PLAYERS];
new DaneGracza[MAX_PLAYERS][Dgracza];
new DaneAreny[MAX_PLAYERS][Dgracza];
new DaneTextdraw[MAX_PLAYERS][Dgracza];
new IdAreny[MAX_PLAYERS];
//antictimers
new bool:pCBugging[MAX_PLAYERS];
new ptmCBugFreezeOver[MAX_PLAYERS];
new ptsLastFiredWeapon[MAX_PLAYERS];

new npcbuscar;
new gamemodetext[128];
public OnGameModeInit()
{
	foreach(new i : Player)
	{
	    if(VehicleSpawned[i] != -1)
		{
	        DestroyVehicle(VehicleSpawned[i]);
	        VehicleSpawned[i] = (-1);
		}
	}
	DmArenaObiekty();
	format(gamemodetext,sizeof(gamemodetext),"IPS %s",SERVER_VERSION);
	SetGameModeText(gamemodetext);
//animacjegracza
	UsePlayerPedAnims();
	ShowNameTags(0);
	SetNameTagDrawDistance(0.0);
	DisableInteriorEnterExits();
	
	AddPlayerClass(0, 0.0, 0.0, 3.0, 0.0, 0, 0, 0, 0, 0, 0);
	
	//npc
	ConnectNPC("rejbot", "bot");
	npcbuscar = CreateVehicle(431, 0, 0, 10, 0, 1, 2, 0, 0);
	
	SetTimer("scoreikasanaczas", 300000, true);
	SetTimer("updatesekunda", 1000, true);
	SetTimer("Reklama",900000, true);
	SetTimer("update5", 5000, true);
	
	if(!dfile_FileExists(FOLDER_KONT))
		return printf("BLAD: Folder %s nie istnieje w folderze Scriptfiles! Stworz ja!", FOLDER_KONT);
	
	printf("\nGamemode %s wersja %s by icy zostal pomyslnie wlaczony!\n", SERVER_NAME, SERVER_VERSION);


//td welcome
	welcomenew1 = TextDrawCreate(-27.000000, 0.000000, "_");
	TextDrawFont(welcomenew1, 1);
	TextDrawLetterSize(welcomenew1, 1.058333, 4.500000);
	TextDrawTextSize(welcomenew1, 830.500000, 17.000000);
	TextDrawSetOutline(welcomenew1, 1);
	TextDrawSetShadow(welcomenew1, 0);
	TextDrawAlignment(welcomenew1, 1);
	TextDrawColor(welcomenew1, -1);
	TextDrawBackgroundColor(welcomenew1, 255);
	TextDrawBoxColor(welcomenew1, 150);
	TextDrawUseBox(welcomenew1, 1);
	TextDrawSetProportional(welcomenew1, 1);
	TextDrawSetSelectable(welcomenew1, 0);

	welcomenew2 = TextDrawCreate(-27.000000, 410.000000, "_");
	TextDrawFont(welcomenew2, 1);
	TextDrawLetterSize(welcomenew2, 1.058333, 4.500000);
	TextDrawTextSize(welcomenew2, 830.500000, 17.000000);
	TextDrawSetOutline(welcomenew2, 1);
	TextDrawSetShadow(welcomenew2, 0);
	TextDrawAlignment(welcomenew2, 1);
	TextDrawColor(welcomenew2, -1);
	TextDrawBackgroundColor(welcomenew2, 255);
	TextDrawBoxColor(welcomenew2, 150);
	TextDrawUseBox(welcomenew2, 1);
	TextDrawSetProportional(welcomenew2, 1);
	TextDrawSetSelectable(welcomenew2, 0);

	welcomenew3 = TextDrawCreate(320.000000, 30.000000, "~y~-");
	TextDrawFont(welcomenew3, 1);
	TextDrawLetterSize(welcomenew3, 40.762580, 2.000000);
	TextDrawTextSize(welcomenew3, 400.000000, 17.000000);
	TextDrawSetOutline(welcomenew3, 0);
	TextDrawSetShadow(welcomenew3, 0);
	TextDrawAlignment(welcomenew3, 2);
	TextDrawColor(welcomenew3, -1);
	TextDrawBackgroundColor(welcomenew3, 255);
	TextDrawBoxColor(welcomenew3, 50);
	TextDrawUseBox(welcomenew3, 0);
	TextDrawSetProportional(welcomenew3, 1);
	TextDrawSetSelectable(welcomenew3, 0);

	welcomenew4 = TextDrawCreate(320.000000, 397.000000, "~y~-");
	TextDrawFont(welcomenew4, 1);
	TextDrawLetterSize(welcomenew4, 40.762580, 2.000000);
	TextDrawTextSize(welcomenew4, 400.000000, 17.000000);
	TextDrawSetOutline(welcomenew4, 0);
	TextDrawSetShadow(welcomenew4, 0);
	TextDrawAlignment(welcomenew4, 2);
	TextDrawColor(welcomenew4, -1);
	TextDrawBackgroundColor(welcomenew4, 255);
	TextDrawBoxColor(welcomenew4, 50);
	TextDrawUseBox(welcomenew4, 0);
	TextDrawSetProportional(welcomenew4, 1);
	TextDrawSetSelectable(welcomenew4, 0);

	ipslogowelcome = TextDrawCreate(206.000000, 9.000000, "~y~I~w~CY ~y~P~w~ARTY ~y~S~w~erver");
	TextDrawFont(ipslogowelcome, 2);
	TextDrawLetterSize(ipslogowelcome, 0.600000, 2.000000);
	TextDrawTextSize(ipslogowelcome, 510.000000, 17.000000);
	TextDrawSetOutline(ipslogowelcome, 1);
	TextDrawSetShadow(ipslogowelcome, 0);
	TextDrawAlignment(ipslogowelcome, 1);
	TextDrawColor(ipslogowelcome, -1);
	TextDrawBackgroundColor(ipslogowelcome, 255);
	TextDrawBoxColor(ipslogowelcome, 50);
	TextDrawUseBox(ipslogowelcome, 0);
	TextDrawSetProportional(ipslogowelcome, 1);
	TextDrawSetSelectable(ipslogowelcome, 0);
/////////////////////////////////////////////////////////////////////////////////
	adminmsg1 = TextDrawCreate(143.000000, 381.000000, " ");
	TextDrawFont(adminmsg1, 1);
	TextDrawLetterSize(adminmsg1, 0.262499, 1.349998);
	TextDrawTextSize(adminmsg1, 639.500000, 37.000000);
	TextDrawSetOutline(adminmsg1, 1);
	TextDrawSetShadow(adminmsg1, 0);
	TextDrawAlignment(adminmsg1, 1);
	TextDrawColor(adminmsg1, -1378294017);
	TextDrawBackgroundColor(adminmsg1, 255);
	TextDrawBoxColor(adminmsg1, 50);
	TextDrawUseBox(adminmsg1, 0);
	TextDrawSetProportional(adminmsg1, 1);
	TextDrawSetSelectable(adminmsg1, 0);

	adminmsg2 = TextDrawCreate(143.000000, 400.000000, " ");
	TextDrawFont(adminmsg2, 1);
	TextDrawLetterSize(adminmsg2, 0.262499, 1.349998);
	TextDrawTextSize(adminmsg2, 639.500000, 37.000000);
	TextDrawSetOutline(adminmsg2, 1);
	TextDrawSetShadow(adminmsg2, 0);
	TextDrawAlignment(adminmsg2, 1);
	TextDrawColor(adminmsg2, -1378294017);
	TextDrawBackgroundColor(adminmsg2, 255);
	TextDrawBoxColor(adminmsg2, 50);
	TextDrawUseBox(adminmsg2, 0);
	TextDrawSetProportional(adminmsg2, 1);
	TextDrawSetSelectable(adminmsg2, 0);

	adminmsg3 = TextDrawCreate(143.000000, 419.000000, " ");
	TextDrawFont(adminmsg3, 1);
	TextDrawLetterSize(adminmsg3, 0.262499, 1.349998);
	TextDrawTextSize(adminmsg3, 639.500000, 37.000000);
	TextDrawSetOutline(adminmsg3, 1);
	TextDrawSetShadow(adminmsg3, 0);
	TextDrawAlignment(adminmsg3, 1);
	TextDrawColor(adminmsg3, -1378294017);
	TextDrawBackgroundColor(adminmsg3, 255);
	TextDrawBoxColor(adminmsg3, 50);
	TextDrawUseBox(adminmsg3, 0);
	TextDrawSetProportional(adminmsg3, 1);
	TextDrawSetSelectable(adminmsg3, 0);
	//TD IBIZA
	PasekDraw[0] = TextDrawCreate(-14.000000, 423.000000, "hud:radar_hostpital");
	TextDrawFont(PasekDraw[0], 4);
	TextDrawLetterSize(PasekDraw[0], 0.600000, 2.000000);
	TextDrawTextSize(PasekDraw[0], 679.000000, 25.000000);
	TextDrawSetOutline(PasekDraw[0], 0);
	TextDrawSetShadow(PasekDraw[0], 4);
	TextDrawAlignment(PasekDraw[0], 2);
	TextDrawColor(PasekDraw[0], 95);
	TextDrawBackgroundColor(PasekDraw[0], 255);
	TextDrawBoxColor(PasekDraw[0], 255);
	TextDrawUseBox(PasekDraw[0], 1);
	TextDrawSetProportional(PasekDraw[0], 1);
	TextDrawSetSelectable(PasekDraw[0], 0);

	PasekDraw[1] = TextDrawCreate(656.000000, 430.000000, "_");
	TextDrawFont(PasekDraw[1], 1);
	TextDrawLetterSize(PasekDraw[1], -0.441666, -0.250000);
	TextDrawTextSize(PasekDraw[1], 400.000000, 17.000000);
	TextDrawSetOutline(PasekDraw[1], 1);
	TextDrawSetShadow(PasekDraw[1], 0);
	TextDrawAlignment(PasekDraw[1], 3);
	TextDrawColor(PasekDraw[1], 16711935);
	TextDrawBackgroundColor(PasekDraw[1], 255);
	TextDrawBoxColor(PasekDraw[1], 852308735);
	TextDrawUseBox(PasekDraw[1], 1);
	TextDrawSetProportional(PasekDraw[1], 0);
	TextDrawSetSelectable(PasekDraw[1], 0);

	DrawZabawy[0] = TextDrawCreate(2.000000, 136.000000, "~n~~n~/arena~n~~n~/onede~n~~n~/mini~n~~n~/wh~n~~n~/so~n~~n~/antic~n~~n~/sniper");
	TextDrawFont(DrawZabawy[0], 2);
	TextDrawLetterSize(DrawZabawy[0], 0.183329, 1.049998);
	TextDrawTextSize(DrawZabawy[0], 400.000000, 17.000000);
	TextDrawSetOutline(DrawZabawy[0], 1);
	TextDrawSetShadow(DrawZabawy[0], 0);
	TextDrawAlignment(DrawZabawy[0], 1);
	TextDrawColor(DrawZabawy[0], 1084679167);
	TextDrawBackgroundColor(DrawZabawy[0], 255);
	TextDrawBoxColor(DrawZabawy[0], 50);
	TextDrawUseBox(DrawZabawy[0], 0);
	TextDrawSetProportional(DrawZabawy[0], 1);
	TextDrawSetSelectable(DrawZabawy[0], 0);

	//DrawZabawy[1] = TextDrawCreate(10.000000, 145.000000, "~n~~n~0~n~~n~0~n~~n~0~n~~n~0~n~~n~0~n~~n~0~n~~n~0");
	DrawZabawy[1] = TextDrawCreate(10.000000, 145.000000, " ");
	TextDrawFont(DrawZabawy[1], 2);
	TextDrawLetterSize(DrawZabawy[1], 0.183329, 1.049998);
	TextDrawTextSize(DrawZabawy[1], 400.000000, 17.000000);
	TextDrawSetOutline(DrawZabawy[1], 1);
	TextDrawSetShadow(DrawZabawy[1], 0);
	TextDrawAlignment(DrawZabawy[1], 1);
	TextDrawColor(DrawZabawy[1], -1);
	TextDrawBackgroundColor(DrawZabawy[1], 255);
	TextDrawBoxColor(DrawZabawy[1], 50);
	TextDrawUseBox(DrawZabawy[1], 0);
	TextDrawSetProportional(DrawZabawy[1], 1);
	TextDrawSetSelectable(DrawZabawy[1], 0);

	TDLogo[0] = TextDrawCreate(545.000000, 409.000000, "I");
	TextDrawFont(TDLogo[0], 2);
	TextDrawLetterSize(TDLogo[0], 0.312498, 2.049998);
	TextDrawTextSize(TDLogo[0], 400.000000, 17.000000);
	TextDrawSetOutline(TDLogo[0], 1);
	TextDrawSetShadow(TDLogo[0], 0);
	TextDrawAlignment(TDLogo[0], 1);
	TextDrawColor(TDLogo[0], 255);
	TextDrawBackgroundColor(TDLogo[0], -65281);
	TextDrawBoxColor(TDLogo[0], 50);
	TextDrawUseBox(TDLogo[0], 0);
	TextDrawSetProportional(TDLogo[0], 1);
	TextDrawSetSelectable(TDLogo[0], 0);

	TDLogo[1] = TextDrawCreate(548.000000, 415.000000, "cy");
	TextDrawFont(TDLogo[1], 2);
	TextDrawLetterSize(TDLogo[1], 0.224996, 1.200001);
	TextDrawTextSize(TDLogo[1], 400.000000, 17.000000);
	TextDrawSetOutline(TDLogo[1], 1);
	TextDrawSetShadow(TDLogo[1], 0);
	TextDrawAlignment(TDLogo[1], 1);
	TextDrawColor(TDLogo[1], 255);
	TextDrawBackgroundColor(TDLogo[1], -65281);
	TextDrawBoxColor(TDLogo[1], 50);
	TextDrawUseBox(TDLogo[1], 0);
	TextDrawSetProportional(TDLogo[1], 1);
	TextDrawSetSelectable(TDLogo[1], 0);

	TDLogo[2] = TextDrawCreate(576.000000, 410.000000, "P");
	TextDrawFont(TDLogo[2], 2);
	TextDrawLetterSize(TDLogo[2], 0.299997, 1.850000);
	TextDrawTextSize(TDLogo[2], 400.000000, 17.000000);
	TextDrawSetOutline(TDLogo[2], 1);
	TextDrawSetShadow(TDLogo[2], 0);
	TextDrawAlignment(TDLogo[2], 1);
	TextDrawColor(TDLogo[2], 255);
	TextDrawBackgroundColor(TDLogo[2], 16711935);
	TextDrawBoxColor(TDLogo[2], 50);
	TextDrawUseBox(TDLogo[2], 0);
	TextDrawSetProportional(TDLogo[2], 1);
	TextDrawSetSelectable(TDLogo[2], 0);

	TDLogo[3] = TextDrawCreate(584.000000, 415.000000, "arty");
	TextDrawFont(TDLogo[3], 2);
	TextDrawLetterSize(TDLogo[3], 0.224996, 1.200001);
	TextDrawTextSize(TDLogo[3], 400.000000, 17.000000);
	TextDrawSetOutline(TDLogo[3], 1);
	TextDrawSetShadow(TDLogo[3], 0);
	TextDrawAlignment(TDLogo[3], 1);
	TextDrawColor(TDLogo[3], 255);
	TextDrawBackgroundColor(TDLogo[3], 16711935);
	TextDrawBoxColor(TDLogo[3], 50);
	TextDrawUseBox(TDLogo[3], 0);
	TextDrawSetProportional(TDLogo[3], 1);
	TextDrawSetSelectable(TDLogo[3], 0);

	TDLogo[4] = TextDrawCreate(578.000000, 430.000000, "www.discord.gg/rHg97EP");
	TextDrawFont(TDLogo[4], 1);
	TextDrawLetterSize(TDLogo[4], 0.224996, 1.049998);
	TextDrawTextSize(TDLogo[4], 400.000000, 17.000000);
	TextDrawSetOutline(TDLogo[4], 0);
	TextDrawSetShadow(TDLogo[4], 0);
	TextDrawAlignment(TDLogo[4], 2);
	TextDrawColor(TDLogo[4], -1);
	TextDrawBackgroundColor(TDLogo[4], 255);
	TextDrawBoxColor(TDLogo[4], 50);
	TextDrawUseBox(TDLogo[4], 0);
	TextDrawSetProportional(TDLogo[4], 1);
	TextDrawSetSelectable(TDLogo[4], 0);

	DateAndTime[0] = TextDrawCreate(577.000000, 27.000000, "00:00");
	TextDrawFont(DateAndTime[0], 1);
	TextDrawLetterSize(DateAndTime[0], 0.291666, 0.849999);
	TextDrawTextSize(DateAndTime[0], 400.000000, 17.000000);
	TextDrawSetOutline(DateAndTime[0], 1);
	TextDrawSetShadow(DateAndTime[0], 0);
	TextDrawAlignment(DateAndTime[0], 2);
	TextDrawColor(DateAndTime[0], -1);
	TextDrawBackgroundColor(DateAndTime[0], 255);
	TextDrawBoxColor(DateAndTime[0], 50);
	TextDrawUseBox(DateAndTime[0], 0);
	TextDrawSetProportional(DateAndTime[0], 1);
	TextDrawSetSelectable(DateAndTime[0], 0);

	DateAndTime[1] = TextDrawCreate(577.000000, 35.000000, "16.11.2020");
	TextDrawFont(DateAndTime[1], 1);
	TextDrawLetterSize(DateAndTime[1], 0.291666, 0.849999);
	TextDrawTextSize(DateAndTime[1], 400.000000, 17.000000);
	TextDrawSetOutline(DateAndTime[1], 1);
	TextDrawSetShadow(DateAndTime[1], 0);
	TextDrawAlignment(DateAndTime[1], 2);
	TextDrawColor(DateAndTime[1], 16711935);
	TextDrawBackgroundColor(DateAndTime[1], 255);
	TextDrawBoxColor(DateAndTime[1], 50);
	TextDrawUseBox(DateAndTime[1], 0);
	TextDrawSetProportional(DateAndTime[1], 1);
	TextDrawSetSelectable(DateAndTime[1], 0);

	PasekDraw[2] = TextDrawCreate(248.000000, 416.000000, "~y~]");
	TextDrawFont(PasekDraw[2], 2);
	TextDrawLetterSize(PasekDraw[2], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[2], 400.000000, 17.000000);
	TextDrawSetOutline(PasekDraw[2], 0);
	TextDrawSetShadow(PasekDraw[2], 0);
	TextDrawAlignment(PasekDraw[2], 1);
	TextDrawColor(PasekDraw[2], -1);
	TextDrawBackgroundColor(PasekDraw[2], 255);
	TextDrawBoxColor(PasekDraw[2], 50);
	TextDrawUseBox(PasekDraw[2], 0);
	TextDrawSetProportional(PasekDraw[2], 1);
	TextDrawSetSelectable(PasekDraw[2], 0);

	PasekDraw[3] = TextDrawCreate(191.000000, 416.000000, "HUD:radar_race");
	TextDrawFont(PasekDraw[3], 4);
	TextDrawLetterSize(PasekDraw[3], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[3], 10.000000, 10.500000);
	TextDrawSetOutline(PasekDraw[3], 1);
	TextDrawSetShadow(PasekDraw[3], 0);
	TextDrawAlignment(PasekDraw[3], 1);
	TextDrawColor(PasekDraw[3], -1);
	TextDrawBackgroundColor(PasekDraw[3], 255);
	TextDrawBoxColor(PasekDraw[3], 50);
	TextDrawUseBox(PasekDraw[3], 0);
	TextDrawSetProportional(PasekDraw[3], 1);
	TextDrawSetSelectable(PasekDraw[3], 0);

	PasekDraw[4] = TextDrawCreate(304.000000, 415.000000, "HUD:radar_emmetgun");
	TextDrawFont(PasekDraw[4], 4);
	TextDrawLetterSize(PasekDraw[4], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[4], 10.000000, 10.500000);
	TextDrawSetOutline(PasekDraw[4], 1);
	TextDrawSetShadow(PasekDraw[4], 0);
	TextDrawAlignment(PasekDraw[4], 1);
	TextDrawColor(PasekDraw[4], -1);
	TextDrawBackgroundColor(PasekDraw[4], 255);
	TextDrawBoxColor(PasekDraw[4], 50);
	TextDrawUseBox(PasekDraw[4], 0);
	TextDrawSetProportional(PasekDraw[4], 1);
	TextDrawSetSelectable(PasekDraw[4], 0);

	PasekDraw[5] = TextDrawCreate(357.000000, 415.000000, "HUD:radar_locosyndicate");
	TextDrawFont(PasekDraw[5], 4);
	TextDrawLetterSize(PasekDraw[5], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[5], 10.000000, 10.500000);
	TextDrawSetOutline(PasekDraw[5], 1);
	TextDrawSetShadow(PasekDraw[5], 0);
	TextDrawAlignment(PasekDraw[5], 1);
	TextDrawColor(PasekDraw[5], -1);
	TextDrawBackgroundColor(PasekDraw[5], 255);
	TextDrawBoxColor(PasekDraw[5], 50);
	TextDrawUseBox(PasekDraw[5], 0);
	TextDrawSetProportional(PasekDraw[5], 1);
	TextDrawSetSelectable(PasekDraw[5], 0);

	PasekDraw[6] = TextDrawCreate(408.000000, 415.000000, "HUD:radar_ammugun");
	TextDrawFont(PasekDraw[6], 4);
	TextDrawLetterSize(PasekDraw[6], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[6], 10.000000, 10.500000);
	TextDrawSetOutline(PasekDraw[6], 1);
	TextDrawSetShadow(PasekDraw[6], 0);
	TextDrawAlignment(PasekDraw[6], 1);
	TextDrawColor(PasekDraw[6], -1);
	TextDrawBackgroundColor(PasekDraw[6], 255);
	TextDrawBoxColor(PasekDraw[6], 50);
	TextDrawUseBox(PasekDraw[6], 0);
	TextDrawSetProportional(PasekDraw[6], 1);
	TextDrawSetSelectable(PasekDraw[6], 0);

	PasekDraw[7] = TextDrawCreate(454.000000, 415.000000, "HUD:radar_gangB");
	TextDrawFont(PasekDraw[7], 4);
	TextDrawLetterSize(PasekDraw[7], 0.291666, 1.200000);
	TextDrawTextSize(PasekDraw[7], 10.000000, 10.500000);
	TextDrawSetOutline(PasekDraw[7], 1);
	TextDrawSetShadow(PasekDraw[7], 0);
	TextDrawAlignment(PasekDraw[7], 1);
	TextDrawColor(PasekDraw[7], -1);
	TextDrawBackgroundColor(PasekDraw[7], 255);
	TextDrawBoxColor(PasekDraw[7], 50);
	TextDrawUseBox(PasekDraw[7], 0);
	TextDrawSetProportional(PasekDraw[7], 1);
	TextDrawSetSelectable(PasekDraw[7], 0);

	TDRandomMSG = TextDrawCreate(394.000000, 400.000000, "~y~] ~w~~h~random message~y~]");
	TextDrawFont(TDRandomMSG, 2);
	TextDrawLetterSize(TDRandomMSG, 0.191666, 1.049998);
	TextDrawTextSize(TDRandomMSG, 400.000000, 17.000000);
	TextDrawSetOutline(TDRandomMSG, 1);
	TextDrawSetShadow(TDRandomMSG, 0);
	TextDrawAlignment(TDRandomMSG, 3);
	TextDrawColor(TDRandomMSG, -1);
	TextDrawBackgroundColor(TDRandomMSG, 255);
	TextDrawBoxColor(TDRandomMSG, 50);
	TextDrawUseBox(TDRandomMSG, 0);
	TextDrawSetProportional(TDRandomMSG, 1);
	TextDrawSetSelectable(TDRandomMSG, 0);
	
	return 1;
}

public OnGameModeExit()
{
	TextDrawDestroy(PasekDraw[0]);
	TextDrawDestroy(PasekDraw[1]);
	TextDrawDestroy(TDLogo[0]);
	TextDrawDestroy(DrawZabawy[0]);
	TextDrawDestroy(DrawZabawy[1]);
	TextDrawDestroy(TDLogo[1]);
	TextDrawDestroy(TDLogo[2]);
	TextDrawDestroy(TDLogo[3]);
	TextDrawDestroy(TDLogo[4]);
	TextDrawDestroy(DateAndTime[0]);
	TextDrawDestroy(DateAndTime[1]);
	TextDrawDestroy(PasekDraw[2]);
	TextDrawDestroy(PasekDraw[3]);
	TextDrawDestroy(PasekDraw[4]);
	TextDrawDestroy(PasekDraw[5]);
	TextDrawDestroy(PasekDraw[6]);
	TextDrawDestroy(PasekDraw[7]);
	TextDrawDestroy(TDRandomMSG);
	return 1;
}

//////sercanadglogowa
new HealthIcon[MAX_PLAYERS];

public OnPlayerTakeDamage(playerid)
{
	if(DaneGracza[playerid][Dead] == false)
	{
		DestroyObject(HealthIcon[playerid]);
		HealthIcon[playerid] = CreateObject(1240, 0,0,0,0,0,0);
		AttachObjectToPlayer(HealthIcon[playerid], playerid, 0.0, 0.0, 1.5, 0.0, 0.0, 0.0);
		SetTimerEx("UsunSerceglowa", 1000, false, "i", playerid);
	}
	PlayerPlaySound(playerid,1190,0.0,0.0,0.0); //pain sound
	return 1;
}

//horn 3200
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	PlayerPlaySound(playerid, 1084, 0.0, 0.0, 0.0);
	new string[300];
	if(dialogid == DIALOG_ZMIENRANGE)
	{
		if(response)
		{
			new id = DaneGracza[playerid][WybranyGracz];
			DaneGracza[id][Ranga] = listitem;
			format(string, sizeof string, "{"COLOR_AXWELL"}> {ffffff}You have changed {"COLOR_AXWELL"}%s [%i] {ffffff} rank to {"COLOR_AXWELL"}%s.", NazwaGracza(id), id, NazwaRangi(listitem));
			SendClientMessage(playerid, -1, string);
			format(string, sizeof string, "{"COLOR_AXWELL"}> {ffffff} Administrator {"COLOR_AXWELL"}%s [%i] {ffffff}changed Your rank to {"COLOR_AXWELL"}%s.", NazwaGracza(playerid), playerid, NazwaRangi(listitem));
			SendClientMessage(id, -1, string);
		}
	}
	
	if(dialogid == DIALOG_LOGOWANIE)
	{
		if(response)
		{
			dfile_Open(SciezkaKontaGracza(playerid));
			new haslo[300], hasloex[130];
			haslo = dfile_ReadString("Haslo");
			WP_Hash(hasloex, sizeof hasloex, inputtext);
			dfile_CloseFile();
			if(strcmp(hasloex, haslo, false) == 0)
			{
				WczytajKonto(playerid);
				DaneGracza[playerid][Zalogowany] = true;
				TogglePlayerSpectating(playerid, false);
				//SetTimerEx("SpawnujGracza", 500, false, "i", playerid);
				SendClientMessage(playerid, COLOR_WHITE, "{FFAF00}> {ffffff}You have successfully logged in!");
				StopAudioStreamForPlayer(playerid); 
				//loadskin
				dfile_Open(SciezkaKontaGracza(playerid));
				SetPlayerSkin(playerid, dfile_ReadInt("Skin"));
				DaneGracza[playerid][Kills] = dfile_ReadInt("Kills");
				DaneGracza[playerid][Deaths] = dfile_ReadInt("Deaths");
				dfile_CloseFile();
				//tdrawy
				spawnTD(playerid);

				SetPlayerTime(playerid, 12, 0);
			}
			else
			{
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_RED, "> {ffffff}Wrong password.");
			}
		}
		else Kick(playerid);
	}
	else if(dialogid == DIALOG_REJESTRACJA)
	{
		if(response)
		{
			if(strlen(inputtext) >= 6)
			{
				StworzKonto(playerid, inputtext);
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_WHITE, "{FFAF00}> {ffffff}Your account was created!");
			}
			else
			{
				OknoRejestracji(playerid);
				SendClientMessage(playerid, COLOR_RED, "> {ffffff}Password has to be at least 6 digits long!");
			}
		}
		else Kick(playerid);
	}
//teles
	else if(dialogid == DIALOG_TELES)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,5,DIALOG_STYLE_MSGBOX,"Teleports Page 2","{FFAF00}/lsa {ffffff}- tp to Los Santos Airport\n{FFAF00}/sfa {ffffff}- tp to San Fierro Airport\n{FFAF00}/lva {ffffff}- tp to Las Venturas Airport\n{FFAF00}/aa {ffffff}- tp to Abandoned Airport in Las Venturas", ">","X");
		}
	}
	else if(dialogid == DIALOG_TELES2)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,6,DIALOG_STYLE_MSGBOX,"Teleports Page 3","{FFAF00}/pc {ffffff}- tp to Palomeeno Creek\n{FFAF00}/mg {ffffff}- tp to Montgomery\n{FFAF00}/bb {ffffff}- tp to Blueberry\n{FFAF00}/ap {ffffff}- tp to Angel Pine\n{FFAF00}/bayside {ffffff}- tp to Bayside", ">","X");
		}
	}
	else if(dialogid == DIALOG_TELES3)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,7,DIALOG_STYLE_MSGBOX,"Teleports Page 4","{FFAF00}/eq {ffffff}- tp to El Quebrados\n{FFAF00}/vo {ffffff}- tp to Valle Okultado\n{FFAF00}/lp {ffffff}- tp to Las Payasadas\n{FFAF00}/lb {ffffff}- tp to Las Barrancas\n{FFAF00}/fc {ffffff}- tp to Fort Carson", ">","X");
		}
	}
	else if(dialogid == DIALOG_TELES4)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,8,DIALOG_STYLE_MSGBOX,"Teleports Page 5","{FFAF00}/am {ffffff}- tp to Aldea Malvada\n{FFAF00}/gt {ffffff}- tp to Ghost Town (Las Brujas)\n{FFAF00}/army {ffffff}- tp to zone 69\n{FFAF00}/chiliad {ffffff}- tp to Mount Chiliad", "X","");
		}
	}
	else if(dialogid == DIALOG_DM)
	{
		if(response)
		{
			if(DaneAreny[playerid][Warenie] == true)
			{
				SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
			}
			else switch(listitem)
            {
                case 0: dajgraczadoareny(playerid);
                case 1: dajgraczadoonede(playerid);
                case 2: dajgraczadomini(playerid);
				case 3: dajgraczadowarehouse(playerid);
				case 4: dajgraczadosawnoff(playerid);
				case 5: dajgraczadoanticbug(playerid);
				case 6: dajgraczadosniper(playerid);
            }
		}
	}
	else if(dialogid == DIALOG_ACMDS1)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,11,DIALOG_STYLE_MSGBOX,"Admin cmds","{FFAF00}/ban playerid reason {ffffff}- Ban player\n{FFAF00}/unban name {ffffff}- Unban player", ">","x");
		}
	}
	else if(dialogid == DIALOG_ACMDS2)
	{
		if(response)
		{
			ShowPlayerDialog(playerid,12,DIALOG_STYLE_MSGBOX,"H@ cmds","{FFAF00}/god {ffffff}- {ffffff}Toggle godmode\n{FFAF00}/w id {ffffff}- {ffffff}change your virtual world\n{FFAF00}/delvehall {ffffff}- {ffffff}Despawn all vehicles\n{FFAF00}/gmx {ffffff}- {ffffff}Restart gamemode\n{FFAF00}/giverank playerid {ffffff}- {ffffff}change player rank duh\n{FFAF00}/clearmsg {ffffff}- {ffffff}clear admin messages\n{FFAF00}/msg1-3 text {ffffff}- {ffffff}admin message\n{00FFFF}fuck off form these.", ">","x");
		}
	}
	else if(dialogid == DIALOG_HELP)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, 13, DIALOG_STYLE_MSGBOX,"Help dialog 2","{FFAF00}/t playerid message {ffffff}- Priv message\n{FFAF00}/dm {ffffff}- DM menu\n{FFAF00}/exit {ffffff}- Exit DM arena", "X","");
		}
	}
	return 0;
}

new ConnectMsg[256];
public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid))
	{
		return 1;
	}
	ResetujDaneGracza(playerid);


	new ip[128], stringvpn[59];
	GetPlayerIp(playerid, ip, sizeof ip);
	format(stringvpn, sizeof stringvpn, "blackbox.ipinfo.app/lookup/%s", ip);
	HTTP(playerid, HTTP_GET, stringvpn, "", "MyHttpResponse");
	


	PlayAudioStreamForPlayer(playerid, "http://miastomuzyki.pl/n/rmfmaxxx.pls"); //audio
	
	SetPlayerColor(playerid, COLOR_WHITE);

	new name[MAX_PLAYER_NAME], string[200 + MAX_PLAYER_NAME], country[90];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerCountry(playerid, country, sizeof(country));
	format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has joined the server from {00ffff}%s.",name, playerid, country);
	SendClientMessageToAll(COLOR_WHITE, string);
	
	
	SetPlayerVirtualWorld(playerid, 1337);

///////////////////////////////////////////////////////	
	TextDrawShowForPlayer(playerid, ipslogowelcome);
	TextDrawShowForPlayer(playerid, welcomenew1);
	TextDrawShowForPlayer(playerid, welcomenew2);
	TextDrawShowForPlayer(playerid, welcomenew3);
	TextDrawShowForPlayer(playerid, welcomenew4);
////////////////////////////////////////////////////	
	
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	SendClientMessage(playerid, COLOR_WHITE, " ");
	format(ConnectMsg,sizeof(ConnectMsg),"{FFAF00}> {ffffff}Server version: {FFAF00}%s {FFFFFF}| for more information: {FFAF00}/help{FFFFFF}",SERVER_VERSION);
	SendClientMessage(playerid, COLOR_WHITE, ConnectMsg);

	//speedometero
	//speedometer
	ConnectTD(playerid);

	return 1;
}

#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(PRESSED(KEY_FIRE))
    {
        if (IsPlayerInAnyVehicle(playerid))
        {
            AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
        }
    }
	if(PRESSED(KEY_SUBMISSION))
    {
        if (IsPlayerInAnyVehicle(playerid))
        {
			RepairVehicle(GetPlayerVehicleID(playerid));
        }
    }
	//anticbug
	if(IdAreny[playerid] == 6)
	{
		if(!pCBugging[playerid] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			if(PRESSED(KEY_FIRE))
			{
				switch(GetPlayerWeapon(playerid))
				{
					case WEAPON_DEAGLE, WEAPON_SHOTGUN, WEAPON_SNIPER:
					{
						ptsLastFiredWeapon[playerid] = gettime();
					}
				}
			}
			else if(PRESSED(KEY_CROUCH))
			{
				if((gettime() - ptsLastFiredWeapon[playerid]) < 1)
				{
					TogglePlayerControllable(playerid, false);
					ClearAnimations(playerid,1);
					ApplyAnimation(playerid,"ped","FALL_COLLAPSE",4.1,0,1,1,0,0,1);
					pCBugging[playerid] = true;

					GameTextForPlayer(playerid, "~r~~h~DON'T C-BUG!", 3000, 4);

					KillTimer(ptmCBugFreezeOver[playerid]);
					ptmCBugFreezeOver[playerid] = SetTimerEx("CBugFreezeOver", 1000, false, "i", playerid);
				}
			}
		}
	}
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(DaneGracza[playerid][Zalogowany] == true)
	{
		ZapiszKonto(playerid);
		new name[MAX_PLAYER_NAME], string[700 + MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		switch(reason)
		{
			case 0:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Timeout/Crash).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
			case 1:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Quit).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
			case 2:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Kick/Ban).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
		}
	}
	else if(DaneGracza[playerid][Zalogowany] == false)
	{
		new name[MAX_PLAYER_NAME], string[700 + MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		switch(reason)
		{
			case 0:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Lack of login, Timeout/Crash).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
			case 1:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Lack of login, Quit).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
			case 2:
			{
				format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}has left the server {00ffff}(Lack of login, Kick/Ban).",name, playerid);
				SendClientMessageToAll(COLOR_WHITE, string);
			}
		}
	}
	ResetujDaneGracza(playerid);
	//usuntd
	PlayerTextDrawDestroy(playerid, hpbar[playerid]);
	

	PlayerTextDrawDestroy(playerid, PacketPing[playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[0][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[1][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[2][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[3][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[4][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[5][playerid]);
	PlayerTextDrawDestroy(playerid, PlayerPasek[6][playerid]);
	PlayerTextDrawDestroy(playerid, sdisplay[playerid]);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid))
	{
		PutPlayerInVehicle(playerid, npcbuscar, 0);
		//GivePlayerWeapon(playerid, 24, 999999999999999);
		//GivePlayerWeapon(playerid, 25, 999999999999999);
		SetPlayerSkin(playerid, 2);
		SetPlayerColor(playerid, COLOR_BLUE);
		return 1;
	}
	DaneGracza[playerid][Dead] = false;
	if(DaneGracza[playerid][Zalogowany] == false)
	{
		TogglePlayerSpectating(playerid, true);
		SetTimerEx("spec", 500, false, "i", playerid);
		SetTimerEx("flycamera", 750, false, "i", playerid);
		if(!dfile_FileExists(SciezkaKontaGracza(playerid)))
		{
			OknoRejestracji(playerid);
		}
		else
		{
			OknoLogowania(playerid);
		}
	}
	else if(DaneGracza[playerid][Zalogowany] == true)
	{
		PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
		//loadskin
		dfile_Open(SciezkaKontaGracza(playerid));
		SetPlayerSkin(playerid, dfile_ReadInt("Skin"));
		dfile_CloseFile();
		
		new rangaid = DaneGracza[playerid][Ranga];
		if(rangaid == RANGA_VIP)
		{
			SetPlayerColor(playerid, COLOR_YELLOW);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
		}
	}
	if(DaneAreny[playerid][Warenie] == true)
	{
		switch(IdAreny[playerid])
		{
			case 1:
			{
				new Random = random(sizeof(RandomSpawns));
				SetPlayerPos(playerid, RandomSpawns[Random][0], RandomSpawns[Random][1], RandomSpawns[Random][2]);
				SetPlayerFacingAngle(playerid, RandomSpawns[Random][3]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 2);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 25, 9999);
				GivePlayerWeapon(playerid, 24, 9999);
			}
			case 2:
			{
				new Rand=random(sizeof(OneDe));
				SetPlayerPos(playerid,OneDe[Rand][0],OneDe[Rand][1],OneDe[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 3);
				SetPlayerVirtualWorld(playerid, 3);
				SetPlayerHealth(playerid, 20);
				SetPlayerArmour(playerid, 0);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 24, 9999);
			}
			case 3:
			{
				new Rand=random(sizeof(MiniSpawn));
				SetPlayerPos(playerid,MiniSpawn[Rand][0],MiniSpawn[Rand][1],MiniSpawn[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 4);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 38, 99999);			
			}
			case 4:
			{
				new Rand=random(sizeof(CaliSpawn));
				SetPlayerPos(playerid,CaliSpawn[Rand][0],CaliSpawn[Rand][1],CaliSpawn[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, 5);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 31, 9999);
				GivePlayerWeapon(playerid, 27, 9999);
			}
			case 5:
			{
				new Rand=random(sizeof(SoSpawn));
				SetPlayerPos(playerid,SoSpawn[Rand][0],SoSpawn[Rand][1],SoSpawn[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 1);
				SetPlayerVirtualWorld(playerid, 6);
				SetPlayerHealth(playerid, 100);
				SetPlayerArmour(playerid, 100);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 26, 9999);
			}
			case 6:
			{
				new Rand=random(sizeof(AntiSpawn));
				SetPlayerPos(playerid,AntiSpawn[Rand][0],AntiSpawn[Rand][1],AntiSpawn[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 7);
				SetPlayerHealth(playerid, 160);
				SetPlayerArmour(playerid, 0);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 31, 9999);
				GivePlayerWeapon(playerid, 24, 9999);
			}
			case 7:
			{
				new Rand=random(sizeof(SniperSpawn));
				SetPlayerPos(playerid,SniperSpawn[Rand][0],SniperSpawn[Rand][1],SniperSpawn[Rand][2]);
				SetCameraBehindPlayer(playerid);
				SetPlayerInterior(playerid, 10);
				SetPlayerVirtualWorld(playerid, 8);
				SetPlayerHealth(playerid, 20);
				SetPlayerArmour(playerid, 0);
				ResetPlayerWeapons(playerid);
				GivePlayerWeapon(playerid, 34, 9999);
			}
		}
	}
	else
	{
		new randomspawn = random(sizeof(RandomSpawnOW));
		SetPlayerPos(playerid, RandomSpawnOW[randomspawn][0], RandomSpawnOW[randomspawn][1], RandomSpawnOW[randomspawn][2]);
		SetPlayerFacingAngle(playerid, RandomSpawnOW[randomspawn][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerArmour(playerid, 100);

		SetTimerEx("givegun", 1000, false, "i", playerid);
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid))
	{
		return 1;
	}
	SetTimerEx("SpawnujGracza", 600, false, "i", playerid);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	new wiadomosc[2048];
	new nazwarangi[32];
	new rangaid = DaneGracza[playerid][Ranga];
	nazwarangi = NazwaRangi(rangaid);
	if(DaneGracza[playerid][Zalogowany] == false) 
	{
		SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
		return 0;
	}
	else if(rangaid == RANGA_HEAD)
	{
		if(text[0] == '@')
		{
			foreach(new i : Player)
			{
				new rangai = DaneGracza[i][Ranga];
				if (rangai == RANGA_HEAD)
				{
					format(wiadomosc, sizeof(wiadomosc), "{"COLOR_AXWELL"}@ {ffffff}%s {cccccc}[%d] {ffffff}%s", NazwaGracza(playerid), playerid, text[1]);
					SendClientMessage(i, -1, wiadomosc);
					PlayerPlaySound(i,1137,0.0,0.0,0.0);
				}
			}
		}
		else if(text[0] != '@')
		{
			format(wiadomosc, sizeof(wiadomosc), "{ffffff}[{ff0000}%s{ffffff}] {cccccc}%s [%d] {FFFFFF}%s",nazwarangi, NazwaGracza(playerid), playerid, text);
			SendClientMessageToAll(COLOR_WHITE, wiadomosc);
		}
		return 0;
	}
	else if (rangaid == RANGA_ADMIN)
	{
		format(wiadomosc, sizeof(wiadomosc), "{ffffff}[{"COLOR_AXWELL"}%s{ffffff}] {cccccc}%s [%d] {FFFFFF}%s",nazwarangi, NazwaGracza(playerid), playerid, text);
		SendClientMessageToAll(COLOR_WHITE, wiadomosc);
		return 0;
	}
	else if (rangaid == RANGA_MODERATOR)
	{
		format(wiadomosc, sizeof(wiadomosc), "{ffffff}[{00ffff}%s{ffffff}] {cccccc}%s [%d] {FFFFFF}%s",nazwarangi, NazwaGracza(playerid), playerid, text);
		SendClientMessageToAll(COLOR_WHITE, wiadomosc);
		return 0;
	}
	else if (rangaid == RANGA_VIP)
	{
		format(wiadomosc, sizeof(wiadomosc), "{ffff88}%s {cccccc}[%d] {FFFFFF}%s",NazwaGracza(playerid), playerid, text);
		SendClientMessageToAll(COLOR_WHITE, wiadomosc);
		return 0;
	}
	else if (rangaid == RANGA_GRACZ)
	{
		format(wiadomosc, sizeof(wiadomosc), "{cccccc}%s [%d] {FFFFFF}%s", NazwaGracza(playerid), playerid, text);
		SendClientMessageToAll(COLOR_WHITE, wiadomosc);
		return 0;
	}
	return 0;
}
new deathanim[][] =
{
	"ko_shot_face",
	"ko_shot_face",
	"ko_shot_face",
	"ko_shot_stom",
	"ko_shot_stom",
	"ko_shot_stom",
	"ko_shot_front",
	"BIKE_fall_off",
	"ko_skid_front",
	"ko_spin_l"
};
new BloodExp[MAX_PLAYERS];
public OnPlayerDeath(playerid, killerid, reason)
{
    if(killerid != INVALID_PLAYER_ID)
    {
        GivePlayerMoney(killerid, 5000); 
        SetPlayerScore(killerid,GetPlayerScore(killerid)+3);
		killstreak[killerid]++;
		DaneGracza[killerid][Kills]++;
		DaneGracza[playerid][Deaths]++;
		
		SendDeathMessage(killerid, playerid, reason);
		switch(killstreak[killerid])
		{
			case 1:
			{
				GameTextForPlayer(killerid, "~y~>>~r~kill~y~<<", 3000, 4);
			}
			case 2:
			{
				GameTextForPlayer(killerid, "~y~>>~r~double kill~y~<<", 3000, 4);
			}
			case 3:
			{
				GameTextForPlayer(killerid, "~y~>>~r~multi kill~y~<<", 3000, 4);
			}
			case 4:
			{
				GameTextForPlayer(killerid, "~y~>>~r~monster kill~y~<<", 3000, 4);
			}
			case 5:
			{
				GameTextForPlayer(killerid, "~y~>>~r~holy shhhiiiitt~y~<<", 3000, 4);
			}
			case 6:
			{
				GameTextForPlayer(killerid, "~y~>>~r~unstoppable~y~<<", 3000, 4);
			}
			case 7:
			{
				GameTextForPlayer(killerid, "~y~>>~r~godlike~y~<<", 3000, 4);
			}
		}
    }
	killstreak[playerid] = 0;
	DaneGracza[playerid][Dead] = true;
	GameTextForPlayer(playerid, "~r~~h~WASTED!", 3000, 6);
	GivePlayerMoney(playerid, 100);
	RemovePlayerFromVehicle(playerid);
	//krew

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	new Random = random(sizeof(deathanim));
	ClearAnimations(playerid);
	ApplyAnimation(playerid, "PED", deathanim[Random][0], 4.1, 0, 0, 0, 1, 0, 1); // dead anim
	BloodExp[playerid] = CreateObject(18668, x, y, z - 1.5, 0.0, 0.0, 0.0);
	SetTimerEx("RemoveBloodEffect", 2500, false, "i", BloodExp[playerid]);
	SetTimerEx("killplayer", 3500, false, "i", playerid);
    return 0;
}

public speedometer(playerid) 
{
    GetVehicleVelocity(GetPlayerVehicleID(playerid), svx[playerid], svy[playerid], svz[playerid]);
    s1[playerid] = floatsqroot(((svx[playerid]*svx[playerid])+(svy[playerid]*svy[playerid]))+(svz[playerid]*svz[playerid]))*100;
    s2[playerid] = floatround(s1[playerid],floatround_round);
    format(s3[playerid],256,"%i km/h", s2[playerid]); 
    PlayerTextDrawSetString(playerid, sdisplay[playerid], s3[playerid]); 
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate) {
    KillTimer(stimer[playerid]); 
    PlayerTextDrawSetString(playerid, sdisplay[playerid], " "); 
    if(newstate == 2) stimer[playerid] = SetTimerEx("speedometer", 255, true, "i", playerid);
    else if(newstate == 3) stimer[playerid] = SetTimerEx("speedometer", 250, true, "i", playerid);
    return 1;
} 
forward MyHttpResponse(playerid, response_code, data[]);
public MyHttpResponse(playerid, response_code, data[])
{
	new name[MAX_PLAYERS];
	new string[1024];
	new ip[128];
	GetPlayerName(playerid, name, sizeof(name));
	GetPlayerIp(playerid, ip, sizeof ip);
	if(strcmp(ip, "127.0.0.1", true) == 0)
	{
        return 1;
	}
	if(response_code == 200)
	{	
		if(data[0] == 'Y')
		{
			format(string, sizeof(string), "{00ffff}> {FFFFFF}%s {00ffff}[%d] {FFFFFF}Please disable your {00ffff}proxy/VPN {FFFFFF}and rejoin!",name, playerid);
			SendClientMessageToAll(COLOR_WHITE, string);
	    	SetTimerEx("DelayedKick", 1000, false, "i", playerid);
		}
		if(data[0] == 'N')
		{
		
		}
		if(data[0] == 'X')
		{
			printf("WRONG IP FORMAT");
		}
		else
		{
			printf("The request failed! The response code was: %d", response_code);
		}
	}
	return 1;
}

//Stocki
stock NazwaRangi(rangaid)
{
	new nazwa[15];
	if(rangaid == RANGA_GRACZ) nazwa = "Player";
	else if(rangaid == RANGA_VIP) nazwa = "VIP";
	else if(rangaid == RANGA_MODERATOR) nazwa = "Moderator";
	else if(rangaid == RANGA_ADMIN) nazwa = "Admin";
	else if(rangaid == RANGA_HEAD) nazwa = "H@";
	return nazwa;
}
stock JestRanga(playerid, ranga)
{
	if(DaneGracza[playerid][Ranga] >= ranga) return 1;
	else return 0;
}

stock ResetujDaneGracza(playerid)
{
	DaneGracza[playerid][Zalogowany] = false;
	DaneTextdraw[playerid][tdon] = false;
	DaneGracza[playerid][Ranga] = 0;
	IsGod[playerid] = 0;
	killstreak[playerid] = 0;
	pCBugging[playerid] = false;
	KillTimer(ptmCBugFreezeOver[playerid]);
	ptsLastFiredWeapon[playerid] = 0;
	DaneGracza[playerid][Dead] = true;
	DaneAreny[playerid][Warenie] = false;
	IdAreny[playerid] = 0;
	if(VehicleSpawned[playerid] != -1)
	{
	    DestroyVehicle(VehicleSpawned[playerid]);
	    VehicleSpawned[playerid] = (-1);
	}
	return 1;
}


stock ZapiszKonto(playerid)
{
	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteInt("Punkty", GetPlayerScore(playerid));
	dfile_WriteInt("Kasa", GetPlayerMoney(playerid));
	dfile_WriteInt("Skin", GetPlayerSkin(playerid));
	dfile_WriteInt("Ranga", DaneGracza[playerid][Ranga]);
	dfile_WriteBool("Banned", DaneGracza[playerid][Banned]);
	dfile_WriteString("IP", DaneGracza[playerid][IP]);
	dfile_WriteInt("Kills", DaneGracza[playerid][Kills]);
	dfile_WriteInt("Deaths", DaneGracza[playerid][Deaths]);
	
	dfile_SaveFile();
	dfile_CloseFile();
	return 1;
}

stock WczytajKonto(playerid)
{
	ResetPlayerMoney(playerid);
	
	dfile_Open(SciezkaKontaGracza(playerid));
	
	SetPlayerScore(playerid, dfile_ReadInt("Punkty"));
	GivePlayerMoney(playerid, dfile_ReadInt("Kasa"));
	DaneGracza[playerid][Ranga] = dfile_ReadInt("Ranga");
    GetPlayerIp(playerid, DaneGracza[playerid][IP], 128);
	dfile_CloseFile();
	return 1;
}

stock StworzKonto(playerid, haslo[])
{
	new hasloex[256];
	WP_Hash(hasloex, sizeof hasloex, haslo);
	
	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteString("Haslo", hasloex);
	dfile_WriteInt("Punkty", 10);
	dfile_WriteInt("Kasa", 50000);
	dfile_WriteInt("Skin", 0);
	dfile_WriteInt("Ranga", 0);
	dfile_WriteInt("Kills", 0);
	dfile_WriteInt("Deaths", 0);
	dfile_WriteString("IP", "0.0.0.0");
	dfile_WriteBool("Banned", false);
	dfile_SaveFile();
	dfile_CloseFile();
	return 1;
}

stock SciezkaKontaGracza(playerid)
{
	new sciezka[128];
	format(sciezka, sizeof sciezka, FOLDER_KONT"%s.ini", NazwaGracza(playerid));
	return sciezka;
}

stock OknoRejestracji(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_REJESTRACJA, DIALOG_STYLE_PASSWORD, "Account Registration", "Welcome to the server \nplease register your account!", ">", "X");
	return 1;
}

stock OknoLogowania(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_LOGOWANIE, DIALOG_STYLE_PASSWORD, "Account Login", "Welcome to the server \nYour account has been found, please login!", ">", "X");
	return 1;
}

stock NazwaGracza(playerid)
{
	new nazwa[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nazwa, sizeof nazwa);
	return nazwa;
}

stock RemoveAllPlayersFromVehicle(vehicleid)
{
	foreach(new i : Player)
	{
	    if(IsPlayerInVehicle(i, vehicleid))
	    RemovePlayerFromVehicle(i);
	}
	return 1;
}

stock dajgraczadoareny(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined arena.");
		IdAreny[playerid] = 1;
		DaneAreny[playerid][Warenie] = true;
		new Random = random(sizeof(RandomSpawns));
		SetPlayerPos(playerid, RandomSpawns[Random][0], RandomSpawns[Random][1], RandomSpawns[Random][2]);
		SetPlayerFacingAngle(playerid, RandomSpawns[Random][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	return 1;
}

stock dajgraczadoonede(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Onede.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 2;
		new Rand=random(sizeof(OneDe));
		SetPlayerPos(playerid,OneDe[Rand][0],OneDe[Rand][1],OneDe[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 3);
		SetPlayerVirtualWorld(playerid, 3);
		SetPlayerHealth(playerid, 20);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	return 1;
}


stock dajgraczadomini(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Minigun.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 3;
		new Rand=random(sizeof(MiniSpawn));
		SetPlayerPos(playerid,MiniSpawn[Rand][0],MiniSpawn[Rand][1],MiniSpawn[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 4);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 38, 99999);
	}
	return 1;
}


stock dajgraczadowarehouse(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Warehouse.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 4;
		new Rand=random(sizeof(CaliSpawn));
		SetPlayerPos(playerid,CaliSpawn[Rand][0],CaliSpawn[Rand][1],CaliSpawn[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 5);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 31, 9999);
		GivePlayerWeapon(playerid, 27, 9999);
	}
	return 1;
}
stock dajgraczadosawnoff(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Sawn-Off.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 5;
		new Rand=random(sizeof(SoSpawn));
		SetPlayerPos(playerid,SoSpawn[Rand][0],SoSpawn[Rand][1],SoSpawn[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 6);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 26, 9999);
	}
	return 1;
}
stock dajgraczadoanticbug(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Anti +c.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 6;
		new Rand=random(sizeof(AntiSpawn));
		SetPlayerPos(playerid,AntiSpawn[Rand][0],AntiSpawn[Rand][1],AntiSpawn[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 7);
		SetPlayerHealth(playerid, 160);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 31, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	return 1;
}
stock dajgraczadosniper(playerid)
{
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined Sniper.");
		DaneAreny[playerid][Warenie] = true;
		IdAreny[playerid] = 7;
		new Rand=random(sizeof(SniperSpawn));
		SetPlayerPos(playerid,SniperSpawn[Rand][0],SniperSpawn[Rand][1],SniperSpawn[Rand][2]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 10);
		SetPlayerVirtualWorld(playerid, 8);
		SetPlayerHealth(playerid, 20);
		SetPlayerArmour(playerid, 0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 34, 9999);
	}
	return 1;
}

stock spawnTD(playerid)
{
	TextDrawShowForPlayer(playerid, adminmsg1);
	TextDrawShowForPlayer(playerid, adminmsg2);
	TextDrawShowForPlayer(playerid, adminmsg3);
	PlayerTextDrawShow(playerid, hpbar[playerid]);

	TextDrawHideForPlayer(playerid, ipslogowelcome);
	TextDrawHideForPlayer(playerid, welcomenew1);
	TextDrawHideForPlayer(playerid, welcomenew2);
	TextDrawHideForPlayer(playerid, welcomenew3);
	TextDrawHideForPlayer(playerid, welcomenew4);

	//td ibiza
	TextDrawShowForPlayer(playerid, PasekDraw[0]);
	TextDrawShowForPlayer(playerid, PasekDraw[1]);
	TextDrawShowForPlayer(playerid, TDLogo[0]);
	TextDrawShowForPlayer(playerid, DrawZabawy[0]);
	TextDrawShowForPlayer(playerid, DrawZabawy[1]);
	TextDrawShowForPlayer(playerid, TDLogo[1]);
	TextDrawShowForPlayer(playerid, TDLogo[2]);
	TextDrawShowForPlayer(playerid, TDLogo[3]);
	TextDrawShowForPlayer(playerid, TDLogo[4]);
	TextDrawShowForPlayer(playerid, DateAndTime[0]);
	TextDrawShowForPlayer(playerid, DateAndTime[1]);
	TextDrawShowForPlayer(playerid, PasekDraw[2]);
	TextDrawShowForPlayer(playerid, PasekDraw[3]);
	TextDrawShowForPlayer(playerid, PasekDraw[4]);
	TextDrawShowForPlayer(playerid, PasekDraw[5]);
	TextDrawShowForPlayer(playerid, PasekDraw[6]);
	TextDrawShowForPlayer(playerid, PasekDraw[7]);
	TextDrawShowForPlayer(playerid, TDRandomMSG);
	PlayerTextDrawShow(playerid, PacketPing[playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[0][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[1][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[2][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[3][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[4][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[5][playerid]);
	PlayerTextDrawShow(playerid, PlayerPasek[6][playerid]);
	PlayerTextDrawShow(playerid, sdisplay[playerid]);
	return 1;
}



stock ConnectTD(playerid)
{
    sdisplay[playerid] = CreatePlayerTextDraw(playerid,492.0,337.0," ");
    PlayerTextDrawSetShadow(playerid,sdisplay[playerid],0);
    PlayerTextDrawSetOutline(playerid,sdisplay[playerid],1);
    PlayerTextDrawFont(playerid,sdisplay[playerid], 2);
	
	hpbar[playerid] = CreatePlayerTextDraw(playerid, 558.000000, 66.000000, "100");
	PlayerTextDrawFont(playerid, hpbar[playerid], 2);
	PlayerTextDrawLetterSize(playerid, hpbar[playerid], 0.241666, 0.899999);
	PlayerTextDrawTextSize(playerid, hpbar[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, hpbar[playerid], 1);
	PlayerTextDrawSetShadow(playerid, hpbar[playerid], 0);
	PlayerTextDrawAlignment(playerid, hpbar[playerid], 2);
	PlayerTextDrawColor(playerid, hpbar[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, hpbar[playerid], 255);
	PlayerTextDrawBoxColor(playerid, hpbar[playerid], 50);
	PlayerTextDrawUseBox(playerid, hpbar[playerid], 0);
	PlayerTextDrawSetProportional(playerid, hpbar[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, hpbar[playerid], 0);

	//td ibiza
	PacketPing[playerid] = CreatePlayerTextDraw(playerid, 610.000000, 16.000000, "PL: 0.0% | PING: 100");
	PlayerTextDrawFont(playerid, PacketPing[playerid], 1);
	PlayerTextDrawLetterSize(playerid, PacketPing[playerid], 0.174998, 0.950002);
	PlayerTextDrawTextSize(playerid, PacketPing[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PacketPing[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PacketPing[playerid], 0);
	PlayerTextDrawAlignment(playerid, PacketPing[playerid], 3);
	PlayerTextDrawColor(playerid, PacketPing[playerid], 255);
	PlayerTextDrawBackgroundColor(playerid, PacketPing[playerid], 852308735);
	PlayerTextDrawBoxColor(playerid, PacketPing[playerid], 50);
	PlayerTextDrawUseBox(playerid, PacketPing[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PacketPing[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PacketPing[playerid], 0);

	PlayerPasek[0][playerid] = CreatePlayerTextDraw(playerid, 196.000000, 430.000000, "XP");
	PlayerTextDrawFont(playerid, PlayerPasek[0][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[0][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[0][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[0][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[0][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[0][playerid], 2);
	PlayerTextDrawColor(playerid, PlayerPasek[0][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[0][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[0][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[0][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[0][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[0][playerid], 0);

	PlayerPasek[1][playerid] = CreatePlayerTextDraw(playerid, 252.000000, 430.000000, "Rank");
	PlayerTextDrawFont(playerid, PlayerPasek[1][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[1][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[1][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[1][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[1][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[1][playerid], 2);
	PlayerTextDrawColor(playerid, PlayerPasek[1][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[1][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[1][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[1][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[1][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[1][playerid], 0);

	PlayerPasek[2][playerid] = CreatePlayerTextDraw(playerid, 309.000000, 430.000000, "Kills");
	PlayerTextDrawFont(playerid, PlayerPasek[2][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[2][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[2][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[2][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[2][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[2][playerid], 2);
	PlayerTextDrawColor(playerid, PlayerPasek[2][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[2][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[2][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[2][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[2][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[2][playerid], 0);

	PlayerPasek[3][playerid] = CreatePlayerTextDraw(playerid, 363.000000, 430.000000, "Deaths");
	PlayerTextDrawFont(playerid, PlayerPasek[3][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[3][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[3][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[3][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[3][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[3][playerid], 2);
	PlayerTextDrawColor(playerid, PlayerPasek[3][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[3][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[3][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[3][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[3][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[3][playerid], 0);

	PlayerPasek[4][playerid] = CreatePlayerTextDraw(playerid, 413.000000, 430.000000, "Streak");
	PlayerTextDrawFont(playerid, PlayerPasek[4][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[4][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[4][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[4][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[4][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[4][playerid], 2);
	PlayerTextDrawColor(playerid, PlayerPasek[4][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[4][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[4][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[4][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[4][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[4][playerid], 0);

	PlayerPasek[5][playerid] = CreatePlayerTextDraw(playerid, 477.000000, 430.000000, "onlineplr");
	PlayerTextDrawFont(playerid, PlayerPasek[5][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[5][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[5][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[5][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[5][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[5][playerid], 3);
	PlayerTextDrawColor(playerid, PlayerPasek[5][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[5][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[5][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[5][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[5][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[5][playerid], 0);

	PlayerPasek[6][playerid] = CreatePlayerTextDraw(playerid, 58.000000, 430.000000, "(~y~0~w~) Name");
	PlayerTextDrawFont(playerid, PlayerPasek[6][playerid], 1);
	PlayerTextDrawLetterSize(playerid, PlayerPasek[6][playerid], 0.220833, 1.049998);
	PlayerTextDrawTextSize(playerid, PlayerPasek[6][playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PlayerPasek[6][playerid], 0);
	PlayerTextDrawSetShadow(playerid, PlayerPasek[6][playerid], 0);
	PlayerTextDrawAlignment(playerid, PlayerPasek[6][playerid], 1);
	PlayerTextDrawColor(playerid, PlayerPasek[6][playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PlayerPasek[6][playerid], 255);
	PlayerTextDrawBoxColor(playerid, PlayerPasek[6][playerid], 50);
	PlayerTextDrawUseBox(playerid, PlayerPasek[6][playerid], 0);
	PlayerTextDrawSetProportional(playerid, PlayerPasek[6][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PlayerPasek[6][playerid], 0);
	return 1;
}


stock ObiektyOnede(playerid)
{
	//onedeobiek
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 169.9688, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 215.5625, 170.2266, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 170.2266, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 170.1641, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 217.8516, 170.6016, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 223.2031, 170.2422, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 210.2813, 171.3047, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 171.5469, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 170.9453, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 171.9844, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 171.4922, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 211.3203, 173.4453, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 211.3828, 174.2344, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 215.2188, 172.3125, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 215.5625, 174.2266, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 172.9609, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 174.0234, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 217.8516, 172.6172, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 222.2188, 172.2656, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 174.3047, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 223.2266, 174.4063, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 210.3203, 175.4688, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 175.5938, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 175.0000, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 218.1484, 174.5781, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 222.2109, 176.4297, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 175.6250, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 178.3594, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 179.6719, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 179.0234, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 181.5938, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 182.2578, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 231.9375, 180.2500, 1002.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 209.2500, 183.5156, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 209.2500, 185.0391, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 213.2891, 185.1563, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 209.2500, 188.1875, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 209.2500, 186.6016, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 213.2891, 187.5547, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2185, 213.7578, 184.3359, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2185, 213.7578, 186.9297, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 214.7813, 187.7969, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 215.5000, 187.7969, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 216.6406, 185.7891, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 216.2266, 187.7969, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 216.7813, 186.9531, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2165, 216.9453, 186.6328, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 218.4922, 185.7891, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2165, 218.9063, 186.6328, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 219.2734, 187.6875, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 221.4609, 188.7813, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 221.4609, 187.1953, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 221.4609, 185.6016, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2191, 221.4609, 183.9922, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 227.3438, 184.9219, 1002.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.5469, 184.6172, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 229.1953, 184.6172, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 229.8594, 184.6172, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 231.6172, 182.9063, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2162, 242.9766, 189.5703, 1007.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 2162, 242.9766, 191.7266, 1007.1953, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 244.4297, 188.2813, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 247.8594, 187.2578, 1007.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 248.0781, 188.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 248.1953, 184.8281, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 249.0313, 185.3047, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 249.0313, 187.3672, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 250.1172, 184.2578, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 250.1172, 186.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 251.0703, 188.2813, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 250.7109, 187.0156, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 250.7109, 184.8359, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 252.0234, 192.8906, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 252.7109, 192.2344, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 253.2266, 185.1953, 1007.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 253.5469, 188.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 253.6719, 187.0078, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 254.5000, 185.3047, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 254.5000, 187.3672, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 255.5938, 184.2578, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 255.5938, 186.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 254.6094, 192.8906, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 255.2656, 192.2344, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 256.2813, 187.0156, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 256.5469, 188.2813, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 256.7266, 184.3828, 1007.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 257.1797, 192.8906, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 257.5391, 191.8672, 1007.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 258.8203, 188.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 259.0391, 187.0078, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 259.0391, 184.8281, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2161, 259.3828, 193.3750, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 259.7734, 185.3047, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 259.7734, 187.3672, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2161, 260.7734, 193.3750, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 260.8594, 184.2578, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2198, 260.8594, 186.3203, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 261.8125, 188.2813, 1007.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 261.4375, 184.8359, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 261.4375, 187.0156, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2161, 262.1719, 193.3750, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 246.5469, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 247.1953, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 247.8594, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 249.6563, 197.2969, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 254.5703, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 255.2188, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 255.8828, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 257.8672, 197.2969, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 262.5391, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 263.1875, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 263.8516, 197.6406, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 265.6953, 185.5234, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 265.6953, 186.2109, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 265.6953, 187.5234, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 265.6953, 186.8594, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2195, 265.7422, 184.2422, 1007.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 2195, 265.7422, 188.7422, 1007.8125, 0.25);
	RemoveBuildingForPlayer(playerid, 756, 276.2031, 170.8594, 1006.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 753, 271.7031, 172.5234, 1006.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 756, 271.1719, 174.4609, 1006.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 756, 273.4766, 173.7500, 1006.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 756, 275.3203, 174.4609, 1006.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 184.1328, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 184.7969, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 185.4453, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 186.9688, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 187.6328, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 188.9688, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 270.5703, 188.2813, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 270.8594, 186.2188, 1007.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2252, 301.0703, 180.3672, 1007.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 2208, 296.2500, 185.1172, 1006.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 14854, 296.6875, 184.5000, 1008.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 296.4922, 185.9141, 1006.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 298.4609, 185.9141, 1006.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 283.4297, 188.7344, 1006.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 284.4688, 188.7344, 1006.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 285.5234, 188.7344, 1006.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 286.5625, 188.7344, 1006.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 287.5625, 188.7344, 1006.1719, 0.25);
	RemoveBuildingForPlayer(playerid, 2252, 291.6563, 187.9844, 1007.4531, 0.25);
	RemoveBuildingForPlayer(playerid, 950, 207.9063, 140.4766, 1002.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2204, 208.1719, 149.8672, 1002.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 2197, 209.2109, 145.8594, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 950, 213.1563, 140.4766, 1002.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 2199, 212.5078, 144.4297, 1002.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 210.1875, 148.1094, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 211.4688, 148.1094, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 215.0078, 147.3125, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 216.6328, 147.2578, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 216.6719, 148.2031, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 215.1094, 148.2422, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1714, 211.0313, 150.0156, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2211, 211.4453, 152.2891, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2206, 211.8438, 149.1094, 1002.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 2241, 212.4375, 151.7969, 1002.5000, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 215.0859, 149.2500, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 216.6563, 149.2578, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2029, 215.9844, 149.9531, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 215.8594, 150.8047, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 210.2969, 162.9531, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 210.3203, 167.1172, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 211.3203, 160.9297, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 161.6875, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 163.0156, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 211.3125, 165.0938, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 165.8281, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 211.3047, 169.2813, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 210.9844, 167.1484, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 215.5625, 162.5078, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 163.2813, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 215.5625, 164.5547, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 165.2969, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 215.2188, 166.8516, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 216.1953, 167.3359, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 950, 223.9766, 140.4766, 1002.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 950, 218.4375, 140.4766, 1002.5625, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 227.6172, 140.5938, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 227.6172, 141.2578, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 227.6172, 141.9063, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 227.6172, 142.5938, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 227.9219, 143.4766, 1002.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.8203, 144.1953, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.8203, 145.2266, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2204, 219.9375, 152.2969, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2184, 219.9844, 148.0703, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 220.1797, 147.2969, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 221.4531, 147.2031, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2194, 222.0078, 148.1406, 1003.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1714, 221.1094, 149.2969, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.8203, 146.2891, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.8203, 147.3281, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1722, 228.8203, 148.3281, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1808, 228.5547, 155.1172, 1002.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 164.3203, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 162.3047, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 166.3594, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 217.8516, 162.9375, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 217.8516, 164.9609, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 217.8516, 166.9375, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 161.7266, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 223.2031, 161.8906, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 163.0547, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 222.2031, 163.9219, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 222.6250, 165.7656, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 223.2422, 166.0547, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2356, 222.2031, 167.2188, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2193, 222.2188, 168.0781, 1002.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 2252, 231.5781, 158.7891, 1003.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 2186, 228.8125, 162.3828, 1002.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 230.5234, 164.1641, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 14855, 231.4688, 163.8516, 1006.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1806, 230.5234, 166.0000, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2208, 231.3984, 166.4609, 1002.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 2252, 233.9453, 168.5000, 1003.3594, 0.25);
	return 1;
}
	
stock DmArenaObiekty()
{
	CreateDynamicObject(11440, 38.22640, 2530.88623, 19.75180,   0.00000, 0.00000, -90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 38.22640, 2530.88623, 19.75180,   0.00000, 0.00000, -90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 56.77030, 2646.27344, 15.45480,   0.00000, 0.00000, -90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 53.46889, 2533.47803, 17.41480,   0.00000, 0.00000, -90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 95.36870, 2481.00610, 16.67680,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 95.42590, 2498.94019, 17.53780,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11440, 31.42529, 2482.10498, 18.52180,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 41.93180, 2525.35815, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 49.93180, 2525.35815, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 57.93180, 2525.35815, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 65.93180, 2525.35815, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 73.77180, 2525.35742, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 81.77180, 2525.35742, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 89.77180, 2525.35742, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.01780, 2518.96143, 15.47030,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.01780, 2510.96631, 15.47030,   0.00000, 0.00000, -180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.01780, 2502.97119, 15.47030,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.01780, 2494.97632, 15.47030,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 89.77180, 2488.58057, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 81.77180, 2488.58057, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 73.77180, 2488.58057, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 65.93180, 2488.58057, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 57.93180, 2488.58057, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 49.93180, 2488.58057, 15.47030,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 41.93180, 2488.58057, 15.47030,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.55360, 2518.88354, 15.47030,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 26.93495, 2514.57104, 15.47030,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.57200, 2502.97119, 15.47030,   0.00000, 0.00000, -180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.57200, 2494.97632, 15.47030,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.26380, 2518.96143, 17.68430,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.26380, 2510.96631, 17.80730,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.26380, 2502.97119, 17.80730,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 90.26380, 2494.97632, 17.80730,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 89.77180, 2488.33472, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 81.77180, 2488.33472, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 73.77180, 2488.33472, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 65.93180, 2488.33472, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 57.93180, 2488.33472, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 49.93180, 2488.33472, 17.80730,   0.00000, 0.00000, -90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 41.93180, 2488.33472, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.32600, 2494.97632, 17.80730,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.32600, 2502.97119, 17.80730,   0.00000, 0.00000, -180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.32600, 2510.96631, 17.80730,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.30760, 2518.88354, 17.80730,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 41.85980, 2525.60742, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 49.93180, 2525.60425, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 57.99070, 2525.61597, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 65.93180, 2525.60425, 17.80730,   0.00000, 0.00000, 270.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 73.77180, 2525.60352, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 81.72710, 2525.60352, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 89.77180, 2525.60352, 17.80730,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11447, 46.55646, 2487.65649, 19.65380,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.30760, 2526.87842, 17.80730,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3511, 34.52170, 2487.67554, 12.38010,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(622, 12.61295, 2532.18945, 12.24870,   0.00000, 0.00000, 226.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(641, 85.92670, 2485.35938, 18.69030,   -18.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11447, 69.94530, 2484.99634, 20.51230,   0.00000, 0.00000, 153.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3798, 78.19926, 2514.12866, 15.35090,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3799, 78.00382, 2516.54614, 15.35630,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3799, 78.02426, 2498.90088, 15.35630,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3798, 77.03933, 2496.41455, 15.35090,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3799, 46.55693, 2516.75854, 15.35630,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3798, 48.95782, 2514.36353, 15.35090,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3798, 47.70146, 2496.41138, 15.47730,   0.00000, 0.00000, -34.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3800, 48.51942, 2512.48535, 15.47740,   0.00000, 0.00000, -26.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3799, 47.11760, 2499.30273, 15.35630,   0.00000, 0.00000, -8.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3800, 77.41902, 2516.13550, 17.69140,   0.00000, 0.00000, -26.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(928, 77.87320, 2499.58325, 17.93470,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(11426, 35.55360, 2510.88354, 15.47030,   0.00000, 0.00000, 180.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19397, 64.52060, 2503.65332, 16.84520,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 61.33640, 2503.65210, 16.84460,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 63.65440, 2505.26025, 15.99660,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 65.35440, 2505.26025, 15.99660,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19397, 64.47860, 2510.14551, 16.84520,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 63.65440, 2508.41626, 15.99660,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 65.35440, 2508.41626, 15.99660,   0.00000, 0.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 61.33640, 2510.15210, 16.84460,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 67.67240, 2510.15210, 16.84460,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 67.67240, 2503.65112, 16.84460,   0.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 69.53340, 2503.65918, 16.24660,   36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 72.13340, 2503.65918, 14.36660,   36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 69.53340, 2510.14429, 16.24660,   36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 72.13340, 2510.14429, 14.36660,   36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 59.48340, 2510.14429, 16.24660,   -36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 56.88340, 2510.14429, 14.36660,   -36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 59.48340, 2503.66431, 16.24660,   -36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19369, 56.88340, 2503.66431, 14.36660,   -36.00000, 0.00000, 90.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 61.65440, 2505.32739, 17.67660,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 61.65440, 2508.52441, 17.67660,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 65.08640, 2505.32739, 17.67660,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 65.08640, 2508.52441, 17.67660,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 67.63840, 2505.32739, 17.67860,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 67.64240, 2508.52441, 17.67860,   0.00000, 90.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 70.79840, 2505.32739, 16.67860,   0.00000, 126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 70.78960, 2508.54663, 16.68660,   0.00000, 126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 73.62160, 2508.49463, 14.63260,   0.00000, 126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 73.64160, 2505.28662, 14.62860,   0.00000, 126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 58.52440, 2505.32739, 16.67660,   0.00000, -126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 58.52440, 2508.44751, 16.67660,   0.00000, -126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 55.69440, 2508.52759, 14.61660,   0.00000, -126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(19372, 55.71440, 2505.34839, 14.61660,   0.00000, -126.00000, 0.00000, 2, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(3798, 64.57830, 2506.98022, 17.75890,   0.00000, 0.00000, -11.00000, 2, -1, -1, 400, 400, -1, 0);
	
	//miniobiekty
	CreateDynamicObject(8674, 96.65465, 1920.41321, 16.48270,   0.00000, 90.00000, 90.00000, 4, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(8674, 226.47639, 1868.52307, 13.40070,   0.00000, 0.00000, 90.00000, 4, -1, -1, 400, 400, -1, 0);
	
	//obiekty antic
	
	CreateDynamicObject(8355, -1348.10132, 2544.06079, 85.16900,   0.00000, -90.00000, 0.00000, 7, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(8355, -1339.31311, 2559.75977, 85.16900,   0.00000, -90.00000, -90.00000, 7, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(8355, -1272.45313, 2528.19995, 85.16900,   0.00000, -90.00000, -180.00000, 7, -1, -1, 400, 400, -1, 0);
	CreateDynamicObject(8355, -1307.09924, 2477.86768, 85.16900,   0.00000, -90.00000, -272.00000, 7, -1, -1, 400, 400, -1, 0);
    return 1;
}


//Timery
forward spec(playerid);
public spec(playerid)
{
	TogglePlayerSpectating(playerid, true);
	SetCameraBehindPlayer(playerid);
	return 1;
}

forward flycamera(playerid); //timer spawn
public flycamera(playerid)
{
	switch(random(7))
	{
		case 0:
		{
			// Vinewood Sign
			InterpolateCameraPos(playerid, 1334.0220, -783.3859, 87.6606, 1407.5430, -896.9464, 87.6606, 20000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid,1415.7408, -806.5591, 85.0399, 1415.7408, -806.5591, 85.0399, 20000, CAMERA_MOVE);
		}
		case 1:
		{
			// Vinewood Sign 2
			InterpolateCameraPos(playerid, 1476.7277, -874.3438, 110.0, 1476.7277, -900.000, 70.0, 5000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1415.2177, -807.9233, 200.0, 1415.2177, -807.9233, 85.0623, 5000, CAMERA_MOVE);
		}
		case 2:
		{
			// Desert Mountains
			InterpolateCameraPos(playerid, -365.5211, 1938.2665, 86.0535, -228.2556, 1821.5653, 96.6716, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, -327.0362, 1943.1190, 112.4141, -206.0446, 1895.2479, 91.2241, 15000, CAMERA_MOVE);
		}
		case 3:
		{
			// Streets of San Fierro
			InterpolateCameraPos(playerid, -2078.7246, 731.2352, 69.4141, -1714.5399, 731.2352, 69.4141, 45000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, -1971.8036, 731.0178, 45.2969, -1607.8036, 731.0178, 45.2969, 45000, CAMERA_MOVE);
		}
		case 4:
		{
			// LS Beach
			InterpolateCameraPos(playerid, 340.3344, -1801.2339, 10.6959, 207.3543, -1801.2339, 10.6959, 80000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 289.9604, -1766.6553, 4.5469, 159.9604, -1766.6553, 4.5469, 80000, CAMERA_MOVE);
		}
		case 5:
		{
			// SF Bridge
			InterpolateCameraPos(playerid, -2630.2266, 1459.0537, 65.6484, -2596.2339, 2039.0321, 263.0035, 20000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, -2678.6890, 1589.8137, 129.3078, -2713.4839, 1757.8318, 98.4932, 20000, CAMERA_MOVE);
		}
		case 6:
		{
			// LV Stadium
			InterpolateCameraPos(playerid, 1328.3080, 2116.9485, 11.0156, 1287.4218, 2097.1223, 55.1216, 20000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1334.9221, 2077.7285, 26.6737, 1381.2794, 2184.0823, 11.0234, 20000, CAMERA_MOVE);
		}
	}
	return 1;
}


forward givegun(playerid); //timer gun
public givegun(playerid)
{
	if(GetPlayerScore(playerid) <= 100) 
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 29, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	else if(GetPlayerScore(playerid) >= 100 && GetPlayerScore(playerid) < 200)
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 30, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	else if(GetPlayerScore(playerid) >= 250 && GetPlayerScore(playerid) < 350) 
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 5, 9999);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 31, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	else if(GetPlayerScore(playerid) >= 350 && GetPlayerScore(playerid) < 750) 
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 8, 9999);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 31, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	else if(GetPlayerScore(playerid) >= 750) 
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 8, 9999);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 28, 9999);
		GivePlayerWeapon(playerid, 31, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	return 1;
}


forward killplayer(playerid); //timer spawn
public killplayer(playerid)
{
	DaneGracza[playerid][Dead] = false;
	SetPlayerHealth(playerid, 100);
	SpawnPlayer(playerid);
	return 1;
}

forward RemoveBloodEffect(playerid);
public RemoveBloodEffect(playerid)
{
	DestroyObject(BloodExp[playerid]);
	return 1;
}

forward CBugFreezeOver(playerid);
public CBugFreezeOver(playerid)
{
	TogglePlayerControllable(playerid, true);

	pCBugging[playerid] = false;
	return 1;
}

forward DelayedKick(playerid);
public DelayedKick(playerid)
{
    Kick(playerid);
    return 1;
}
forward DelayedBan(playerid);
public DelayedBan(playerid)
{
    Ban(playerid);
    return 1;
}
forward SpawnujGracza(playerid);
public SpawnujGracza(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

forward UsunSerceglowa(playerid);
public UsunSerceglowa(playerid)
{
	DestroyObject(HealthIcon[playerid]);
	return 1;
}

forward scoreikasanaczas(); //5min score money
public scoreikasanaczas()
{
	foreach(new i : Player)
	{
	if(IsPlayerConnected(i))
	{
		SendClientMessage(i, COLOR_BLUE, "> {ffffff}You have received 5 score and 10000 money.");
		GivePlayerMoney(i, 10000);
		SetPlayerScore(i,GetPlayerScore(i)+5);
	}
}
	return 1;
}
forward Reklama(); //15min
public Reklama()
{
	SendClientMessageToAll(COLOR_WHITE, "{ff0000}> {ffffff}Remember to join our Discord server! {ff0000}discord.gg/rHg97EP");
	return 1;
}


//update1sec
forward updatesekunda(playerid);
public updatesekunda(playerid)
{	
	new stringdata[358];
	new stringtime[358];
	new dzien, miesiac, rok, godzina, minuta;
	getdate(rok, miesiac, dzien);
	gettime(godzina, minuta);
	format(stringdata, sizeof stringdata, "%02d.%02d.%04d", dzien, miesiac, rok);
	format(stringtime, sizeof stringtime, "%02d:%02d", godzina, minuta);
	TextDrawSetString(DateAndTime[0], stringtime);
	TextDrawSetString(DateAndTime[1], stringdata);
	

	return 1;
}

forward update5(playerid);
public update5(playerid)
{
	new string[512];
	new Random = random(sizeof(RandomMessages));
	format(string, sizeof string, "~y~] ~w~~h~%s ~y~]", RandomMessages[Random]);
	TextDrawSetString(TDRandomMSG, string);
	return 1;
}


public OnPlayerUpdate(playerid)
{
	/////////////////////////////////
	new healthbar[30];
	new Float:hp;
	new Float:ar;
    new Float:health;
    new veh = GetPlayerVehicleID(playerid);
    GetPlayerHealth(playerid,hp);
	GetPlayerArmour(playerid,ar);
    if(IsGod[playerid] == 1)
    {
		if(hp < 9998.0) SetPlayerHealth(playerid, 9999.0);
		if(ar < 9998.0) SetPlayerArmour(playerid, 9999.0);
		if(health < 998.0)
		{
			SetVehicleHealth(veh, 1000.0);
			RepairVehicle(veh);
		}
   	}
	
	format(healthbar, sizeof healthbar, "%.0f%", hp);
	PlayerTextDrawSetString(playerid, hpbar[playerid], healthbar);
	
	new stringping[358];
	new killstreakstring[16];
	new killsstring[16];
	new deathsstrings[16];
	new stringonline[5];
	new stringXP[128];
	new rangaid = DaneGracza[playerid][Ranga];	

	format(stringping, sizeof stringping, "PL: %.1f%% | PING: %i", NetStats_PacketLossPercent(playerid), GetPlayerPing(playerid));
	PlayerTextDrawSetString(playerid, PacketPing[playerid], stringping);


	new name[MAX_PLAYER_NAME + 1];
	new namestring[MAX_PLAYER_NAME + 20];
	GetPlayerName(playerid, name, sizeof name);
	format(name, sizeof name, "%s", name);
	format(namestring, sizeof namestring, "(~y~%d~w~) %s", playerid, name);
	PlayerTextDrawSetString(playerid, PlayerPasek[6][playerid], namestring);

	format(killstreakstring, sizeof killstreakstring, "%i", killstreak[playerid]);
	PlayerTextDrawSetString(playerid, PlayerPasek[4][playerid], killstreakstring);
	
	format(killsstring, sizeof killsstring, "%i", DaneGracza[playerid][Kills]);
	PlayerTextDrawSetString(playerid, PlayerPasek[2][playerid], killsstring);
	
	format(deathsstrings, sizeof deathsstrings, "%i", DaneGracza[playerid][Deaths]);
	PlayerTextDrawSetString(playerid, PlayerPasek[3][playerid], deathsstrings);
	
	format(stringonline, sizeof stringonline, "%d", Iter_Count(Player));
	PlayerTextDrawSetString(playerid, PlayerPasek[5][playerid], stringonline);

	
	format(stringXP, sizeof stringXP, "%i", GetPlayerScore(playerid));
	PlayerTextDrawSetString(playerid, PlayerPasek[0][playerid], stringXP);
	
	switch(rangaid)
	{
		case 0: PlayerTextDrawSetString(playerid, PlayerPasek[1][playerid], "player");
		case 1: PlayerTextDrawSetString(playerid, PlayerPasek[1][playerid], "~y~VIP");
		case 2: PlayerTextDrawSetString(playerid, PlayerPasek[1][playerid], "~b~Moderator");
		case 3: PlayerTextDrawSetString(playerid, PlayerPasek[1][playerid], "~y~Admin");
		case 4: PlayerTextDrawSetString(playerid, PlayerPasek[1][playerid], "~r~Head");
	}
	
	switch(GetPlayerWeapon(playerid))
	{
		case WEAPON_GRENADE, WEAPON_MOLTOV, WEAPON_COLT45, WEAPON_SILENCED, WEAPON_TEARGAS, WEAPON_SATCHEL, WEAPON_FLAMETHROWER, WEAPON_HEATSEEKER, WEAPON_ROCKETLAUNCHER, WEAPON_FIREEXTINGUISHER, WEAPON_SPRAYCAN:
		{
			Kick(playerid);
		}
		case WEAPON_MINIGUN:
		{
			if(IdAreny[playerid] != 3)
			{
				Kick(playerid);
			}
		}
	}
	return 1;
}

///////////////////////////////////////////////////////////////////////////KOMENDY MODA
public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ) 
{
	if(JestRanga(playerid, RANGA_VIP))//jest ta ranga albo wyzsza
    {
		if(DaneGracza[playerid][Dead] == true) return 0;
		if(DaneAreny[playerid][Warenie] == true) return 0;
        else if(GetPlayerState(playerid) ==  PLAYER_STATE_DRIVER)
        {
            SetVehiclePos(GetPlayerVehicleID(playerid), fX, fY, fZ);
            PutPlayerInVehicle(playerid, GetPlayerVehicleID(playerid), 0);
        }
        else   
        {
            SetPlayerPos(playerid, fX, fY, fZ);
        }
    }
    return true;
}

CMD:acmds(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))//jest ta ranga albo wyzsza
	{
	ShowPlayerDialog(playerid,10,DIALOG_STYLE_MSGBOX,"Moderator cmds","{FFAF00}/givemoney/score playerid ammount {ffffff}- {ffffff}Give money/score to player\n{FFAF00}/jetpack {ffffff}- {ffffff}Spawn jetpack\n{FFAF00}/kick playerid reason {ffffff}- {ffffff}Kick player\n{FFAF00}/go playerid {ffffff}- {ffffff}go to player\n{FFAF00}/get playerid {ffffff}- {ffffff}bring player to your pos\n{FFAF00}/spec playerid {ffffff}- {ffffff}spectate\n{FFAF00}/specoff {ffffff}- {ffffff}exit spectating", ">","x");
	}
	return 1;
}
CMD:go(playerid,params[])
{	
	new Float:Pos[3];
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		if (sscanf(params, "us[80]", id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /go [id]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		GetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

CMD:get(playerid,params[])
{
	new Float:Pos[3];
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		if (sscanf(params, "us[80]", id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /get [id]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		SetPlayerPos(id, Pos[0], Pos[1], Pos[2]);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

CMD:givemoney(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		new string[128], targetid, money;
        if(sscanf(params, "ud", targetid, money)) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}USAGE: /givemoney [playerid] [money]");

        if(IsPlayerConnected(targetid))
        {
            GivePlayerMoney(targetid, GetPlayerMoney(targetid) + money);
            format(string, sizeof(string), "> {ffffff}You have given %d money to %s.",money, NazwaGracza(targetid));
            SendClientMessage(playerid, COLOR_RED, string);
        }
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
CMD:givescore(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		new string[128], targetid, score;
        if(sscanf(params, "ud", targetid, score)) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}USAGE: /givescore [playerid] [score]");

        if(IsPlayerConnected(targetid))
        {
            SetPlayerScore(targetid, GetPlayerScore(targetid) + score);
            format(string, sizeof(string), "> {ffffff}You have given %d score to %s.",score, NazwaGracza(targetid));
            SendClientMessage(playerid, COLOR_RED, string);
        }
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
CMD:jetpack(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(DaneAreny[playerid][Warenie] == true) return SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	else if(JestRanga(playerid, RANGA_VIP))//jest ta ranga albo wyzsza
	{
		SetPlayerSpecialAction(playerid, 2);
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

new name1[MAX_PLAYER_NAME];
new name2[MAX_PLAYER_NAME];
new StringKick[286]; 
CMD:kick(playerid,params[])
{
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		new reason[80];
		if (sscanf(params, "us[80]", id,reason)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /kick [id] [reason]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		GetPlayerName(playerid, name1, sizeof(name1));
		GetPlayerName(id, name2, sizeof(name2));
		format(StringKick,sizeof(StringKick),"> {ffffff}Administrator {ff0000}%s {ffffff}kicked {ff0000}%s {ffffff}Reason: {ff0000}%s",name1,name2,reason);
		SendClientMessageToAll(COLOR_RED,StringKick);
		SetTimerEx("DelayedKick", 200, false, "i", id);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

CMD:spec(playerid,params[])
{
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		if (sscanf(params, "us[80]", id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /spec [id]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		GetPlayerName(playerid, name1, sizeof(name1));
		GetPlayerName(id, name2, sizeof(name2));
		if(playerid == id) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}You can't spectate yourself.");
		
		GetPlayerName(id, name2, sizeof(name2));
		format(StringKick,sizeof(StringKick),"> {ffffff}Spectating {ff0000}%s",name2);
		SendClientMessage(playerid,COLOR_RED,StringKick);
		
		TogglePlayerSpectating(playerid, true);
		SetPlayerInterior(playerid, GetPlayerInterior(id));
		SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(id));
		if(GetPlayerState(id) == PLAYER_STATE_DRIVER)
		{
			new vehicleid;
			vehicleid = GetPlayerVehicleID(id);
			PlayerSpectateVehicle(playerid, vehicleid, SPECTATE_MODE_NORMAL);
		}
		else
		PlayerSpectatePlayer(playerid, id, SPECTATE_MODE_NORMAL);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
CMD:specoff(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_MODERATOR))
	{
		TogglePlayerSpectating(playerid, false);
		SpawnPlayer(playerid);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
///////////////////////////////////////////////////////////////////////////KOMENDY ADMINA

CMD:ban(playerid,params[])
{
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_ADMIN))
	{
		new reason[80];
		if (sscanf(params, "us[80]", id,reason)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /ban [id] [reason]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		DaneGracza[id][Banned] = true;
		GetPlayerName(playerid, name1, sizeof(name1));
		GetPlayerName(id, name2, sizeof(name2));
		format(StringKick,sizeof(StringKick),"> {ffffff}Administrator {ff0000}%s {ffffff}banned {ff0000}%s {ffffff}Reason: {ff0000}%s",name1,name2,reason);
		SendClientMessageToAll(COLOR_RED,StringKick);
		//Ban(id);
		SetTimerEx("DelayedBan", 1000, false, "i", id);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

CMD:unban(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_ADMIN))
	{
		
		new BannedName[MAX_PLAYER_NAME];
		new string[700];
		new unbanstring[700];
		if (sscanf(params,"s",BannedName)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /unban [nick]");
		else
		{		
			new path[256];
			format(path, sizeof path, FOLDER_KONT"%s.ini", BannedName);
			if(dfile_FileExists(path))
			{
				dfile_Open(path);
				if(dfile_ReadBool("Banned") == true)
				{
					format(string, sizeof string, "unbanip %s", dfile_ReadString("IP"));
					SendRconCommand(string);
					GetPlayerName(playerid, name1, sizeof(name1));
					format(unbanstring,sizeof(unbanstring),"> {ffffff}Administrator {ff0000}%s {ffffff}unbanned {ff0000}%s",name1,BannedName);
					SendClientMessageToAll(COLOR_RED,unbanstring);
					dfile_WriteBool("Banned", false);
					dfile_SaveFile();
				}
				else SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not banned!");
				dfile_CloseFile();
			}
			else SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player does not exist!");
		}
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
///////////////////////////////////////////////////////////////////////////KOMENDY Head
CMD:giverank(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD) || IsPlayerAdmin(playerid))
	{
		new id, string[500], naglowek[250];
		if(sscanf(params, "u", id)) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}Usage: /giverank playerid");
		else if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}Player does not exist.");
		else if(DaneGracza[id][Zalogowany] == false) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}Player not logged in.");
		else
		{
			DaneGracza[playerid][WybranyGracz] = id;
			strcat(string, "Player\n");
			strcat(string, "VIP\n");
			strcat(string, "Moderator\n");
			strcat(string, "Admin\n");
			strcat(string, "Head(wypierdalac od tego)");
			format(naglowek, sizeof naglowek, "{ffffff}Change rank of {"COLOR_AXWELL"}%s[%i]", NazwaGracza(id), id);
			ShowPlayerDialog(playerid, DIALOG_ZMIENRANGE, DIALOG_STYLE_LIST, naglowek, string, ">", "x");
		}
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}

new iString[180];
CMD:msg1(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	format(iString, sizeof(iString), "%s", params);
	TextDrawSetString(adminmsg1, iString);
	return 1;
}
CMD:msg2(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	format(iString, sizeof(iString), "%s", params);
	TextDrawSetString(adminmsg2, iString);
	return 1;
}
CMD:msg3(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	format(iString, sizeof(iString), "%s", params);
	TextDrawSetString(adminmsg3, iString);

	return 1;
}



CMD:god(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
		if(IsGod[playerid] == 0)
		{
			IsGod[playerid] = 1;
			SetPlayerHealth(playerid, 9999999.0);
			SetPlayerArmour(playerid, 9999999.0);
			SendClientMessage(playerid, COLOR_RED, "> {ffffff}God Mode is Activated");
			SetVehicleHealth(playerid, 1000.0);
		}
		else if(IsGod[playerid] == 1)
		{
			IsGod[playerid] = 0;
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 100.0);
			SendClientMessage(playerid, COLOR_RED, "> {ffffff}God Mode is DeActivated");
			SetVehicleHealth(playerid, 1000.0);
		}
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}

CMD:gmx(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
		GameModeExit( );
		return true;
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}
CMD:clearmsg(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
		TextDrawSetString(adminmsg1, " ");
		TextDrawSetString(adminmsg2, " ");
		TextDrawSetString(adminmsg3, " ");
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}
CMD:sex(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
		//PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/768773462989864971/800010931983089704/Hentai_Orgasm_Anime_Sound_-_Sound_Effect_for_editing.mp3"); //audio
		new Float:Pos[3];
		GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
		CreateExplosion(Pos[0], Pos[1], Pos[2], 7, 6.0);
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
	if(bodypart == 9 && weaponid == 24)
	{
		GameTextForPlayer(playerid, "~g~headshot~r~~n~deagle", 3000, 1);
	}
	else if(bodypart == 9 && weaponid == 33)
	{
		GameTextForPlayer(playerid, "~g~headshot~r~~n~rifle", 3000, 1);
	}
	else if(bodypart == 9 && weaponid == 34)
	{
		GameTextForPlayer(playerid, "~g~headshot~r~~n~sniper", 3000, 1);
	}
	
	PlayerPlaySound(playerid,17802,0.0,0.0,0.0);
    return 1;
}

CMD:w(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
	new world;
    if(sscanf(params,"i",world)) return SendClientMessage(playerid,COLOR_RED, "> {ffffff}Usage {00ffff}/w [id]");
    SetPlayerVirtualWorld(playerid,world);
    SendClientMessage(playerid,COLOR_RED, "> {ffffff}You have changed your VW.");
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}

CMD:delvehall(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	else if(JestRanga(playerid, RANGA_HEAD))//jest ta ranga albo wyzsza
	{
		foreach(new i : Player)
		{
			if(VehicleSpawned[i] != -1)
			{
				DestroyVehicle(VehicleSpawned[i]);
				VehicleSpawned[i] = (-1);
			}
		}
		SendClientMessageToAll(COLOR_RED, "> {FFFFFF}Vehicles were removed by an {ff0000}H@.");
	}
	else
	SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	return 1;
}

//skin changer
CMD:skin(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	new skin;
    if(sscanf(params,"i",skin)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Usage {FFAF00}/skin id");
    if(!IsValidSkin(skin)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Wrong skin {FFAF00}id");
    SetPlayerSkin(playerid,skin);
    SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}You have changed your skin.");
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteInt("Skin", GetPlayerSkin(playerid));

	dfile_SaveFile();
	dfile_CloseFile();
	return 1;
}
stock IsValidSkin(SkinID)
{
	if((SkinID >= 0 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 311)) return true;
    else return false;
}
//end skinchanger
CMD:time(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	new time;
    if(sscanf(params,"i",time)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Usage {FFAF00}/time id");
    if(!IsValidTime(time)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Wrong time {FFAF00}id");
    SetPlayerTime(playerid,time, 0);
    SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}You have changed your time.");
	return 1;
}


CMD:weather(playerid,params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	new weather;
    if(sscanf(params,"i",weather)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Usage {FFAF00}/weather id");
    if(!IsValidTime(weather)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Wrong weather {FFAF00}id");
    SetPlayerWeather(playerid,weather);
    SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}You have changed your weather.");
	return 1;
}

stock IsValidTime(time)
{
	if(time >= 0 && time <= 23) return true;
    else return false;
}
stock IsValidWeather(weather)
{
	if(weather >= 0 && weather <= 256) return true;
    else return false;
}
//teleport
CMD:ls(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 2504.8557,-1668.1201,13.3695);
		SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Los Santos");
	
	}
	return 1;
}


CMD:lv(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 2108.2048,1022.2280,10.8203);
		SetPlayerFacingAngle(playerid, 177);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Las Venturas");
	}
	return 1;
}

CMD:sf(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -1972.8636,288.6777,35.1719);
		SetPlayerFacingAngle(playerid, 92);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}San Fierro");
	}
	return 1;
}

CMD:drift(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid,-279.8016,1538.4362,75.3570);
		SetPlayerFacingAngle(playerid, 135);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}big Ear");
	}
	return 1;
}

CMD:lva(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 1680.5010,1593.2078,10.8203);
		SetPlayerFacingAngle(playerid, 104);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Las Venturas Airport");
	}
	return 1;
}

CMD:lsa(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 1961.6454,-2255.9773,13.5469);
		SetPlayerFacingAngle(playerid, 176);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Los Santos Airport");
	}
	return 1;
}
CMD:sfa(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -1320.9324,-411.5818,14.1484);
		SetPlayerFacingAngle(playerid, 266);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}San Fierro Airport");
	}
	return 1;
}

CMD:pc(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 2281.7026,-38.3575,26.4876);
		SetPlayerFacingAngle(playerid, 359);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Palomeeno Creek");
	}
	return 1;
}

//dlaraya
CMD:bsls(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 1223.8655,-1815.7615,16.5938);
		SetPlayerFacingAngle(playerid, 190);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Los Santos Bus Station");
	}
	return 1;
}

CMD:bslv(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 2844.5093,1291.1006,11.3906);
		SetPlayerFacingAngle(playerid, 89);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Las Venturas Bus Station");
	}
	return 1;
}
CMD:bssf(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -1972.6777,137.9721,27.6875);
		SetPlayerFacingAngle(playerid, 90);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}San Fierro Bus Station");
	}
	return 1;
}
CMD:bayside(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -2227.6858,2326.7825,7.5469);
		SetPlayerFacingAngle(playerid, 88);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Bayside Marina");
	}
	return 1;
}

CMD:eq(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -1552.7572,2647.7339,55.8359);
		SetPlayerFacingAngle(playerid, 271);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}El Quebrados");
	}
	return 1;
}

CMD:vo(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -846.4752,2741.0237,45.7801);
		SetPlayerFacingAngle(playerid, 185);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Valle Okultado");
	}
	return 1;
}

CMD:lp(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -251.8926,2603.7224,62.8582);
		SetPlayerFacingAngle(playerid, 185);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Las Payasadas");
	}
	return 1;
}

CMD:aa(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 403.4505,2536.3401,16.5456);
		SetPlayerFacingAngle(playerid, 167);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Abandoned Airport");
	}
	return 1;
}

CMD:fc(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -89.5088,1219.1871,19.7422);
		SetPlayerFacingAngle(playerid, 180);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Fort Carson");
	}
	return 1;
}

CMD:lb(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -856.3732,1542.9072,22.8289);
		SetPlayerFacingAngle(playerid, 266);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Las Barrancas");
	}
	return 1;
}

CMD:ap(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -2172.6912,-2428.5659,30.6250);
		SetPlayerFacingAngle(playerid, 230);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Angel Pine");
	}
	return 1;
}

CMD:chiliad(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -2320.5913,-1636.5212,483.7031);
		SetPlayerFacingAngle(playerid, 192);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Mount Chiliad");
	}
	return 1;
}

CMD:mg(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 1334.5803,288.0219,19.5615);
		SetPlayerFacingAngle(playerid, 245);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Montgomery");
	}
	return 1;
}

CMD:bb(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 167.8942,-40.7553,1.5781);
		SetPlayerFacingAngle(playerid, 253);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Blueberry");
	}
	return 1;
}

CMD:gt(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -391.6147,2275.4690,40.9376);
		SetPlayerFacingAngle(playerid, 188);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Ghost Town");
	}
	return 1;
}


CMD:am(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, -1297.1420,2501.3269,86.9221);
		SetPlayerFacingAngle(playerid, 11);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Aldea Malvada");
	}
	return 1;
}

CMD:army(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		SetPlayerPos(playerid, 213.7717,1866.8424,13.1406);
		SetPlayerFacingAngle(playerid, 360);
		SetCameraBehindPlayer(playerid);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have been teleported to {FFAF00}Area 69");
	}
	return 1;
}

CMD:arena(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are already in arena!");
	}
	else
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have joined arena.");
		IdAreny[playerid] = 1;
		DaneAreny[playerid][Warenie] = true;
		new Random = random(sizeof(RandomSpawns));
		SetPlayerPos(playerid, RandomSpawns[Random][0], RandomSpawns[Random][1], RandomSpawns[Random][2]);
		SetPlayerFacingAngle(playerid, RandomSpawns[Random][3]);
		SetCameraBehindPlayer(playerid);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 2);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 100);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 25, 9999);
		GivePlayerWeapon(playerid, 24, 9999);
	}
	return 1;
}


//arenaonede	
CMD:onede(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadoonede(playerid);
	ObiektyOnede(playerid);
	return 1;
}


CMD:mini(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadomini(playerid);
	return 1;
}


CMD:wh(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadowarehouse(playerid);
	return 1;
}
CMD:so(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadosawnoff(playerid);
	return 1;
}
CMD:antic(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadoanticbug(playerid);
	return 1;
}
CMD:sniper(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	dajgraczadosniper(playerid);
	return 1;
}

CMD:exit(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have left arena.");
		DaneAreny[playerid][Warenie] = false;
		IdAreny[playerid] = 0;
		SpawnPlayer(playerid);
		SetPlayerHealth(playerid, 100);
		SetPlayerArmour(playerid, 0);
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not in any DM arena!");
	}
	return 1;
}

//VEHSPAWN	

CMD:veh(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		new Float:sPos[4];
		if(!strlen(params)) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}Usage /veh [id]");
		if(strval(params) < 400 || strval(params) > 611) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}Wrong vehicle id");

		if(IsPlayerInAnyVehicle(playerid))
		{
			GetVehiclePos(GetPlayerVehicleID(playerid), sPos[0], sPos[1], sPos[2]);
			GetVehicleZAngle(GetPlayerVehicleID(playerid), sPos[3]);
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			else
			RemovePlayerFromVehicle(playerid);
		}
		else
		{
			GetPlayerPos(playerid, sPos[0], sPos[1], sPos[2]);
			GetPlayerFacingAngle(playerid, sPos[3]);
		}
		if(VehicleSpawned[playerid] != -1)
		DestroyVehicle(VehicleSpawned[playerid]);
		VehicleSpawned[playerid] = CreateVehicle(strval(params[0]), sPos[0], sPos[1], sPos[2], sPos[3], -1, -1, -1);
		SetVehicleVirtualWorld(VehicleSpawned[playerid], GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(VehicleSpawned[playerid], GetPlayerInterior(playerid));
		PutPlayerInVehicle(playerid, VehicleSpawned[playerid], 0);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Your vehicle was spawned.");
	}
	return 1;
}

CMD:vc(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		new color1;
		new color2;
		if(sscanf(params, "ii", color1, color2)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: /vc [color1] [color2]");
		if(VehicleSpawned[playerid] == -1) return SendClientMessage(playerid, COLOR_RED, "> {ffffff}You have not spawned any vehicle {COLOR_RED}/veh [id]");
		if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_RED, "> {ffffff} You are not driving");
		
		ChangeVehicleColor(GetPlayerVehicleID(playerid), color1, color2);
	}
	return 1;
}

CMD:delveh(playerid, params[])
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneAreny[playerid][Warenie] == true)
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command in arena!");
	}
	else
	{
		if(VehicleSpawned[playerid] == -1) return SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}You have not spawned any vehicle {COLOR_RED}/veh [id]");
		DestroyVehicle(VehicleSpawned[playerid]);
		VehicleSpawned[playerid] = (-1);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Your vehice was removed");
	}
	return 1;
}

CMD:help(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	ShowPlayerDialog(playerid,3,DIALOG_STYLE_MSGBOX,"Help","{FFAF00}/help {ffffff}- {ffffff}Help dialog\n{FFAF00}/veh id {ffffff}- Spawn vehicle\n{FFAF00}/delveh {ffffff}- Remove spawned vehicle\n{FFAF00}/vc color1 color2{ffffff}- Change veh color\n{FFAF00}/tune {ffffff}- Vehicle tune menu\n{FFAF00}/skin id {ffffff}- Change skin\n{FFAF00}/teles {ffffff}- Teleport dialog\n{FFAF00}/time id {ffffff}- Change time\n{FFAF00}/weather id {ffffff}- Change weather", ">","X");
	return 1;
}

CMD:teles(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	ShowPlayerDialog(playerid,4,DIALOG_STYLE_MSGBOX,"Teleports Page 1","{FFAF00}/ls {ffffff}- tp to Los Santos\n{FFAF00}/sf {ffffff}- tp to San Fierro\n{FFAF00}/lv {ffffff}- tp to Las Venturas\n{FFAF00}/bsls {ffffff}- tp to bus station in LS\n{FFAF00}/bslv {ffffff}- tp to bus station in LV\n{FFAF00}/bssf {ffffff}- tp to bus station in SF", ">","X");
	return 1;
}

CMD:dm(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	ShowPlayerDialog(playerid, DIALOG_DM, DIALOG_STYLE_LIST, "DeathMatch", "/arena\n/onede\n/mini\n/wh\n/so\n/anticn\n/sniper", ">", "X");
	return 1;
}

CMD:td(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Dead] == true) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You can't do that now...");
	if(DaneTextdraw[playerid][tdon] == false)
	{
		PlayerTextDrawHide(playerid, sdisplay[playerid]);
		PlayerTextDrawHide(playerid, hpbar[playerid]);
		
		TextDrawHideForPlayer(playerid, PasekDraw[0]);
		TextDrawHideForPlayer(playerid, PasekDraw[1]);
		TextDrawHideForPlayer(playerid, TDLogo[0]);
		TextDrawHideForPlayer(playerid, DrawZabawy[0]);
		TextDrawHideForPlayer(playerid, DrawZabawy[1]);
		TextDrawHideForPlayer(playerid, TDLogo[1]);
		TextDrawHideForPlayer(playerid, TDLogo[2]);
		TextDrawHideForPlayer(playerid, TDLogo[3]);
		TextDrawHideForPlayer(playerid, TDLogo[4]);
		TextDrawHideForPlayer(playerid, DateAndTime[0]);
		TextDrawHideForPlayer(playerid, DateAndTime[1]);
		TextDrawHideForPlayer(playerid, PasekDraw[2]);
		TextDrawHideForPlayer(playerid, PasekDraw[3]);
		TextDrawHideForPlayer(playerid, PasekDraw[4]);
		TextDrawHideForPlayer(playerid, PasekDraw[5]);
		TextDrawHideForPlayer(playerid, PasekDraw[6]);
		TextDrawHideForPlayer(playerid, PasekDraw[7]);
		TextDrawHideForPlayer(playerid, TDRandomMSG);
		PlayerTextDrawHide(playerid, PacketPing[playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[0][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[1][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[2][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[3][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[4][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[5][playerid]);
		PlayerTextDrawHide(playerid, PlayerPasek[6][playerid]);
		
		
		
		DaneTextdraw[playerid][tdon] = true;
	}
	else
	{
		PlayerTextDrawShow(playerid, sdisplay[playerid]);
		PlayerTextDrawShow(playerid, hpbar[playerid]);
		
		TextDrawShowForPlayer(playerid, PasekDraw[0]);
		TextDrawShowForPlayer(playerid, PasekDraw[1]);
		TextDrawShowForPlayer(playerid, TDLogo[0]);
		TextDrawShowForPlayer(playerid, DrawZabawy[0]);
		TextDrawShowForPlayer(playerid, DrawZabawy[1]);
		TextDrawShowForPlayer(playerid, TDLogo[1]);
		TextDrawShowForPlayer(playerid, TDLogo[2]);
		TextDrawShowForPlayer(playerid, TDLogo[3]);
		TextDrawShowForPlayer(playerid, TDLogo[4]);
		TextDrawShowForPlayer(playerid, DateAndTime[0]);
		TextDrawShowForPlayer(playerid, DateAndTime[1]);
		TextDrawShowForPlayer(playerid, PasekDraw[2]);
		TextDrawShowForPlayer(playerid, PasekDraw[3]);
		TextDrawShowForPlayer(playerid, PasekDraw[4]);
		TextDrawShowForPlayer(playerid, PasekDraw[5]);
		TextDrawShowForPlayer(playerid, PasekDraw[6]);
		TextDrawShowForPlayer(playerid, PasekDraw[7]);
		TextDrawShowForPlayer(playerid, TDRandomMSG);
		PlayerTextDrawShow(playerid, PacketPing[playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[0][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[1][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[2][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[3][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[4][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[5][playerid]);
		PlayerTextDrawShow(playerid, PlayerPasek[6][playerid]);
		
		
		DaneTextdraw[playerid][tdon] = false;
	}
	return 1;
}


new namemsg1[MAX_PLAYER_NAME];
new namemsg2[MAX_PLAYER_NAME];
new StringPriv[286]; 
CMD:t(playerid,params[])
{
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(DaneGracza[playerid][Zalogowany] == true)
	{
		new reason[80];
		if (sscanf(params, "us[80]", id,reason)) return SendClientMessage(playerid, COLOR_WHITE,"{FFAF00}> {ffffff}USAGE: {FFAF00}/t [id] [message]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");

		GetPlayerName(playerid, namemsg1, sizeof(namemsg1));
		GetPlayerName(id, namemsg2, sizeof(namemsg2));
		format(StringPriv,sizeof(StringPriv),"{FFAF00}> {ffffff}Message from:{FFAF00} %s{ffffff} [%d]: %s",namemsg1,playerid,reason);
		SendClientMessage(id, COLOR_WHITE, StringPriv);
		SendClientMessage(playerid, COLOR_WHITE, "{FFAF00}> {ffffff}Message sent.");
		PlayerPlaySound(playerid,1137,0.0,0.0,0.0);
		PlayerPlaySound(id,1137,0.0,0.0,0.0);
		return 1;
	}
	return 1;
}

CMD:zjeb(playerid,params[])
{
	new id;
	if(DaneGracza[playerid][Zalogowany] == false) return SendClientMessage(playerid, COLOR_BLUE, "> {ffffff}You are not logged in...");
	else if(JestRanga(playerid, RANGA_HEAD))
	{
		if (sscanf(params, "us[80]", id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}USAGE: {ff0000}/zjeb [id]");
		if(!IsPlayerConnected(id)) return SendClientMessage(playerid,COLOR_RED,"> {ffffff}This player is not connected.");
		SetPlayerHealth(id, 0);
		return 1;
	}
	else
	{
		SendClientMessage(playerid,COLOR_RED, "> {ffffff}You are not allowed to use this command!");
	}
	return 1;
}
