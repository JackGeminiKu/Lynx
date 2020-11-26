Pet = Unit:New('pet')

function Pet:CastAction(index)
    return wow.CastPetAction(index)
end

function Pet:Follow()
    for i = 1, 10, 1 do
        local name, _, _, _, _, _, _ = wow.GetPetActionInfo(i);
        if (name == "PET_ACTION_FOLLOW") then
            wow.CastPetAction(i);
        end
    end
end
