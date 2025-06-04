local isNoclip = false
local moveSpeed = 0.6
local upDownSpeed = 0.4
local toggleKey = 121 -- F2

CreateThread(function()
    while true do
        Wait(0)

        -- Toggle noclip
        if IsControlJustPressed(0, toggleKey) then
            local ped = PlayerPedId()
            isNoclip = not isNoclip

            if isNoclip then
                SetEntityInvincible(ped, true)
                SetEntityCollision(ped, false, false)
                FreezeEntityPosition(ped, false)

                -- Load and play freefall animation
                RequestAnimDict("skydive@freefall")
                while not HasAnimDictLoaded("skydive@freefall") do
                    Wait(10)
                end
                TaskPlayAnim(ped, "skydive@freefall", "freefall", 8.0, -8, -1, 49, 0, false, false, false)
            else
                -- Clear animation & restore state
                local ped = PlayerPedId()
                ClearPedTasksImmediately(ped)
                SetEntityInvincible(ped, false)
                SetEntityCollision(ped, true, true)
            end
        end

        -- Noclip movement
        if isNoclip then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)
            local forward = GetEntityForwardVector(ped)
            local right = GetEntityRightVector(ped)

            if IsControlPressed(0, 32) then -- W
                pos = pos + forward * moveSpeed
            end
            if IsControlPressed(0, 33) then -- S
                pos = pos - forward * moveSpeed
            end
            if IsControlPressed(0, 34) then -- A
                pos = pos - right * moveSpeed
            end
            if IsControlPressed(0, 35) then -- D
                pos = pos + right * moveSpeed
            end
            if IsControlPressed(0, 22) then -- SPACE (up)
                pos = pos + vector3(0, 0, upDownSpeed)
            end
            if IsControlPressed(0, 36) then -- CTRL (down)
                pos = pos - vector3(0, 0, upDownSpeed)
            end

            SetEntityCoordsNoOffset(ped, pos.x, pos.y, pos.z, true, true, true)
            SetEntityVelocity(ped, 0.0, 0.0, 0.0)
        end
    end
end)
