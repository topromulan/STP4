pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- super turtle pong 4
-- 2016-2017 macrowave
-- https://github.com/topromulan/stp4
-- by timelime, professor nom, and timelime jr.

-- 
-- 
-- warning: the following
--   spaghetti code may  
--  contain meatballs or 
-- binary tree fragments,
--    and may have been  
-- processed by a machine
--    that is or also    
-- multi-processes nuts. 
-- 
-- 

function _init()
 do_intro()
 win_at_9()
 music_lover=true
 songs={1,5,11,15,19}
 next_song=1
 current_song=1
end

function _draw()
 draw_mode()
 
end

function _update()
  cycles+=1

  --fix bug when it wraps
  if(cycles<0) then
   cycles=1 
   if(oddball!=nil) service_time=0 
  end

  update_mode()
  
end

function do_intro()

 intro_ending=false
 intro_ending_at=nil

 --coordinates of planets l/r
 lx=40 ly=20
 rx=80 ry=20

 lcolor=4
 rcolor=3

 cycles=0

 yt=113 yb=117
 xl=15 xr=109

 --
 
 stplogoclr1=7
 stplogoclr2=5
 stplogoclr=stplogoclr1

 stplogosx=20 stplogosy=45
 stplogoswidth=15 stplogosheight=21
 stplogotx=40 stplogoty=50
 stplogotwidth=15 stplogotheight=21
 stplogopx=60 stplogopy=55
 stplogopwidth=15 stplogopheight=21

 -- 

 air=0 water=1 letter=11 wet=3

 rainline=yt-2
 rainfloor=rainline+12
 rainmemory={}
 for i=rainline,rainfloor+5 do
  rainmemory[i]={}
  for j=0,127 do
   rainmemory[i][j]=false
  end
 end
 
 update_mode=intro_update
 draw_mode=intro_draw

 menuitem(1,"2-player game",play_2p)
 menuitem(2,"ai vs ai match",play_ai_only)
 if(win==9) win_at_9() else win_at_2()

 game_init()
  
 cls(5)
end

function intro_update()
 newbtn_mgmt()
 
 if(intro_ending) then
  if(intro_ending_at==nil) then
   intro_ending_at=cycles+55
   sfx(10) sfx(11) schedule_sfx(17,21+flr(rnd(5)))
  end
  if(cycles>intro_ending_at) play_game()
  rainfloor+=0.11
  for x=1,50 do
   pset(10+rnd(104),rainfloor-rnd(),0)
  end
 end 

 for p=1,2 do
  if(newbtnp("o",p) or newbtnp("x",p)) then
   -- take money and begin exit
   if(ai[p]) ai[p]=false
   if(not intro_ending) intro_ending=true
   -- possibly exit quick
   if(newbtn("o",p) and newbtn("x",p)) then
    intro_ending_at=cycles+1
   end   
  end
 end


 lx+=1
 if(lx>200) lx=-200
 if(lx==50) then
  schedule_sfx(0,rnd(2)) 
  rx+=0.75 ry+=0.85
 end

 if(rx>85) then
  subx=1
 elseif(rx>80) then
  subx=0.6
 elseif(rx>75) then
  subx=0.4
 else
  subx=0
 end

 if(ry>25) then
  suby=1
 elseif(ry>20) then
  suby=0.6
 elseif(ry>15) then
  suby=0.4
 else
  suby=0
 end
 
 if(rnd()>0.975) rx+=rnd()-subx
 if(rnd()>0.985) ry+=rnd()-suby

 sound_effect_mgmt()
end

