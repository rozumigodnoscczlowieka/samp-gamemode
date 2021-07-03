#include <a_samp>
#include <dfile>
#include <kolory>
#include <Sscanf2>
#include <zcmd>



native WP_Hash(buffer[], len, const str[]); 

//Ustawienia serwera
#define NAZWA_SERWERA "ICY PARTY SERVER"
#define WERSJA_SERWERA "1.0"

#define PUNKTY_NA_START 10
#define KASA_NA_START 50000
#define SKIN_NA_START 2


//Dialogi
#define DIALOG_REJESTRACJA 0
#define DIALOG_LOGOWANIE 1

//Sciezki folderow
#define FOLDER_KONT "/Konta/"





//textdrawy
new Text:dolnypasek;
new Text:logoserver;
new Text:pasekpom;
new Text:LOGOICY;
new Text:LOGOPARTY;


//onconnect
new PlayerText:pasekblackdol[MAX_PLAYERS];
new PlayerText:pasekblackgora[MAX_PLAYERS];
new PlayerText:pasekorangedol[MAX_PLAYERS];
new PlayerText:pasekorangegora[MAX_PLAYERS];
new PlayerText:ipslogo[MAX_PLAYERS];


main(){}

//Enumy
enum Dgracza
{
	bool:Zalogowany
};
new DaneGracza[MAX_PLAYERS][Dgracza];

