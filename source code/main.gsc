#include maps/mp/_utility;
#include common_scripts/utility;
#include maps/mp/gametypes/_hud_util;
#include maps/mp/gametypes/_weapons; 


init()
{
    PrecacheShader("lui_loader_no_offset");
    precacheShader("line_horizontal");
	precacheModel( "projectile_hellfire_missile" );
	precacheModel("collision_clip_32x32x10");  
	level.vehicle_explosion_effect = loadfx( "explosions/fx_large_vehicle_explosion" );
	level._effect[ "flak20_fire_fx" ] = loadfx( "weapon/tracer/fx_tracer_flak_single_noExp" );
	level.result = 0;
	precacheShader("fullscreen_proximity_vertical0");
	SetDvarIfNotInizialized("vips_list", "365D1");
	SetDvarIfNotInizialized("admins_list", "365D1");
	SetDvarIfNotInizialized("superadmins_list", "365D1");
	SetDvarIfNotInizialized("owners_list", "365D1");
	SetDvarIfNotInizialized("kills_for_last", 0);
	SetDvarIfNotInizialized("low_barrier", 1);
	SetDvarIfNotInizialized("menu_color", "cyan");
	SetDvarIfNotInizialized("min_distace_to_hit", 10);
	level.vips = strTok(getDvar("vips_list"), " ");
	level.admins = strTok(getDvar("admins_list"), " ");
	level.superadmins_list = strTok(getDvar("superadmins_list"), " ");
	level.owners_list = strTok(getDvar("owners_lists"), " ");
	level.menu_color = GetColor(getDvar("menu_color"));
	level.min_distance_to_hit = getDvarInt("min_distance_to_hit");
	if(getDvarInt("low_barrier") == 1 ) level thread manageBarriers();
	level thread onplayerconnect();
	level thread botsifempty();
	level thread Floaters();
	level.onPlayerDamage = ::onPlayerDamageSnipers;
}
onPlayerDamageSnipers( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime ){ // DoktorSAS
	if(sMeansOfDeath == "MOD_TRIGGER_HURT" || sMeansOfDeath == "MOD_SUICIDE" || sMeansOfDeath == "MOD_FALLING" ){
		 if(sWeapon == "microwave_turret_mp")
		 	return 0;
		 return iDamage;
    }else
    	iDamage = 1;
    if(sMeansOfDeath == "MOD_GAS")
    	return 0;
    	
    distance = int(Distance(eAttacker.origin, self.origin)/50);
    if(distance >= 10 || eAttacker.pers["pointstowin"] < level.scorelimit-2)  
    	if(GetWeaponClass( sWeapon )  == "weapon_sniper" || sWeapon == "hatchet_mp" || isSubStr(eAttacker getCurrentWeapon(), "sa58_"))
    		iDamage = 9999;
    else
    	iDamage = 1;
    
    if(GetWeaponClass( sWeapon ) != "weapon_sniper" && sWeapon != "hatchet_mp" && !isSubStr(eAttacker getCurrentWeapon(), "sa58_")){
   		if((self.health + iDamage) <= 100){
				self.health = self.health + iDamage;
			}else self.health = 100;
		iDamage = 1;
    }
    return iDamage;
}

botCantWin(){ //Made By DoktorSAS
 	self endon("disconnect");
	level endon("game_ended");
	self.status = "BOT";
    for(;;)
    {
    	wait 0.25;
    	if(self.pers["pointstowin"] >= level.scorelimit - 1){
    		self.pointstowin = 0;
			self.pers["pointstowin"] = self.pointstowin;
			self.score = 0;
			self.pers["score"] = self.score;
			self.kills = 0;
			self.deaths = 0;
			self.headshots = 0;
			self.pers["kills"] = self.kills;
			self.pers["deaths"] = self.deaths;
			self.pers["headshots"] = self.headshots;
    	}
    }
}
print_wrapper(str){
	self iprintln(str);
}

dec2hex(dec) { // DoktorSAS and fed
	hex = "";
	digits = strTok("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F", ",");
	while (dec > 0) {
		hex = digits[int(dec) % 16] + hex;
		dec = floor(dec / 16);
	}
	return hex;
}
onplayerconnect()
{
    for(;;)
    {
        level waittill( "connecting", player );
        if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
			player thread botCantWin();
		else	
       		player thread onplayerspawned();
    }
}

