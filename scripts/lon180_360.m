function  newlons= lon180_360(lons180EW);
%newlons= lon360_180EW(lons);
%
%
%(AFRICA        INDIA        SE ASIA           PACIFIC                                  E. PACIFIC          S. AMERICA                                  ATLANTIC)
%EW-Notation:  [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180/-180 -170 -160 -150 -140 -130 -120 -110 -100 -90  -80  -70 -60 -50 -40 -30 -20 -10  0]
%360 notation: [10 20 30 40 50 60 70 80 90 100 110 120 130 140 150 160 170 180       190  200  210  220  230  240  250  260 270  280  290 300 310 320 330 340 350 360]


newlons = lons180EW;
indEW180 = find(newlons <0);
newlons(indEW180) = 360+newlons(indEW180);