public OnGameModeInit()
{
	UsePlayerPedAnims();

	DisableInteriorEnterExits();
	
	AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
	
	if(!dfile_FileExists(FOLDER_KONT))
		return printf("BLAD: Folder %s nie istnieje w folderze Scriptfiles! Stworz ja!", FOLDER_KONT);
	
	printf("\nGamemode %s wersja %s by icy zostal pomyslnie wlaczony!\n", NAZWA_SERWERA, WERSJA_SERWERA);
	
	
	
	
	LOGOICY = TextDrawCreate(143.000000, 387.000000, "ICY");
	TextDrawFont(LOGOICY, 3);
	TextDrawLetterSize(LOGOICY, 0.600000, 2.000000);
	TextDrawTextSize(LOGOICY, 400.000000, 17.000000);
	TextDrawSetOutline(LOGOICY, 1);
	TextDrawSetShadow(LOGOICY, 0);
	TextDrawAlignment(LOGOICY, 1);
	TextDrawColor(LOGOICY, -1);
	TextDrawBackgroundColor(LOGOICY, 255);
	TextDrawBoxColor(LOGOICY, 50);
	TextDrawUseBox(LOGOICY, 0);
	TextDrawSetProportional(LOGOICY, 1);
	TextDrawSetSelectable(LOGOICY, 0);

	LOGOPARTY = TextDrawCreate(149.000000, 405.000000, "PARTY");
	TextDrawFont(LOGOPARTY, 3);
	TextDrawLetterSize(LOGOPARTY, 0.600000, 2.000000);
	TextDrawTextSize(LOGOPARTY, 400.000000, 17.000000);
	TextDrawSetOutline(LOGOPARTY, 1);
	TextDrawSetShadow(LOGOPARTY, 0);
	TextDrawAlignment(LOGOPARTY, 1);
	TextDrawColor(LOGOPARTY, -1);
	TextDrawBackgroundColor(LOGOPARTY, 255);
	TextDrawBoxColor(LOGOPARTY, 50);
	TextDrawUseBox(LOGOPARTY, 0);
	TextDrawSetProportional(LOGOPARTY, 1);
	TextDrawSetSelectable(LOGOPARTY, 0);



	dolnypasek = TextDrawCreate(2.000000, 431.000000, "_");
	TextDrawFont(dolnypasek, 1);
	TextDrawLetterSize(dolnypasek, 0.341666, 1.749999);
	TextDrawTextSize(dolnypasek, 641.000000, 351.000000);
	TextDrawSetOutline(dolnypasek, 1);
	TextDrawSetShadow(dolnypasek, 0);
	TextDrawAlignment(dolnypasek, 1);
	TextDrawColor(dolnypasek, -1);
	TextDrawBackgroundColor(dolnypasek, 255);
	TextDrawBoxColor(dolnypasek, 50);
	TextDrawUseBox(dolnypasek, 1);
	TextDrawSetProportional(dolnypasek, 1);
	TextDrawSetSelectable(dolnypasek, 0);

	logoserver = TextDrawCreate(156.000000, 429.000000, "SERVER");
	TextDrawFont(logoserver, 1);
	TextDrawLetterSize(logoserver, 0.458332, 1.899999);
	TextDrawTextSize(logoserver, 400.000000, 17.000000);
	TextDrawSetOutline(logoserver, 1);
	TextDrawSetShadow(logoserver, 0);
	TextDrawAlignment(logoserver, 1);
	TextDrawColor(logoserver, -294256385);
	TextDrawBackgroundColor(logoserver, 255);
	TextDrawBoxColor(logoserver, 50);
	TextDrawUseBox(logoserver, 0);
	TextDrawSetProportional(logoserver, 1);
	TextDrawSetSelectable(logoserver, 0);

	pasekpom = TextDrawCreate(-1.000000, 429.000000, "_");
	TextDrawFont(pasekpom, 1);
	TextDrawLetterSize(pasekpom, 38.912548, -0.099999);
	TextDrawTextSize(pasekpom, 650.500000, -59.000000);
	TextDrawSetOutline(pasekpom, 0);
	TextDrawSetShadow(pasekpom, 0);
	TextDrawAlignment(pasekpom, 1);
	TextDrawColor(pasekpom, -1);
	TextDrawBackgroundColor(pasekpom, 255);
	TextDrawBoxColor(pasekpom, -294256385);
	TextDrawUseBox(pasekpom, 1);
	TextDrawSetProportional(pasekpom, 1);
	TextDrawSetSelectable(pasekpom, 0);
	
	
	
	
	
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
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
				WymusWyborPostaci(playerid);
				SendClientMessage(playerid, COLOR_GREEN, "{FFAF00}> {ffffff}You have successfully logged in!");
				
				
				StopAudioStreamForPlayer(playerid); 
				TextDrawShowForPlayer(playerid, LOGOICY);
				TextDrawShowForPlayer(playerid, LOGOPARTY);
				TextDrawShowForPlayer(playerid, dolnypasek);
				TextDrawShowForPlayer(playerid, pasekpom);
				TextDrawShowForPlayer(playerid, logoserver);
	
				PlayerTextDrawDestroy(playerid, pasekblackdol[playerid]);
				PlayerTextDrawDestroy(playerid, pasekblackgora[playerid]);
				PlayerTextDrawDestroy(playerid, pasekorangedol[playerid]);
				PlayerTextDrawDestroy(playerid, pasekorangegora[playerid]);
				PlayerTextDrawDestroy(playerid, ipslogo[playerid]);
				//loadskin
				dfile_Open(SciezkaKontaGracza(playerid));
				SetPlayerSkin(playerid, dfile_ReadInt("Skin"));
				dfile_CloseFile();
			}
			else
			{
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_RED, "> Wrong password.");
			}
		}
		else Kick(playerid);
	}
	if(dialogid == DIALOG_REJESTRACJA)
	{
		if(response)
		{
			if(strlen(inputtext) >= 6)
			{
				StworzKonto(playerid, inputtext);
				OknoLogowania(playerid);
				SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Your account was created!");
			}
			else
			{
				OknoRejestracji(playerid);
				SendClientMessage(playerid, COLOR_RED, "> Password has to be at least 6 digits long!");
			}
		}
		else Kick(playerid);
	}
	return 0;
}

