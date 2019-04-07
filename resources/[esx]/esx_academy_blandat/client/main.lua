	-- 00. [ KNAPPAR ]
	local Keys = {
	  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
	}

	-- 01. [ VARIABLAR ]

		ESX = nil
		local PlayerData 	= {}
		local PlayerPed 	= GetPlayerPed(-1)



	-- 02. [ TABELLER OCH OBJEKT ]


	-- 03. [ ESX_BOILERPLATE STANDARD - TRÅDAR ]

	-- DENNA TRÅD KÖRS TILL ETT ESX-OBJEKT ÄR HÄMTAT
	Citizen.CreateThread(function() 
		while ESX == nil do
			TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
			Citizen.Wait(0)
		end
	end)


	-- 04. [ ESX_BOILERPLATE STANDARD - HÄNDELSEHANTERARE ]

	RegisterNetEvent('esx:playerLoaded')
	AddEventHandler('esx:playerLoaded', function(xPlayer)
	  PlayerData = xPlayer   
	end)

	-- HÄMTAR KARAKTÄRENS JOBB OCH SÄTTER DEN TILL KARAKTÄRENS PlayerData-OBJEKT UNDER NYCKELVÄRDET "job"
	RegisterNetEvent('esx:setJob')
	AddEventHandler('esx:setJob', function(job)
	  PlayerData.job = job
	end)



	-- 05. [ FUNKTIONER ]
	
	function openGolfCarMenu()
		
		local farghyllan = {}

		for farg,blandning in pairs(config.carColors) do
			table.insert(farghyllan, {label = farg, value = blandning})
		end

		ESX.UI.Menu.Open(
		    'default', GetCurrentResourceName(), 'GOLFBILSUTHYRNING',
		    {
		    	title    = 'VÄLJ FÄRG PÅ GOLFBILEN',
		    	align    = 'bottom-right',
		    	elements = farghyllan,
		    },
		    function(data, menu)
		   		local blandning = data.current.value
		   		spawnCar(blandning)
		   		menu.close()
		    end,
		    function(data, menu)
		    	menu.close()
		    end
		)
	end

	function spawnCar(inBlandning)
		local blandning = inBlandning
		
		ESX.Game.SpawnVehicle(config.sv.model, config.sv.spawn, config.sv.heading, function(golfbil)
			SetVehicleCustomPrimaryColour(golfbil, blandning.r, blandning.g, blandning.b)
		end)
	
	end


	-- 06. [ HÄNDELSEHANTERARE ]

	AddEventHandler('academy:hasEnteredMarker', function()
		CurrentAction 		= 'golfbil'
		CurrentActionMsg 	= 'Tryck ~g~E~w~ för att öppna Golfbilsuthyrningen'
	end)

	AddEventHandler('academy:hasExitedMarker', function()
		CurrentAction = nil
	end)

	-- 07. [ TRÅDAR FÖR MARKERINGAR / RINGAR (ESX_BOILERPLATE) ]


	-- MÅLA UPP MARKERINGAR (RINGAR)-TRÅDEN
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0) -- FÅR INTE TAS BORT ELLER ÄNDRAS
			local coords = GetEntityCoords(PlayerPed) -- HÄMTAR SPELARENS POSITION

			if GetDistanceBetweenCoords(coords, config.Ring.x, config.Ring.y, config.Ring.z, true) < config.DrawDistance then -- HÄR SKA NÅGOT HÄNDA NÄR DISTANSEN MELLAN SPELAREN OCH X Y Z ÄR MINDRE ÄN DRAWDISTANCE
				DrawMarker(config.Type, config.Ring.x, config.Ring.y, config.Ring.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, config.Size.x, config.Size.y, config.Size.z, config.Color.r, config.Color.g, config.Color.b, config.Color.a, false, true, 2, false, false, false, false)
			end

		end
	end)

	-- GÅ IN OCH UR RINGEN-TRÅDEN
	Citizen.CreateThread(function() 
		while true do
			Citizen.Wait(10) -- FÅR INTE TAS BORT, ENDAST ÄNDRAS TILL 0, INTE HÖGRE ÄN 10
			local coords = GetEntityCoords(PlayerPed) -- HÄMTAR SPELARENS POSITION
			local isInMarker = false -- SKAPAR EN LOKAL VARIABEL I TRÅDEN OCH SÄTTER VÄRDET FALSE

			-- IF-SATSEN KOLLAR DISTANSEN MELLAN SPELAREN OCH RINGENS POSITION, ÄR DENNA DISTANS MINDRE ÄN RINGENS X VÄRDE, SÅ STÅR VI I RINGEN. 
			if GetDistanceBetweenCoords(coords, config.Ring.x, config.Ring.y, config.Ring.z, true) < config.Size.x then
				isInMarker = true
			end

			if isInMarker and not HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = true
				TriggerEvent('academy:hasEnteredMarker')
			end

			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('academy:hasExitedMarker')
			end
		end
	end)

	-- INTERAKTION MED MARKERINGAR (RINGAR)-TRÅDEN
	Citizen.CreateThread(function()
		while true do 
			Citizen.Wait(10)

			if CurrentAction ~= nil then -- NÄR VI GÅR IN I EN RING SÅ SÄTTS CURRENTACTION TILL NÅGOT, OCH SÅ LÄNGE SOM DEN INTE ÄR NIL SÅ ÄR DET OKEJ.
				SetTextComponentFormat('STRING')
				AddTextComponentString(CurrentActionMsg)
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)

				if IsControlJustReleased(0, Keys["E"]) then -- KOLLAR NÄR MAN SLÄPPT KNAPPEN 38 (E), DÅ FORTSÄTTER IF-SATSEN		
					
					-- HÄR GÅR VI IGENOM VÄRDET PÅ CurrentAction-VARIABELN OCH SER VAD SOM SKALL UTFÖRAS
					if CurrentAction == 'golfbil' then
						openGolfCarMenu()
					end
					CurrentAction = nil
				end

			end
		end
	end)


	-- SKAPA BLIP PÅ KARTAN SÅ MAN VET VART MAN KAN HYRA EN GOLFBIL.
	Citizen.CreateThread(function()
		
		local destination = AddBlipForCoord(config.Map.x, config.Map.y, config.Map.z)
		
		SetBlipSprite(destination, config.Map.id)
		SetBlipColour(destination, config.Map.color)
		SetBlipScale(destination, 0.7)		

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Golfbilsuthyrning')
		EndTextCommandSetBlipName(destination)
	end)