function intro_draw()
 rectfill(0,0,127,102,5)

 rd=30
 ld=32+sin(lx/1000)*20
 ratio=ld/rd
 circfill(lx,ly,ld,lcolor)
 s=player_sprites[1][1+flr(cycles/5)%7]
 sx=s*8%128
 sy=8*flr(s*8/128)
 sspr(sx,sy,8,8,lx-12*ratio,ly-24*ratio,24*ratio,24*ratio)

 circfill(rx,ry,rd,rcolor)
 if(lx>=51 and lx<=70) then
  s=player_sprites[2][6]
 else
  s=player_sprites[2][1+flr(cycles/5)%2]
 end
 sx=s*8%128
 sy=8*flr(s*8/128)
 sspr(sx,sy,8,8,rx-12,ry-20,24,24)

 print("1992-2017 macrowave",38,25,11) 

 local intro_left
 if(intro_ending and intro_ending_at!=nil) then
  intro_left=intro_ending_at-cycles
  stplogoclr=intro_left/2
  stplogosx-=rnd()
  stplogosy-=rnd()
  stplogoswidth+=rnd(0.75)
  stplogosheight+=rnd(0.75)
  stplogotx-=rnd()
  stplogoty+=rnd(0.5)
  stplogotwidth+=rnd(0.65)
  stplogotheight+=rnd(0.65)
  stplogopx-=rnd(0.5)
  stplogopy-=rnd()
  stplogopwidth+=rnd(0.55)
  stplogopheight+=rnd(0.55)
 else
 end
 
 mode="untamed"
 if(win==9) mode="classic 9-point"
 if(win==2) mode="best 2 outta 3"

 if(not intro_left) intro_left=55
 for i=0,#mode do
  print(sub(mode,i,i),
   stplogosx+1+i*(4+60/intro_left/4)+55/intro_left,
   stplogosy-11+i*7.5/(62-intro_left),
   10+#mode)
 end
 
 sspr(0,12,12,20,rnd(1.005)+stplogosx,stplogosy,stplogoswidth,stplogosheight)
 sspr(16,12,12,20,rnd(1.010)+stplogotx,stplogoty,stplogotwidth,stplogotheight)
 sspr(32,12,12,20,rnd(1.015)+stplogopx,stplogopy,stplogopwidth,stplogopheight)

 if(intro_ending) then
   print("uper",stplogosx+stplogoswidth,stplogosy+stplogosheight/2,stplogoclr)
   print("urtle",stplogotx+stplogotwidth*0.8,stplogoty+stplogotheight/2,stplogoclr)
   print("ong",stplogopx+stplogopwidth*0.9,stplogopy+stplogopheight/2,stplogoclr)
 end
 
 if(flr(cycles/30)%2!=0) print("insert money to play",8,90,6)
 if(rnd()<0.975) print("live",79+rnd(3),104+rnd(3),8)
 if(rnd()<0.975) print("live",79+rnd(3),104+rnd(3),8)
 if(flr(cycles/25)%2!=0) print("broadcasting live",28,105,11)

 if(cycles<15) print("from "..stadium_name,xl,yt,letter)

 
 
 for y=flr(rainfloor),rainline,-1 do
  for x=xl-4,xr+4 do
   above=pget(x,y-1)
   here=pget(x,y)
   result=here
   if(here==air) then
    if(water==above or wet==above) then
     result=water
    end
   elseif(here==water) then
    if(above!=water and above!=wet) then
     result=air
    end
   elseif(here==letter) then
    if(water==above or wet==above) then
     if(rnd()>0.65) then
      result=wet
     end
    end
   elseif(here==wet) then
    if(air==above or letter==above) then
     if(rnd()>0.65) then
      if(rainmemory[y][x]==false) then
       rainmemory[y][x]=true
       result=wet
      else
       rainmemory[y][x]=false
       result=letter
      end
     end
    end
   else
    result=here
   end

   pset(x,y,result)
  end 
 end

 for y=rainline,rainfloor do
  for x=xl-5,xr+5 do
   if(cycles<13) then
    coord={x-1+rnd(3),y-1+rnd(3)}
    if(pget(coord[1],coord[2])!=water) pset(coord[1],coord[2],0)
   end
  end
 end 
 
 for x=xl-4,xr+4 do
  if(rnd()<0.15 or (rnd()>0.02 and flr(cycles/150)%2==1)) then
   pset(x,rainline,1) -- rain
  end
 end

end

function play_game()
-- game_init() called during intro
 update_mode=game_update
 draw_mode=game_draw
 
-- menuitem(1,"direct deposit:",print)
 menuitem(1,"+1 "..pnames[1],point_p1)
 menuitem(2,"+1 "..pnames[2],point_p2)
 if(music_lover) love_music() else hate_music()
end

function game_init()
 players={}
 shieldx={-1,-1} --avoid error
 adjustedx=-1 adjustedy=-1

 oddball_sprites={11,12,13,29,45,44,43,27}

 players[1]={}
 players[2]={}

 ai={true,true}

 js={{num=1},{num=0}}

 newbtn_init()

 player_sprites={{9,25,41,57,56,55,54},{10,26,42,58,59,60,61}}
 
 scores={1,1}
 lead=0

 holding={false,false}

 winding_uppage={false,false}
 serve_powers={1,1}
 winding_dirs={1,1}

 names={
  { {"red","red","red","rouge","rusty","ruddy","redder","rosy","ruby","russet","big red","beet red"},
    {"ricky","ricky","ralf","rancid","remy","rebner","raggy","rose","ray","ruffguy","razor","ripple","rhine","roo","radagast"} },
  { {"purple","purple","purplish","p.","plum","perse","p-diddy"},
    {"pete","pete","page","paddy","padma","price","pinky","peppy","po-po","patty","press","poof","perp","pixel"} },
 }

 pnames={"fifteen chars!!","fifteen chars!!"}
 for p=1,2 do
  while(#pnames[p]>=15) do
   pnames[p]=names[p][1][1+flr(rnd(#names[p][1]))].." "..names[p][2][1+flr(rnd(#names[p][2]))]
  end
 end

 trophy_for_player1=false
 trophy_for_player2=false

 party_message=nil

 stadium_fans={80,81,82,83,84,85,86,87,88}

 stadium_audience={}

 stadium_name="turtle pong stadium"

 stadium_floor_top=25
 stadium_floor_height=32
 --regular floor
 rugcolorpairs={{2,14,false},{3,4,false},{1,13,false},{0,5,false},{12,13,false},{12,13,true}}
 rug=rugcolorpairs[1+flr(rnd(#rugcolorpairs))]

 stadium_floor_color1=rug[1]
 stadium_floor_color2=rug[2]
 stadium_floor_flicker=rug[3]

 stadium_seats={
  {8,25},{21,24},{34,23},{47,22},
  {65,22},{78,23},{91,24},{104,25},

  {14,34},{28,33},{42,32},
          {56,31},
  {70,32},{84,33},{98,34},
  
  {19,43},{33,42},{47,41},
  {61,41},{75,42},{89,43},
 }

 stadium_field_left=5
 stadium_field_right=122
 stadium_field_top=58
 stadium_field_bottom=119
 stadium_field_middle=0.5*(stadium_field_left+stadium_field_right)
 stadium_field_chalkcolor=7
 stadium_field_grasscolor=3
 stadium_field_goalzonewidth=15

 stadium_display_left=25
 stadium_display_right=102
 stadium_display_top=8
 stadium_display_bottom=29
 stadium_display_lightcolor=10
 stadium_display_woodcolor=1
 if(rnd()<0.66) stadium_display_woodcolor=2
 if(rnd()<0.63) stadium_display_woodcolor=13
 stadium_display_digit_width=12
 stadium_display_digit_height_max=17
 stadium_display_digit_heights={2,2}

 playersx={stadium_field_left+stadium_field_goalzonewidth-13,
  stadium_field_right-stadium_field_goalzonewidth+5}

 players[1].xmin=stadium_field_left-3
 players[1].xmax=stadium_field_left+stadium_field_goalzonewidth-5

 players[2].xmin=stadium_field_right-stadium_field_goalzonewidth-2
 players[2].xmax=stadium_field_right-4

 playersdx={0,0}
 playersdy={0,0}

 playersy={stadium_field_top+5,stadium_field_bottom-13}

 players[1].ymin=stadium_field_top-1
 players[1].ymax=stadium_field_bottom-8
 players[2].ymin=players[1].ymin
 players[2].ymax=players[1].ymax
 
 --seat the audience
 for seat=1,#stadium_seats do
  stadium_audience[seat]={}
  while(stadium_audience[seat].sprite==nil or stadium_audience[seat].sprite==stadium_audience[seat-1].sprite) do
   stadium_audience[seat].sprite=stadium_fans[1+flr(rnd(#stadium_fans))]
   if(seat==1 or rnd()<0.2) break   
  end
  if(rnd()>win/9) stadium_audience[seat].sprite=31
 end
 shuffle_audience_timing()

 upforgrabs=true
 service_time=cycles+25+rnd(10)
 oddball_dx=0 oddball_dy=0
 oddball_x=64
 oddball_y=64
 approaching_player=1

 help_flag=false
 
 ai_far_field=23
end

function set_player_pose(num,pose)
 if(players[num].stagger_effect == nil) players[num].stagger_effect=0
 if(players[num].stagger_effect>0) then
  players[num].stagger_effect-=1
 else
  players[num].sprite=player_sprites[num][pose]
 end
end

function player_service(num)
 playersdx[num]*=0.75
 playersdy[num]*=0.75
 if(upforgrabs and cycles>service_time+25+rnd(3.2) and newbtnp("o",num)) then
  --move it into player's hands
  upforgrabs=false
  oddball_dx=0 oddball_dy=0
  holding[num]=true
 elseif(holding[num]) then
  if(newbtn("o",num)) then
   --still winding up
   winding_uppage[num]=true
   player_windup(num)
  else
   --let it fly
   holding[num]=false
   winding_uppage[num]=false
   oddball_dx=-1*(-3+2*num)*(1+rnd(0.5)+serve_powers[num]/15)
   oddball_dy=0.1-rnd(0.2)
   --oddball_dx*=0.55 --for serve testing
   oddball_dx+=(0.1+rnd(0.1))*playersdx[num]
   reldx=playersdx[num]
   if(num==2) reldx*=-1
   if(reldx<-0.65) then
    oddball_dy+=3*playersdy[num]
   elseif(reldx<0) then
    oddball_dy+=2.25*playersdy[num]
   elseif(reldx==0) then
    oddball_dy+=2*playersdy[num]
   elseif(reldx<=0.8) then
    oddball_dy+=1.75*playersdy[num]
   else
    oddball_dy+=1.25*playersdy[num]
   end

   sfx(1+num) sfx(4,3)
   if(music_lover and not (ai[1] and ai[2])) play_song()
  end
 else
  --dancing?
 end
 set_player_pose(num,3)
end

function player_windup(num)
 if(serve_powers[num]==nil) serve_powers[num]=1

 serve_powers[num]+=winding_dirs[num]
 
 if(serve_powers[num]>10) then
  serve_powers[num]=10
  winding_dirs[num]=-3
 elseif(serve_powers[num]<1) then
  serve_powers[num]=1
  winding_dirs[num]=0.5
 end
 
end

function draw_windup()

 draw_it=false
 if(winding_uppage[1]) then
  draw_it=true draw_num=1 draw_clr=8
 elseif(winding_uppage[2]) then
  draw_it=true draw_num=2 draw_clr=2
 end
 
 windup_width=10
 wind_x1=stadium_field_middle-windup_width/2
 wind_x2=stadium_field_middle+windup_width/2 
 wind_y1=stadium_field_bottom-1
 wind_y2=127

 if(draw_it) then
  if(draw_num==1) then
   meter_left=wind_x1+1
   meter_right=wind_x1+(windup_width-1)*(serve_powers[draw_num]/10)
  else
   meter_left=wind_x2-(windup_width-1)*(serve_powers[draw_num]/10)
   meter_right=wind_x2-1
  end
  rectfill(wind_x1,wind_y1,wind_x2-1,wind_y2-1,14)
  rectfill(meter_left,wind_y1+1,meter_right,wind_y2-1,draw_clr)
  rect(wind_x1,wind_y1,wind_x2,wind_y2,15)
 else
  rectfill(wind_x1,stadium_field_bottom+1,wind_x2,126,5)
  print("vs",stadium_field_middle-3,122,15)
 end  
end


function game_update()
 -- original version:
 -- if(btnp(4)) then scores[1] += 1 end
 -- if(btnp(5)) then scores[2] += 1 end

 if(cycles>service_time) then
  if(ai[1] and ai[2]) then
   if(scores[1]>=win or scores[2]>=win) do_intro()
  end
  if(scores[1]>=win) then
   player_wins(1)
  end
  if(scores[2]>=win) then
   player_wins(2)
  end
 end
 
 if(stadium_floor_flicker) then
  super_important_t=stadium_floor_color1
  stadium_floor_color1=stadium_floor_color2
  stadium_floor_color2=super_important_t
 end

 
 for p=1,2 do
  set_player_pose(p,1+flr(rnd(1.05)))

  if(ai[p]) then
   ai_control(p)

   if(btn(5,0)) then   
    js[p].l=nil
    js[p].u=nil
    js[p].d=nil
    js[p].r=nil
   end
  end

  if((holding[p] or not newbtn("o",p))) then
   if(newbtn("l",p)) playersdx[p]-=0.35-rnd(0.05)
   if(newbtn("r",p)) playersdx[p]+=0.29+rnd(0.05)
   if(newbtn("u",p)) playersdy[p]-=0.35-rnd(0.03)
   if(newbtn("d",p)) playersdy[p]+=0.35+rnd(0.03)
  end
  if(not (newbtn("l",p) or newbtn("r",p))) playersdx[p]*=0.65
  if(not (newbtn("u",p) or newbtn("d",p))) playersdy[p]*=0.74
  --introduces a waver when not hanging onto the paddle
--  if(band(shr(btn(),(p%2)*8),2^0+2^1+2^2+2^3)==0) then
  if(not (newbtn("l",p) or newbtn("r",p) or newbtn("u",p) or newbtn("d",p))) then
   playersdx[p]*=(0.7+rnd(0.6))
   playersdy[p]*=(0.7+rnd(0.6))
   if(rnd()<playersdx[p]) playersdx[p]*=-1
  end 
   
  threshold=0.25
  if(abs(playersdx[p])<threshold
    and abs(playersdy[p])<threshold) then
   players[p].moving=false
   playersdx[p]=0
   playersdy[p]=0
  else
   players[p].moving=true
  end
  
  if(players[p].moving) then
   set_player_pose(p,1+flr(rnd(2)))

   if(playersdx[p]>0.75) playersdx[p]=0.75
   if(playersdx[p]<-0.89) playersdx[p]=-0.89
   if(playersdy[p]>1.25) playersdy[p]=0.95
   if(playersdy[p]<-1.25) playersdy[p]=-0.95

   playersx[p]+=playersdx[p]
   playersy[p]+=playersdy[p]
  end

  if(newbtn("o",p) or winding_uppage[p]) player_service(p)
  if(holding[p]) then
   if(newbtn("o",p)) poke(0x36c8,serve_powers[p]*5)

   if(newbtnp("o",p)) sfx(18,3)
  end  
 end

 if(upforgrabs) then
  if(service_time-cycles<12) music(-1)
  oddball_x=(stadium_field_left+stadium_field_right)/2-4
  oddball_y=(stadium_field_top+stadium_field_bottom)/2-4
 elseif(holding[1]) then
  oddball_x=playersx[1]+6
  oddball_y=playersy[1]+1
 elseif(holding[2]) then
  oddball_x=playersx[2]-6
  oddball_y=playersy[2]+1
 else
  oddball_x+=oddball_dx
  oddball_y+=oddball_dy
 end

 slope_a_dope=oddball_dy/oddball_dx if(approaching_player==2) slope_a_dope*=-1
 dope_num=approaching_player
 adjustedx=oddball_x+flr(3.5+rnd())
 adjustedy=oddball_y+flr(3.5+rnd())
 shieldx={playersx[1]+6,playersx[2]+1}

 --if ai vs ai lead will be p2 lead
 --doesn't matter whatever
 lowspeed=1.3234-lead/10
 highspeed=4.2

 force_multiplier=-1*(1.05-lead/150)-(cycles-service_time)/10000 
 
 if(abs(adjustedx-shieldx[dope_num])<3) then
  --check for paddle impact

  shieldhity1=playersy[dope_num]-3
  shieldhity2=playersy[dope_num]+8
  
  dope_offset=flr(0.5+adjustedy-shieldhity1)

  if(adjustedy>=shieldhity1 and adjustedy<=shieldhity2) then
   if(not players[approaching_player].dancing) then
    --collision
    printh("p"..dope_num.." at "..cycles)
    printh(" odx="..oddball_dx.." ody="..oddball_dy)
    printh(" low "..lowspeed.." hi "..highspeed)
    printh(" fm="..force_multiplier)
    oddball_dx*=force_multiplier
    if(dope_offset<2.1) then
     oddball_dy-=1.8+rnd(0.4)
    elseif(dope_offset<4.1) then
     oddball_dy-=0.25
     oddball_dy*=1.2
    elseif(dope_offset<8) then
     oddball_dy*=0.5
     oddball_dy+=-0.2+rnd(0.4)
    elseif(dope_offset<10) then
     oddball_dy+=0.25
     oddball_dy*=1.2
    else
     oddball_dy+=1.8+rnd(0.4)
    end
   else
    --they screwed up boooo
    sfx(8) sfx(9)
   end

   if(approaching_player==1 and playersdx[approaching_player]<0
     or approaching_player==2 and playersdx[approaching_player]>0) then
    oddball_dx+=0.2*playersdx[approaching_player] 
   else
    oddball_dx+=(0.05+rnd(0.05))*playersdx[approaching_player]
   end
   if(abs(lead)>3) lowspeed*=0.75
   if(abs(oddball_dx)<lowspeed) oddball_dx=lowspeed*(oddball_dx/abs(oddball_dx))
   if(abs(oddball_dx)>highspeed) oddball_dx=highspeed*(oddball_dx/abs(oddball_dx))
   oddball_dy+=0.45*playersdy[approaching_player]

   shuffle_audience_timing()
   
   if(slope_a_dope>0.15 or dope_offset>9.9) then
    set_player_pose(approaching_player,5)
   elseif(slope_a_dope<-0.15 or dope_offset<2.1) then
    set_player_pose(approaching_player,4)
   else
    set_player_pose(approaching_player,3)
   end
   players[approaching_player].stagger_effect=35
   sfx(1+approaching_player)
   --glancing blows
   --extra oomph
   if(not players[approaching_player].moving and newbtn("o",approaching_player)) then oddball_dx*=1.1 sfx(0) end   
  end
 end

 approaching_player=1 if(oddball_dx > 0) then approaching_player=2 end 

 yadjust={0,-6}
 effective_top=stadium_field_top+yadjust[1]
 effective_bottom=stadium_field_bottom+yadjust[2]
 dope_diff=effective_top-oddball_y
 local out_of_bounds --shorter than out_of_bounds=false!
 if(dope_diff>0) then
  out_of_bounds=true
  oddball_y=effective_top+dope_diff
 end
 dope_diff=oddball_y-effective_bottom
 if(dope_diff>0) then
  out_of_bounds=true
  oddball_y=effective_bottom-dope_diff
 end
 if(out_of_bounds) oddball_dy*=-0.75-rnd(0.2)

 --score!! goal!!
 if(oddball_x<stadium_field_left-4 or oddball_x>stadium_field_right-3) then
  if(oddball_x>stadium_field_middle) then
   scoring_player=1
  else
   scoring_player=2
  end
  scores[scoring_player]+=1
  stadium_display_digit_heights[scoring_player]=2
  schedule_sfx(1,7)--lets clapping begin first
  upforgrabs=true
  oddball_x=64 oddball_y=85 --approximately in the middle so ai returns to midfield
  service_time=cycles+45+rnd(10)
  if(scores[1]<win and scores[2]<win) then
   poke(0x3681,60+flr(rnd(30)))
   sfx(16)
   schedule_sfx(16,2)
   if(rnd()<0.15) schedule_sfx(17,5)
  else
   --winner winner chicken dinner 
   music(-1)
   players[scoring_player].dancing=true
   schedule_sfx(10,10) schedule_sfx(11,11)
   poke(0x3681,80)--3241+10*44
   sfx(16)
   poke(0x36c5,180)
--   schedule_sfx(17,20) --only if compress music into a 3track
  end
  players[scoring_player].dancing=true
 end

 sound_effect_mgmt()
 newbtn_mgmt()

end

function shuffle_audience_timing()
 for i=1,#stadium_audience do
  stadium_audience[i].timing=-19+flr(rnd(39))
 end
end

function game_draw()
 cls()
 rect(0,0,127,127,5) --

 msgv=stadium_name
 clrv=15
 if(rnd()<0.2 and cycles%2==0) clrv=7
 print(msgv,64-2*#msgv,2,clrv)

 draw_field() 
 draw_scoreboard()
 draw_floor(stadium_field_middle,stadium_floor_top,stadium_floor_height)
 draw_names()
 
 exitx=(stadium_display_left+stadium_display_right)/2-12
 exity=stadium_display_bottom-25
 draw_door(exitx,exity+3) --just adding a little length
 draw_door(exitx,exity)

 draw_audience()
 draw_player(1)
 draw_player(2)
 draw_oddball()
 draw_windup()

 if(scores[1]==0 and scores[2]==0) then
  clrv=(flr(cycles/25)%2+5)
  if(upforgrabs and cycles-intro_ending_at>125) then
   help_flag=true
   msgv="(hold  to serve)"
   print(msgv,stadium_field_middle-2*#msgv,stadium_field_bottom-15,clrv)   
  end
  if(help_flag and (holding[1] or holding[2]) and cycles-intro_ending_at>145) then
   msgv="(let that turtle fly!))"
   print(msgv,stadium_field_middle-2*#msgv,stadium_field_bottom-22,clrv)
   msgv="     watch | that meter"
   print(msgv,stadium_field_middle-2*#msgv,stadium_field_bottom-13,clrv)
   msgv="|"
   print(msgv,stadium_field_middle-2*#msgv,stadium_field_bottom-8,cycles%16+rnd(3))
   msgv="v"
   print(msgv,stadium_field_middle-2*#msgv,stadium_field_bottom-6,4+cycles%5)
   
   if(winding_uppage[1]) then
    if(winding_dirs[1]>2) winding_dirs[1]=2
    if(winding_dirs[1]<-0.5) winding_dirs[1]=-0.5
   elseif(winding_uppage[2]) then
    if(winding_dirs[2]>2) winding_dirs[2]=2
    if(winding_dirs[2]<-0.5) winding_dirs[2]=-0.5
   end
  end
 end
end


function draw_field()
 rectfill(stadium_field_left, stadium_field_top,
  stadium_field_right,stadium_field_bottom,
  stadium_field_grasscolor)
 rect(stadium_field_left, stadium_field_top,
  stadium_field_right,stadium_field_bottom,
  stadium_field_chalkcolor)
 rect(stadium_field_left, stadium_field_top,
  stadium_field_left+stadium_field_goalzonewidth,
  stadium_field_bottom, stadium_field_chalkcolor)
 rect(stadium_field_right, stadium_field_top,
  stadium_field_right-stadium_field_goalzonewidth,
  stadium_field_bottom, stadium_field_chalkcolor)
 print("stp",
   (stadium_field_left+stadium_field_right)/2-5,
   (stadium_field_top+stadium_field_bottom)/2-3)
end   

function draw_player(num)
--this should be in game_update
-- or its own function called
-- from game_update (player_update()?)
 if(players[num].dancing) then
  if(players[num].started_dancing==nil) players[num].started_dancing=cycles
  
  if(cycles-players[num].started_dancing<9) then
   players[num].stagger_effect=nil
   set_player_pose(num,6)
   players[num].stagger_effect=15
  elseif(cycles-players[num].started_dancing<25) then
   players[num].stagger_effect=nil
   set_player_pose(num,7)
   players[num].stagger_effect=8
  elseif(cycles-players[num].started_dancing<32) then
   --noop
  else
   players[num].started_dancing=nil
   players[num].dancing=false
  end 
 else
--  set_player_sprite(num,player_sprites[num][1+flr(rnd(2))])
 end

 if(playersx[num]<players[num].xmin) playersx[num]=players[num].xmin
 if(playersy[num] < players[num].ymin) playersy[num]=players[num].ymin
 if(playersx[num] > players[num].xmax) playersx[num]=players[num].xmax
 if(playersy[num] > players[num].ymax) playersy[num]=players[num].ymax

 spr(players[num].sprite,playersx[num],playersy[num])
 if(ai[num]) print("ai",playersx[num]+1,playersy[num]-7,7)

-- print(num,playersx[num]+3,playersy[num]+9,7) 

end

function draw_oddball()
 if(upforgrabs) then
  oddball_sprite=oddball_sprites[2]
 elseif(holding[1]) then
  oddball_sprite=oddball_sprites[1+flr(cycles/5)%3]
 elseif(holding[2]) then
  oddball_sprite=oddball_sprites[5+flr(cycles/6)%3]
 else
  oddball_sprite=oddball_sprites[1+flr(cycles/3.3)%8]
 end

 if(cycles>service_time) spr(oddball_sprite,oddball_x,oddball_y)
end

function draw_scoreboard()
 coords={}
 coords[1]={}
 coords[2]={}
 coords[1].x=stadium_display_left+2
 coords[1].y=stadium_display_top+2
 coords[2].x=stadium_display_right-2-stadium_display_digit_width
 coords[2].y=stadium_display_top+2
 
 rectfill(stadium_display_left,stadium_display_top,
  stadium_display_right, stadium_display_bottom,
  stadium_display_woodcolor)

 for i=1,2 do
  if(scores[i]==0) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
  end 
  if(scores[i]==1) then
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==2) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==3) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==4) then
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==5) then
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==6) then
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==7) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(scores[i]==8) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
  end 
  if(scores[i]==9) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y,stadium_display_lightcolor)
  end 

  if(stadium_display_digit_heights[i]<stadium_display_digit_height_max) then
   stadium_display_digit_heights[i]+=1
  end
 end
end

function draw_names()
 print(pnames[1],2,121,8)
 print(pnames[2],127-4*#pnames[2],121,2)
end

function draw_floor(middle,top,height)
 for i=1,height do
  if(i<8) then
   the_rad=15+i^2
   if(the_rad>60) the_rad=62
  else
   the_rad=60-1.5*(i%3)-i/10
  end
  l=middle-the_rad
  r=middle+the_rad
  h=top+i
  line(l,h,r,h,stadium_floor_color1)
  for j=l+2,r-2,4 do
   c=stadium_floor_color2
   --blink red when win!
   if((scores[1]>=win or scores[2]>=win) and flr(cycles/15)%2==0) then
    c=8
   end
   line(j,h,j+1,h,c)
  end
 end
end

function draw_door(exitx,exity)
 ul_sprite=73
 ulsx=(ul_sprite%16)*8
 ulsy=(flr(ul_sprite/16)*8)

 sspr(ulsx,ulsy,24,24,exitx,exity)
 print("exit",exitx+5,exity+5,15)
  
end

function draw_audience()
 for seat=1,#stadium_seats do
  seatx=stadium_seats[seat][1]
  seaty=stadium_seats[seat][2]
  spr(6,seatx,seaty,2,2)
  --draw each audience member in 
  -- their seat, facing the ball
  fan_sprite=stadium_audience[seat].sprite
  if(oddball_x < seatx+stadium_audience[seat].timing) fan_sprite-=16
  if(oddball_x > seatx+8+stadium_audience[seat].timing) fan_sprite+=16
  spr(fan_sprite,seatx+4,seaty+3)
 end
end

function player_wins(num)
 if(num==1) then
  trophy_for_player1=true
 elseif(num==2) then
  trophy_for_player2=true
 end
 update_mode=party_update
 draw_mode=party_draw
 party_started=flr(cycles)+1
 menuitem(1) menuitem(2) menuitem(3)

 if(party_message==nil and num==1) then
  if(ai[1]) aicredit=" (ai)" else aicredit=""
  party_message=pnames[1]..aicredit.." wins"


  plaque_color=8
 elseif(party_message==nil and num==2) then
  if(ai[2]) aicredit=" (ai)" else aicredit=""
  party_message=pnames[2]..aicredit.." wins"
  plaque_color=2
 else
  party_message="everybody wins!!"
  plaque_color=4
 end
 party_update()
 compliments={"stellar","first place","electric","like a ninja","epic","rad","top notch"," zen-like ","pico-riffic"}
 adjective=compliments[1+flr(rnd(#compliments))]

 per=4+flr(rnd(3.5)) -- a mysterious global variable
end


function party_update()
 party_time=cycles-party_started

 if(party_time>120
   or party_time>10 and (
    (trophy_for_player1 and newbtn("x",1) and newbtn("o",1))
    or (trophy_for_player2 and newbtn("x",2) and newbtn("o",2))
  )) then do_intro() end

 if(party_started==cycles-5) music(0)
 
 sound_effect_mgmt()
 newbtn_mgmt()
end

function party_draw()
 cls(5)

 draw_floor(80,65,63)
 draw_door(70,44)
 
 party_p=1.1*(8+party_time/12)

 for i=1,#stadium_audience do
  z=stadium_audience[i].sprite+32
  row=1+flr(i/per)
  col=i%6
  sspr(z*8%128,8*flr(z*8/128),8,8,
   60+party_p-5*row+
    (i%per)*((360-(10-row)*30)/party_p)
    , --x
   59-party_p/12+row*(8-row),--y
   20/party_p*(row*per),--w
   20/party_p*(row*per),--h
   ((cycles+flr(stadium_audience[i].timing))%3==0)--x flip
  )
 end
 party_drapes_draw()

 if(flr(cycles/3.1)%2==0) then
  clr1=4 clr2=9
 else
  clr1=9 clr2=4
 end

 rectfill(7,11,65+4*#adjective,33,5)
 rect(7,11,65+4*#adjective,33,9)
 if(party_time>10) print("thanks for playing",10,15,clr1)
 if(party_time>20 and flr(cycles/20)%2==0) print("that was "..adjective.."!!",13,23,clr2)

 plaquexy={}
 plaquexy[1]=42-2*#party_message
 if(plaquexy[1]<2) plaquexy[1]=3
 plaquexy[2]=40-0.12*#party_message
 if(party_time>38) then
  tcolor=15
  if(party_time>42) rectfill(plaquexy[1],plaquexy[2],plaquexy[1]+2+4*#party_message,plaquexy[2]+8,plaque_color)
 else
  if(flr(cycles/1.5)%2==0) tcolor=15 else tcolor=plaque_color
 end

 print(party_message,plaquexy[1]+2,plaquexy[2]+2,tcolor)

 for party_p=1,2 do
  if(party_p==1 and trophy_for_player1 or
     party_p==2 and trophy_for_player2) then
   s1234=player_sprites[party_p][1+cycles%6]
   sx1234=s1234*8%128
   sy1234=8*flr(s1234*8/128)
   px1234=128*(party_time/125)
   if(party_p==2) then px1234=128-px1234 end --so player 2 comes from r
   py1234=100-party_time/20+50*sin(party_time/cycles)
   sspr(sx1234,sy1234,8,8,px1234,py1234,48+rnd(2),48+rnd(2))
  end
 end
end

function party_drapes_draw()
 for y1234=0,127 do
  for x1234=0,127 do
   if(y1234>party_line1(x1234)) pset(x1234,y1234,party_fn(x1234,y1234))
   if(y1234<party_line2(x1234)) pset(x1234,y1234,party_fn(x1234,y1234))
  end
 end
 for x1234=0,127 do
  pset(x1234,party_line1(x1234),15)
  pset(x1234,party_line2(x1234),11)
 end
end

function party_line1(x)
 return(1.5*x+40*cos(cycles/100))
end
function party_line2(x)
 return(0.5*x-30*sin(1/cycles))
end
function party_fn(x,y)
 return((cycles/8+x*y)%16)
end

function sound_effect_mgmt()
 if(scheduled_sfx==nil) scheduled_sfx={}
 foreach(scheduled_sfx,
  function(x)
   if(cycles>=x[2]) then
    sfx(x[1])
    del(scheduled_sfx,x)
   end
  end
 )
end
function schedule_sfx(s,o)
 add(scheduled_sfx,{s,cycles+o})
end

function newbtn_init()
 for p=1,2 do
  for b=0,5 do
   if(btn(b,js[p].num)) then
    --false is a reminder that it
    -- was already pressed at init
    js[p][newbtn_conv(b)]=false
   else
    js[p][newbtn_conv(b)]=nil
   end
   --it will only be used if ai
   --but why check. because the
   --joystick wrapper ai vs
   --human is backwards, btnp
   --uses this hack for the
   --case where it is important
   --that the ai btnp like for
   --the windup sound.
   js[p].pflags={}
  end
 end
end

function newbtn_conv(x)
 js_mappings={
  {0,"l"},{1,"r"},{2,"u"},{3,"d"},
  {4,"o"},{5,"x"}
 }
 for i=1,#js_mappings do
  if(x==js_mappings[i][1]) return js_mappings[i][2]
  if(x==js_mappings[i][2]) return js_mappings[i][1]
 end
end

function newbtn_mgmt()
 for p=1,2 do
  for b=0,5 do
   if(ai[p] and update_mode==game_update) then
    if(js[p][newbtn_conv(b)]) then
     if(js[p][newbtn_conv(b)]>0) then
      js[p][newbtn_conv(b)]=js[p][newbtn_conv(b)]-1 --why not -=1 work (??)
     else
      js[p][newbtn_conv(b)]=nil
     end
    end
    for k,v in pairs(js[p].pflags) do
     if(v==true) v=nil
     if(v==false) js[p].pflags[k]=true
    end
   else
    m=newbtn_conv(b)
    if(btn(b,js[p].num)) then
     if(js[p][m]) then
      js[p][m]+=1
     else
      js[p][m]=0
     end
    else
     js[p][m]=nil
    end
   end
  end
 end

 --debatable
 if(players[p]) then
  if(js[p].l and js[p].r) then
   if(js[p].l>js[p].r) js[p].r=nil else js[p].l=nil
  end
  if(js[p].u and js[p].d) then
   if(js[p].u<js[p].d) js[p].d=nil else js[p].u=nil
  end
 end
 
end

function newbtn(b,p)
 if(js[p][b]) return true
 return false
end

function newbtnp(b,p)
 if(newbtn(b,p)) then
  if(js[p][b]==0) return true
  if(js[p].pflags[b]) return true
 end 
end

function ai_control(p)
 midfield=0.5*(stadium_field_top+stadium_field_bottom)-11+rnd(9)
 if(p==1) midzone=stadium_field_left+4 else midzone=stadium_field_right-10
 distance=abs(shieldx[p]-adjustedx)
 slope={oddball_dy*(0.95+rnd(0.04)),oddball_dx*(0.9+rnd(0.09))}
 slope.a=slope[1]/slope[2]
 top=stadium_field_top bottom=stadium_field_bottom
 height=bottom-top
 direction=oddball_dx/abs(oddball_dx)
 if(p==1) then
  backwards="l" forwards="r"
 else
  backwards="r" forwards="l"
 end
 coming=true if(p!=approaching_player) coming=false

 lead=scores[p]-scores[1+p%2]
 availability=cycles-service_time
 if(upforgrabs
   and (
    availability>80+10*lead and rnd()<0.025
    or lead<0 and availability>15 and rnd()<0.01
    or ai[1] and ai[2] and rnd()<0.005
  )
   and (
    ai[1] and ai[2]
    or not (scores[1]+scores[2]==0)
  ))
    then
  js[p].o=15+flr(rnd(10))
  js[p].pflags["o"]=false
  serve_strategy={
   chance1=rnd(0.1),
   chance2=rnd(0.3),
  }
  serve_strategy.dir1=forwards if(rnd()<0.15) serve_strategy.dir1=backwards
  serve_strategy.dir2="u" if(rnd()<0.65) serve_strategy.dir2="d"
 end   

 if(holding[p]) then
  --execute ai service strategy
  if(js[p].o and js[p].o<5) then
   if(rnd()<0.7-serve_strategy.chance1) js[p][serve_strategy.dir1]=2
   if(rnd()<0.5-serve_strategy.chance2) js[p][serve_strategy.dir2]=2
  else
   if(rnd()<serve_strategy.chance1) js[p][serve_strategy.dir1]=1
   if(rnd()<serve_strategy.chance2) js[p][serve_strategy.dir2]=1
  end
   
 elseif(upforgrabs or holding[p%2+1] or not coming) then
  --amble toward midfield
  if(playersy[p]<midfield-rnd(15) and rnd()<0.15) js[p]["d"]=flr(rnd(3))
  if(playersy[p]>midfield+rnd(15) and rnd()<0.15) js[p]["u"]=flr(rnd(3))
  --somewhat toward the ball
  if(playersy[p]<oddball_y-2 and rnd()<0.01) js[p]["d"]=3
  if(playersy[p]>oddball_y+2 and rnd()<0.01) js[p]["u"]=3

  if(playersx[p]<midzone-1+rnd(2) and not js[p].l) js[p].r=2
  if(playersx[p]>midzone+1-rnd(2) and not js[p].r) js[p].l=2
  if(upforgrabs) then
   playersdy[p]*=0.5
   playersdx[p]*=0.25
  end
  players[p].thinking=nil
 else
  yprojection=adjustedy+slope[1]*(distance/abs(slope[2]))
  gap=abs(playersy[p]-yprojection-1)
  if(distance>ai_far_field) then
   --sizing it up faraway
   if(rnd()>0.94) then --tend to back up
    js[p][backwards]=flr(rnd(3))
   elseif(rnd()>0.98) then
    js[p][forwards]=flr(rnd(2))
   end
   if(not players[p].thinking) then
    players[p].thinking=5+flr(rnd(7.5))
   elseif(players[p].thinking>0) then
    players[p].thinking-=1
    if(not (js[p].u or js[p].d)) then
     if(adjustedy<playersy[p]) then
      if(rnd()>0.25) js[p].u=2
     else
      if(rnd()>0.25) js[p].d=2
     end
    end
   else
    if(yprojection<top-2 or yprojection>bottom+2) then
     if(oddball_dy<0) then
      to_wall=adjustedy-stadium_field_top
      overage=stadium_field_top-yprojection
     else
      to_wall=stadium_field_bottom-adjustedy
      overage=yprojection-stadium_field_bottom
     end
     bounces=1+flr(abs(overage)/height)
     newyproj=overage%height
     if((bounces%2==1 and oddball_dy>0)
       or (bounces%2==0 and oddball_dy<0)) then
      newyproj=height-newyproj
     end
     newyproj+=stadium_field_top
    else
     newyproj=yprojection
    end
    if(playersy[p]>newyproj) then
     js[p].u=5 js[p].d=nil
    else
     js[p].d=5 js[p].u=nil
    end   
   end

  else
   -- near field
   hands_y=playersy[p]+3
   nearyproj=yprojection
   if(yprojection<stadium_field_top-1 or yprojection>stadium_field_bottom+5 or yprojection<stadium_field_top-5) nearyproj=midfield
   if(gap>2 and distance<15) then
    js[p][forwards]=nil
    js[p][backwards]=2
   else
    if(rnd()>0.74) then --tend to run for it
     js[p][forwards]=3
    elseif(rnd()>0.93) then
     js[p][backwards]=2
    end    
   end
   if(hands_y>nearyproj-1) then
    js[p].u=2
   elseif(hands_y<nearyproj-5) then
    js[p].d=3
   end

   if(distance>7*abs(oddball_dx) and distance<8.1*abs(oddball_dx)) then
    if(gap<2) then
     js[p].o=10
    end
   end
   
  end
  
 end
end

function point_p1()
 point_p(1)
end
function point_p2()
 point_p(2)
end

function point_p(p)
 scores[p]+=1
 stadium_display_digit_heights[p]=5+p+rnd(4)
 sfx(19) sfx(flr(20+rnd(5)))
end

function play_2p()
 for p=1,2 do
  ai[p]=false
 end
 intro_ending=true
end

function play_ai_only()
 for p=1,2 do
  ai[p]=true
 end
 intro_ending=true
 intro_ending_at=cycles
end

function win_at_2()
 win=2
 menuitem(3,"classic 9-point game",win_at_9)
 game_init()
end

function win_at_9()
 win=9
 menuitem(3,"best 2 out of 3",win_at_2)
 game_init()
end

function love_music()
 music_lover=true
 menuitem(3,"no music",hate_music)
 if(not upforgrabs and not holding[1] and not holding[2]) play_song()
end

function hate_music()
 music_lover=false
 menuitem(3,"music on",love_music)
 music(-1)
end

function play_song()
 music(next_song)
 last_song=next_song
 while(last_song==next_song) do
  next_song=songs[1+flr(rnd(#songs))]
 end
end


__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000888800002220000000000000088000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000fff000001ff0000084000000044000000008800000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000fff0c008fff0000844b400004bb400004b44800000000000000000
000a70000000000000000000000000000000000000000000000000000000000000000000000bb0c0080bb00000033b4000b33b0004b344000000000000000000
0007a0000000000000000000000000000000000000000000000000555500000000000000000bb6c0084bb00000b33b0000b33b0000b33b000000000000000000
007007000000000000000000000000000000000000000000000055555555000000000000000bb0c0080bb000004bb000004bb400040bb4000000000000000000
000000000000000000000000000000000000000000000000000955555555900000000000000560c0080600000000400000004000000040000000000000000000
00000000000000000000000000000000000000000000000000095555555590000000000000056000000650000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000095555555590000000000000888800002220000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000095555555590000000000000fff000001ff0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000099555555990000000000000fff0c008fff000004bb40000000000004bb4000000000000000000
000000000000000000000000000000000000000000000000000099999999000000000000000bb0c0080bb00084b33b400000000000b33b480000000000000000
0000eeee8880000000444444aaa0000000bbbbbbe000000000000a0000a0000000000000000bb6c0084bb00084b33b000000000004b33b480000000000000000
000eeeee8888000004444444aaaa00000bbbbbbbee000000000000000000000000000000000bb0c0080bb000004bb40000000000004bb4000000000000000000
00eeeeee8888000004444444aaaa00000bbbbbbbeee00000000000000000000000000000000650c0080060000000000000000000000000000000000000000000
00eeeeee8880000000444444aaa000000bbbbbbbeee0000000000000000000000000000000065000000560000000000000000000000000000000000000000000
0cccc000000000000000eeee40000000088880004444000000000000000000000000000000088880000222000000000000000000000000000000000000000000
0ccc0000000000000000eeee400000000888800004440000000000000000000000000000000fff000001f1000000000000004000000000000000000000000000
0ccc0000000000000000eeee400000000888800004440000000000000000000000000000000fffc0080fff000004b400004bb4000004b0000000000000000000
0cccc000000000000000eeee400000000888800044440000000000000000000000000000000bb0c00800bb0000033b4000b33b0000433b400000000000000000
00cccccc400000000000eeee400000000888888844400000000000000000000000000000000bb6c0084bb00000b33b0000b33b0000b33b000000000000000000
00cccccc440000000000eeee40000000088888884440000000000000000000000000000000bb00c0080bb0000844b000004bb4000004b4880000000000000000
000ccccc444000000000eeee400000000888888844000000000000000000000000000000000600c0080560000880400000044000000004800000000000000000
0000cccc444000000000eeee40000000088888884000000000000000000000000000000000065000000065000000000000088000000000000000000000000000
00000000eeee000000004444a00000000cccc0000000000000888800000888000008880008888000022220000002220000022200000222000000000000000000
000000000eee000000004444a00000000cccc000000000000c0fff000002f2000000f88c8fff0c00001ff0008000ff000021f100000ff1000000000000000000
000000000eee000000004444a00000000cccc000000000000c0fff00000ddf00000fffc00fff00c000f88000880fff0000088f00000fff000000000000000000
00000000eeee000000004444a00000000cccc000000000000c6bb00000dccd60000bb0c0000bb0c000880000080ff00004888840000bb0000000000000000000
00444444eee0000000004444a00000000cccc000000000000c0bb05000dccd00000bb6c0000bb6c0088bb400088bb40000888800000bb4000000000000000000
04444444eee0000000004444a00000000cccc000000000000c00bb6000dccd60065bb0c0000bb0c0880bb0000088b00000888860088888800000000000000000
04444444ee00000000004444a00000000cccc0000000000000006000000dd05000005c000000556c800560000008060000088050008888000000000000000000
00444444e0000000000004440000000000cc00000000000000056000005600000006000000005600000560000005050000560000000505000000000000000000
00030000000404000000000004444440040040000000000007404070004444003330330000000000000000000000000006666666666600000900000900000000
002222000044440009999900065555600744770000aaaa0007444470111111003333333000000000000000000000000066077000000600000999999900222220
077772200664660a9a77a9900655b5607c77cc700c1ac1a00999977011ff1100377773300000000000000000000000006007070000066000099c9c99022fff22
0c7c72200d64d60a0cddcc006555bb567c77cc7001ca1ca00199190000eef4003474730000005555555555555555000060000700000666000099e99002cfffc2
02222220004444a000aaaae06555cb5677aaa74409999a990411b4400f999ff00f8ff0000000533333333333333500006000700600666000909999900ffeffff
02222220009aa9a0e9e99e9e6555bb5645aa55440a99aaa04bd3b4940099990000f5fb0000005333333333333335000060000006666000009099999008888800
02222220099aa990e999999e6555b556455555a40aaaaaa04943d4940044440000bbbb0000005333333333333335000066007006663033009999999088888880
0055220004999940dd8008dd066666600aa55aa0009009005051150501101100000000000000533333333333333500000666666603333330009999900c000c00
00003000004004a00000000004444440004004000000000070400407004444000333033000005333333333333335000000000000333333330900000900000000
00222200004444a009999990065555600774477000aaaa0070444407011111103333333300545333333333333335450000000000337777330999999900222220
022222200066660099a77a990655b5607cc77cc70c1aac1007999970011ff1103377f7730044533333333333333544000000000003474730099c9c99022fff22
02777720006dd60000cddc006555b5567cc77cc701caa1c00019910000feef000374f470004455555555555555554400aa00000000f8ff00009e999002fcffc2
027cc720004444000eaaaae06555c556477aa7749a9999a904b11b400f9999f000ff8f00004466666666666666664400a0aaaa00000f5fb0909999900ffffeff
02222220009aa9a0e9e99e9e6555b556455aa5540aa99aa049bd3b940f9999f000bf5f00004466666666666666664400a0aa000aa000bbb09099999008888800
02222220099aa990e999999e6555b556455555540aaaaaa04943d4940044440000bbbb00004466666666666666664400a0aaa0a00aaa00009999999088888880
0025520004499440dd8008dd066666600aa55aa000900900505115050110011000000000004466666666666666664400aaaa000a00a00000009999900c000c00
000003000040400000000000044444400004004000000000074004700044440000333033004466666666666666664400000aaa00a0a0aa000900000900000000
002222000044440000999990065555600077477000aaaa00074444700041111103333333004466666666666666664400000000aa00a000000999999900222220
02277770a066466009a77a990655556007cc77c70ac1ac100779999000411f1103377773004466666666666666664400000aa0000aaa0000099c99c9022fff22
0227c7c0a06d46d0009cddc06555b55607cc77c70a1ca1c000919910004fee000337474300446666666666666666440000a00aa00000000000999e9002fcfcf2
022222200a4444000eaaaae0655bc556447aaa7499a99990044b11400ff999f0033ff8f000446666666666666666440000a00a0a00008000909999900fffefff
02222220009aa900e9e99e9e655bb5564455aa540aaa99a0494bd3b40099990000bf5f0000446666666666666666440000a0aa0a000008009099999008888800
02222220099aa940e999999e6555b5564a5555540aaaaaa04943d4940044440000bbbb00004466666666666666664400888aaa8a888888809999999088888880
0022550004999990dd8008dd066666600aa55aa00090090050511505001101100000000000446666666666666666440000000a0a00000800009999900c000c00
00030000004004000000000004444440004004000000000070400407000020000333033000446666666666666666440000000000000080009000090000000000
002222000044440009999990065555600444444000aaaa00704444070044440033333333004466666666666666664400a0aaa00aaaa0aaa09999990000222220
02222220004444009999999906555560444444440aaaaaa00774477001444410333333330044066666066606666044000a0aa00a0aa0aa0a9999999002222222
0222222000444400009999006555b556444444440aaaaaa00044440001ffff10033333300000000000000000000000000a0aa00a0aaaaa0a9999990002222222
02222220004a94000444444e655bb556444444449aaaaaa9044444400ff99ff0003333000000000000000000000000000a0a0a0aaaaaaa0a9999990022222222
022222200099a900e444444e655bb5564a4444440aaaaaa0494444940f99990000bbbb0000000000000000000000000000000000000000000900900008888800
02222220099a9990e4444edd6555b5564aa44a449aaaaaa0494444940044440000bbbb000000000000000000000000000000000000000000090090008888888f
002220000449aa40dde000000666666000444aa0000009005005150501100100000000000000000000000000000000000000000000000000990990000c000c00
00000000000000000000000000000000000000000000000000000000000000000000000000000444444444444444433335555555333333333333333111322222
00000000000000000000000000000000000000000000000000000000000000000000000000000004444444444444444455555533333333333333111111322222
00000000000000000000000000000000000000000000000000000000000000003333333333000031144444444444444444553333333333333311111113222222
00000000000000000000000000000000000000000000000000000000000000003333333333333311333344444444444444444333333333331111133113222222
00000000000000000000000000000000000000000000000000000000000000003333333333333333333334444444444444444443333333111133331132222222
00000000000000000000000000000000000000000000000000000000000000003333333333333333333334444444444444444443333311113333111132222222
00000000000000000000000000000000000000000000000000000000000000003333333333333333333334444444444444444443331113333311111322222222
00000000000000000000000000000000000000000000000000000000000000004443333333333333333334444444444444444443311331131111111322222222
88888000000000020022200000000000000000000000000000000000000000004444000033333333333333344444444444444444433113311111113222222222
82228202022022220020000000000000000000000000000000000000000000004444000333333333333333333344444444444444444331111111132222222222
88288202022002020022000000000000000000000000000000000000000000004444403333333333333333333333344444444444444443333333333322222223
88280222020202022222200000000000000000000000000000000000000000004444443333333335553333333333333344444444444444433333333333332231
08880000000000000000000000000000000000000000000000000000000000004444444333333555555553333333333333344444444444444333333333332311
00000000088802220000000000000000000000000000000000000000000000004444444333335555555555533333333333333444444444444443333344444333
000000000ff0001f0000000000000000000000000000000000000000000000004444444433355555555553333333333333333334444444444444333444444133
000000000ff000ff0000000000000000000000000000000000000000000000000444444444555555553333333333333333333333344444444444434444444331
00000000000000000000000000000000000000000000000000000000000000000444444444444333333333333333331333333333333444444444444444444111
00000000000000000000000000000000000000000000000000000000000000003144444444444433333333333333003113333333333334444444444444444111
00000000000000000000000000000000000000000000000000000000000000001134444444444443333333333333333111133333333333344444444444441111
00000000000000000000000000000000000000000000000000000000000000003355444444444444433333333333333333333333333333334444444444411113
00000000000000000000000000000000000000000000000000000000000000005555554444444444443333333333333333333333333333334444444444411333
00000000000000000000000000000000000000000000000000000000000000005555553334444444444333333333333333333333333333444444444444433335
00000000000000000000000000000000000000000000000000000000000000005533331331444444444433333333333333333333333334444444444444444555
00000000000000000000000000000000000000000000000000000000000000003333aa3aa3344444444443333553333333333333333344444444444444444455
000000000000000000000000000000000000000000000000000000000000000033aaa33330000444444444335555555553333333333444444444434444444444
0000000000000000000000000000000000000000000000000000000000000000aaa3333000000044444444435555555555553333334444444444334444444444
00000000000000000000000000000000000000000000000000000000000000003333130000000004444444445555555553331111344444444433333444444444
00000000000000000000000000000000000000000000000000000000000000001311300000000033444444444555533331111113444444444333333334444444
00000000000000000000000000000000000000000000000000000000000000003113000000000335344444444443333311111334444444448333333333444444
00000000000000000000000000000000000000000000000000000000000000001130000000033555334444444444111331113844444444455555533333334444
00000000000000000000000000000000000000000000000000000000000000001300000003353333333444444444411113138444444444555555555553333333
00000000000000000000000000000000000000000000000000000000000000003000000333553333333344444444441111384444444445555555555553333333
00000000000000000000000000000000000000000000000000000000000000000000333311333333333334444444444113344444444455555555555530003333
00000000000000000000000000000000000000000000000000000000000000000033133333003333333333344444444431344444444555555555553300000333
00000000000000000000000000000000000000000000000000000000000000003333330000003333333333334444444443444444445555555555530000000003
00000000000000000000000000000000000000000000000000000000000000003330000000000333333333333444444444444444455555555555300000000031
00000000000000000000000000000000000000000000000000000000000000003000000000000333333333333344444444444444555555555553000000003311
00000000000000000000000000000000000000000000000000000000000000003300000000000333333333333334444444444444555555555530000000031113
00000000000000000000000000000000000000000000000000000000000000003333000000000333333003333333444444444445555555555300000003311131
00000000000000000000000000000000000000000000000000000000000000003333330000003333333333383333344444444443355555553000000333111313
00000000000000000000000000000000000000000000000000000000000000003333333330003333333388833111344444444444333555530000033311133331
00000000000000000000000000000000000000000000000000000000000000003333333333303333338883311111444444444444433335300000331111333111
00000000000000000000000000000000000000000000000000000000000000003333333333333333338331111111444444444444444333300033111113311113
00000000000000000000000000000000000000000000000000000000000000000333333333333333333111111114444444444444444433333331113331111331
00000000000000000000000000000000000000000000000000000000000000000003333333333333311111111144444444544444444443333333331311133311
00000000000000000000000000000000000000000000000000000000000000003331133333333333333311111144444445554444444444333333313113313111
00000000000000000000000000000000000000000000000000000000000000001111338333333333333333311444444445555444444444443333333131331111
00000000000000000000000000000000000000000000000000000000000000001133883333333333333333333444444455555554444444444333333333111113
00000000000000000000000000000000000000000000000000000000000000003388331111333333333333334444444555555553444444444433333333311331
00000000000000000000000000000000000000000000000000000000000000003333111111333333333333344444444555555533344444444443333333333111
00000000000000000000000000000000000000000000000000000000000000001111111113333331333333344444443333555333114444444444433333333333
00000000000000000000000000000000000000000000000000000000000000001111111113333331111333444444443333333311111144444444443333333333
00000000000000000000000000000000000000000000000000000000000000001111111113333331111314444444433333333331111114444444444333333333
00000000000000000000000000000000000000000000000000000000000000001111111113333331113144444444333333333333331133444444444433333333
00000000000000000000000000000000000000000000000000000000000000001111111133333311134444444444333333333333333333544444444403333333
00000000000000000000000000000000000000000000000000000000000000001111111133333311444444444445553333333333333333333444444440033333
00000000000000000000000000000000000000000000000000000000000000001111111133444444444444444455531313333333333333333344444444003333
00000000000000000000000000000000000000000000000000000000000000001111111333444444444444444555533111133333333333333304444444431333
00000000000000000000000000000000000000000000000000000000000000001111111333444444444444445555313113300033333333333304444444413000
00000000000000000000000000000000000000000000000000000000000000001111111333444444444444555555333330000000313333333300444444430000
00000000000000000000000000000000000000000000000000000000000000001111111333444444444455555555330000000000330000000000044444400000
00000000000000000000000000000000000000000000000000000000000000001133333333333555555555555533300000000003300000000000004444400000
00000000000000000000000000000000000000000000000000000000000000001311111111135555555555553303000000000003000000000000033000000000
00000000000000000000000000000000000000000000000000000000000000001311111111355555555555330000000000000000000000000000330000000000
__label__
55555555555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333335555555555555555555555555
55555555555555555555555555555555555555555555555555555555555333333333333333322222222233333333333333333333555555555555555555555555
55555555555555555555555555555555555555555555555555555555553333333333333333322222222233333333333333333333355555555555555555555555
55555555555555555555555555555555555555555555555555555555533333333333333333322222222233333333333333333333335555555555555555555555
555555555555555555555555555555555555555555555555555555553333333333333333333111ffffff33333333333333333333333555555555555555555555
555555555555555555555555555555555555555555555555555555553333333333333333333111ffffff33333333333333333333333555555555555555555555
555555555555555555555555555555555555555555555555555555533333333333333333333111ffffff33333333333333333333333355555555555555555555
555555555555555555555555555555555555555555555555555555333333333333333333888fffffffff33333333333333333333333335555555555555555555
555555555555555555555555555555555555555555555555555555333333333333333333888fffffffff33333333333333333333333335555555555555555555
555555555555555555555555555555555555555555555555555555333333333333333333888fffffffff33333333333333333333333335555555555555555555
555555555555555555555555555555555555555555555555555553333333333333333333888333bbbbbb33333333333333333333333333555555555555555555
555555555555555555555555555555555555555555555555555553333333333333333333888333bbbbbb33333333333333333333333333555555555555555555
555555555555555555555555555555555555555555555555555533333333333333333333888333bbbbbb33333333333333333333333333355555555555555555
555555555555555555555555555555555555555555555555555533333333333333333333888444bbbbbb33333333333333333333333333355555555555555555
555555555555555555555555555555555555555555555555555533333333333333333333888444bbbbbb33333333333333333333333333355555555555555555
555555555555555555555555555555555555555555555555555533333333333333333333888444bbbbbb33333333333333333333333333355555555555555555
555555555555555555555555555555555555555555555555555333333333333333333333888333bbbbbb33333333333333333333333333335555555555555555
555555555555555555555555555555555555555555555555555333333333333333333333888333bbbbbb33333333333333333333333333335555555555555555
555555555555555555555555555555555555555555555555555333333333333333333333888333bbbbbb33333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333388833333366633333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333388833333366633333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333388833333366633333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333333333355566633333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333333333355566633333333333333333333333333335555555555555555
55555555555555555555555555555555555555555555555555533333333333333333333333333355566633333333333333333333333333335555555555555555
55555555555555555555555555555555555555bb55bbb5bbb5bbb33333bbb3bbb3bb33bbb33333bbb3bbb33bb3bbb33bb3b3b3bbb3b3b3bbb555555555555555
555555555555555555555555555555555555555b55b5b5b5b553b3333333b3b3b33b3333b33333bbb3b3b3b333b3b3b3b3b3b3b3b3b3b3b35555555555555555
555555555555555555555555555555555555555b55bbb5bbb5bbb3bbb3bbb3b3b33b3333b33333b3b3bbb3b333bb33b3b3b3b3bbb3b3b3bb5555555555555555
555555555555555555555555555555555555555b5555b555b5b5333333b333b3b33b3333b33333b3b3b3b3b333b3b3b3b3bbb3b3b3bbb3b55555555555555555
55555555555555555555555555555555555555bbb555b555b5bbb33333bbb3bbb3bbb333b33333b3b3b3b33bb3b3b3bb33bbb3b3b33b33bbb555555555555555
55555555555555555555555555555555555555555555555555553333333333333333333333333333333333333333333333333333333333355555555555555555
55555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333333333333333333333555555555555555555
55555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333333333333333333333555555555555555555
55555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333333333333333335555555555555555555
55555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333333333333333335555555555555555555
55555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333333333333333335555555555555555555
55555555555555555555555555555555555555555555555555555553333333333333333333333333333333333333333333333333333355555555555555555555
55555555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333333333333333555555555555555555555
55555555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333333333333333555555555555555555555
55555555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333333333335555555555555555555555
55555555555555555555555555555555555555555555555555555555553333333333333333333333333333333333333333333333355555555555555555555555
55555555555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333333333555555555555555555555555
55555555555555555555555555555555555555555555555555555555555533333333333333333333333333333333333333333335555555555555555555555555
55555555555555555555555555555555555555555555555555555555555553333333333333333333333333333333333333333355555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555333333333333333333333333333333333333333555555555555555555555555555
5555555555555555555555555eeeee88885555555555555555555555555555533333333333333333333333333333333333335555555555555555555555555555
555555555555555555555555eeeeee88888b5b555555555555555555555555553333333333333333333333333333333333355555555555555555555555555555
55555555555555555555555eeeeeee8888855b555bbb55bb55555555555555555533333333333333333333333333333335555555555555555555555555555555
55555555555555555555555eeeeeee8888555b555b5b5b5555bb5bbb555555555553333333333333333333333333333355555555555555555555555555555555
555555555555555555555ccccc5555555b555b555bbb5bbb5b5555b555bb55555555553333333333333333333333355555555555555555555555555555555555
555555555555555555555cccc555555555bb5bbb5b54444444aaaab55b5555555bbb555533333333333333333335555555555555555555555555555555555555
555555555555555555555cccc5555555555555555444444444aaaaa55b5555555b5b55555bbb33bb333333355555555555555555555555555555555555555555
555555555555555555555ccccc555555555555555444444444aaaaab5b5555555bbb5bbb5b5b5b5b5bbb5bb55555555555555555555555555555555555555555
55555555555555555555555ccccccc45555555555554444444aaaa5555bb5555555b55555bbb5b5b55b55b5b5555555555555555555555555555555555555555
55555555555555555555555ccccccc444555555555555eeeee45555555555555555b55555b555b5b55b55b5b5555555555555555555555555555555555555555
55555555555555555555555ccccccc444555555555555eeeee4555555555555bbbbbbbe55b555bb555b55b5b5555555555555555555555555555555555555555
555555555555555555555555cccccc444455555555555eeeee45555555555bbbbbbbbbeee55555555bbb5b5b5555555555555555555555555555555555555555
5555555555555555555555555ccccc444455555555555eeeee45555555555bbbbbbbbbeeee555555555555555555555555555555555555555555555555555555
555555555555555555555555555555eeeee5555555555eeeee45555555555bbbbbbbbbeeee555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555eeee5555555555eeeee455555555558888855554444455555555555555555555555555555555555555555555555555555
5555555555555555555555555555555eeee5555555555eeeee455555555558888855555444455555555555555555555555555555555555555555555555555555
555555555555555555555555555555eeeee5555555555eeeee455555555558888855555444455555555555555555555555555555555555555555555555555555
555555555555555555555554444444eeee55555555555eeeee455555555558888855554444455555555555555555555555555555555555555555555555555555
555555555555555555555444444444eeee5555555555544444a55555555558888888884444555555555555555555555555555555555555555555555555555555
555555555555555555555444444444eee55555555555544444a55555555558888888884444555555555555555555555555555555555555555555555555555555
555555555555555555555554444444e5555555555555544444a55555555558888888884444555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555544444a55555555558888888884445555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555544444a55555555558888888884555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555544444a5555555555ccccc55555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555544444a5555555555ccccc55555555555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555444455555555555ccccc55555555555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555555555555555555ccccc55555555555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555555555555555555ccccc55555555555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555555555555555555ccccc55555555555555555555555555555555555555555555555555555555555555
5555555555555555555555555555555555555555555555555555555555555ccccc55555555555555555555555555555555555555555555555555555555555555
555555555555555555555555555555555555555555555555555555555555555cc555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555666566555665666566656665555566655665665566656565555566655665555566656555666565655555555555555555555555555555555555555555
55555555565565656555655565655655555566656565656565556565555556556565555565656555656565655555555555555555555555555555555555555555
55555555565565656665665566555655555565656565656566556665555556556565555566656555666566655555555555555555555555555555555555555555
55555555565565655565655565655655555565656565656565555565555556556565555565556555656555655555555555555555555555555555555555555555
55555555666565656655666565655655555565656655656566656665555556556655555565556665656566655555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555558885888888888888855555555555555555555555555555555
5555555555555555555555555555bbb5bbb55bb5bbb5bb555bb5bbb55bb5bbb5bbb5bb555bb55558b858bbb8b8b8bbb855555555555555555555555555555555
5555555555555555555555555555b5b5b5b5b5b5b5b5b5b5b555b5b5b5555b555b55b5b5b5555558b8588b88b8b8b88855555555555555555555555555555555
5555555555555555555555555555bb55bb55b5b5bbb5b5b5b555bbb5bbb55b555b55b5b5b5555558b8558b88b8b8bb8555555555555555555555555555555555
5555555555555555555555555555b5b5b5b5b5b5b5b5b5b5b555b5b555b55b555b55b5b5b5b55558b8888b88bbb8b88855555555555555555555555555555555
5555555555555555555555555555bbb5b5b5bb55b5b5bbb55bb5b5b5bb555b55bbb5b5b5bbb55558bbb8bbb88b88bbb855555555555555555555555555555555
55555555550000000000000550000005000005000050000000000500000000000050000000000008888888888888888800000000000050000000555555555555
55555555505000010010000000000000011000100010000000001000000000000010100000000000000000001000001000100000000000000005555555555555
55555555500000000000000010000000000000000101000100000000100001000001000011110001000000000000111000000000001000100000555555555555
5555555550001003bb1b3300b3033b00000bb3030b0bbb0bbb0b000bbb11001bbb00b30bb001bb000000bb0bbb0bbb0b3003bb13130bb3000000555555555555
555555555000000b000b130b0b033b001010b1030b0b0b00b00b000b0001000b0b03030b0b0b1000000b0010b0030b131b11300b0b0b3b010000555555555555
555555555500011bb00b3103030303100000b0030b0bb000b00b101bb010000b3b0303130b031000010b3300b003bb031b01300b0b031b010100555555555555
555555555000100b000b1303030303000000b103030b0b00b00b000b0000001310030b030b031b1001001300b0030b031b00300b03131b000100555555555555
555555555000000b000b1b03b10303000100b101330b0b00b00b3b1bbb0010031003b0030b03bb10001b3100b0031b033b0b3b00b3031b000000555555555555
55555555500000101000101101010000000001011100100000001000000000011001000100010000000011050001100110101000010100100000555555555555
55555555500000001000100101010000000001011500100000001000000010011101000100010000000011000001100110101000015100000000555555555555
55555555500000001000100101110000000101011000100000001000000000010101000110010001100011000111100110001000010000000000555555555555
55555555500000000010100101010010000105110010110000000010000000010101000110010011000111000101000110001000010000100000555555555555
55555555550000000000100101010000000100010000110000000000000001010101000110010000000111000101001110001000010001011005555555555555
55555555500000000000100100010000010100010000110001000010500010010101001110010000000111000101000100001000010001100000555555555555
55555555550000000005000005000500005000000005000050000000005005000000000500000050000000000500000005000000005000000005555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000001100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000000001c050190501705016050190501c0501f050220502605027050270500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200003d3503b45038350365503335031450303502e5502b35028450273502525022250203501e4501c3501b55019550183501a4501b3501f5502235025450283502b5502b55029350234501e3501c4501a450
000400001a5501d5500c7530c70300000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0004000012550145500e7530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000003f750034500e7530e7031a7030000000000000001a7030c7030c703000000000000000000000000000000187030000000000000000000000000000000000000000000000000000000000000000000000
00140000091500c1500c1500c1500c1500f1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014000003150061500615006150041500e1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000002425025250252500000021250212500000022250222500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000200001f1601e1601b160191702217014170101500a15006150181500a150011501800018000170001800017000000000000000000000000000000000000000000000000000000000000000000000000000000
002d0000181500c1500c1500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00100000185302b10021520323001b5303230021520273002053021520205301f52020520273001d5100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000c0600000007050000000c06000000070700e00014060000000f050000000e040000000b0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
002000001174318500117430e6101f7531574313743135001f7431175313753117531375311753107530e6101875322000137532200015773220001775322000187531c7531f7632377321000187531200024610
00200000284231c4341044518000127201d4301f4202043021430000001144413610137440c6101d4001d40013610116101161010610106000e61010610116200c61018400184501740017450184001845218452
002000000d242022000c2431140013232136100c2430c200182400c61018243132001324313243132330c700111401d103101302b203132401520010240000000c2420c2320c2420c2300c242026101262000000
00200000005400c6100c76018200005501d4000c7700c6100055000000147500000005550000000e750000000c75000000045500000013750000000c5500000015750000000c550187500c550006100000000000
018d00003462434620346250000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
016e00003562435620356253560500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a000107017190000c000000000000000000000000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000000
0012000013720167201b72022720387003a7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000a0000220201a220100201e0201e220362200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000002019720174201272018420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000412004120041200412000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0010000014110151100f3101031000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000002c3112d3131d5173c014000001f5173c014000002c3142d3101d5103c010000001f5103c014000002c3132d3131d5173c014000001f5173c014000002c3152d3131d5143c015000001f5163c01600000
0110000011117110161171311713157130000013713000000c117100161071310713157130000013713000001111711016117131171315713000001371300000101170e0160e7130e71315713000001371300000
011000002c3112d3131d5173c014000001f5173c014000002c3142d3101d5103c010000001f5103c014000002c3132d3131d5173c014000001f5173c014000002c3152d3131d5143c015000001f5163c01600000
0110000011117110161171311713157130000013713000000c117100161071310713157130000013713000001111711016117131171315713000001371300000101170e0160e7130e71315713000001371300000
0120000018310183230000013420134130000000000104100f4230000013420134221841200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0120000018300183031841018413184011841017414104000f4130000013410134121840215400154101741017410154101541300000000001540010410114201142010420104230000000000000000000000000
011000000c1270c0160c71311713157230000013723000001712710016107131071315723000001372300000101270e0160e7130e713157230000013723000000e1270d0160d7130d71315723000001372300000
01100000180241302318026130251b0161e005000040c024130200c023130260c0250d016000000000010024110200d023110260d0250e016000000000015024110200d023110260d02510016000000000013024
01100000180101301010010000001101015010180100000013020130200000000000000001b7101a7101471000000000000f7100e710087100000000000000000000000000000000000000000000000000000000
011000001c0101a0100c010000000c010100101301000000130201502013020000000c7100b720000000000000000000000000005000050500000000050000000505005000000500500003050050000405000000
0110000000000050500000000050000000505000000000500000004050000000005000000070500000009050000000c0500000009050000000a050000000c0500000007050000000905000000050500000007050
0110000007310043061d314073100000018314053100000000000223140b315133120c31000311263140000005310000001c314053100000018314033100000000000073141f315043120c3101e3140731000000
001000000001000110002100002000120002200001000110002200001000110002100001000110002100001000110002100001000110002100001000120002200002000110002100001000110002100001000310
01cc00000000000020000200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000000614203100c6131831013614000000000000614203100c613183101361400000000000000000614203100c61318310136140000000000000000000000614203100c6131831013614000000000000000
011000001713017130171221712216125161251511015110151121511215115151151f1051e102070230702318130181301812218122171251712516110161101611216112151151511516102151050703307033
00110100000101d0101d010122100e0101c0101c01000010000101d2101d210000101d2101d2201d2200002000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110000000000000008510075100851000000000000b5100b5100b51000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110000000101d0101d010122100e0101c0101c01000010000101d2101d210000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00110000000000000008510075100851000000000000b5100b5100b51000000000000651005510065100001000010000100d5100d5100d5100001000010000100001000010000100001000010000100001000000
001100000151001510015100151001510015100002000020000200002000010000100001000010000200002000010000100001000010000100001000010000100001000010000100001000010000100001000010
012200000e527195271a5271b5271a5271b5270000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c3150c31000000133151431200000123121331500000113151231200000103100e3100e3100000000315003100000007315083120000006312073150000005315063120000004310023100231000000
01100000003150031000000073150831200000063120731500000053150631200000043100231002310000000c3150c310000001331514312000001231213315000001131512312000001421312305173120c313
001000000001000010035100371004710025200252001720017200232001310013100131002310025100253002530025300252002520025200002000010000100001001600016100161004710000100001000010
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01110020010200102503025000000202002025000250000001020010250302500000020200202500025000000702505025000000502504025040260000002025010200102503025000000202002025040250e000
0111012000053100530000000000020530e053000000005300000000530000000053020530e0530000000053020531005300000050531005300000020530d05300000010530c053000000c053000530c05300000
0111000000023100231361500000020230e023000000002300000000230761500023056150e0230000000023020231002313615050231002311615020230d02300000010230c023000000c023076150c02307615
011000001951219514255001e5001e5121e5152050020500205122051400000185001e5121e51518500000002251523512000001e512000001b5121b515135001a5151a512386000000019514195123760000002
01100000131301313013122131221311013110141151411515132151321512015120151101511020115201151f1221f1221e1251e1251d1121d1121e1151e1151f1151f1151e1121e1121d1121d1121e1151e115
01110000191511a1221b125121051310000000111211312214135110002112121122221351e0000c1100d1210e1210f1211012211135000001f21304223100000f0001e213032230f0000f0001d2130222300001
010f000016101171020b22307223000001511113122151221b125000000000013111121221112215125000000000012111111221012213125000000000011111101220f122141250000013121131250000000000
011100000000000615131221511507625000001311111122131250062500000111110f122111250062500000006250e1110f1221012500000000000c1150d1250f1130d1140c1130e1140f1130d1131361500000
010600001851118515185151851218505185051b50018511185151851518511185121a5051a5051a50000000185151851518510000001a5051a5151a5101a5101a512185051c5001c5051c5111c5151c5121c502
011000001800317113157131311311013101130e7130c7131531300000152130000011313000001541300000180030b1130971307113050130411302713007130431300000052130000010313000001d41300000
014000001811115112131111311113111111121011110111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011100000c1000c1100c1050c1100c1050b1100b115111100511504110041151311013115051100511512110000001311013105131100000011110111150f1100e1151511014115121100e1150f1100000013113
014000000711109112071110711107111051120411104111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000c1000d1100c1000d1200b100151201511512120000001112000000141200000014120141151311300000201200000020120000001e1201d1151b1200000019130000001b12000000161201511512113
__music__
04 0c0d0e0f
01 1a1b1d44
00 1a1b1c44
02 1a1e5c44
00 41424344
00 32333744
01 32333844
00 32344344
02 32333944
00 41424344
01 3d3c3b44
00 3f3e3b44
02 3d3e3b44
00 41424344
00 41424344
00 20212526
01 22232444
00 2023241f
02 2224241f
00 3a764344
01 272e3570
00 272f3644
02 272f3044
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