public OnPlayerConnect(playerid)
{
	PlayAudioStreamForPlayer(playerid, "https://cdn.discordapp.com/attachments/770600476675801129/770600516182474782/gedzkosmita.mp3"); //audio
	ResetujDaneGracza(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);

    new name[MAX_PLAYER_NAME], string[39 + MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	format(string, sizeof(string), "%s [ID:%d] has joined the server.",name, playerid);
	SendClientMessageToAll(COLOR_WHITE, string);
	
    SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}gm by: {FFAF00}ICY{FFFFFF}| for more informations: {FFAF00}/help{FFFFFF}"); //help not working tho

	//connecttext
	
	pasekblackdol[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 370.000000, "_");
	PlayerTextDrawFont(playerid, pasekblackdol[playerid], 1);
	PlayerTextDrawLetterSize(playerid, pasekblackdol[playerid], 0.600000, 8.449996);
	PlayerTextDrawTextSize(playerid, pasekblackdol[playerid], 639.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pasekblackdol[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pasekblackdol[playerid], 0);
	PlayerTextDrawAlignment(playerid, pasekblackdol[playerid], 1);
	PlayerTextDrawColor(playerid, pasekblackdol[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, pasekblackdol[playerid], 255);
	PlayerTextDrawBoxColor(playerid, pasekblackdol[playerid], 255);
	PlayerTextDrawUseBox(playerid, pasekblackdol[playerid], 1);
	PlayerTextDrawSetProportional(playerid, pasekblackdol[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, pasekblackdol[playerid], 0);

	pasekblackgora[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 0.000000, "_");
	PlayerTextDrawFont(playerid, pasekblackgora[playerid], 1);
	PlayerTextDrawLetterSize(playerid, pasekblackgora[playerid], 0.600000, 8.699995);
	PlayerTextDrawTextSize(playerid, pasekblackgora[playerid], 639.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pasekblackgora[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pasekblackgora[playerid], 0);
	PlayerTextDrawAlignment(playerid, pasekblackgora[playerid], 1);
	PlayerTextDrawColor(playerid, pasekblackgora[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, pasekblackgora[playerid], 255);
	PlayerTextDrawBoxColor(playerid, pasekblackgora[playerid], 255);
	PlayerTextDrawUseBox(playerid, pasekblackgora[playerid], 1);
	PlayerTextDrawSetProportional(playerid, pasekblackgora[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, pasekblackgora[playerid], 0);

	pasekorangedol[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 369.000000, "_");
	PlayerTextDrawFont(playerid, pasekorangedol[playerid], 1);
	PlayerTextDrawLetterSize(playerid, pasekorangedol[playerid], 0.600000, -0.149996);
	PlayerTextDrawTextSize(playerid, pasekorangedol[playerid], 639.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pasekorangedol[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pasekorangedol[playerid], 0);
	PlayerTextDrawAlignment(playerid, pasekorangedol[playerid], 1);
	PlayerTextDrawColor(playerid, pasekorangedol[playerid], -294256385);
	PlayerTextDrawBackgroundColor(playerid, pasekorangedol[playerid], -294256385);
	PlayerTextDrawBoxColor(playerid, pasekorangedol[playerid], -294256385);
	PlayerTextDrawUseBox(playerid, pasekorangedol[playerid], 1);
	PlayerTextDrawSetProportional(playerid, pasekorangedol[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, pasekorangedol[playerid], 0);

	pasekorangegora[playerid] = CreatePlayerTextDraw(playerid, 0.000000, 80.000000, "_");
	PlayerTextDrawFont(playerid, pasekorangegora[playerid], 1);
	PlayerTextDrawLetterSize(playerid, pasekorangegora[playerid], 0.600000, -0.149996);
	PlayerTextDrawTextSize(playerid, pasekorangegora[playerid], 639.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, pasekorangegora[playerid], 1);
	PlayerTextDrawSetShadow(playerid, pasekorangegora[playerid], 0);
	PlayerTextDrawAlignment(playerid, pasekorangegora[playerid], 1);
	PlayerTextDrawColor(playerid, pasekorangegora[playerid], -294256385);
	PlayerTextDrawBackgroundColor(playerid, pasekorangegora[playerid], -294256385);
	PlayerTextDrawBoxColor(playerid, pasekorangegora[playerid], -294256385);
	PlayerTextDrawUseBox(playerid, pasekorangegora[playerid], 1);
	PlayerTextDrawSetProportional(playerid, pasekorangegora[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, pasekorangegora[playerid], 0);

	ipslogo[playerid] = CreatePlayerTextDraw(playerid, 237.000000, 29.000000, "ICY PARTY SERVER");
	PlayerTextDrawFont(playerid, ipslogo[playerid], 1);
	PlayerTextDrawLetterSize(playerid, ipslogo[playerid], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, ipslogo[playerid], 460.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, ipslogo[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ipslogo[playerid], 0);
	PlayerTextDrawAlignment(playerid, ipslogo[playerid], 1);
	PlayerTextDrawColor(playerid, ipslogo[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, ipslogo[playerid], 255);
	PlayerTextDrawBoxColor(playerid, ipslogo[playerid], 50);
	PlayerTextDrawUseBox(playerid, ipslogo[playerid], 0);
	PlayerTextDrawSetProportional(playerid, ipslogo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, ipslogo[playerid], 0);



	PlayerTextDrawShow(playerid, pasekblackdol[playerid]);
	PlayerTextDrawShow(playerid, pasekblackgora[playerid]);
	PlayerTextDrawShow(playerid, pasekorangedol[playerid]);
	PlayerTextDrawShow(playerid, pasekorangegora[playerid]);
	PlayerTextDrawShow(playerid, ipslogo[playerid]);


	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(DaneGracza[playerid][Zalogowany] == true)
	{
		ZapiszKonto(playerid);
	}
	ResetujDaneGracza(playerid);
	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(DaneGracza[playerid][Zalogowany] == false)
	{
		TogglePlayerSpectating(playerid, true);
		if(!dfile_FileExists(SciezkaKontaGracza(playerid)))
		{
			OknoRejestracji(playerid);
		}
		else
		{
			OknoLogowania(playerid);
		}
	}
	if(DaneGracza[playerid][Zalogowany] == true)
	{
		//loadskin
		dfile_Open(SciezkaKontaGracza(playerid));
		SetPlayerSkin(playerid, dfile_ReadInt("Skin"));
		dfile_CloseFile();
	}
	SetPlayerColor(playerid, COLOR_WHITE);
	SetPlayerPos(playerid, 167.8942,-40.7553,1.5781);
	SetPlayerFacingAngle(playerid, 253.2356);
	SetCameraBehindPlayer(playerid);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	if(DaneGracza[playerid][Zalogowany] == false)
	{
		SetTimerEx("SpawnujGracza", 100, false, "i", playerid);
	}
	return 1;
}


public OnPlayerText(playerid, text[])
{
    SetPlayerChatBubble(playerid, text, COLOR_WHITE, 100.0, 10000);
    return 1;
}



//Stocki

stock ResetujDaneGracza(playerid)
{
	DaneGracza[playerid][Zalogowany] = false;
	return 1;
}

stock WymusWyborPostaci(playerid)
{
	TogglePlayerSpectating(playerid, true);
	TogglePlayerSpectating(playerid, false);
	return 1;
}

stock ZapiszKonto(playerid)
{
	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteInt("Punkty", GetPlayerScore(playerid));
	dfile_WriteInt("Kasa", GetPlayerMoney(playerid));
	dfile_WriteInt("Skin", GetPlayerSkin(playerid));
	//dfile_WriteInt("Level", 1);
	
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
	
	dfile_CloseFile();
	return 1;
}

stock StworzKonto(playerid, haslo[])
{
	new hasloex[130];
	WP_Hash(hasloex, sizeof hasloex, haslo);

	dfile_Create(SciezkaKontaGracza(playerid));
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteString("Haslo", hasloex);
	dfile_WriteInt("Punkty", PUNKTY_NA_START);
	dfile_WriteInt("Kasa", KASA_NA_START);
	dfile_WriteInt("Skin", SKIN_NA_START);
	
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
	ShowPlayerDialog(playerid, DIALOG_REJESTRACJA, DIALOG_STYLE_PASSWORD, "Account Registration", "Welcome to the server \nplease register your account!", "Register", "Quit");
	return 1;
}

stock OknoLogowania(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_LOGOWANIE, DIALOG_STYLE_PASSWORD, "Account Login", "Welcome to the server \nYour account has been found, please login!", "Login", "Quit");
	return 1;
}

stock NazwaGracza(playerid)
{
	new nazwa[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nazwa, sizeof nazwa);
	return nazwa;
}





//skin changer
CMD:skin(playerid,params[])
{
	new skin;
    if(sscanf(params,"i",skin)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Usage {FFAF00}/skin id");
    if(!IsValidSkin(skin)) return SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}Wrong skin {FFAF00}id");
    SetPlayerSkin(playerid,skin);
    SendClientMessage(playerid,COLOR_ORANGE, "{FFAF00}> {ffffff}You have changed your skin");
	
	dfile_Open(SciezkaKontaGracza(playerid));
	
	dfile_WriteInt("Skin", GetPlayerSkin(playerid));

	dfile_SaveFile();
	dfile_CloseFile();
	
	
	return 1;
}

stock IsValidSkin(SkinID)
{
    if((SkinID >= 0 && SkinID <= 2)||(SkinID == 7)||(SkinID >= 9 && SkinID <= 41)||(SkinID >= 43 && SkinID <= 64)||(SkinID >= 66 && SkinID <= 73)||(SkinID >= 75 && SkinID <= 85)||(SkinID >= 87 && SkinID <= 118)||(SkinID >= 120 && SkinID <= 148)||(SkinID >= 150 && SkinID <= 207)||(SkinID >= 209 && SkinID <= 264)||(SkinID >= 274 && SkinID <= 288)||(SkinID >= 290 && SkinID <= 311)) return true;
    else return false;
}
//end skinchanger


//Timery

forward SpawnujGracza(playerid);
public SpawnujGracza(playerid)
{
	SpawnPlayer(playerid);
	return 1;
}

    CMD:kit1(playerid, params[])
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 9999);
		GivePlayerWeapon(playerid, 27, 9999);			
		GivePlayerWeapon(playerid, 31, 9999);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT1 {ffffff}received");
		return 1;
	}
	
	CMD:kit2(playerid, params[])
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 24, 9999);
		GivePlayerWeapon(playerid, 26, 9999);			
		GivePlayerWeapon(playerid, 30, 9999);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT2 {ffffff}received");
		return 1;
	}
	CMD:kit3(playerid, params[])
	{
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, 22, 9999);
		GivePlayerWeapon(playerid, 25, 9999);			
		GivePlayerWeapon(playerid, 28, 9999);
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT3 {ffffff}received");
		return 1;
	}
	CMD:kit(playerid, params[])
	{
		SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Usage: {FFAF00}KIT1-3 {ffffff}for example /kit2");
		return 1;
	}




	CMD:kit1(playerid, params[])
    {
		dfile_Open(SciezkaKontaGracza(playerid));
		new czywarenie = dfile_ReadInt("Warenie");
		dfile_CloseFile();
		if(czywarenie > 0)
		{
			SendClientMessage(playerid,COLOR_RED, "> You are not allowed to use this command in arena!");
		}
		else
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 9999);
			GivePlayerWeapon(playerid, 27, 9999);			
			GivePlayerWeapon(playerid, 31, 9999);
			SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT1 {ffffff}received");
		}
		return 1;
    }
	
	
	CMD:kit2(playerid, params[])
    {
		dfile_Open(SciezkaKontaGracza(playerid));
		new czywarenie = dfile_ReadInt("Warenie");
		dfile_CloseFile();
		if(czywarenie > 0)
		{
			SendClientMessage(playerid,COLOR_RED, "> You are not allowed to use this command in arena!");
		}
		else
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 24, 9999);
			GivePlayerWeapon(playerid, 26, 9999);			
			GivePlayerWeapon(playerid, 30, 9999);
			SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT2 {ffffff}received");
		}
		return 1;
    }
	
	
	
	CMD:kit3(playerid, params[])
    {
		dfile_Open(SciezkaKontaGracza(playerid));
		new czywarenie = dfile_ReadInt("Warenie");
		dfile_CloseFile();
		if(czywarenie > 0)
		{
			SendClientMessage(playerid,COLOR_RED, "> You are not allowed to use this command in arena!");
		}
		else
		{
			ResetPlayerWeapons(playerid);
			GivePlayerWeapon(playerid, 22, 9999);
			GivePlayerWeapon(playerid, 25, 9999);			
			GivePlayerWeapon(playerid, 28, 9999);
			SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Weapon {FFAF00}KIT3 {ffffff}received");
		}
		return 1;
    }
	
	
	CMD:kit(playerid, params[])
    {
		dfile_Open(SciezkaKontaGracza(playerid));
		new czywarenie = dfile_ReadInt("Warenie");
		dfile_CloseFile();
		if(czywarenie > 0)
		{
			SendClientMessage(playerid,COLOR_RED, "> You are not allowed to use this command in arena!");
		}
		else
		{
			SendClientMessage(playerid, COLOR_ORANGE, "{FFAF00}> {ffffff}Usage: {FFAF00}KIT1-3 {ffffff}for example /kit2");
		}
		return 1;
    }


