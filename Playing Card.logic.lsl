string imageTexture = "Playing Card.png";
integer imageRows = 4;
integer imageColumns = 14;

list suites = ["Clubs", "Diamonds", "Hearts", "Spades"];
list values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King"];

integer parentChannel = 0;
integer myChannel = 0;
integer myListener = 0;
key parentId = NULL_KEY;

integer myId = 0;
list playerIds = [];
integer keepListening = FALSE;

integer cardSuite = 0;
integer cardValue = 0;

processCommand(string name, string value)
{
    if(name == "id") myId = (integer)value;
    if(name == "playerId") playerIds += [(key)value];
    if(name == "keeplistening") keepListening = TRUE;
    if(name == "die") llDie();
    if(name == "show") showFace(cardValue, cardSuite);
    if(name == "hide") showBack();
    if(name == "value") cardValue = (integer)value;
    if(name == "suite") cardSuite = (integer)value;
}
stopListening()
{
    if(myListener != 0)
    {
        llListenRemove(myListener);
        myListener = 0;
    }
}
integer startListening(key parentId)
{
    stopListening();
    integer channel = (llRound(llFrand(0x7FFFFBFF)) + 0x4FF) * -1;
    myListener = llListen(channel, "", parentId, "");
    return channel;
}
init(integer channel)
{
    showBack();
    myId = 0;
    playerIds = [];
    parentChannel = channel;
    if(parentChannel != 0)
    {
        llSetTimerEvent(1800); // 30 minutes
        myChannel = startListening(NULL_KEY);
        llRegionSay(parentChannel, llList2CSV(["rezzed", myChannel]));
    }
    else
        llSetTimerEvent(0);
}
reportTouched(key id)
{
    if(parentChannel != 0)
    {
        myChannel = startListening(NULL_KEY);
        llRegionSay(parentChannel, llList2CSV(["touched", myChannel, "id", myId, "avatarId", id]));
    }
}
showFace(integer value, integer suite)
{
    string valueName = llList2String(values, value) ;
    string suiteName = llList2String(suites, suite) ;
    //llWhisper(PUBLIC_CHANNEL, valueName + " of " + suiteName);
    displayImage(suite, imageRows, value, imageColumns, imageTexture, ALL_SIDES, 0);
}
showBack()
{
    displayImage(2, imageRows, 13, imageColumns, imageTexture, ALL_SIDES, 0);
}
showWildCard(integer black)
{
    if(black)
        displayImage(0, imageRows, 13, imageColumns, imageTexture, ALL_SIDES, 0);
    else
        displayImage(1, imageRows, 13, imageColumns, imageTexture, ALL_SIDES, 0);
}
displayImage(
    integer row, integer rows, 
    integer column, integer columns, 
    string texture, integer face, float rot)
{
    float width = 1.0 / (float)columns;
    float height = 1.0 / (float)rows;
    
    vector offset = <-0.5 + (width * 0.5), 0.5 - (height * 0.5), 0>;
    offset.x += column * width;
    offset.y -= row * height;
    
    llSetPrimitiveParams([PRIM_TEXTURE, face, texture, <width, height, 0>, offset, rot]);
}
default
{
    state_entry()
    {
        init(0);
    }
    on_rez(integer start_param)
    {
        init(start_param);
    }

    touch_start(integer total_number)
    {
        integer i;
        for(i = 0; i < total_number; i++)
            if(llListFindList(playerIds, [llDetectedKey(i)]) != -1)
                reportTouched(llDetectedKey(i));
    }
    listen(integer channel, string name, key id, string message)
    {
        keepListening = FALSE;
        parentId = id;

        list params = llParseString2List(message, [", "], []);
        
        integer i = 0;
        integer n = llGetListLength(params);
        
        for(i = 0; i < n; i += 2)
        {
            string name = llList2String(params, i);
            string value = llList2String(params, i + 1);
            processCommand(name, value);
        }
        if(!keepListening)
            stopListening();
    }
    timer()
    {
        llDie();
    }
}
