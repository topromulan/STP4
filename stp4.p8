pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- super turtle pong 4
-- 2016-2017 macrowave
-- https://github.com/topromulan/stp4
-- from dale and dahlia anderson.
function _init()
 screen={}
 do_intro()
 debug=false
end

function _draw()
 screen.draw()
 
 if(debug) then
  local x1,y1,x2,y2,clr
  x1=65 y1=56
  x1=oddball.x+4
  y1=oddball.y+4
  clr=10
  
  x2=x1+oddball.dx*10
  y2=y1+oddball.dy*10
 
  line(x1,y1,x2,y2,clr)
  
  if(debug) then 
   for p=1,2 do
    if(players[p].ai and 
     players[p].thinking
     and players[p].thinking>0
    ) then
     print("??",players[p].x+1,players[p].y+5,7)
    end
--    print(flr(players[p].dx*10),players[p].x-5,players[p].y+1,14)
--    print(flr(players[p].dy*10),players[p].x-5,players[p].y+7,14)
   end 
  end

  draw_joystick(1)
  draw_joystick(2)
 end
end

function _update()
  cycles+=1

 if(cycles%30==0) printh("")
  
  --fix bug when it wraps
  if(cycles<0) then
   cycles=1 
   if(oddball!=nil) oddball.service_time=0 
  end

  screen.update()

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
 
 stplogo={}
 stplogos={}
 stplogot={}
 stplogop={}
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
 
 screen.update=intro_update
 screen.draw=intro_draw

 game_init()
 newbtn_init()
  
 cls(5)
end

function intro_update()
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

 if(btnp()!=0 and not intro_ending) intro_ending=true
 for p=1,2 do
  if(btnp(4,players[p].js.num) or btnp(5,players[p].js.num)) then
   if(players[p].ai) then
    players[p].ai=false
   else
    intro_ending_at=cycles
   end
  end
 end

 lx+=1
 if(lx>200) lx=-200
 if(lx==50) then
  schedule_sfx(0,flr(rnd(2))) 
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
 newbtn_mgmt()
end

function intro_draw()
 rectfill(0,0,127,102,5)

 local s,sx,sy
 local rd=30
 local ld=32+sin(lx/1000)*20
 local ratio=ld/rd
 circfill(lx,ly,ld,lcolor)
 s=players[1].sprites[1+flr(cycles/5)%7]
 sx=s*8%128
 sy=8*flr(s*8/128)
 sspr(sx,sy,8,8,lx-12*ratio,ly-24*ratio,24*ratio,24*ratio)

 circfill(rx,ry,rd,rcolor)
 if(lx>=51 and lx<=70) then
  s=players[2].sprites[6]
 else
  s=players[2].sprites[1+flr(cycles/5)%2]
 end
 sx=s*8%128
 sy=8*flr(s*8/128)
 sspr(sx,sy,8,8,rx-12,ry-20,24,24)

 print("1992-2017 macrowave",38,25,11) 

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

 if(cycles<15) print("from turtle pong stadium",xl,yt,letter)

 
 
 for y=flr(rainfloor),rainline,-1 do
  for x=xl-4,xr+4 do
   local above=pget(x,y-1)
   local here=pget(x,y)
   local result=here
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
    local coord={x-1+rnd(3),y-1+rnd(3)}
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
 screen.update=game_update
 screen.draw=game_draw
end

