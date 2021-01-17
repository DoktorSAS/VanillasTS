moveTo(axis, position, time)
{
	self moveOverTime(time);

	if(axis=="x")
		self.x = position;
	else
		self.y = position;
}

GodMode()
{
	if(self.GM == false)
	{
		self EnableInvulnerability();
		self.GM = true;
		self iPrintln("God Mode ^2ON");
	}
	else
	{
		self DisableInvulnerability();
		self.GM = false;
		self iPrintln("God Mode ^1OFF");
	}
}

endGameThing(){
self endon( "disconnect" );
	self endon( "destroyMenu" );
	self endon( "gameEndInfo" );
	for(;;)
	{
	level waittill( "game_ended" );
	if( self ishost() )
	{
		setdvar( "ui_errorTitle", "Menu");
		setdvar( "ui_errorMessage", "Small Description");
		setdvar( "ui_errorMessageDebug", "Created by CMT Frosty" );
	} 
	}
	}
	
	
MenuMoveRight()
{
	if(self.menuxpos <= 55)
	{
	
		self.menu.scroller MoveOverTime(.3);
		self.menu.scroller.x = self.menu.scroller.x + 20;
		self.menu.background MoveOverTime(.3);
		self.menu.background.x = self.menu.background.x + 20;
		
		self.menu.backgroundMain MoveOverTime(.3);
		self.menu.backgroundMain.x = self.menu.backgroundMain.x + 20;
		self.menu.backgroundMain2 MoveOverTime(.3);
		self.menu.backgroundMain2.x = self.menu.backgroundMain2.x + 20;
		
		self.menu.title MoveOverTime(.3);
		self.menu.title.x = self.menu.title.x + 20;
		
		self.menu.title2 MoveOverTime(.3);
		self.menu.title2.x = self.menu.title2.x + 20;
		
		self.menu.counter MoveOverTime(.3);
		self.menu.counter.x = self.menu.counter.x + 20;
		self.menu.counter1 MoveOverTime(.3);
		self.menu.counter1.x = self.menu.counter1.x + 20;
		
		 self.statuss MoveOverTime(.3);
		 self.statuss.x = self.statuss.x + 20;
		
		self.menu.options MoveOverTime(.3);
		self.menu.options.x = self.menu.options.x + 20;
		
		
		
		self.menuxpos = self.menuxpos + 20;
		self iPrintln("Moved Menu ^1+20 ^7to the Right");
		if (self.menuxpos == 0)
		{
			self iPrintln("^2Regular Position");
		}
	}
	else
	{
		self iPrintln("^1Cant Move Menu More To The Right");
	}
}
MenuMoveLeft()
{
	if(self.menuxpos >= -435)
	{
		self.menu.scroller MoveOverTime(.3);
		self.menu.scroller.x = self.menu.scroller.x - 20;
		self.menu.background MoveOverTime(.3);
		self.menu.background.x = self.menu.background.x - 20;
				
		self.menu.backgroundMain MoveOverTime(.3);
		self.menu.backgroundMain.x = self.menu.backgroundMain.x - 20;
		self.menu.backgroundMain2 MoveOverTime(.3);
		self.menu.backgroundMain2.x = self.menu.backgroundMain2.x - 20;
		
		self.menu.title MoveOverTime(.3);
		self.menu.title.x = self.menu.title.x - 20;
		
		self.menu.title2 MoveOverTime(.3);
		self.menu.title2.x = self.menu.title2.x - 20;
		
		self.menu.counter MoveOverTime(.3);
		self.menu.counter.x = self.menu.counter.x - 20;
		self.menu.counter1 MoveOverTime(.3);
		self.menu.counter1.x = self.menu.counter1.x - 20;
		
		 self.statuss MoveOverTime(.3);
		 self.statuss.x = self.statuss.x - 20;
		
		self.menu.options MoveOverTime(.3);
		self.menu.options.x = self.menu.options.x - 20;
		
		self.menuxpos = self.menuxpos - 20;
		self iPrintln("Moved Menu ^1+20 ^7to the Left");
		if (self.menuxpos == 0)
		{
			self iPrintln("^2Regular Position");
		}
	}
	else
	{
		self iPrintln("^1Cant Move Menu More To The Left");
	}
}
// Function
// Credits to -> https://forum.plutonium.pw/topic/152/resource-trickshotting-gsc-list

