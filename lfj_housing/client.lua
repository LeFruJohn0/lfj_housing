vRP = Proxy.getInterface("vRP")
vRPS = Tunnel.getInterface("vRP","lfj_housing")
vRPhouse = Tunnel.getInterface("lfj_housing","lfj_housing")
vRPC = {}
Tunnel.bindInterface("lfj_housing",vRPC)
vRPS = Tunnel.getInterface("lfj_housing","lfj_housing")

housestypeslist = {
    ["Cheap"] = {
      exit = {266.09219360352,-1007.2996826172,-101.00855255126},
      inventory = {265.89614868164,-999.40612792968,-99.008689880372},
      wardrobe = {259.89672851562,-1003.7418823242,-99.008613586426}
    },
    ["Expensive"] = {
        exit = {-784.72161865234,323.62002563476,211.99723815918},
        inventory = {-766.57244873046,328.38446044922,211.39654541016},
        wardrobe = {-793.36315917968,326.8432006836,210.79663085938}
    },
  }

houses = {}
idh = nil
typeh = nil

function vRPC.CreateHouses(house)
    houses = nil
    Wait(1000)
    houses = house
    blips()
end

function vRPC.setUpJoinedPlayer(id, type)
    idh = id
    typeh = type
end

function vRPC.unfreeze()
    FreezeEntityPosition(PlayerPedId(), false)
end

local blipss = {}

function blips()
    for k,v in pairs(houses) do	
        print("test")
        local blip = AddBlipForCoord(tonumber(v.x),tonumber(v.y), tonumber(v.z))
        SetBlipSprite(blip, 40)
        SetBlipScale(blip, 0.7)
        SetBlipColour(blip, 25)
        SetBlipAsShortRange(blip, true)
        
        BeginTextCommandSetBlipName("STRING")
        if v.sellingprice == 0 then
            AddTextComponentString("House #"..v.id.." ~r~(Owned)")
        else
            AddTextComponentString("House #"..v.id.." ~g~(For Selling)")
        end
        EndTextCommandSetBlipName(blip)
        blipss[v.id] = blip
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for k,v in pairs(blipss) do
            RemoveBlip(blipss[k])
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        while houses == nil do Wait(1000) print("not") end
        for k,v in pairs(houses) do
            if Vdist(GetEntityCoords(PlayerPedId()), tonumber(v.x),tonumber(v.y), tonumber(v.z)) < 10.0 then
            DrawMarker(27, vector3(tonumber(v.x),tonumber(v.y), tonumber(v.z) - 1), 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 50, false, true, 2, nil, nil, false)
            if Vdist(GetEntityCoords(PlayerPedId()), tonumber(v.x),tonumber(v.y), tonumber(v.z)) < 5.0 then
            -- Draw3DText(tonumber(v.x),tonumber(v.y), tonumber(v.z) + 1.5, "~w~House Id: ~g~"..tonumber(v.id), 1.0)
            Draw3DText(tonumber(v.x),tonumber(v.y), tonumber(v.z) + 0.50, "~w~Owner Id: ~g~"..tonumber(v.owner_id), 1.0)
            Draw3DText(tonumber(v.x),tonumber(v.y), tonumber(v.z), "~w~House Type: ~g~"..tostring(v.type), 1.0)
            if v.owner_id == 0 then
            Draw3DText(tonumber(v.x),tonumber(v.y), tonumber(v.z) + 0.25, "~w~House Price: ~g~"..tonumber(v.sellingprice), 1.0)
        elseif v.owner_id ~= 0 then
            if v.sellingprice ~= 0 then
                Draw3DText(tonumber(v.x),tonumber(v.y), tonumber(v.z) + 0.25, "~w~House Price: ~g~"..tonumber(v.sellingprice), 1.0)
            end
            end
            if Vdist(GetEntityCoords(PlayerPedId()), tonumber(v.x),tonumber(v.y), tonumber(v.z)) < 1.0 then
                Draw2DText(0.45, 0.9, "[~g~E~w~] House Menu")
            if IsControlJustReleased(0, 38) then
                FreezeEntityPosition(PlayerPedId(), true)
                vRPS.enterHouseMenu({v.id})
                idh = v.id
                typeh = tostring(v.type)
                print(typeh)
            end
            end
        end
            end
        end
    end