function game_init()
 players={}

 oddball={}
 oddball.sprites={11,12,13,29,45,44,43,27}

 players[1]={}
 players[2]={}

 players[1].ai=true
 players[2].ai=true
 players[1].js={}
 players[1].js.num=1
 players[2].js={}
 players[2].js.num=0

 players[1].sprites={9,25,41,57,56,55,54}
 players[2].sprites={10,26,42,58,59,60,61}
 
 players[1].score=0
 players[2].score=0
 players[1].holding=false
 players[2].holding=false
 players[1].winding_up=false
 players[2].winding_up=false
 players[1].serve_power=1
 players[2].serve_power=1
 players[1].winding_dir=1
 players[2].winding_dir=1

 local lnames={
  {"red","red","red","rouge","rusty","ruddy","redder","rosy","ruby","russet","big red","beet red"},
  {"ricky","ricky","ralf","rancid","remy","rebner","raggy","rose","ray","ruffguy","razor","ripple","rhine","roo","radagast"}
 }
 local rnames={
  {"purple","purple","purplish","p.","plum","perse","p-diddy"},
  {"pete","pete","page","paddy","padma","price","pinky","peppy","po-po","patty","press","poof","perp","pixel"}
 }

 local too_long="radagast rebner"
 players[1].name=too_long players[2].name=too_long
 while(#players[1].name>=#too_long) do
  players[1].name=lnames[1][1+flr(rnd(#lnames[1]))].." "..lnames[2][1+flr(rnd(#lnames[2]))]
 end
 while(#players[2].name>=#too_long) do
  players[2].name=rnames[1][1+flr(rnd(#rnames[1]))].." "..rnames[2][1+flr(rnd(#rnames[2]))]
 end 
 trophy_for_player1=false
 trophy_for_player2=false
 party_message=nil

 stadium_fans={80,81,82,83,84,85,86,87,88}

 stadium_audience={}

 stadium_floor_top=25
 stadium_floor_height=32
 --regular floor
 local rugcolorpairs={{2,14,false},{3,4,false},{1,13,false},{0,5,false},{12,13,false},{12,13,true}}
 local i=1+flr(rnd(#rugcolorpairs))

 stadium_floor_color1=rugcolorpairs[i][1]
 stadium_floor_color2=rugcolorpairs[i][2]
 stadium_floor_flicker=rugcolorpairs[i][3]

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

 players[1].x=stadium_field_left + stadium_field_goalzonewidth-13
 players[1].xmin=stadium_field_left-3
 players[1].xmax=stadium_field_left+stadium_field_goalzonewidth-5
 players[1].dx=0 players[1].dy=0

 players[2].x=stadium_field_right - stadium_field_goalzonewidth+5
 players[2].xmin=stadium_field_right-stadium_field_goalzonewidth-2
 players[2].xmax=stadium_field_right-4
 players[2].dx=0 players[2].dy=0

 players[1].y=stadium_field_top + 5
 players[2].y=stadium_field_bottom-13
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
  stadium_audience[seat].timing=0
 end
 shuffle_audience_timing()
 
 oddball.upforgrabs=true
 oddball.service_time=cycles+10+rnd(3)
 oddball.dx=0 oddball.dy=0
 oddball.x=64 -- so it's not nil
 oddball.y=64
 oddball.approaching_player=1

 help_flag=false
 
 ai_far_field=23
end

function set_player_pose(num,pose)
 if(players[num].stagger_effect == nil) players[num].stagger_effect=0
 if(players[num].stagger_effect>0) then
  players[num].stagger_effect-=1
 else
  players[num].sprite=players[num].sprites[pose]
 end
end

function player_service(num)
 players[num].dx*=0.75
 players[num].dy*=0.75
 if(oddball.upforgrabs and cycles>oddball.service_time+25+rnd(3.2) and not players[num].dancing) then
  --move it into player's hands
  oddball.upforgrabs=false
  oddball.dx=0 oddball.dy=0
  players[num].holding=true
 elseif(players[num].holding) then
  if(newbtn("o",num)) then
   --still winding up
   players[num].winding_up=true
   player_windup(num)
  else
   --let it fly
   players[num].holding=false
   players[num].winding_up=false
   oddball.dx=-1*(-3+2*num)*(1+rnd(0.5)+players[num].serve_power/10)
   oddball.dy=0.1-rnd(0.2)
   --oddball.dx*=0.55 --for serve testing
   oddball.dx+=(0.1+rnd(0.1))*players[num].dx
   local reldx=players[num].dx
   if(num==2) reldx*=-1
   if(reldx<-0.65) then
    oddball.dy+=3*players[num].dy
   elseif(reldx<0) then
    oddball.dy+=2.25*players[num].dy
   elseif(reldx==0) then
    oddball.dy+=2*players[num].dy
   elseif(reldx<=0.8) then
    oddball.dy+=1.75*players[num].dy
   else
    oddball.dy+=1.25*players[num].dy
   end

   sfx(1+num) sfx(4)
  end
 else
  --dancing?
 end
 set_player_pose(num,3)
end

function player_windup(num)
 if(players[num].serve_power==nil) players[num].serve_power=1

 players[num].serve_power+=players[num].winding_dir
 
 if(players[num].serve_power>10) then
  players[num].serve_power=10
  players[num].winding_dir=-3
 elseif(players[num].serve_power<1) then
  players[num].serve_power=1
  players[num].winding_dir=0.5
 end
 
end

function draw_windup()
 local draw_it,num,clr
 if(players[1].winding_up) then
  draw_it=true num=1 clr=8
 elseif(players[2].winding_up) then
  draw_it=true num=2 clr=2
 else
  draw_it=false
 end
 
 
 local x1,y1,x2,y2,middle,width,meter_left,meter_right
 middle=0.5*(stadium_field_left+stadium_field_right)
 width=10
 x1=middle-width/2 x2=middle+width/2 
 y1=stadium_field_bottom-1 y2=127

 if(draw_it) then
  if(num==1) then
   meter_left=x1+1
   meter_right=x1+(width-1)*(players[num].serve_power/10)
  else
   meter_left=x2-(width-1)*(players[num].serve_power/10)
   meter_right=x2-1
  end
  rect(x1,y1,x2,y2,15)
  rectfill(x1+1,y1+1,x2-1,y2-1,14)
  rectfill(meter_left,y1+1,meter_right,y2-1,clr)
 else
  rectfill(x1,stadium_field_bottom+1,x2,126,5)
  print("vs",middle-3,122,15)
 end  
end


function game_update()
 -- original version:
 -- if(btnp(4)) then players[1].score += 1 end
 -- if(btnp(5)) then players[2].score += 1 end

 if(cycles>oddball.service_time) then
  if(players[1].score>=9) then
   player_wins(1) 
  end
  if(players[2].score>=9) then
   player_wins(2)
  end
 end
 
 if(stadium_floor_flicker) then
  local t=stadium_floor_color1
  stadium_floor_color1=stadium_floor_color2
  stadium_floor_color2=t
 end

 
 for p=1,2 do
  set_player_pose(p,1+flr(rnd(1.05)))

  if(players[p].ai) then
   ai_control(p)
   
   if(oddball.upforgrabs
     and (
      (cycles-oddball.service_time>80+10*(players[p].score-players[1+p%2].score)
       and rnd()<0.01)
      or (cycles-oddball.service_time>5
       and players[p%2+1].score>players[p].score)
      or rnd()<0.005
      or (players[1].ai and players[2].ai and rnd()<0.05)
     )
    )
     and (
      players[1].ai and players[2].ai
      or not (players[1].score+players[2].score==0)
    )
      then
    players[p].js.o=5+flr(rnd(20))
   end
     
--   players[p].js.l=nil
--   players[p].js.u=nil
--   players[p].js.d=nil
--   players[p].js.r=nil
  end

  if((players[p].holding or players[p].dancing or not newbtn("o",p))) then
   if(newbtn("l",p)) players[p].dx-=0.35-rnd(0.05)
   if(newbtn("r",p)) players[p].dx+=0.29+rnd(0.05)
   if(newbtn("u",p)) players[p].dy-=0.35-rnd(0.03)
   if(newbtn("d",p)) players[p].dy+=0.35+rnd(0.03)
  end
  if(not (newbtn("l",p) or newbtn("r",p))) players[p].dx*=0.65
  if(not (newbtn("u",p) or newbtn("d",p))) players[p].dy*=0.74
  --introduces a waver when not hanging onto the paddle
--  if(band(shr(btn(),(p%2)*8),2^0+2^1+2^2+2^3)==0) then
  if(not (newbtn("l",p) or newbtn("r",p) or newbtn("u",p) or newbtn("d",p))) then
   players[p].dx*=(0.7+rnd(0.6))
   players[p].dy*=(0.7+rnd(0.6))
   if(rnd()<players[p].dx) players[p].dx*=-1
  end 
   
  local threshold=0.25
  if(p==2) threshold=0.005
  if(players[p].dx<threshold and players[p].dx>-1*threshold
    and players[p].dy<threshold and players[p].dy>-1*threshold) then
   players[p].moving=false
   players[p].dx=0
   players[p].dy=0
  else
   players[p].moving=true
  end
  
  if(players[p].moving) then
   set_player_pose(p,1+flr(rnd(2)))

   if(players[p].dx>0.75) players[p].dx=0.75
   if(players[p].dx<-0.89) players[p].dx=-0.89
   if(players[p].dy>1.25) players[p].dy=0.95
   if(players[p].dy<-1.25) players[p].dy=-0.95

   players[p].x+=players[p].dx
   players[p].y+=players[p].dy
  end

  if(newbtn("o",p) or players[p].winding_up) player_service(p)
--  if(newbtnp("x",p)) players[1+p%2].score+=1
  if(newbtn("x",p)) then
   oddball.x-=oddball.dx
   oddball.y-=oddball.dy
   oddball.x+=1.3*players[p].dx
   oddball.y+=1.5*players[p].dy
  end
 end

 if(oddball.upforgrabs) then
  oddball.x=(stadium_field_left+stadium_field_right)/2-4
  oddball.y=(stadium_field_top+stadium_field_bottom)/2-4
 elseif(players[1].holding) then
  oddball.x=players[1].x+6
  oddball.y=players[1].y+1
 elseif(players[2].holding) then
  oddball.x=players[2].x-6
  oddball.y=players[2].y+1
 else
  oddball.x+=oddball.dx
  oddball.y+=oddball.dy
 end

 local slope=oddball.dy/oddball.dx if(oddball.approaching_player==2) slope*=-1
 local num,offset,adjustedx,adjustedy

 num=oddball.approaching_player
 adjustedx=oddball.x+flr(3.5+rnd())
 adjustedy=oddball.y+flr(3.5+rnd())
 if(num==1) shieldx=players[1].x+5 else shieldx=players[2].x+2
 
 if(abs(adjustedx-shieldx)<3) then
  --check for paddle impact
  local shieldhity1,shieldhity2

  shieldhity1=players[num].y-5
  shieldhity2=players[num].y+8
  
  offset=flr(0.5+adjustedy-shieldhity1)

  if(adjustedy>=shieldhity1 and adjustedy<=shieldhity2) then
   if(not players[oddball.approaching_player].dancing) then
    --collision
    oddball.dx*=-1
    if(offset<2.1) then
     oddball.dy-=1.8+rnd(0.4)
    elseif(offset<4.1) then
     oddball.dy-=0.25
     oddball.dy*=1.2
    elseif(offset<8) then
     oddball.dy*=0.5
     oddball.dy+=-0.2+rnd(0.4)
    elseif(offset<10) then
     oddball.dy+=0.25
     oddball.dy*=1.2
    else
     oddball.dy+=1.8+rnd(0.4)
    end
   else
    --they screwed up boooo
    sfx(8) sfx(9)
   end

   if(oddball.approaching_player==1 and players[oddball.approaching_player].dx<0
     or oddball.approaching_player==2 and players[oddball.approaching_player].dx>0) then
    oddball.dx+=0.2*players[oddball.approaching_player].dx 
   else
    oddball.dx+=(0.05+rnd(0.05))*players[oddball.approaching_player].dx
   end
   local lowspeed=0.888
   local highspeed=5.0
   if(abs(oddball.dx)<lowspeed) oddball.dx=lowspeed*(oddball.dx/abs(oddball.dx))
   if(abs(oddball.dx)>highspeed) oddball.dx=highspeed*(oddball.dx/abs(oddball.dx))
   oddball.dy+=0.45*players[oddball.approaching_player].dy

   shuffle_audience_timing()
   
   if(slope>0.15 or offset>9.9) then
    set_player_pose(oddball.approaching_player,5)
   elseif(slope<-0.15 or offset<2.1) then
    set_player_pose(oddball.approaching_player,4)
   else
    set_player_pose(oddball.approaching_player,3)
   end
   players[oddball.approaching_player].stagger_effect=35
   sfx(1+oddball.approaching_player)
   --glancing blows
   --extra oomph
   if(not players[oddball.approaching_player].moving and newbtn("o",oddball.approaching_player)) then oddball.dx*=1.1 sfx(0) end   
  end
 end

 oddball.approaching_player=1 if(oddball.dx > 0) then oddball.approaching_player=2 end 

 local out_of_bounds,diff,effective_top,effective_bottom
 local yadjust={0,-6}
 effective_top=stadium_field_top+yadjust[1]
 effective_bottom=stadium_field_bottom+yadjust[2]
 diff=effective_top-oddball.y
 if(diff>0) then
  out_of_bounds=true
  oddball.y=effective_top+diff
 end
 diff=oddball.y-effective_bottom
 if(diff>0) then
  out_of_bounds=true
  oddball.y=effective_bottom-diff
 end
 if(out_of_bounds) oddball.dy*=-0.75-rnd(0.2)
 

 --score!! goal!!
 local scoring_player
 if(oddball.x<stadium_field_left-4 or oddball.x>stadium_field_right-3) then
  if(oddball.x>stadium_field_middle) then
   scoring_player=1
  else
   scoring_player=2
  end
  players[scoring_player].score+=1
  stadium_display_digit_heights[scoring_player]=2
  schedule_sfx(1,7)--lets clapping begin first
  oddball.upforgrabs=true
  oddball.x=64 oddball.y=85 --approximately in the middle so ai returns to midfield
  if(players[1].score<9 and players[2].score<9) then
   oddball.service_time=cycles+20+rnd(5)
   poke(0x3681,60+flr(rnd(30)))
   sfx(16)
   schedule_sfx(16,2)
   if(rnd()<0.15) schedule_sfx(17,5)
  else
   --winner winner chicken dinner 
   oddball.service_time=cycles+55+rnd(10)+12
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
 rect(0,0,127,127,5) --———

 local msg="turtle pong stadium"
 local clr=15
 if(rnd()<0.2 and cycles%2==0) clr=7
 print(msg,64-2*#msg,2,clr)

 draw_field() 
 draw_scoreboard()
 draw_floor(stadium_field_middle,stadium_floor_top,stadium_floor_height)
 draw_names()
 
 local exitx=(stadium_display_left+stadium_display_right)/2-12
 local exity=stadium_display_bottom-25
 draw_door(exitx,exity+3) --just adding a little length
 draw_door(exitx,exity)

 draw_audience()
 draw_player(1)
 draw_player(2)
 draw_oddball()
 draw_windup()

 if(players[1].score==0 and players[2].score==0) then
  local msg,clr
  clr=(flr(cycles/25)%2+5)
  if(oddball.upforgrabs and cycles-intro_ending_at>125) then
   help_flag=true
   msg="(hold Ž to serve)"
   print(msg,stadium_field_middle-2*#msg,stadium_field_bottom-15,clr)   
  end
  if(help_flag and (players[1].holding or players[2].holding) and cycles-intro_ending_at>145) then
   msg="(let that turtle fly!))"
   print(msg,stadium_field_middle-2*#msg,stadium_field_bottom-22,clr)
   msg="     watch | that meter"
   print(msg,stadium_field_middle-2*#msg,stadium_field_bottom-13,clr)
   msg="|"
   print(msg,stadium_field_middle-2*#msg,stadium_field_bottom-8,cycles%16+rnd(3))
   msg="v"
   print(msg,stadium_field_middle-2*#msg,stadium_field_bottom-6,4+cycles%5)
   
   if(players[1].winding_up) then
    if(players[1].winding_dir>2) players[1].winding_dir=2
    if(players[1].winding_dir<-0.5) players[1].winding_dir=-0.5
   elseif(players[2].winding_up) then
    if(players[2].winding_dir>2) players[2].winding_dir=2
    if(players[2].winding_dir<-0.5) players[2].winding_dir=-0.5
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
--  set_player_sprite(num,players[num].sprites[1+flr(rnd(2))])
 end

 if(players[num].x<players[num].xmin) players[num].x=players[num].xmin
 if(players[num].y < players[num].ymin) players[num].y=players[num].ymin
 if(players[num].x > players[num].xmax) players[num].x=players[num].xmax
 if(players[num].y > players[num].ymax) players[num].y=players[num].ymax

 spr(players[num].sprite,players[num].x,players[num].y)
 if(players[num].ai) print("ai",players[num].x+1,players[num].y-7,7)
end

function draw_oddball()
 if(oddball.upforgrabs) then
  oddball.sprite=oddball.sprites[2]
 elseif(players[1].holding) then
  oddball.sprite=oddball.sprites[1+flr(cycles/5)%3]
 elseif(players[2].holding) then
  oddball.sprite=oddball.sprites[5+flr(cycles/6)%3]
 else
  oddball.sprite=oddball.sprites[1+flr(cycles/3.3)%8]
 end

 if(cycles>oddball.service_time) then
  spr(oddball.sprite,oddball.x,oddball.y)
 end
end

function draw_scoreboard()
 local coords={}
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
  if(players[i].score==0) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
  end 
  if(players[i].score==1) then
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==2) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==3) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==4) then
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==5) then
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==6) then
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==7) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
  end 
  if(players[i].score==8) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium_display_digit_width,coords[1].y,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y,coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i]/2,coords[i].x,coords[i].y+stadium_display_digit_heights[i]/2,stadium_display_lightcolor)
   line(coords[i].x+stadium_display_digit_width,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y+stadium_display_digit_heights[i],stadium_display_lightcolor)
   line(coords[i].x,coords[i].y+stadium_display_digit_heights[i],coords[i].x,coords[i].y,stadium_display_lightcolor)   
  end 
  if(players[i].score==9) then
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
 print(players[1].name,2,121,8)
 print(players[2].name,127-4*#players[2].name,121,2)
end

function draw_floor(middle,top,height)
 for i=1,height do
  local rad
  if(i<8) then
   rad=15+i^2
   if(rad>60) rad=62
  else
   rad=60-1.5*(i%3)-i/10
  end
  local l=middle-rad
  local r=middle+rad
  local h=top+i
  line(l,h,r,h,stadium_floor_color1)
  for j=l+2,r-2,4 do
   local c=stadium_floor_color2
   --blink red when win!
   if((players[1].score==9 or players[2].score==9) and flr(cycles/15)%2==0) then
    c=8
   end
   line(j,h,j+1,h,c)
  end
 end
end

function draw_door(exitx,exity)
 local ul_sprite=73
 local ulsx=(ul_sprite%16)*8
 local ulsy=(flr(ul_sprite/16)*8)

 sspr(ulsx,ulsy,24,24,exitx,exity)
 print("exit",exitx+5,exity+5,15)
  
end

function draw_audience()
 for seat=1,#stadium_seats do
  local seatx=stadium_seats[seat][1]
  local seaty=stadium_seats[seat][2]
  spr(6,seatx,seaty,2,2)
  --draw each audience member in 
  -- their seat, facing the ball
  local fan_sprite=stadium_audience[seat].sprite
  if(oddball.x < seatx+stadium_audience[seat].timing) fan_sprite-=16
  if(oddball.x > seatx+8+stadium_audience[seat].timing) fan_sprite+=16
  spr(fan_sprite,seatx+4,seaty+3)
 end
end

function player_wins(num)
 if(num==1) then
  trophy_for_player1=true
 elseif(num==2) then
  trophy_for_player2=true
 end
 screen.update=party_update
 screen.draw=party_draw
 party_started=cycles+1

 if(party_message==nil and num==1) then
  party_message=players[1].name.." wins"
  plaque_color=8
 elseif(party_message==nil and num==2) then
  party_message=players[2].name.." wins"
  plaque_color=2
 else
  party_message="everybody wins!!"
  plaque_color=4
 end
 music(0)
 party_update()
 local compliments={"’stellar’","first place","–electric–","…like a ninja…","epic","rad","“top notch“","™ zen-like ™","Žpico-riffic—"}
 adjective=compliments[1+flr(rnd(#compliments))]

 per=4+flr(rnd(3.5)) -- a mysterious global variable
end


function party_update()
 party_time=cycles-party_started
 if(party_time>120 or ((party_time>25) and (newbtnp("o",1) or newbtnp("o",2)))) do_intro()

 sound_effect_mgmt()
 newbtn_mgmt()
end

function party_draw()
 cls(5)

 draw_floor(80,65,63)
 draw_door(70,44)
 
 local p=1.1*(8+party_time/12)

 for i=1,#stadium_audience do
  local z=stadium_audience[i].sprite+32
  local row=1+flr(i/per)
  local col=i%6
  sspr(z*8%128,8*flr(z*8/128),8,8,
   60+p-5*row+
    (i%per)*((360-(10-row)*30)/p)
    , --x
   59-p/12+row*(8-row),--y
   20/p*(row*per),--w
   20/p*(row*per),--h
   ((cycles+flr(stadium_audience[i].timing))%3==0)--x flip
  )
 end
 party_drapes_draw()

 local clr1,clr2
 if(flr(cycles/3.1)%2==0) then
  clr1=4 clr2=9
 else
  clr1=9 clr2=4
 end

 rectfill(7,11,65+4*#adjective,33,5)
 rect(7,11,65+4*#adjective,33,9)
 if(party_time>10) print("thanks for playing",10,15,clr1)
 if(party_time>20 and flr(cycles/20)%2==0) print("that was "..adjective.."!!",13,23,clr2)

 local plaquexy={}
 plaquexy[1]=42-2*#party_message
 plaquexy[2]=40
 local tcolor
 if(party_time>38) then
  tcolor=15
  if(party_time>42) rectfill(plaquexy[1],plaquexy[2],plaquexy[1]+2+4*#party_message,plaquexy[2]+8,plaque_color)
 else
  if(flr(cycles/1.5)%2==0) tcolor=15 else tcolor=plaque_color
 end

 print(party_message,plaquexy[1]+2,plaquexy[2]+2,tcolor)

 for p=1,2 do
  local s,sx,sy,px,py
  if(p==1 and trophy_for_player1 or
     p==2 and trophy_for_player2) then
   s=players[p].sprites[1+cycles%6]
   sx=s*8%128
   sy=8*flr(s*8/128)
   px=128*(party_time/125)
   if(p==2) then px=128-px end --so player 2 comes from r
   py=100-party_time/20+50*sin(party_time/cycles)
   sspr(sx,sy,8,8,px,py,24,24)
  end
 end
end

function party_drapes_draw()
 local x,y
 for y=0,127 do
  for x=0,127 do
   if(y>party_line1(x)) pset(x,y,party_fn(x,y))
   if(y<party_line2(x)) pset(x,y,party_fn(x,y))
  end
 end
 for x=0,127 do
  pset(x,party_line1(x),15)
  pset(x,party_line2(x),11)
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
   if(btn(b,players[p].js.num)) then
    --false is a reminder that it
    -- was already pressed at init
    players[p].js[newbtn_conv(b)]=false
   else
    players[p].js[newbtn_conv(b)]=nil
   end
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
   if(players[p].ai) then
    if(players[p].js[newbtn_conv(b)]) then
     if(players[p].js[newbtn_conv(b)]>0) then
      players[p].js[newbtn_conv(b)]=players[p].js[newbtn_conv(b)]-1 --why not -=1 work (??)
     else
      players[p].js[newbtn_conv(b)]=nil
     end
    end
   else
    local m=newbtn_conv(b)
    if(btn(b,players[p].js.num)) then
     if(players[p].js[m]) then
      players[p].js[m]+=1
     else
      players[p].js[m]=0
     end
    else
     players[p].js[m]=nil
    end
   end
  end
 end

 if(players[p]) then --??
  if(players[p].js.l and players[p].js.r) then
   if(players[p].js.l>players[p].js.r) players[p].js.r=nil else players[p].js.r=nil
  end
  if(players[p].js.u and players[p].js.d) then
   if(players[p].js.u>players[p].js.d) players[p].js.d=nil else players[p].js.u=nil
  end
 end
end

function newbtn(b,p)
 if(players[p].js[b]) return true
 return false
end

function newbtnp(b,p)
 if(newbtn(b,p)) then
  if(players[p].js[b]==0) return true
 end
 return false
end

function ai_control(p)
 local midfield=0.5*(stadium_field_top+stadium_field_bottom)-11+rnd(9)
 local midzone if(p==1) midzone=stadium_field_left+4 else midzone=stadium_field_right-10
 local distance=abs(players[p].x-oddball.x) if(p==2) distance-=4
 if(p==2) distance+=3 else distance-=4
 local slope={oddball.dy*(0.95+rnd(0.04)),oddball.dx*(0.9+rnd(0.09))}
 slope.a=slope[1]/slope[2]
 local top=stadium_field_top local bottom=stadium_field_bottom
 local height=bottom-top
 local direction=oddball.dx/abs(oddball.dx)
 local backwards,forwards
 if(p==1) then
  backwards="l" forwards="r"
 else
  backwards="r" forwards="l"
 end
 local coming=true if(p!=oddball.approaching_player) coming=false
 if(oddball.upforgrabs or players[p%2+1].holding or not coming) then
  --amble toward midfield
  if(players[p].y<midfield-2 and rnd()<0.15) players[p].js["d"]=3
  if(players[p].y>midfield+2 and rnd()<0.15) players[p].js["u"]=3
  if(players[p].x<midzone-1+rnd(2) and not players[p].js.l) players[p].js.r=2
  if(players[p].x>midzone+1-rnd(2) and not players[p].js.r) players[p].js.l=2
  players[p].thinking=nil
 else
  local yprojection=oddball.y+slope[1]*(distance/abs(slope[2]))
  local gap=abs(players[p].y-yprojection)
  if(distance>ai_far_field) then
   --sizing it up faraway
   if(rnd()>0.94) then --tend to back up
    players[p].js[backwards]=flr(rnd(3))
   elseif(rnd()>0.98) then
    players[p].js[forwards]=flr(rnd(2))
   end
   if(not players[p].thinking) then
    players[p].thinking=5+flr(rnd(7.5))
   elseif(players[p].thinking>0) then
    players[p].thinking-=1
    if(not (players[p].js.u or players[p].js.d)) then
     if(oddball.y<players[p].y) then
      if(rnd()>0.25) players[p].js.u=2
     else
      if(rnd()>0.25) players[p].js.d=2
     end
    end
   else
    if(yprojection<top-5 or yprojection>bottom+5) then
     local to_wall,bounces,overage
     if(oddball.dy<0) then
      to_wall=oddball.y-stadium_field_top
      overage=stadium_field_top-yprojection
     else
      to_wall=stadium_field_bottom-oddball.y
      overage=yprojection-stadium_field_bottom
     end
     bounces=1+flr(abs(overage)/height)
     newyproj=overage%height
     if((bounces%2==1 and oddball.dy>0)
       or (bounces%2==0 and oddball.dy<0)) then
      newyproj=height-newyproj
     end
     newyproj+=stadium_field_top
    else
     newyproj=yprojection
    end
    if(players[p].y>newyproj) then
     players[p].js.u=5 players[p].js.d=nil
    else
     players[p].js.d=5 players[p].js.u=nil
    end   
   end
  else
   -- near field
   local nearyproj=yprojection
   if(yprojection<stadium_field_top-1 or yprojection>stadium_field_bottom+1) nearyproj=midfield
   if(gap>3 and distance<15) then
    players[p].js[forwards]=nil
    players[p].js[backwards]=2
   else
    if(rnd()>0.74) then --tend to run for it
     players[p].js[forwards]=3
    elseif(rnd()>0.83) then
     players[p].js[backwards]=2
    end    
   end
   if(players[p].y>nearyproj+1) then
    players[p].js.u=2
   elseif(players[p].y<nearyproj-4) then
    players[p].js.d=2
   end

   if(distance>7*abs(oddball.dx) and distance<8.1*abs(oddball.dx)) then
    if(gap<4) then
     players[p].js.o=10
    end
    printh("checking "..gap.." "..distance.." odx="..oddball.dx)
   end
   
  end
  
 end
end

function draw_joystick(num)
 local u,l
 if(num==1) l=stadium_field_left+stadium_field_goalzonewidth/2 else l=stadium_field_right-2.5*stadium_field_goalzonewidth
 u=stadium_field_top-15

 local diam=2

 rectfill(l,u,l+diam*14,u+diam*8,5)
 rect(l,u,l+diam*14,u+diam*8,15)

 local x,y

 x=l+diam*1.5 y=u+diam*4
 if(players[num].js.l) circfill(x,y,diam,8)
 circ(x,y,diam,7)

 x=l+diam*4.5 y=u+diam*4
 if(players[num].js.r) circfill(x,y,diam,8)
 circ(x,y,diam,7)

 x=l+diam*3 y=u+diam*2
 if(players[num].js.u) circfill(x,y,diam,8)
 circ(x,y,diam,7)

 x=l+diam*3 y=u+diam*6
 if(players[num].js.d) circfill(x,y,diam,8)
 circ(x,y,diam,7)

 x=l+diam*9 y=u+diam*5
 if(players[num].js.o) circfill(x,y,diam,8)
 circ(x,y,diam,7)

 x=l+diam*12 y=u+diam*5
 if(players[num].js.x) circfill(x,y,diam,8)
 circ(x,y,diam,7)
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
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
50000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005
50000000000000000000000000fff0f0f0fff0fff0f000fff00000fff00ff0ff000ff000000ff0fff0fff0ff00fff0f0f0fff000000000000000000000000005
500000000000000000000000000f00f0f0f0f00f00f000f0000000f0f0f0f0f0f0f0000000f0000f00f0f0f0f00f00f0f0fff000000000000000000000000005
500000000000000000000000000f00f0f0ff000f00f000ff000000fff0f0f0f0f0f0000000fff00f00fff0f0f00f00f0f0f0f000000000000000000000000005
500000000000000000000000000f00f0f0f0f00f00f000f0000000f000f0f0f0f0f0f0000000f00f00f0f0f0f00f00f0f0f0f000000000000000000000000005
500000000000000000000000000f000ff0f0f00f00fff0fff00000f000ff00f0f0fff00000ff000f00f0f0fff0fff00ff0f0f000000000000000000000000005
50000000000000000000000000000000000000000000000000000005555555555555555000000000000000000000000000000000000000000000000000000005
50000000000000000000000002222222222222222222222222222225333333333333335222222222222222222222222222222220000000000000000000000005
50000000000000000000000002222222222222222222222222222225fff3f3f3fff3fff222222222222222222222222222222220000000000000000000000005
500000000000000000000000022aaaaaaaaaaaaa2222222222222225f333f3f33f333f522222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a2222222222222225ff333f333f333f522222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a2222222222222225f333f3f33f333f522222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a2222222222222545fff3f3f3fff33f545222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244533333333333333544222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244555555555555555544222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a222222222222244666666666666666644222222222222222222222222222a220000000000000000000000005
500000000000000000000000022a22222222222a424222222ee22aaaa66666666666666999992ee222224242222222222222a220000000000000000000000005
50000000000000000000000002444444aaaaaaaa444422ee22e5ac1ac15666666666659a77a992ee222244442222222224444220000000000000000000000005
50000000000000000300000002655556222222a5664665e22e95a1ca1c59666666669559cddc59e22ea566466522222211111120000000030000000000000005
5000000000000022220000000565555652ee29a56d46d59e22999a9999596666666695eaaaae59ee29a56d46d59e222511ff1150000000222200000000000005
50000000000052277775000296555b5569e2295a444455922e95aaa99a59666666669e9e99e9e9e2295a444455922e955feef559000057777225000000000005
5000000000095227c7c592ee9655bc5569ee29559aa9559e2295aaaaaa5922ee22ee9e999999e9ee29559aa9559e2295f9999f5922e95c7c7225900000000005
522ee22ee22952222225922e9655bb55692ee9599aa9459ee29959559599e22ee22e9dd8558dd92ee9599aa9459ee295f9999f59e22952222225922ee22ee205
500000022ee9522222259ee296555b5569e22994999999922ee9999999922ee22ee2299999999ee22994999999922e95544445592ee9522222259ee200000005
500022ee22e95222222592ee9966666699ee2299999999ee22eea2ee2aee22e4224e22ae22ea22ee2299999999ee22991155119922e95222222592ee22200005
50000022ee29952255599e22e99999999e22ee2aee22ae2233323322ee22ee774772ee22ee224444ee2aee22ae22ee2999999992ee29955522599e2222000005
500000022ee2999999992ee22ea22eea2ee42e422ee22ee3333333e22ee257cc77c72ee22ee2411111e22ee224444442aee22ae22ee299999999222200000005
500022ee22ee2aee22ae22ee22ee22ee2277477e22ee2253377773ee22e957cc77c792ee2255411f11ee22ee2655556e22ee22e4224e2aee22ae22ee22200005
50000022ee22ee22ee2299999e22ee2257cc77c7ee22e95337474392ee29447aaa749e22e9554fee5592ee225655b565ee22ee274477ee22ee22ee2220000005
500000022ee22ee22e59a77a99e22ee957cc77c79ee229533ff8f5922ee94455aa549ee2295ff999f5922ee96555bb569ee22e7c77cc75e22ee2222200000005
5000022ee22ee22ee9559cddc59ee229447aaa74922ee955bf5f559ee2294a555554922ee9559999559ee2296555cb56922ee97c77cc759ee22ee22ee2200005
50000022ee22ee22e95eaaaae592ee294455aa549e22e955bbbb5592ee299aa55aa99e22e95544445592ee296555bb569e22e977aaa74492ee22ee2220000005
5000000022ee22ee29e9e99e9e9e22e94a55555492ee29955555599e22ee9999999922ee29951151199e22e96555b55692ee2945aa55449e22ee222000000005
5000022ee22efffffffffffffffffffffffffffff22ee2999999992ee22eea2ee2aee22ee2999999992efffffffffffffffffffffffffffff22ee22ee2000005
50000022ee22f555555555555555555555555555fe22ee2aee22ae22ee22ee22ee444444ee2aee22ae22f555555555555555555555555555fe22ee2220000005
5000000022eef555577755555555555555555555f24722ee22ee2aaaa2ee22ee2265555622ee22e333e3f555577755555555555555555555f2ee222000000005
5000022ee22ef555755575555555555555555555f447e22ee225ac1ac15ee22ee5655556522ee2233333f555755575555555555555555555f22ee22222000005
500000022ee2f555755575555555555555555555f9995ee22e95a1ca1c592ee296555b5569e22ee37777f555755575555555555555555555fee22ee200000005
5000000022eef555755575555555555555555555f99159ee22999a99995922ee9655bc5569ee22934747f555755575555555555555555555f2ee222000000005
5000022ee22ef577777777755555555555555555f114592ee295aaa99a59e22e9655bb55692ee295f8fff577777777755555555555555555f22ee22222000005
500000022ee2f755575755575555555555555555fd3b49e22e95aaaaaa592ee296555b5569e22e955f5ff788875755575555555555555555fee22ee200000005
50000000022ef755575755575555577755577755fd49492ee29959559599e22e99666666992ee2955bbbf788875755575555577755577755f22ee20000000005
50000022ee22f755575755575555755575755575f1555922ee2999999992ee22e99999999e22ee995555f788875755575555755575755575fe22ee2220000005
500000022ee2f577777777755555755575755575f9999ee22ee2aee22ae22ee22ea22eea2ee22ee99999f577777777755555755575755575fee2222200000005
50000000022ef555788875555555755575755575f22ae22ee22ee22ee22ee22ee22ee22ee22ee22ea22ef555788875555555755575755575f22ee20000000005
50000022ee22f555788875555555577755577755fe22ee22ee22ee22ee22ee22ee22ee22ee22ee22ee22f555788875555555577755577755fe22ee2220000005
5000000022eef555788875555555555555555555f2ee22ee22ee22ee22ee22ee22ee22ee22ee22ee22eef555788875555555555555555555f2ee222000000005
50000000022ef555577755555555555555555555f22ee22ee22ee22ee22ee22ee22ee22ee22ee22ee22ef555577755555555555555555555f222220000000005
500007777777f555555555555555555555555555f7777777777777777777777777777777777777777777f555555555555555555555555555f777777777700005
500007333333fffffffffffffffffffffffffffff3333333333333333333333333333333333333333333fffffffffffffffffffffffffffff333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733377737773333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733373733733333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733377733733333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733373733733333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733373737773333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333222333333700005
500007333333333333337333333333333333333333333333333333333333333333333333333333333333333333333333333333333337338333ff333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733883fff333333700005
50000733333337773777733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733383ff3333333700005
50000733333337373373733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733388bb4333333700005
500007333333377733737333333333333333333333333333333333333333333333333333333333333333333333333333333333333337333388b3333333700005
50000733333337373373733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333836333333700005
50000733333337373777733333333333333333333333333333333333333773777377733333333333333333333333333333333333333733333535333333700005
50000733333333333333733333333333333333333333333333333333337333373373733333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333337773373377733333333333333333333333333333333333333733333333333333700005
50000733333333888833733333333333333333333333333333333333333373373373333333333333333333333333333333333333333733333333333333700005
50000733333333fff333733333333333333333333333333333333333337733373373333333333333333333333333333333333333333733333333333333700005
50000733333333fff3c3733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
500007333333333bb3c3733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
500007333333333bb6c3733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
7000000000000777b777733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
070000000000033763c7733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
00700000000003776377733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
07000000000003333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
70000000000003733373733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
00000000000003333333733333333333333333333333333333333333333333333333333333333333333333333333333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333333338833333333333333333733333333333333700005
50000733333333333333733333333333333333333333333333333333333333333333333333333333333334b44833333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333333333334b344333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333333333333b3ab333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333333333334aab4333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333333333333333333a3343333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333333333aa33333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333333333333333a3333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333333aa33333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333333333333a3333333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333333aa33333333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333333333a3333333333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333333aa33333333333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333333a3333333333333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333333aa33333333333333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333333a3333333333333333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333333aa33333333333333333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333333a3333333333333333333333333333333333333333733333333333333700005
5000073333333333333373333333333333333333333333333333333333333333aa33333333333333333333333333333333333333333733333333333333700005
500007333333333333337333333333333333333333333333333333333333333a3333333333333333333333333333333333333333333733333333333333700005
5000077777777777777777777777777777777777777777777777777777777aa77777777777777777777777777777777777777777777777777777777777700005
500000000000000000000000000000000000000000000000000000000055a5555555500000000000000000000000000000000000000000000000000000000005
50888080808800880080800000888008800880888000000000000000005555555555500000000000000222020202220222020002220000022202220022022205
508080808080808080808000008080808080008000000000000000000055f5f55ff5500000000000000202020202020202020002000000020202020200020005
508800808080808080888000008800808088808800000000000000000055f5f5f555500000000000000222020202200222020002200000022202220200022005
508080808080808080008000008080808000808000000000000000000055f5f5fff5500000000000000200020202020200020002000000020002020202020005
508080088088808880888000008080880088008880000000000000000055fff555f5500000000000000200002202020200022202220000020002020222022205
5000000000000000000000000000000000000000000000000000000000555f55ff55500000000000000000000000000000000000000000000000000000000005
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
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 0c0d0e0f
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