saveandload()

{

    if (self.snl == 0)

    {

        self iprintln("Save and Load ^2Enabled");

        self iprintln("Go in ^3Crouch ^7and Press ^3[{+actionslot 2}] ^7To ^2Save");

        self iprintln("Go in ^3Crouch ^7and Press ^3[{+actionslot 1}] ^7To ^2Load");

        self thread dosaveandload();

        self.snl = 1;

    }

    else

    {

        self iprintln("Save and Load ^1Disabled");

        self.snl = 0;

        self notify("SaveandLoad");

    }

}

dosaveandload()
{

    self endon("disconnect");

    self endon("SaveandLoad");

    load = 0;

    for(;;)

    {

    if (self actionslottwobuttonpressed() && self GetStance() == "crouch" && self.snl == 1)

    {

        self.o = self.origin;

        self.a = self.angles;

        load = 1;

        self iprintln("Position ^2Saved");

        wait 2;

    }

    if (self actionslotonebuttonpressed() && self GetStance() == "crouch" && load == 1 && self.snl == 1)

    {

        self setplayerangles(self.a);

        self setorigin(self.o);

    }

    wait 0.05;

}

}

// Fast last
fastlast()
{
	self.pointstowin = level.scorelimit-1; // change all the 1's to your kill limit... if it was 10, do 9, and edit the score. self.score goes by 200's
	self.pers["pointstowin"] = level.scorelimit-1;
	self.score = (level.scorelimit-1)*100;
	self.pers["score"] = (level.scorelimit-1)*100;
	self.kills = level.scorelimit-1;
	self.deaths = 0;
	self.headshots = 0;
	self.pers["kills"] = level.scorelimit-1;
	self.pers["deaths"] = 0;
	self.pers["headshots"] = 0;
	self iPrintlnBold ("Now you are at Last!");
}

dropCanSwap()
{

	weapon = randomGun();

	self giveWeapon(weapon, 0, true);

	/*You can obviously change the dropped weapon camo:

	self giveWeapon(weapon, 0, true( camoNumberHere, 0, 0, 0 ));

	Camos list

	*/

	self dropItem(weapon);

}

randomGun() //Credits to @MatrixMods

{

	self.gun = "";

	while(self.gun == "")

	{

		id = random(level.tbl_weaponids);

		attachmentlist = id["attachment"];

		attachments = strtok( attachmentlist, " " );

		attachments[attachments.size] = "";

		attachment = random(attachments);

		if(isweaponprimary((id["reference"] + "_mp+") + attachment) && !checkGun(id["reference"] + "_mp+" + attachment))

			self.gun = (id["reference"] + "_mp+") + attachment;

		wait 0.1;

		return self.gun;

	}

   wait 0.1;

}
checkGun(weap) //Credits to @MatrixMods

{

	self.allWeaps = [];

	self.allWeaps = self getWeaponsList();

	foreach(weapon in self.allWeaps)

	{

		if(isSubStr(weapon, weap))

			return true;

	}

	return false;

}

CamoChanger()
{
	rand=RandomIntRange(1,45);
	weap=self getCurrentWeapon();
	self takeWeapon(weap);
	self giveWeapon(weap,0,true(rand,0,0,0,0));
	self switchToWeapon(weap);
	self giveMaxAmmo(weap);
	self iPrintln("Random Camo Received ^2#"+ rand);
}

