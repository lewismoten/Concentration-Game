default
{
    state_entry()
    {
        if(llGetNumberOfPrims() != 1) {
            llOwnerSay("Object must have 1 prims");
            return;
        }

        string image = "Playing Card.png";

        llSetLinkPrimitiveParamsFast(LINK_ROOT, [
            PRIM_LINK_TARGET, 1,
                PRIM_NAME, "Playing Card", 
                PRIM_DESC, "Touch me to flip me over.", 
                PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0.0, 1.0, 0.0>, 0.0, ZERO_VECTOR, <1.0, 1.0, 0.0>, ZERO_VECTOR, 
                PRIM_SLICE, <0.0, 1.0, 0.0>, 
                PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_PRIM, 
                PRIM_MATERIAL, PRIM_MATERIAL_WOOD, 
                PRIM_PHYSICS, FALSE, 
                PRIM_TEMP_ON_REZ, FALSE, 
                PRIM_PHANTOM, FALSE, 
                PRIM_POSITION, <123.036900, 110.175100, 57.360290>, 
                PRIM_POS_LOCAL, <123.036900, 110.175100, 57.360290>, 
                PRIM_ROTATION, llEuler2Rot(<0.213965, -0.147312, 0.087544> * DEG_TO_RAD), 
                PRIM_ROT_LOCAL, llEuler2Rot(<0.213965, -0.147312, 0.087544> * DEG_TO_RAD), 
                PRIM_SIZE, <0.168447, 0.254329, 0.010000>, 
                PRIM_TEXT, "", ZERO_VECTOR, 1.0, 
                PRIM_FLEXIBLE, FALSE, 0, 0.0, 0.0, 0.0, 0.0, ZERO_VECTOR, 
                PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0.0, 0.0, 0.0, 
                PRIM_OMEGA, ZERO_VECTOR, 0.0, 0.0, 
                PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0, 
                PRIM_TEXTURE, ALL_SIDES, image, <0.071429, 0.250000, 0.0>, <0.464286, -0.125000, 0.0>, 0.0, 
                PRIM_BUMP_SHINY, ALL_SIDES, PRIM_SHINY_NONE, PRIM_BUMP_NONE, 
                PRIM_FULLBRIGHT, ALL_SIDES, FALSE, 
                PRIM_TEXGEN, ALL_SIDES, PRIM_TEXGEN_DEFAULT, 
                PRIM_GLOW, ALL_SIDES, 0.0, 
                PRIM_NORMAL, ALL_SIDES, NULL_KEY, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0, 
                PRIM_SPECULAR, ALL_SIDES, NULL_KEY, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0, <1.0, 1.0, 1.0>, 51, 0, 
                PRIM_ALPHA_MODE, ALL_SIDES, PRIM_ALPHA_MODE_BLEND, 0, 
            PRIM_LINK_TARGET, LINK_ROOT
        ]);
    }
}