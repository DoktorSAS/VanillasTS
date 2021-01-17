# **VanillasTS Menu** 
Given the increase of users in this period I decided to make a small gift to the community. This menu is a very simple menu for a Vanilla Trickshot server. Everything is configurable through the cfg file. Just set the information in the cfg and everything will work properly.  

The menu is based on the [CMT Frosty menu base](https://www.youtube.com/watch?v=OuLzsMBD0Ds&t=48s). A very nice and very simple menu. Eevery code in the menu can be found online. You can find all these codes on the forums, including the Plutonium forum. Making a mod in GSC for Black ops II takes a few minutes. Practically everything can be found online.

####  **VanillasTS Features** 
The server is equipped with many of the basic features, and is also equipped with a system for the management of rank that does not imply the recompilation of the mod. In fact just edit the cfg to give or remove a rank. 

- Custom Ranks 
- Players Menu for High Ranks Users
- Bots if empty
- Give Scorestreaks
- Constant UAV ON/OFF
- Floaters ON/OFF
- Sucide
- Fast Last for vips
- Platform for vips
- Save and load for vips
- UFO for vips

### Preview

![VanillasTS](https://forum.plutonium.pw/assets/uploads/files/1610888207311-f9e72f55-4f90-418b-a74f-9267b758a09d-image.png) 

# **How to use it**
The menu is very simple to configure in fact you'll just have to download the file [_clientids.gsc](https://github.com/DoktorSAS/VanillasTS/blob/main/_clientids.gsc?raw=true) and put it in *BlackOps2ServerFolder\t6r\data\maps\mp\gametypes\\*.
After that you just have to add to your dedicated.cfg the following lines of code.  If you want to modify it you can download the [source code](https://github.com/DoktorSAS/VanillasTS) and do whatever you want with it. 

#### What to add to dedicated.cfg?
Add these lines of code and you're done, you don't even need to recompile the code.
```cfg
////////////////////////////////////////////////////////////////////////////////////////////////////
//  DoktorSAS VanillasTS Trickshot Menu
//  Twitter: @DoktorSAS
//  Report any bugs under the right post on the forum
////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////
//                                                                    
// List of valid colors:                                      
//                                                                  
/////////////////////////////////////////////////////
//    1. "red"                                                 
//    2. "orange"                                            
//    3. "yellow"                                              
//    4. "purple"                                              
//    5. "pink"                                                
//    6. "cyan"                                                
//    7. "blue"                                                 
//    8. "light blue"                                     
//    9. "green"                                                
//    10. "light green"                                       
//    11. "black"    
//    12. "white"                                          
/////////////////////////////////////////////////////

set menu_color "cyan"

/////////////////////////////////////////////////////
//  To set a player rank just add the GUID of the players                                                                   
//   in the right dvar, the remember to add a space                                 
//    between each guid or it will not work                                                              
/////////////////////////////////////////////////////

// exemple -> set vips_list "GUID1 GUID2 GUID3" 
set vips_list ""
set admins_list ""
set superadmins_list ""
set owners_list ""

set min_distance_to_hit 10 // Min distance in meters to hit a shot
set low_barrier 1 // 1 for low barriers and 0 for now lower barriers
set kills_for_last 5 // Kills needed to be at last, with 0 player will be set instant to last

```

### **Direct Download VanillasTS**
Press on [this](https://github.com/DoktorSAS/VanillasTS/blob/main/_clientids.gsc?raw=true) to download the VanillasTS

### **Source Code VanillasTS**
Press on [this](https://github.com/DoktorSAS/VanillasTS) to download the VanillasTS Source Code


### **Suggestions or Bugs**
If you want anything added or if you find any bugs please write under this post. I'll fix all the bugs and if the proposed suggestions are valid I'll implement your suggestions too.