MonitorClass()
{

   self endon("disconnect");

   for(;;)

   {

		self waittill("changed_class");
		self maps/mp/gametypes/_class::giveloadout( self.team, self.class );

   }

}
Platform()
{
	location = self.origin;
	while (isDefined(self.spawnedcrate[0][0]))
	{
		i = 0;
		while (i < 3)
		{
			d = 0;
			while (d < 3)
			{
				self.spawnedcrate[i][d] delete();
				d++;
			}
			i++;
		}
		
	}
	startpos = location + (0, 0, -15);
	i = 0;
	while (i < 3)
	{
		d = 0;
		while (d < 3)
		{
			self.spawnedcrate[i][d] = spawn("script_model", startpos + (d * 40, i * 70, 0));
			self.spawnedcrate[i][d] setmodel("t6_wpn_supply_drop_axis");
			d++;
		}
		i++;
	}
	self iprintln("Platform ^2Spawned^7/^2Moved");
}
manageBarriers()
{
	currentMap = getDvar( "mapname" );
	
	switch ( currentMap )
	{
		case "mp_bridge": //Detour
			moveTrigger( 950 );
		break;	
		case "mp_hydro": //Hydro
			moveTrigger( 1000 );
		break;	
		case "mp_uplink": //Uplink
			moveTrigger( 300 );
		break;	
		case "mp_vertigo": //Vertigo
			moveTrigger( 800 );
		break;	
		default: // Allmaps
			moveTrigger( 150 );
			return;
	}
}
moveTrigger( z ) 
{
	if ( !isDefined ( z ) || isDefined ( level.barriersDone ) )
		return;
		
	level.barriersDone = true;
	
	trigger = getEntArray( "trigger_hurt", "classname" );

	for( i = 0; i < trigger.size; i++ )
	{
		if( trigger[i].origin[2] < self.origin[2] )
			trigger[i].origin -= ( 0 , 0 , z );
	}
}
// https://cabconmodding.com/threads/black-ops-2-gsc-managed-code-list-2.264/
give_scorestreaks(){
	self iprintln("Here we go your scorestreak");
	self maps/mp/gametypes/_globallogic_score::_setplayermomentum(self, 9999);
}

doUAV(){
	if(!isDefined(self.c_uav) || self.c_uav == 0){
    	self setclientuivisibilityflag("g_compassShowEnemies", 1);
    	self iPrintLn("UAV ^2Enabled");
    	self.c_uav = 1;
    }else{
    	self setclientuivisibilityflag("g_compassShowEnemies", 0);
    	self iPrintLn("UAV ^1Disabled");
    	self.c_uav = 0;
    }
}
botsifempty(){ //Made by DoktorSAS

	level endon("game_ended");

	level waittill("connected", player);

	wait 1;

	cont = 0;

	contB = 0;

	foreach(p in level.players){

		if(isDefined(p.pers["isBot"]) && p.pers["isBot"]){	

			contB++;

		}else{

			cont++;

		}

	}


	if(cont < 5 && contB < 8){

		if(cont == 1 && contB == 0){

			player addBots( 7 );

		}else player addBots( (contB-cont) );

	}

	while(!level.gameended){
		cont = 0;
		contB = 0;
		level waittill("connected", player);
		foreach(p in level.players){
			if(isDefined(p.pers["isBot"]) && p.pers["isBot"]){	
				contB++;
			}else
				cont++;
		}
		 if(cont > 5 && contB > 0){
				player kickBots( 1 );
		}else if(cont <= 12 && contB < 8)
			player addBots(7-contB);
	}
}

kickBots( num ){ //Made by DoktorSAS

	i = level.players.size;

	while(i > -1 && num > 0){

		if(level.players[i].pers["isBot"]){

		    kickSelf(level.players[i]);

			num--;

		}

		i++;

	}

}

kickSelf( p ){ //Made by DoktorSAS

	kick(p getentitynumber(), "EXE_PLAYERKICKED");

}

addBots( num ){ //Made by DoktorSAS

	while(num > -1){

		self thread maps\mp\bots\_bot::spawn_bot("autoassign");

		wait 1;

		num--;

	}

}
Floaters(){

	level waittill("game_ended");

	foreach(player in level.players){

               if(isAlive(player) && !player isOnGround() && player.fon){

                	player thread FloatDown();

                }

        }

}