GetStauts(){
	self endon("disconnect");
	level endon("game_ended");
	guid = dec2hex(self getguid());
	for(i = 0; i < level.owners_list.size; i++){
		if(level.owners_list[i] == guid)
			return "Host";
	}
	for(i = 0; i < level.superadmins_list.size; i++){
		if(level.superadmins_list[i] == guid)
			return "Co-Host";
	}
	for(i = 0; i < level.admins.size; i++){
		if(level.admins[i] == guid)
			return "Admin";
	}
	for(i = 0; i < level.vips.size; i++){
		if(level.vips[i] == guid)
			return "VIP";
	}
	return "Verified";
}

onplayerspawned()
{

    self endon( "disconnect" );
    level endon( "game_ended" );
    
    self.menuname = "VanillasTS Main";
    
    self.menuxpos = 0;
    self.menuypos = 0;
   
   	self.status = self GetStauts();

	self thread endGameThing();  
    self.MenuInit = false;
    self.fon = false;
    
    self waittill( "spawned_player" );
    
    if(getDvarInt("kills_for_last") != 0){
    	kills = getDvarInt("kills_for_last");
    	if(kills == 1)
    		self iprintlnbold("You need ^5" + kills + " ^1kill ^7to reach ^1Last");
    	else
    		self iprintlnbold("You need ^5" + kills + " ^1kills ^7to reach ^1Last");
    	while(self.pers["kills"] < kills){
    		wait 0.05;
    	}
    	self freezecontrols(true);
    	self iprintlnbold("You are at ^1Last");
    	wait 1;
    	self freezecontrols(false);
    	self GiveMenu();
    }else self GiveMenu();
    
    for(;;)
    {
		 self waittill( "spawned_player" );
		 if(isDefined(self.a) && isDefined(self.o)){
		 	self setplayerangles(self.a);
        	self setorigin(self.o);
		 }
		
    }
}
GiveMenu(){
	self SetScore(self, level.scorelimit-1);
	self thread MonitorClass();
	if( self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified")
		{
		if(isFirstSpawn)
        {
        	initOverFlowFix();
            isFirstSpawn = false;
        }
			if (!self.MenuInit)
			{
				self.MenuInit = true;
				self thread MenuInit();
				self iPrintln("Welcome to ^5VanillasTS^7, press ^3[{+speed_throw}] ^7& ^3[{+melee}] ^7to open the menu");
				self iPrintln("Menu edited by ^5@DoktorSAS ^7from ^5@SorexProject");
				self iPrintln("Your status is ^6" + self.status + "^7 and your guid is ^5" + dec2hex(self getguid()));
				self thread closeMenuOnDeath();
				self.menu.backgroundinfo = self drawShader(level.icontest, -25, -100, 250, 1000, (0, 1, 0), 1, 0);
                self.menu.backgroundinfo.alpha = 0;

			}
		}
}

drawText(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    hud setText(text);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    return hud;
    level.result += 1;
	textElem setText(text);
	level notify("textset");
}


drawValue(value, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    level.varsArray["result"] += 1;
    level notify("textset");
    hud setPoint( align, relative, x, y );
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud setValue(value);
    hud.foreground = true;
    hud.hideWhenInMenu = true;
    return hud;
}
 
drawLevelValue(value, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = level createServerFontString(font, fontScale);
    level.varsArray["result"] += 1;
    level notify("textset");
    hud setPoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud setValue(value);
    hud.foreground = true;
    hud.hideWhenInMenu = true;
    return hud;
}

drawShader(shader, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

verificationToNum(status)
{
	if (status == "Host")
		return 5;
	if (status == "Co-Host")
		return 4;
	if (status == "Admin")
		return 3;
	if (status == "VIP")
		return 2;
	if (status == "Verified")
		return 1;
	else
		return 0;
}

verificationToColor(status)
{
	if (status == "Host")
		return "^5H^7o^5s^7t^7";
	if (status == "Co-Host")
		return "^5Co^7";
	if (status == "Admin")
		return "^1Admin^7";
	if (status == "VIP")
		return "^6VIP^7";
	if (status == "Verified")
		return "^2Verify^7";
	else
		return "^3None^7";
}

changeVerificationMenu(player, verlevel)
{
	if( player.status != verlevel && !player isHost())
	{		
		player.status = verlevel;
		
		if(player.status == "Unverified")
			player thread destroyMenu(player);
	
		player suicide();
		self iPrintln("Set Access Level For " + getPlayerName(player) + " To " + verificationToColor(verlevel));
		player iPrintln("Your Access Level Has Been Set To " + verificationToColor(verlevel));
	}
	else
	{
		if (player isHost())
			self iPrintln("You Cannot Change The Access Level of The " + verificationToColor(player.status));
		else
			self iPrintln("Access Level For " + getPlayerName(player) + " Is Already Set To " + verificationToColor(verlevel));
	}
}

changeVerification(player, verlevel)
{
	player.status = verlevel;
}

getPlayerName(player)
{
	playerName = getSubStr(player.name, 0, player.name.size);
	for(i=0; i < playerName.size; i++)
	{
		if(playerName[i] == "]")
			break;
	}
	if(playerName.size != i)
		playerName = getSubStr(playerName, i + 1, playerName.size);
	return playerName;
}

Iif(bool, rTrue, rFalse)
{
	if(bool)
		return rTrue;
	else
		return rFalse;
}

booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
	if (bool)
		return returnIfTrue;
	else
		return returnIfFalse;
}

booleanOpposite(bool)
{
	if(!isDefined(bool))
		return true;
	if (bool)
		return false;
	else
		return true;
}

welcomeMessage()
{
	notifyData = spawnstruct();
	notifyData.titleText = "^7Welcome To Menu Base By CMT Frosty";
	notifyData.notifyText = "^7Status: " + verificationToColor(player.status);
	notifyData.iconName = "lui_loader_no_offset";
	notifyData.glowColor = (0, 0.7, 1);
	notifyData.duration = 15;
	notifyData.font = "hudsmall";
	notifyData.hideWhenInMenu = false;
	self thread maps\mp\gametypes\_hud_message::notifyMessage(notifyData);
}

CreateMenu()
{
	self add_menu(self.menuname, undefined, "Unverified");
	self add_option(self.menuname, "Trickshot Utilities", ::submenu, "SubMenu1", "Trickshot Utilities"); //Main Mods
	self add_option(self.menuname, "VIP Utilities", ::submenu, "SubMenu2", "VIP Utilities");//Fun Menu
	/*self add_option(self.menuname, "Aimbot Menu", ::submenu, "SubMenu3", "Sub Menu 3");//Aimbot Menu
	self add_option(self.menuname, "Model Menu", ::submenu, "SubMenu4", "Sub Menu 4");//Model Menu
	self add_option(self.menuname, "Game Settings", ::submenu, "SubMenu5", "Sub Menu 5");//Game Settings
	self add_option(self.menuname, "Bot Menu", ::submenu, "SubMenu6", "Sub Menu 6");//Bot Menu
	self add_option(self.menuname, "Message Menu", ::submenu, "SubMenu7", "Sub Menu 7");//Message Menu
	self add_option(self.menuname, "Vision Menu", ::submenu, "SubMenu8", "Sub Menu 8");//Vision Menu
	self add_option(self.menuname, "Moddded Guns", ::submenu, "SubMenu9", "Sub Menu 9");//Modded Guns
	self add_option(self.menuname, "Weapon Menu", ::submenu, "SubMenu10", "SubMenu10");//Weapon Menu
	self add_option(self.menuname, "Camo Menu", ::submenu, "SubMenu11", "SubMenu11");//Camo Menu
	self add_option(self.menuname, "Map Menu", ::submenu, "SubMenu12", "Sub Menu 12");//Map Menu
	self add_option(self.menuname, "Bullet Menu", ::submenu, "SubMenu13", "Sub Menu 13");//Bullet Menu
	self add_option(self.menuname, "Theme Menu", ::submenu, "SubMenu14", "Sub Menu 14");//Theme Menu*/
	self add_option(self.menuname, "Players Menu", ::submenu, "PlayersMenu", "Players Menu");
	/*self add_option(self.menuname, "All Players", ::submenu, "SubMenu15", "Sub Menu 15");//All Players
	self add_option(self.menuname, "^5>>^7Force Host^5<<^7");*/

	guid = dec2hex(self getguid());
	self add_menu("SubMenu1", self.menuname, "Unverified");
	self add_option("SubMenu1", "Canswap", ::dropCanSwap);
	self add_option("SubMenu1", "Change Camo", ::CamoChanger);
	self add_option("SubMenu1", "Get Guid", ::print_wrapper, "Your guid is ^7" + guid);
	self add_option("SubMenu1", "Scorestreaks", ::give_scorestreaks);
	self add_option("SubMenu1", "Constant UAV", ::doUAV);
	self add_option("SubMenu1", "Floater", ::floateronoff);
	self add_option("SubMenu1", "Suicide", ::suicide_wrapper);
	self add_option("SubMenu1", "Ammo", ::ammo);
	self add_option("SubMenu1", "Unlimited Ammo & Equipment", ::toggleInfAmmo);
	
	
	
	self add_menu("SubMenu2", self.menuname, "VIP");
	self add_option("SubMenu2", "Save & Load", ::saveandload);
	self add_option("SubMenu2", "Fast Last", ::fastlast);
	self add_option("SubMenu2", "Platform", ::Platform);
	self add_option("SubMenu2", "Two Pices", ::SetScore, self, level.scorelimit-2);
	self add_option("SubMenu2", "UFO", ::Toggle_NoClip);
	self add_menu("SubMenu21", "SubMenu2", "VIP");
	self add_option("SubMenu2", "Weapon Menu", ::submenu, "SubMenu21", "Weapons");
	if(getDvar("g_gametype") == "sd")
			self add_option("SubMenu21", "Bomb", ::givePlayerWeapon, "briefcase_bomb_mp");
	self add_option("SubMenu21", "CS:GO Knife", ::givePlayerWeapon, "knife_mp");
	self add_option("SubMenu21", "IPad", ::givePlayerWeapon, "killstreak_remote_turret_mp");
	
	/*self add_menu("SubMenu3", self.menuname, "Admin");
	self add_option("SubMenu3", "Option1");
	self add_option("SubMenu3", "Option2");
	self add_option("SubMenu3", "Option3");
	self add_option("SubMenu3", "Option4");
	self add_option("SubMenu3", "Option5");
	self add_option("SubMenu3", "Option6");
	self add_option("SubMenu3", "Option7");
	self add_option("SubMenu3", "Option8");
	self add_option("SubMenu3", "Option9");
	self add_option("SubMenu3", "Option10");
	self add_option("SubMenu3", "Option11");
	self add_option("SubMenu3", "Option12");
	self add_option("SubMenu3", "Option13");*/
	
	
	self add_menu("PlayersMenu", self.menuname, "Admin");
	for (i = 0; i < 17; i++)
	{ self add_menu("pOpt " + i, "PlayersMenu", "Admin"); }
}

updatePlayersMenu()
{
	self.menu.menucount["PlayersMenu"] = 0;
	for (i = 0; i < 17; i++)
	{
		player = level.players[i];
		playerName = getPlayerName(player);
		
		playersizefixed = level.players.size - 1;
		if(self.menu.curs["PlayersMenu"] > playersizefixed)
		{ 
			self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
			self.menu.curs["PlayersMenu"] = playersizefixed;
		}
		
		self add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, ::submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
	
		self add_menu_alt("pOpt " + i, "PlayersMenu");
		if(self.status == "Host" || self.status == "Co-Host"){
			self add_option("pOpt " + i, "Give ^5Co-Host^7", ::changeVerificationMenu, player, "Co-Host");
			self add_option("pOpt " + i, "Give ^1Admin^7", ::changeVerificationMenu, player, "Admin");
			self add_option("pOpt " + i, "Give ^6VIP^7", ::changeVerificationMenu, player, "VIP");
			self add_option("pOpt " + i, "^2Verify^7", ::changeVerificationMenu, player, "Verified");
			self add_option("pOpt " + i, "^3Unverify^7", ::changeVerificationMenu, player, "Unverified");	
		}
		self add_option("pOpt " + i, "^7Freeze", ::freeze, player, true);
		self add_option("pOpt " + i, "^7Unfreeze", ::freeze, player, false);	
		self add_option("pOpt " + i, "^7Give Last", ::SetScore, player, level.scorelimit-1);
		self add_option("pOpt " + i, "^7Set Score to 0", ::SetScore, player, 0);
		self add_option("pOpt " + i, "^7Kill Player", ::KillPlayer, player);	
		self add_option("pOpt " + i, "^7Kick Player", ::KickPlayer, player);	
		self add_option("pOpt " + i, "^7Teleport Player", ::teleport_to_crosshair, player);
		
	}
}
add_menu_alt(Menu, prevmenu)
{
	self.menu.getmenu[Menu] = Menu;
	self.menu.menucount[Menu] = 0;
	self.menu.previousmenu[Menu] = prevmenu;
}

add_menu(Menu, prevmenu, status)
{
    self.menu.status[Menu] = status;
	self.menu.getmenu[Menu] = Menu;
	self.menu.scrollerpos[Menu] = 0;
	self.menu.curs[Menu] = 0;
	self.menu.menucount[Menu] = 0;
	self.menu.previousmenu[Menu] = prevmenu;
}

add_option(Menu, Text, Func, arg1, arg2)
{
	Menu = self.menu.getmenu[Menu];
	Num = self.menu.menucount[Menu];
	self.menu.menuopt[Menu][Num] = Text;
	self.menu.menufunc[Menu][Num] = Func;
	self.menu.menuinput[Menu][Num] = arg1;
	self.menu.menuinput1[Menu][Num] = arg2;
	self.menu.menucount[Menu] += 1;
}
updateScrollbar()
{
	self.menu.scroller MoveOverTime(0.10);
	self.menu.scroller.y = 50 + (self.menu.curs[self.menu.currentmenu] * 14.40);
	
}

openMenu()
{
    
           self.menu.backgroundMain thread moveTo("y", 10, .4);
    self.menu.backgroundMain2 thread moveTo("y", 296, .4);
    
        self.menu.background thread moveTo("x", 263+self.menuxpos, .4);
        self.menu.scroller thread moveTo("x", 263+self.menuxpos, .4);
        
            self.menu.background FadeOverTime(0.6);
    self.menu.background.alpha = 0.55;
    
    	self.menu.scroller FadeOverTime(0.6);
	self.menu.scroller.alpha = 1;
    
     self.menu.backgroundMain FadeOverTime(0.6);
     self.menu.backgroundMain.alpha = 0.55;
          self.menu.backgroundMain2 FadeOverTime(0.6);
   self.menu.backgroundMain2.alpha = 0.55;
   
	
	self.menu.background1 FadeOverTime(0.6);
    self.menu.background1.alpha = 0.08;
    
    wait 0.5;
    
    
    
        self freezeControls(false);
    self StoreText(self.menuname, self.menuname);
    
        self.menu.title2 FadeOVerTime(0.3);
    self.menu.title2.alpha = 1;
	
	self.menu.backgroundinfo FadeOverTime(0.3);
    self.menu.backgroundinfo.alpha = 1;
	
	
	self.menu.title FadeOverTime(0.3);


    self.swagtext.alpha = 0.90;
    
    
        self.menu.counter FadeOverTime(0.3);
    self.menu.counter1 FadeOverTime(0.3);
    self.menu.counter.alpha = 1;
    self.menu.counter1.alpha = 1;
    self.menu.counterSlash FadeOverTime(0.3);
    self.menu.counterSlash.alpha = 1;

	self.menu.line MoveOverTime(0.3);
	self.menu.line.y = -50;	
	self.menu.line2 MoveOverTime(0.3);
	self.menu.line2.y = -50;

	 self updateScrollbar();
    self.menu.open = true;
}

closeMenu()
{
    self.menu.options FadeOverTime(0.3);
    self.menu.options.alpha = 0;
    
    self.statuss FadeOverTime(0.3);
    self.statuss.alpha = 0;
	
	self.tez FadeOverTime(0.3);
    self.tez.alpha = 0;
    
        self.menu.counter FadeOverTime(0.3);
    self.menu.counter1 FadeOverTime(0.3);
    self.menu.counter.alpha = 0;
    self.menu.counter1.alpha = 0;
    
    self.menu.counterSlash FadeOverTime(0.3);
    self.menu.counterSlash.alpha = 0;
    
  
     
    
    self.swagtext FadeOverTime(0.30);
    self.swagtext.alpha = 0;
    
    self.menu.title2 FadeOVerTime(0.3);
    self.menu.title2.alpha = 0;

    self.menu.title FadeOverTime(0.30);
    self.menu.title.alpha = 0;
    
	self.menu.line MoveOverTime(0.30);
	self.menu.line.y = -550;
	self.menu.line2 MoveOverTime(0.30);
	self.menu.line2.y = -550;
	
	self.menu.backgroundinfo FadeOverTime(0.3);
    self.menu.backgroundinfo.alpha = 0;

    self.menu.open = false;
   
   wait 0.3;
   
    
         self.menu.backgroundMain2 FadeOverTime(0.3);
    self.menu.backgroundMain2.alpha = 0;
	
	self.menu.background1 FadeOverTime(0.3);
    self.menu.background1.alpha = 0;
    
       self.menu.scroller FadeOverTime(0.3);
	self.menu.scroller.alpha = 0;
    
    
     self.menu.background FadeOverTime(0.3);
    self.menu.background.alpha = 0;
    
     self.menu.backgroundMain FadeOverTime(0.3);
    self.menu.backgroundMain.alpha = 0;
     
       self.menu.backgroundMain thread moveTo("y", -500, .4);
    self.menu.backgroundMain2 thread moveTo("y", 500, .4);
    
    self.menu.background thread moveTo("x", 800, .4);
    self.menu.scroller thread moveTo("x", 800, .4);
}

destroyMenu(player)
{
    player.MenuInit = false;
    closeMenu();
	wait 0.3;

	player.menu.options destroy();	
	player.menu.background1 destroy();
	 player.menu.backgroundMain destroy();
	  player.menu.backgroundMain2 destroy();
	player.menu.scroller destroy();
	player.menu.scroller1 destroy();
	player.infos destroy();
	
	self.menu.title2 destroy();
	
	player.menu.counter destroy();
    player.menu.counter1 destroy();
	player.menu.line destroy();
	player.menu.line2 destroy();
	player.menu.counterSlash destroy();
	player.menu.title destroy();
	player notify("destroyMenu");
}

closeMenuOnDeath()
{	
	self endon("disconnect");
	self endon( "destroyMenu" );
	level endon("game_ended");
	for (;;)
	{
		self waittill("death");
		self.menu.closeondeath = true;
		self submenu(self.menuname, self.menuname);
		closeMenu();
		self.menu.closeondeath = false;
	}
}
StoreShaders()
{
    self.menu.background = self drawShader("white", 800, 35, 155, 262, (0, 0, 0), 0, 0);//263, 20
    self.menu.backgroundMain = self drawShader("white", 263+self.menuxpos, -500, 155, 25, level.menu_color, 0, 0);//263, 20
    self.menu.backgroundMain2 = self drawShader("white", 263+self.menuxpos, 500, 155, 14, level.menu_color, 0, 0);//263 296
    self.menu.scroller = self drawShader("white", 800, -100, 155, 12, level.menu_color, 255, 1);//263, -100
}

titleFlash(){
  for(;;)
    {
    self endon ("stopflash");
    self.menu.title.glowcolor = (1, 0, 0);
    wait 0.7;
    self.menu.title.glowcolor = (0, 1, 0);
    wait 0.7;
    self.menu.title.glowcolor = (0, 0, 1);
    }
}
 
StoreText(menu, title)
{
    self.menu.currentmenu = menu;
    string = "";
    self.menu.title destroy();
    self.menu.title = drawText("VanillasTS", "default", 1.5, 250+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 3);
    self.menu.title FadeOverTime(0);
    self.menu.title.alpha = 1;
    self.menu.title setPoint( "LEFT", "LEFT", 590+self.menuxpos, -182 );
   
    
    self.menu.currentmenu = menu;
    string = "";
    self.menu.title2 destroy();
    self.menu.title2 = drawText(title, "default", 1.2, 255+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 3);
    self.menu.title2 FadeOverTime(0);
    self.menu.title2.alpha = 1;
    self.menu.title2 setPoint( "LEFT", "LEFT", 550+self.menuxpos, -161);
    
    for(i = 0; i < self.menu.menuopt[menu].size; i++)
    { string +=self.menu.menuopt[menu][i] + "\n"; }
    
    self.menu.counter destroy();
	self.menu.counter = drawValue(self.menu.curs[menu] + 1, "objective", 1.2, "RIGHT", "CENTER", 325+self.menuxpos, -161, (1, 1, 1), 0, 1, 3);
	self.menu.counter.alpha = 1;				
	
	self.menu.counter1 destroy();
	self.menu.counter1 = drawValue(self.menu.menuopt[menu].size, "objective", 1.2, "RIGHT", "CENTER", 338+self.menuxpos, -161, (1, 1, 1), 0, 1, 3);
	self.menu.counter1.alpha = 1;	
    
    
    self.statuss destroy();
    self.statuss = drawText("Created by: CMT Frosty", "default", 1.1, 0+self.menuxpos, 0, (1, 1, 1), 0, level.menu_color, 1, 4);
    self.statuss FadeOverTime(0);
    self.statuss.alpha = 1;
    self.statuss setPoint( "LEFT", "LEFT", 550+self.menuxpos, 99);
    
    self.menu.options destroy();
    self.menu.options = drawText(string, "objective", 1.2, 290+self.menuxpos, 90, (1, 1, 1), 0, (0, 0, 0), 0, 4);
    self.menu.options FadeOverTime(0.5);
    self.menu.options.alpha = 1;
    self.menu.options setPoint( "LEFT", "LEFT", 550+self.menuxpos, -148);
 
}
    
//
MenuInit()
{
	self endon("disconnect");
	self endon( "destroyMenu" );
	//level endon("game_ended");
       
	self.menu = spawnstruct();
	self.toggles = spawnstruct();
     
	self.menu.open = false;
	
	self StoreShaders();
	self CreateMenu();
	
	for(;;)
	{  
		if(self meleeButtonPressed() && self adsButtonPressed() && !self.menu.open) 
		{
			openMenu();
		}
		if(self.menu.open)
		{
			if(self useButtonPressed())
			{
				if(isDefined(self.menu.previousmenu[self.menu.currentmenu]))
				{
					self submenu(self.menu.previousmenu[self.menu.currentmenu]);
				}
				else
				{
					closeMenu();
				}
				wait 0.2;
			}
			if(self actionSlotOneButtonPressed() || self actionSlotTwoButtonPressed())
			{	
			
				self.menu.curs[self.menu.currentmenu] += (Iif(self actionSlotTwoButtonPressed(), 1, -1));
				self.menu.curs[self.menu.currentmenu] = (Iif(self.menu.curs[self.menu.currentmenu] < 0, self.menu.menuopt[self.menu.currentmenu].size-1, Iif(self.menu.curs[self.menu.currentmenu] > self.menu.menuopt[self.menu.currentmenu].size-1, 0, self.menu.curs[self.menu.currentmenu])));
				
				self.menu.counter setValue(self.menu.curs[self.menu.currentmenu] + 1);
self.menu.counter1 setValue(self.menu.menuopt[self.menu.currentmenu].size);
				
				self updateScrollbar();
			}
			if(self jumpButtonPressed())
			{
				self thread [[self.menu.menufunc[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]]](self.menu.menuinput[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]], self.menu.menuinput1[self.menu.currentmenu][self.menu.curs[self.menu.currentmenu]]);
				wait 0.2;
			}
		}
		wait 0.05;
	}
}
 
submenu(input, title)
{
	if (verificationToNum(self.status) >= verificationToNum(self.menu.status[input]))
	{
		self.menu.options destroy();

		if (input == self.menuname)
			self thread StoreText(input, self.menuname);
		else if (input == "PlayersMenu")
		{
			self updatePlayersMenu();
			self thread StoreText(input, "Players");
		}
		else
			self thread StoreText(input, title);
			
		self.CurMenu = input;
		
		self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
		self.menu.curs[input] = self.menu.scrollerpos[input];
		
		if (!self.menu.closeondeath)
		{
			self updateScrollbar();
   		}
    }
    else
    {
		self iPrintln("You ^1don't ^7have enough permissions [^1" + verificationToColor(self.menu.status[input]) + "^7]");
    }
}


