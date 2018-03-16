return --[[ This is really gross but I don't have another simple option since IO isn't provided to factorio. I will probably make something autogenerate a Lua file for this eventually]][[ 
WeightTest
{
    [1] "Entry1",
    [2] "Entry2",
    [%1*%2*2] "{GloryNoun}{TestNoun}"
}

MlgOuter1
{
    "{MlgOuter2}",
    "-={MlgOuter2}=-",
    "xX{MlgOuter2}Xx",
    "XxX{MlgOuter2}XxX",
    ".:{MlgOuter2}:."
}

MlgCoreName
{

}

GloryNoun
{
    "Glory",
    "Dignity",
    "Majesty",
    "Celebrity",
    "Triumph",
    "Immortality",
    "Splendor",
    "Greatness",
    "Prestige",
    "Honor",
    "Grandeur",
    "Kudos",
    "Courage",
    "Bravery",
    "Exaltation",
    "Illustriousness",
    "Renown",
    "Magnificence",
    "Eminence",
    "Sublimity",
}

SearcherNoun
{
    "Seeker",
    "Aspirant"
}

GloryAdjective
{
    "Glorious",
    "Dignified",
    "Majestic",
    "Celebritory",
    "Triumphant",
    "Immortal",
    "Splendid",
    "Great",
    "Prestigious",
    "Honored",
    "Honorable",
    "Grandiose",
    "Grand",
    "Courageous",
    "Brave",
    "Exalted",
    "Illustrious",
    "Renowned",
    "Magnificent",
    "Eminent",
    "Sublime",
}

ScaryAdjective
{
    "Scary",
    "Nightmarish",
    "Horrifying",
    "Chilling",
    "Horrendous",
    "Screaming",
}

RotatingAdjective
{
    "Spinning",
    "Revolving",
    "Spiraling",
    "Gyrating",
    "Turning",
    "Rotating",
    "Whirling",
    "Reeling",
}

GunBarrelsNoun
{
    "Barrels",
    "Drums",
    "Cylinders",
}

TurretBarrelNoun
{
    "Six {GloryAdjective} {GunBarrelsNoun}",
    "Six {RotatingAdjective} {GunBarrelsNoun}",
    "Six {ScaryAdjective} {GunBarrelsNoun}",
}

PainNoun
{
    "Pain",
    "Agony",
    "Suffering",
    "Torture",
    "Torment",
}

ArtilleryTurretName
{
    "{ArtilleryDivine1} {ArtilleryDivine2}",
    "{OffspringNoun} of {Deity}", 
    "{DivineBeing}'s {DivineBeingNoun}",
}

#These two are meant to work with eachother for occasional artillery names
ArtilleryDivine1
{
    "Hell",
    "God",
    "Angel",
    "Devil",
    "Demon",
    "Nephilim",
    "Dawn",
    "Life",
    "World",
    "Heaven",
    "Sky",
    "Peace", #Maybe?
}

ArtilleryDivine2
{
    "Breaker",
    "Cracker",
    "Splitter",
    "Destroyer",
    "Hammer",
    "Crusher",
    "Eraser",
    "Spear",
    "Javelin",
    "Deliverer",
    "Cannon",
    "Weapon",
    "Child",
}

OffspringNoun
{
    "Child",
    "Son",
    "Daughter",
    "Progeny",
    "Descendant",
}

Deity
{
    "God",
    "Satan",
    "Lucifer",
    "Ares",
    "Athena",
    "Eris",
    "Gaia",
    "Zeus",
    "Hades",
    "Earth",
    "Mars",
    "Venus",
    "Neptune",
    "Osiris",
    "Ra",
    "Thor",
    "Heaven",
    "Hell",
}


DivineBeing
{
    "God",
    "Devil",
    "Demon",
    "Angel",
    "The Lord",
}

DivineBeingNoun
{
    "Forgiveness",
    "Sadness",
    "Anger",
    "Apathy",
    "Pity",
    "Envy",
    "Hatred",
    "Disdain",
    "Love",
    "Solution",
    "Gift",
    "Messenger",
    "Machine",
    "Device",
    "Solution",
}

CountryNames
{
    "America",
    "Freedomland",
    "Gunland",
    "Gunistan",
    "Guntopia",
    "Africa",
    "Chicago",
    "Detroit",
    "Britain",
    "Australia",
    "Kangarooland",
    "Russia",
    "China",
    "Japan",
}

CountryAdjective
{
    "American",
    "Gunlandian",
    "Gunistanian",
    "African",
    "British",
    "Australian",
    "Russian",
    "Chinese",
    "Japanese",
}

BattleNoun
{
    "War",
    "Battle",
    "Freedom",
    "Liberation",
}

WeaponPersonNoun
{
    "Commander",
    "Leader",
    "Chief",
    "Hero",
    "Veteran",
    "Soldier",
    "Sergeant",
    "Colonel",
    "Lieutenant",
}


DeathNoun
{
    "Death",
    "Extinction",
    "Genocide",
    "Erasure",
}

LiberatorNoun
{
    "Liberator",
    "Deliverer",
    "Rescuer",
    "Redeemer",
}

#Gun Turret Name
GunTurretName
{
    "{GloryAdjective} {AlienNoun} {KillerNoun}",
    "{AlienNoun} {KillerNoun}",
    "{OffspringNoun} of {GloryNoun}",
    "{SearcherNoun} of {GloryNoun}",
    "{GloryNoun} {SearcherNoun}",
    "{TurretBarrelNoun} of {PainNoun}",
    "{TurretBarrelNoun} of {DeathNoun}",
    "{BattleNoun} {WeaponPersonNoun}",
    "{CountryAdjective} {BattleNoun} {WeaponPersonNoun}",
    "{CountryAdjective} {LiberatorNoun}",
    "{GloryAdjective} {WeaponPersonNoun}",
    "{GloryAdjective} {BattleNoun} {WeaponPersonNoun}",
}

KillerNoun
{
    "Killer",
    "Murderer",
    "Exterminator",
    "Executioner",
    "Butcher",
    "Slayer",
    "Soldier",
    "Assassin",
    "Eraser",
    "Ender",
    "Deathbringer",
    "Death Dealer",
}

#Generic alien terms to throw into names
AlienNoun
{
    "Bug",
    "Alien",
    "Biter",
    "Spitter",
    "Worm",
    "Ankle Biter",
    "Vermin",
    "Pest",
    "Insect",
    "Arachnid",
    "Gnat",
    "Grub",
    "Beetle",
    "Cricket",
}












#███████╗██╗      █████╗ ███╗   ███╗███████╗                 
#██╔════╝██║     ██╔══██╗████╗ ████║██╔════╝                 
#█████╗  ██║     ███████║██╔████╔██║█████╗                   
#██╔══╝  ██║     ██╔══██║██║╚██╔╝██║██╔══╝                   
#██║     ███████╗██║  ██║██║ ╚═╝ ██║███████╗                 
#╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝                 
#                                                            
#████████╗██╗  ██╗██████╗  ██████╗ ██╗    ██╗███████╗██████╗ 
#╚══██╔══╝██║  ██║██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗
#   ██║   ███████║██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝
#   ██║   ██╔══██║██╔══██╗██║   ██║██║███╗██║██╔══╝  ██╔══██╗
#   ██║   ██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝███████╗██║  ██║
#   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝

#Flamethrower Turret Name
FlamethrowerTurretName
{
    "{FlamethrowerTurretAdjective} {AlienNoun} {FlamethrowerTurretNoun}",
    "{FlamethrowerTurretAdjective} {CountryAdjective} {FlamethrowerTurretNoun}",
    "{AlienNoun} {FireNoun}",
}

FlamethrowerTurretAdjective
{
    "{FireAdjective}",
    "{GloryAdjective}",
}

FlamethrowerTurretNoun
{
    "{FireNoun}",
    "{KillerNoun}",
    "{WeaponPersonNoun}",
    "{BattleNoun} {WeaponPersonNoun}",
}

#Intended for flamethrower turret
FireAdjective
{
    "Hot",
    "Spicy",
    "Spiced",
    "Habanero",
    "Burning",
    "Toasty",
    "Toasted",
    "Warm",
    "Blazing",
    "Heated",
    "Sweltering",
    "Sizzling",
    "Scorching",
    "Scorched",
    "Broiling",
    "Broiled",
    "Roasting",
    "Roasted",
    "Igneous",
    "Smoking",
    "Smoked",
    "Blistering",
    "Fiery",
    "Sunny",
    "Glowing",
    "Boiling",
    "Incendiary",
    "Molten",
}

FireNoun
{
    "Oven",
    "Furnace",
    "Bonfire",
    "Microwave",
    "Cauldron",
    "Crucible",
    "Pyre",
    "Torch",
    "Pyro",
    "Roaster",
    "Scorcher",
    "Melter",
    "Burner",
}
]]