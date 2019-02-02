shuffle:{[num_decks]
    start_deck:`Clubs`Diamonds`Hearts`Spades cross (`$string 1+ til 13);
    deck:raze num_decks#enlist start_deck;
    size: count deck;
    shuffled_deck:deck[size?til size];
    shuffled_deck
};
checkcard:{
    (`A,(`$(string 2+til 9)),`J`Q`K)[x-1]
};
nextplay:{[simulation]
    if[(count .now.current_deck) < 3;:"End of Game!"];
    checkcard:{(`A,(`$(string 2+til 9)),`J`Q`K)[x-1]};
    
    card1:.now.current_deck[0];
    card2:.now.current_deck[1];
    card1_display:card1[0],checkcard[("I"$string card1[1])];
    card2_display:card2[0],checkcard[("I"$string card2[1])];
    diff:0N,abs ("I"$string card1[1]) - ("I"$string card2[1]);
    dict:(group .now.current_deck[;1]);
    if[diff[1]<=1;
        [
            .now.current_deck:3_.now.current_deck;
            :"Skip!"
            ]
    ];
    order:asc (("I"$string card2[1]);"I"$string card1[1]);
    l:`$string (first order )+ til ((last order)-(first order));
    chance:100*(sum count each dict[l])%(-3+(count .now.current_deck));
    chance_display: (.Q.f[2;chance]),"%";

    res:flip (`left_card`right_card`diff`remaining_cards`chance_within)!(card1_display;card2_display;diff;(0N;-3+count .now.current_deck);(0N;chance_display));
    if[simulation;
        [
            res:res+flip ((enlist `next_card)!(enlist .now.current_deck[2]));
            .now.current_deck:3_.now.current_deck
        ]   
    ];
    res    
};

punt_check:{
    checkcard:{
        (`A,(`$(string 2+til 9)),`J`Q`K)[x-1]
    };
    card1:"I"$string .now.current_deck[0;1];
    card2:"I"$string .now.current_deck[1;1];
    card3:"I"$string .now.current_deck[2;1];
    card1_display:.now.current_deck[0;0],checkcard[card1];
    card2_display:.now.current_deck[1;0],checkcard[card2];
    card3_display:.now.current_deck[2;0],checkcard[card3];
    comb:(card1,card2);
    card1:first asc comb;
    card2:last asc comb;
    diff:card2-card1;
    res:$[card3 within ((card1-1);(card2+1));
            "Score!";
            $[or[card3=card1;card3=card2];
                "Tiang!";
                "Missed!"
             ]
          ];
    action:0N;      
    action:$[not x;"Skip!";action];
    display:flip (`left_card`right_card`next_card`result)!(card1_display;card2_display;card3_display;(action;`$res));
    .now.current_deck:3_.now.current_deck;
    display
};
dont_punt:{x[0b]};
punt:{x[1b]};
reverse_card:{((`A`2`3`4`5`6`7`8`9`10`J`Q`K)!(1+til 13))[x]};
// prep
.now.pot:0;
.now.current_deck:shuffle[5];

// play
nextplay[0b]
punt[punt_check]
dont_punt[punt_check]

// Simulation
simulate:{[x;y]
    .now.current_deck:shuffle[x];
    sim:{nextplay[1b]} each til 1000;
    sim_tab:update reverse_card[left_card],reverse_card[next_card],reverse_card[right_card] from delete from (raze sim where (type each sim) = 98) where null diff;
    result:update state:?[next_card within (left_card+1;right_card+1);`Win;`Lose] from sim_tab;
    display:select cnt:count i by state from result;
    exec cnt from display
}; 

// Monte Carlo
func_each:{
    monte_carlo:simulate[100;] each til 100;
    loses:monte_carlo[;0];
    wins:monte_carlo[;1];
    winning_chances:(sum wins)%((sum loses)+(sum wins));
    .Q.f[2;winning_chances*100],"%"
};

func_peach:{
    monte_carlo:simulate[100;] peach til 100;
    loses:monte_carlo[;0];
    wins:monte_carlo[;1];
    winning_chances:(sum wins)%((sum loses)+(sum wins));
    .Q.f[2;winning_chances*100],"%"
};

