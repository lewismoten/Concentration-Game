default
 {
     state_entry()
     {
         if(llGetNumberOfPrims() != 1) {
             llOwnerSay("Object must have 1 prims");
             return;
         }

         string image = "Game.png";
         
         llSetLinkPrimitiveParamsFast(LINK_ROOT, [
             PRIM_LINK_TARGET, 1,
                 PRIM_NAME, "Concentration Game", 
                 PRIM_DESC, "Play with a friend or on your own to match different cards.", 
                 PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0.0, 1.0, 0.0>, 0.0, ZERO_VECTOR, <1.0, 1.0, 0.0>, ZERO_VECTOR, 
                 PRIM_SLICE, <0.0, 1.0, 0.0>, 
                 PRIM_PHYSICS_SHAPE_TYPE, PRIM_PHYSICS_SHAPE_PRIM, 
                 PRIM_MATERIAL, PRIM_MATERIAL_WOOD, 
                 PRIM_PHYSICS, FALSE, 
                 PRIM_TEMP_ON_REZ, FALSE, 
                 PRIM_PHANTOM, FALSE, 
                 PRIM_POSITION, <121.930600, 109.450100, 57.359600>, 
                 PRIM_POS_LOCAL, <121.930600, 109.450100, 57.359600>, 
                 PRIM_ROTATION, ZERO_ROTATION, 
                 PRIM_ROT_LOCAL, ZERO_ROTATION, 
                 PRIM_SIZE, <0.500000, 0.500000, 0.010000>, 
                 PRIM_TEXT, "", <1.0, 1.0, 1.0>, 1.0, 
                 PRIM_FLEXIBLE, FALSE, 0, 0.0, 0.0, 0.0, 0.0, ZERO_VECTOR, 
                 PRIM_POINT_LIGHT, FALSE, ZERO_VECTOR, 0.0, 0.0, 0.0, 
                 PRIM_OMEGA, ZERO_VECTOR, 0.0, 0.0, 
                 PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0, 
                 PRIM_TEXTURE, ALL_SIDES, image, <1.0, 1.0, 0.0>, ZERO_VECTOR, 0.0, 
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