end)

Citizen.CreateThread(function ()
    while true do
        Wait(0)
        while houses == nil do Wait(1000) print("yes") end
        while typeh == nil do Wait(1000) print("yes") end
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].exit[1], housestypeslist[typeh].exit[2], housestypeslist[typeh].exit[3]) < 10.0 then
            DrawMarker(27, vector3(housestypeslist[typeh].exit[1], housestypeslist[typeh].exit[2], housestypeslist[typeh].exit[3] - 1), 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 50, false, true, 2, nil, nil, false)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].exit[1], housestypeslist[typeh].exit[2], housestypeslist[typeh].exit[3]) < 5.0 then
            Draw3DText(housestypeslist[typeh].exit[1], housestypeslist[typeh].exit[2], housestypeslist[typeh].exit[3] + 0.5, "Exit", 1.0)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].exit[1], housestypeslist[typeh].exit[2], housestypeslist[typeh].exit[3]) < 1.0 then
            Draw2DText(0.45, 0.9, "[~g~E~w~] House Menu")
            if IsControlJustReleased(0, 38) then
                FreezeEntityPosition(PlayerPedId(), true)
                vRPS.exitHouseMenu({idh})
            end
            end
            end
            end
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].inventory[1], housestypeslist[typeh].inventory[2], housestypeslist[typeh].inventory[3]) < 5.0 then
            DrawMarker(27, vector3(housestypeslist[typeh].inventory[1], housestypeslist[typeh].inventory[2], housestypeslist[typeh].inventory[3] - 1), 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 50, false, true, 2, nil, nil, false)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].inventory[1], housestypeslist[typeh].inventory[2], housestypeslist[typeh].inventory[3]) < 3.0 then
            Draw3DText(housestypeslist[typeh].inventory[1], housestypeslist[typeh].inventory[2], housestypeslist[typeh].inventory[3] + 0.5, "Inventory", 1.0)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].inventory[1], housestypeslist[typeh].inventory[2], housestypeslist[typeh].inventory[3]) < 1.0 then
            Draw2DText(0.45, 0.9, "[~g~E~w~] Inventory")
            if IsControlJustReleased(0, 38) then
                -- FreezeEntityPosition(PlayerPedId(), true)
                vRPS.openChest({idh, typeh})
            end
            end
            end
            end
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].wardrobe[1], housestypeslist[typeh].wardrobe[2], housestypeslist[typeh].wardrobe[3]) < 5.0 then
            DrawMarker(27, vector3(housestypeslist[typeh].wardrobe[1], housestypeslist[typeh].wardrobe[2], housestypeslist[typeh].wardrobe[3] - 1), 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 50, false, true, 2, nil, nil, false)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].wardrobe[1], housestypeslist[typeh].wardrobe[2], housestypeslist[typeh].wardrobe[3]) < 3.0 then
            Draw3DText(housestypeslist[typeh].wardrobe[1], housestypeslist[typeh].wardrobe[2], housestypeslist[typeh].wardrobe[3] + 0.5, "Wardrobe", 1.0)
            if Vdist(GetEntityCoords(PlayerPedId()), housestypeslist[typeh].wardrobe[1], housestypeslist[typeh].wardrobe[2], housestypeslist[typeh].wardrobe[3]) < 1.0 then
            Draw2DText(0.45, 0.9, "[~g~E~w~] Wardrobe")
            if IsControlJustReleased(0, 38) then
                -- FreezeEntityPosition(PlayerPedId(), true)
                vRPS.openWardrobe({idh})
            end
            end
            end
            end
    end
end)

function Draw2DText(x, y, text)
    -- Draw text on screen
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0, 0.4)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function Draw3DText(x,y,z,text,scl) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end