// ========= Question 1 [q-SQL/functional select]=========

// Part A
// Create a keyed table 'rating' with 2 columns sym[symbol type] as the key and score[string/char list]
// sym should contain `AAPL `AMD and `AIG with the corresponding scores "AAA", "AAB", "BBB"
// Using the 'trade' binary file given during the course, find on a per second basis for each sym, what was the volume weighted avg price, total size, and number of trades
// Assign the query to the variable 'stats'
// Join 'stats' with the 'rating' table to include score. The result should only include syms that are in the 'rating' table

rating:([sym:`AAPL`AMD`AIG];score:("AAA";"AAB";"BBB"));
trade:get hsym `$"D:/Repo/Q-ingSpree/kdb_training/data/trade";
stats:(select vwap:size wavg price, quantity:sum size,tradeCount:count i by 1 xbar time.second,sym from trade) 
stats ij rating 

// Part B
// Convert the 'stats' table in Part A into from q-SQL to functional form
// Hint: Use 'parse' for clues. Use ~ to check if the results are the same 
parse "(select vwap:size wavg price, quantity:sum size,tradeCount:count i by 1 xbar time.second,sym from trade)"
fsStats:?[trade;();(`second`sym)!((xbar;1;`time.second);`sym);`vwap`quantity`tradeCount!((wavg;`size;`price);(sum;`size);(count;`i))]
fsStats~stats

// ========= Question 2 [Lists] =========
// Given a random list of 100 symbols lvqlugfnydflrnibfclhoilweiughpovafyljzabctkvsckggjifszucufpbrwbejugcrvcgdrmrutihqbiaijhgrwnqiguyaskw saved as variable 'syms'
// Part A: Replace all occurences of `g with `c permernantly 
// Part B: Find out if there are letters that are consecutively the same. Return the index of the first in each pair. HINT: see prev and next
// Part C: Find out how often does a consonent(not a,e,i,o,u) precedes a vowel (a,e,i,o,u) in 'syms'. HINT: 'like' with wildcard "*", each right
syms:`$string"lvqlugfnydflrnibfclhoilweiughpovafyljzabctkvsckggjifszucufpbrwbejugcrvcgdrmrutihqbiaijhgrwnqiguyaskw"
syms:?[syms=`g;`c;syms]
where syms = next syms
count distinct raze (ss[(raze string syms);]') ((.Q.a except "aeiou") cross "aeiou")



// ========= Question 3 [Bonus question] =========
// It's the Lunar New Year season and playing cards are a typical activity amongst friends during this period of the year
// You've just attending a kdb training course and decided that you can write a few simple kdb functions to improve your odds at winning
// Write 2 functions 'shuffle' and 'forecast' to improve your odds and beat the competition

// Part A
// Write a niladic function 'shuffle' that generates a deck(non-repeating) of 52 poker cards with 4 suits - Diamonds, Clubs, Hearts and Spade.
// 'Shuffle' should randomize each time it is called.
// Represent each suit using the first letter of their name; i.e Diamonds = "D", Clubs = "C"
// Cards Ace to Kings are represented by numbers 1 to 13 where Ace is 1, King is 13, Queen is 12, Jack is 11
// Each card is represented by a 2 element list , (x;y) where the first element x is the suit and element y is the number
// For example, ("H";"1") = Ace of Hearts, ("C";"11") = Jack of Clubs
// Sample: 
//    (("S";"7");("D";"5");("C";"12");("D";"7");("D";"10");("D";"1");("H";"7");("S";"1");("H";"1");("D";"9");("C";"9");("D";"2");("C";"10");
//    ("C";"5");("S";"11");("S";"4");("D";"4");("H";"12");("S";"6");("D";"12");("S";"12");("S";"8");("C";"1");("C";"4");("H";"4");("S";"10");
//    ("H";"9");("C";"7");("H";"11");("S";"3");("D";"11");("C";"2");("H";"3");("H";"8");("S";"2");("C";"13");("D";"8");("H";"10");("C";"3");
//    ("S";"13");("S";"5");("D";"13");("H";"6");("S";"9");("H";"2");("H";"5");("C";"8");("H";"13");("C";"11");("D";"3");("D";"6");("C";"6"))
// Hints: There's a function called 'permute' that wasn't taught in class

// Part B
// Write a monadic function 'forecast' that excepts a argument 'deck' that is a shuffled deck from Part A and generates a forecast per turn
// Each forecast should show the probablities of each card appearing next. You can represent this forecast as a dictionary where key is the card number and value is the probabality
// Suits can be ignored in this part. The purpose is to capture the probability of a card numbered card appearing in the next draw
// For example for a deck that has the following as the first 3 cards - ("D";"13");("S";"3");("D";"1") these should be the results each time a new card is dealt
// No cards dealt: ("13";"3";"1";"5";"2";"7";"12";"9";"8";"4";"10";"6";"11")!0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231 0.0769231
// Deal first card:("3";"1";"5";"2";"7";"12";"9";"8";"4";"10";"6";"11";"13")!0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0784314 0.0588235
// Deal second card:("1";"5";"2";"7";"12";"9";"8";"4";"10";"6";"11";"13";"3")!0.08 0.08 0.08 0.08 0.08 0.08 0.08 0.08 0.08 0.08 0.08 0.06 0.06
// Deal third card:("5";"2";"7";"12";"9";"8";"4";"10";"6";"11";"13";"1";"3")!0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0816327 0.0612245 0.0612245 0.0612245
// You can choose to drop numbers that have been fully dealt (all 4 cards are out) as keys in the dictionaries
// Hint 1: This question can be easily solved with some keywords not taught in class. Adverbs are your friends. 'Scan' through the documentation to find some useful functions.  
// Hint 2: Break down the problem into 2 parts - 
//      1) How do i simlate dealing a card (removing the top card of the deck one at a time)?
//      2) How do i calculate the probability of each card given the knowledge of what was dealt previously?

shuffle:{0N?"DCHS" cross enlist each string 1+til 13};
forecast:{[deck]{desc (key snap)!(count each value snap:group x[;1])%count x} each ({1_x}\) deck};
forecast shuffle[]