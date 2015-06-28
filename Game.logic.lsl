
key player1Id = NULL_KEY;
key player2Id = NULL_KEY;
string player1Name = "";
string player2Name = "";
integer player1Turn = FALSE;
integer player1Matches = 0;
integer player1Misses = 0;
integer player2Matches = 0;
integer myChannel = 0;
integer myListener = 0;

string m1 = "Touch again to play on your own, or ask a friend to touch to play together.";
string m2 = "Game was not started in time. Touch me again if you would like to play.";
string m3 = "There are not enough resources available to setup this game.";

list cards = [];

integer cardsRemaining = 0;
integer cardsRezzed = 0;
integer card1Index = -1;
integer card1Channel = -1;

integer getSuite(integer cardIndex)
{
    list values = llParseString2List(llList2String(cards, cardIndex), [":"], []);
    return llList2Integer(values, 1);
}
integer getValue(integer cardIndex)
{
    list values = llParseString2List(llList2String(cards, cardIndex), [":"], []);
    return llList2Integer(values, 0);
}
integer isMatch(integer cardIndex1, integer cardIndex2)
{
    integer value1 = getValue(cardIndex1);
    integer value2 = getValue(cardIndex2);
    integer suite1 = getSuite(cardIndex1);
    integer suite2 = getSuite(cardIndex2);
    
    string card2 = cardId(value2, suite2);
    if(card2 == cardIdMatch(value1, suite1))
        return TRUE;
    return FALSE;
}
endOfGame()
{
    if(player1Id == player2Id)
    {
        llSay(PUBLIC_CHANNEL, player1Name + " finished with " + (string)player1Matches + " matches and " + (string)player1Misses + " misses.");
    }
    else
    {
        string s = "It is a tie! ";
        if(player1Matches > player2Matches)
            s = player1Name + " has won the game! ";
        else if(player2Matches > player1Matches)
            s = player2Name + " has won the game! ";
            
        llSay(PUBLIC_CHANNEL, s + player1Name + " had " + (string)player1Matches + ". " + player2Name + " had " + (string)player2Matches + ".");
        
    }
}
rezNextCard()
{
    if(cardsRezzed >= cardsRemaining)
    {
        llSetTimerEvent(1800);// 30 minutes
        showStatus();
        llWhisper(PUBLIC_CHANNEL, "Ready!");
        return;
    }
    
    // determine rows/columns
    integer rows = llRound(llSqrt(cardsRemaining));
    integer columns = rows;
    if(columns * rows < cardsRemaining)
        columns++;
    
    //llOwnerSay("columns: " + (string)columns + ", rows: " + (string)rows);
    
    // determine row/column of current card
    
    integer column = cardsRezzed % rows;
    integer row = ((cardsRezzed - (cardsRezzed % rows)) / rows);
    
 //   llOwnerSay("column: " + (string)column + ", row: " + (string)row);
    
    float width = 0.168 * 1.1;
    float height = 0.254 * 1.1;

    //return;    
    llRezObject(llGetInventoryName(INVENTORY_OBJECT, 0), 
        llGetPos() + <
            (row * width) - (rows * width * .5), 
            (column * height) - (rows * width * .5), 0>, 
        ZERO_VECTOR, 
        ZERO_ROTATION, 
        myChannel);
    cardsRezzed++;
}
startListening()
{
    if(myListener != 0)
    {
        llListenRemove(myListener);
        myListener = 0;
    }
    myChannel = (llRound(llFrand(0x7FFFFBFF)) + 0x4FF) * -1;
    myListener = llListen(myChannel, "", NULL_KEY, "");
}
shuffleDeck()
{
    // build list of cards
    integer value;
    integer suite;
    for(value = 0; value < 13; value++)
        for(suite = 0; suite < 2; suite++)
        {
            cards += cardId(value, suite);
            cards += cardIdMatch(value, suite);
        }
    
    // mix up pairs
    cards = llListRandomize(cards, 2);

    // remove extra cards
    if(cardsRemaining < 52)
        cards = llDeleteSubList(cards, cardsRemaining, -1);
    
    // mix up cards
    cards = llListRandomize(cards, 1);
}

string cardId(integer value, integer suite)
{
    return (string)value + ":" + (string)suite;
}
string cardIdMatch(integer value, integer suite)
{
    if(suite == 0) return cardId(value, 3);
    if(suite == 1) return cardId(value, 2);
    if(suite == 2) return cardId(value, 1);
    if(suite == 3) return cardId(value, 0);
    return "";
}

