	-- Config-fil, där kan du lagra och hämta saker för att separera ifrån client-filen för att minimera överflöde av kod som enbart håller värden med mera.



	-- Denna variabel rörs inte, denna använder man senare när man kallar på config.nyckelvärde
	config = {}




	-- Bra variabel om man ska lägga in "BLIPS" på kartan
	-- name = Namn när man markerar blipen, color = färg på blipen, id = typ av blip, x, y, z = Vart på kartan ska blipen vara?
	-- https://docs.fivem.net/game-references/blips/ => Länk till tillgängliga blipar och färger
	config.Map = {name = "Golfbilsuthyrning", color = 2, id = 225, x = -1345.2, y = 126.13, z = 56.24}


	-- Ring
	config.Ring = {x = -1345.2, y = 126.13, z = (56.24 - 0.99) }
							
	-- Distansen mellan position av ring & spelaren innan man ser ringen.
	config.DrawDistance = 10.0

	-- Storlek på ringen
	config.Size         = {x = 1.2, y = 1.2, z = 1.5}

	-- Färg på ringen [ RED, GREEN, BLUE, ALPHA (GENOMSKINLIGHET) ]
	config.Color        = {r = 255, g = 0, b = 0, a = 255}

	-- Typ av ring, om marken är ojämn och inte kan använda en platt ring, ändra 25 till 1, för att få en "orginalring"
	config.Type         = 25

	-- Olika färger för bilen
	config.carColors = {
		['Röd'] 	= {r = 255, 	b = 0, 		g = 0},
		['Blå'] 	= {r = 0, 		b = 255, 	g = 0},
		['Grön'] 	= {r = 0, 		b = 0, 		g = 255},
		['Svart']	= {r = 0,		b = 0,		g = 0},
	}

	config.sv = {
		model 		= 'caddy',
		spawn		= {x = -1342.45, y = 127.84, z = 56.24},
		heading		= 85.19
	}