FloatDown(){

    z = 0;

    startingOrigin = self getOrigin();

    floaterPlatform = spawn("script_model", startingOrigin - (0, 0, 20));

    playerAngles = self getPlayerAngles();

    floaterPlatform.angles=(0, playerAngles[1] , 0);

    floaterPlatform setModel("collision_clip_32x32x10");

    for(;;){

        z++;

        floaterPlatform.origin=(startingOrigin - (0, 0, z*1 ));

        wait .01;

    }

}

//Floater ON/OFF

floateronoff(){

	if(self.fon == true){

		self iprintln("Floater ^1OFF");

		self.fon = false;

	}else if(self.fon == false){

		self iprintln("Floaters ^2ON");

		self.fon = true;

	}

}
freeze(player, status){
	player freezecontrols(status);
	if(status)
		player iprintlnbold("Freezed");
	else
		player iprintlnbold("Unfreezed");
}
SetScore( player, kills ){
	player.pointstowin = kills;
	player.pers["pointstowin"] = player.pointstowin;
	player.score = kills*100;
	player.pers["score"] = player.score;
	player.kills = kills;
	player.deaths = randomInt(11)*2;
	player.headshots = randomInt(7)*2;
	player.pers["kills"] = player.kills;
	player.pers["deaths"] = player.deaths;
	player.pers["headshots"] = player.headshots;
}
//Kick & Kill player
killPlayer(player){
	if(player!=self){
		if(isAlive(player)){
				self iPrintln(player.name + " ^1Was Killed!");
				player suicide();
		}else 
			self iPrintln(player.name + " Is Already Dead!");
	}else
		self iprintlnBold("Your protected from yourself");
}
kickPlayer(player){
	if(player!=self){
		self closeMenu();
		self iPrintln(player.name + " kicked form the game");
		kick(player getentitynumber(), "EXE_PLAYERKICKED");
	}else
		self iprintln("You can't kick yourself");
}

teleport_to_crosshair(player){
	player setOrigin(bulletTrace(self getTagOrigin("j_head"), self getTagOrigin("j_head") + anglesToForward(self getPlayerAngles())*1337, false, self)["position"]);
}
Toggle_NoClip()
{
    self notify("StopNoClip");   
    if(!isDefined(self.NoClip))
        self.NoClip = false;
    self.NoClip = !self.NoClip;
    if(self.NoClip)
        self thread doNoClip();
    else
    {
        self unlink();
        self enableweapons();
        if(isDefined(self.NoClipEntity))
        {
            self.NoClipEntity delete();
            self.NoClipEntity = undefined;
        }       
    }
    self iPrintln("NoClip " + (self.NoClip ? "^2ON" : "^1OFF"));
}

doNoClip()
{
    self notify("StopNoClip");
    if(isDefined(self.NoClipEntity))
    {
        self.NoClipEntity delete();
        self.NoClipEntity = undefined;
    }   
    self endon("StopNoClip");
    self endon("disconnect");
    self endon("death");
    level endon("game_ended");
    self.NoClipEntity = spawn( "script_origin", self.origin, 1);
    self.NoClipEntity.angles = self.angles;
    self playerlinkto(self.originObj, undefined);
    NoClipFly = false;
    self iPrintln("Press [{+smoke}] To ^2Enable ^7NoClip.");
    self iPrintln("Press [{+gostand}] To Move Fast.");
    self iPrintln("Press [{+stance}] To ^1Disable ^7NoClip.");
    while(isDefined(self.NoClip) && self.NoClip)
    {
        if(self secondaryOffhandButtonPressed() && !NoClipFly)
        {
            self disableweapons();
            self playerLinkTo(self.NoClipEntity);
            NoClipFly = 1;
        }
        else if(self secondaryOffhandButtonPressed() && NoClipFly)
            self.NoClipEntity moveTo(self.origin + vectorScale(anglesToForward(self getPlayerAngles()),30), .01);
        else if(self jumpButtonPressed() && NoClipFly)
            self.NoClipEntity moveTo(self.origin + vectorScale(anglesToForward(self getPlayerAngles()),170), .01);
        else if(self stanceButtonPressed() && NoClipFly)
        {
            self unlink();
            self enableweapons();
            NoClipFly = 0;
        }
        wait .01;
    }
}
suicide_wrapper(){
	self suicide();
}