integer resourcesAvailable()
{
    if(cardsRemaining < 10) return FALSE;
    
    // TODO: check if anyone, or my group can create objects
    // TODO: check if my objects will be returned after X minutes or less
    
    return TRUE;
}
showText(string message)
{
    llSetText("Concentration\n-------------\n" + message, <1,1,1>, 1);
}
showStatus()
{
    string message = "";
    
    if(player1Id != player2Id)
    {
        if(player1Turn)
            message += "It is " + player1Name + "'s turn\n";
        else
            message += "It is " + player2Name + "'s turn\n";
        
        message += "\n" + player1Name + ": " + (string)player1Matches + "\n";
        message += "\n" + player2Name + ": " + (string)player2Matches ;
    }
    else
    {
        message += player1Name + "\nMatches: " + (string)player1Matches + "\nMisses: " + (string)player1Misses;
    }
        
    showText(message);
}
default
{
    state_entry()
    {
        llSetTimerEvent(0);
        llSetAlpha(1.0, ALL_SIDES);
        llSetScale(<0.5, 0.5, 0.01>);

        if(myListener != 0)
        {
            llListenRemove(myListener);
            myListener = 0;
        }
        player1Id = NULL_KEY;
        player2Id = NULL_KEY;
        player1Name = "";
        player2Name = "";
        
        showText("Touch to start a new game.");
    }

    touch_start(integer total_number)
    {
        
        
        integer i;
        for(i = 0; i < total_number; i++)
        {
            if(player1Id == NULL_KEY)
            {
                player1Id = llDetectedKey(i);
                player1Name = llDetectedName(i);
            }
            else if(player2Id == NULL_KEY)
            {
                player2Id = llDetectedKey(i);
                player2Name = llDetectedName(i);
            }
        }
        
        if(player1Id != NULL_KEY && player2Id != NULL_KEY)
        {
            state play;
            return;
        }
        else if(player1Id != NULL_KEY)
        {
            llInstantMessage(player1Id, m1);
            showText("Touch to play a game with " + player1Name);
        }
        else if(player2Id != NULL_KEY)
        {
            llInstantMessage(player2Id, m1);
            showText("Touch to play a game with " + player2Name);
        }
        llSetTimerEvent(60.0);
    }
    timer()
    {
        if(player1Id != NULL_KEY)
        {
            llInstantMessage(player1Id, m2);
            player1Id = NULL_KEY;
            player1Name = "";
        }
        if(player2Id != NULL_KEY)
        {
            llInstantMessage(player2Id, m2);
            player2Id = NULL_KEY;
            player2Name = "";
        }
        showText("Touch to start a new game.");
        llSetTimerEvent(0.0);
    }
}
state play
{
    state_entry()
    {
        llSetTimerEvent(0);
        llSetAlpha(0.0, ALL_SIDES);
        llSetScale(<0.01, 0.01, 0.01>);
        
        card1Index = -1;
        card1Channel = -1;
        player1Matches = 0;
        player2Matches = 0;
        player1Misses = 0;
        player1Turn = TRUE;
        showStatus();
        cards = [];
        cardsRezzed = 0;
        
        // only rez within limit
        cardsRemaining = llGetParcelMaxPrims(llGetPos(), TRUE) 
            - llGetParcelPrimCount(llGetPos(), PARCEL_COUNT_TOTAL, TRUE);
        if(cardsRemaining > 52)
            cardsRemaining = 52;
         if(cardsRemaining % 2 != 0)
            cardsRemaining--;
   
        if(!resourcesAvailable())
        {
            llInstantMessage(player1Id, m3);
            if(player2Id != NULL_KEY)
                llInstantMessage(player2Id, m3);
            state default;
        }
        
        shuffleDeck();
        startListening();
        rezNextCard();
    }
    timer()
    {
        llSay(PUBLIC_CHANNEL, "The game has taken more than 30 minutes to play.");
        endOfGame();
        state default;
    }
    listen(integer channel, string name, key id, string message)
    {
        list params = llParseString2List(message, [", "], []);
        string command = llList2String(params, 0);
        
        // card just rezzed
        if(command == "rezzed")
        {
            // give id
            llRegionSay(llList2Integer(params, 1), llList2CSV(["id", cardsRezzed - 1, "playerId", player1Id, "playerId", player2Id]));
            rezNextCard();
            return;
        }
        if(command == "touched")
        {
            integer cardChannel = llList2Integer(params, 1);
            integer cardIndex = llList2Integer(params, 3);
            key avatarId = llList2Key(params, 5);
            
            if(cardIndex == card1Index) return;
            
            if(
                (player1Id == avatarId && player1Turn)
                || (player2Id == avatarId &! player1Turn)
            )
            {
                if(card1Index == -1)
                {
                    card1Index = cardIndex;
                    card1Channel = cardChannel;
                    integer suite = getSuite(card1Index);
                    integer value = getValue(card1Index);
                    llRegionSay(cardChannel, llList2CSV(["keeplistening", TRUE, "suite", suite, "value", value, "show", TRUE]));
                }
                else
                {
                    integer suite = getSuite(cardIndex);
                    integer value = getValue(cardIndex);
                    llRegionSay(cardChannel, llList2CSV(["keeplistening", TRUE, "suite", suite, "value", value, "show", TRUE]));
                    llSleep(1.0);
                    
                    if(isMatch(cardIndex, card1Index))
                    {
                        llRegionSay(card1Channel, "die");
                        llRegionSay(cardChannel, "die");
                        if(player1Turn)
                            player1Matches++;
                        else
                            player2Matches++;
                        cardsRemaining -= 2;
                        if(cardsRemaining <= 0)
                        {
                            endOfGame();
                            state default;
                        }
                    }
                    else
                    {
                        llRegionSay(card1Channel, "hide");
                        llRegionSay(cardChannel, "hide");
                        if(player1Id != player2Id)
                            player1Turn = !player1Turn;
                        else
                            player1Misses++;
                    }
                    card1Index = -1;
                    showStatus();
                }
            }
            else
                llRegionSay(cardChannel, "ignore");
        }
    }
}