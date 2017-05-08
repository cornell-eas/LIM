function  newlons= lon360_180(lons360);
%newlons= lon360_180(lons);
%
%
%(AFRICA        INDIA        SE ASIA           PACIFIC                                  E. PACIFIC          S. AMERICA                                  ATLANTIC)
%EW-Notation:  [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180/-180 -170 -160 -150 -140 -130 -120 -110 -100 -90  -80  -70 -60 -50 -40 -30 -20 -10  0]
%360 notation: [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180       190  200  210  220  230  240  250  260 270  280  290 300 310 320 330 340 350 360]
%
%
newlons = lons360;
ind360 = find(newlons > 180);
newlons(ind360) = -[360-newlons(ind360)];

    