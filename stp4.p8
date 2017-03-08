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

 debug_msg_time=75
-- party screen test:
-- game_init()
-- player_wins(1+flr(rnd(2)))
end

function _draw()
  screen.draw()

  if(flr(cycles%2.5)==0) then
   debug_color=14
  elseif(flr(cycles%1.5)==1) then
   debug_color=7
  else
   debug_color=2
  end
  if(debug1!=nil) then
   print(debug1,66,66,debug_color)
   if(debug1_memory!=debug1) then debug1_memory=debug1 debug1_reminder=cycles end
   if(cycles-debug1_reminder>debug_msg_time) then debug1=nil debug1_memory=nil debug1_reminder=nil end  
  end
  if(debug2!=nil) then
   print(debug2,66,96,debug_color)
   if(debug2_memory!=debug2) then debug2_memory=debug2 debug2_reminder=cycles end
   if(cycles-debug2_reminder>debug_msg_time) then debug2=nil debug2_memory=nil debug2_reminder=nil end  
  end
  if(debug3!=nil) then
   print(debug3,62-4*#debug3,66,debug_color)
   if(debug3_memory!=debug3) then debug3_memory=debug3 debug3_reminder=cycles end
   if(cycles-debug3_reminder>debug_msg_time) then debug3=nil debug3_memory=nil debug3_reminder=nil end  
  end
  if(debug4!=nil) then
   print(debug4,62-4*#debug4,96,debug_color)
   if(debug4_memory!=debug4) then debug4_memory=debug4 debug4_reminder=cycles end
   if(cycles-debug4_reminder>debug_msg_time) then debug4=nil debug4_memory=nil debug4_reminder=nil end  
  end
end

function _update()
  cycles+=1
  
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
 stplogo.s={}
 stplogo.t={}
 stplogo.p={}
 stplogo.clr1=7
 stplogo.clr2=5
 stplogo.clr=stplogo.clr1

 stplogo.s.x=20 stplogo.s.y=45
 stplogo.s.width=15 stplogo.s.height=21
 stplogo.t.x=40 stplogo.t.y=50
 stplogo.t.width=15 stplogo.t.height=21
 stplogo.p.x=60 stplogo.p.y=55
 stplogo.p.width=15 stplogo.p.height=21

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
 if(lx>200) then lx=-200 end
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
 
 if(rnd()>0.975) then rx+=rnd()-subx end
 if(rnd()>0.985) then ry+=rnd()-suby end

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
  stplogo.clr=intro_left/2
  stplogo.s.x-=rnd()
  stplogo.s.y-=rnd()
  stplogo.s.width+=rnd(0.75)
  stplogo.s.height+=rnd(0.75)
  stplogo.t.x-=rnd()
  stplogo.t.y+=rnd(0.5)
  stplogo.t.width+=rnd(0.65)
  stplogo.t.height+=rnd(0.65)
  stplogo.p.x-=rnd(0.5)
  stplogo.p.y-=rnd()
  stplogo.p.width+=rnd(0.55)
  stplogo.p.height+=rnd(0.55)
 else
 end
 
 sspr(0,12,12,20,rnd(1.005)+stplogo.s.x,stplogo.s.y,stplogo.s.width,stplogo.s.height)
 sspr(16,12,12,20,rnd(1.010)+stplogo.t.x,stplogo.t.y,stplogo.t.width,stplogo.t.height)
 sspr(32,12,12,20,rnd(1.015)+stplogo.p.x,stplogo.p.y,stplogo.p.width,stplogo.p.height)

 if(intro_ending) then
   print("uper",stplogo.s.x+stplogo.s.width,stplogo.s.y+stplogo.s.height/2,stplogo.clr)
   print("urtle",stplogo.t.x+stplogo.t.width*0.8,stplogo.t.y+stplogo.t.height/2,stplogo.clr)
   print("ong",stplogo.p.x+stplogo.p.width*0.9,stplogo.p.y+stplogo.p.height/2,stplogo.clr)
 end
 
 if(flr(cycles/30)%2!=0) then print("insert money to play",8,90,6) end
 if(rnd()<0.975) then print("live",79+rnd(3),104+rnd(3),8) end
 if(rnd()<0.975) then print("live",79+rnd(3),104+rnd(3),8) end
 if(flr(cycles/25)%2!=0) then print("broadcasting live",28,105,11) end

 if(cycles<15) then print("from turtle pong stadium",xl,yt,letter) end

 
 for y=rainline,rainfloor do
  for x=xl-5,xr+5 do
   if(cycles<5) then
    --fade to black
    pset(x-1+rnd(3),y-1+rnd(3),0)
   else
    --smear it around
    --?
   end
  end
  
 end 
 
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
 stadium={}

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
  {"red","red","red","rouge","rusty","ruddy","redder","rosy","ruby","russet","big red"},
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

 stadium.field={}
 stadium.display={}

 stadium.fans={80,81,82,83,84,85,86,87,88}

 stadium.audience={}

 stadium.floor={}
 stadium.floor.top=25
 stadium.floor.height=32
 --regular floor
 local rugcolorpairs={{2,14,false},{3,4,false},{1,13,false},{0,5,false},{12,13,false},{12,13,true}}
 local i=1+flr(rnd(#rugcolorpairs))

 stadium.floor.color1=rugcolorpairs[i][1]
 stadium.floor.color2=rugcolorpairs[i][2]
 stadium.floor.flicker=rugcolorpairs[i][3]

 stadium.seats={
  {8,25},{21,24},{34,23},{47,22},
  {65,22},{78,23},{91,24},{104,25},

  {14,34},{28,33},{42,32},
          {56,31},
  {70,32},{84,33},{98,34},
  
  {19,43},{33,42},{47,41},
  {61,41},{75,42},{89,43},
 }
 
 stadium.field.left=5
 stadium.field.right=122
 stadium.field.top=58
 stadium.field.bottom=119
 stadium.field.middle=0.5*(stadium.field.left+stadium.field.right)
 stadium.field.chalkcolor=7
 stadium.field.grasscolor=3
 stadium.field.goalzonewidth=15

 stadium.display.left=25
 stadium.display.right=102
 stadium.display.top=8
 stadium.display.bottom=29
 stadium.display.lightcolor=10
 stadium.display.woodcolor=1
 if(rnd()<0.66) stadium.display.woodcolor=2
 if(rnd()<0.63) stadium.display.woodcolor=13
 stadium.display.digit_width=12
 stadium.display.digit_height_max=17
 stadium.display.digit_heights={2,2}

 players[1].x=stadium.field.left + stadium.field.goalzonewidth-13
 players[1].xmin=stadium.field.left-3
 players[1].xmax=stadium.field.left+stadium.field.goalzonewidth-5
 players[1].dx=0 players[1].dy=0

 players[2].x=stadium.field.right - stadium.field.goalzonewidth+5
 players[2].xmin=stadium.field.right-stadium.field.goalzonewidth-2
 players[2].xmax=stadium.field.right-4
 players[2].dx=0 players[2].dy=0

 players[1].y=stadium.field.top + 5
 players[2].y=stadium.field.bottom-13
 players[1].ymin=stadium.field.top-1
 players[1].ymax=stadium.field.bottom-8
 players[2].ymin=players[1].ymin
 players[2].ymax=players[1].ymax
 
 --seat the audience
 for seat=1,#stadium.seats do
  stadium.audience[seat]={}
  while(stadium.audience[seat].sprite==nil or stadium.audience[seat].sprite==stadium.audience[seat-1].sprite) do
   stadium.audience[seat].sprite=stadium.fans[1+flr(rnd(#stadium.fans))]
   if(seat==1 or rnd()<0.2) break   
  end
  stadium.audience[seat].timing=0
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
 if(players[num].stagger_effect == nil) then players[num].stagger_effect=0 end
 if(players[num].stagger_effect>0) then
  players[num].stagger_effect-=1
 else
  players[num].sprite=players[num].sprites[pose]
 end
end

function player_service(num)
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
   oddball.dy+=1.75*players[num].dy
   sfx(1+num) sfx(4)
  end
 else
  --dancing?
 end
 set_player_pose(num,3)
end

function player_windup(num)
 if(players[num].serve_power==nil) then players[num].serve_power=1 end

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
 middle=0.5*(stadium.field.left+stadium.field.right)
 width=10
 x1=middle-width/2 x2=middle+width/2 
 y1=stadium.field.bottom-1 y2=127

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
  rectfill(x1,stadium.field.bottom+1,x2,126,5)
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
 
 if(stadium.floor.flicker) then
  local t=stadium.floor.color1
  stadium.floor.color1=stadium.floor.color2
  stadium.floor.color2=t
 end

 
 for p=1,2 do
  set_player_pose(p,1+flr(rnd(1.05)))

  if(players[p].ai) then
   if(false) then
    -- simple ai
    if(oddball.y<players[p].y+2) then
     players[p].js["u"]=1
    elseif(oddball.y>players[p].y+6) then
     players[p].js["d"]=1
    end

   else
    ai_control(p)
--    newbtn_init() to hold still
   end
  end

  if((players[p].holding or players[p].dancing or not newbtn("o",p))) then
   if(newbtn("l",p)) players[p].dx-=0.45-rnd(0.05)
   if(newbtn("r",p)) players[p].dx+=0.39+rnd(0.05)
   if(newbtn("u",p)) players[p].dy-=0.45-rnd(0.03)
   if(newbtn("d",p)) players[p].dy+=0.45+rnd(0.03)
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

  if(newbtn("o",p) or players[p].winding_up) then player_service(p) end
--  if(newbtnp("x",p)) then players[(p%2)+1].score+=1 end
 end

 if(oddball.upforgrabs) then
  oddball.x=(stadium.field.left+stadium.field.right)/2-4
  oddball.y=(stadium.field.top+stadium.field.bottom)/2-4
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

 local slope=oddball.dy/oddball.dx if(oddball.approaching_player==2) then slope*=-1 end
 local offset
 
 if(abs(oddball.x-players[oddball.approaching_player].x)<3) then
  --check for paddle impact
  local num,shieldhity1,shieldhity2

  num=oddball.approaching_player
  shieldhity1=players[num].y-5
  shieldhity2=players[num].y+7

  offset=flr(0.5+oddball.y-shieldhity1)
  if(oddball.y>=shieldhity1 and oddball.y<=shieldhity2) then
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
   if(newbtn("o",oddball.approaching_player)) then oddball.dx*=1.1 sfx(0) end   
  end
 end

 oddball.approaching_player=1 if(oddball.dx > 0) then oddball.approaching_player=2 end 

 --out of bounds
 if((oddball.y<=stadium.field.top or oddball.y>=stadium.field.bottom-6) and 
    not (players[1].holding or players[2].holding)) then
  oddball.y+=-1*oddball.dy/abs(oddball.dy) --prevents getting stuck
  oddball.dy*=-1
  oddball.dy*=0.75+rnd(0.2)
 end

 --score!! goal!!
 local scoring_player
 if(oddball.x<stadium.field.left-4 or oddball.x>stadium.field.right-3) then
  if(oddball.x>stadium.field.middle) then
   scoring_player=1
  else
   scoring_player=2
  end
  players[scoring_player].score+=1
  stadium.display.digit_heights[scoring_player]=2
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
 for i=1,#stadium.audience do
  stadium.audience[i].timing=-19+flr(rnd(39))
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
 draw_floor(stadium.field.middle,stadium.floor.top,stadium.floor.height)
 draw_names()
 
 local exitx=(stadium.display.left+stadium.display.right)/2-12
 local exity=stadium.display.bottom-25
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
   print(msg,stadium.field.middle-2*#msg,stadium.field.bottom-15,clr)   
  end
  if(help_flag and (players[1].holding or players[2].holding) and cycles-intro_ending_at>145) then
   msg="(let that turtle fly!))"
   print(msg,stadium.field.middle-2*#msg,stadium.field.bottom-22,clr)
   msg="     watch | that meter"
   print(msg,stadium.field.middle-2*#msg,stadium.field.bottom-13,clr)
   msg="|"
   print(msg,stadium.field.middle-2*#msg,stadium.field.bottom-8,cycles%16+rnd(3))
   msg="v"
   print(msg,stadium.field.middle-2*#msg,stadium.field.bottom-6,4+cycles%5)
   
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
 rectfill(stadium.field.left, stadium.field.top,
  stadium.field.right,stadium.field.bottom,
  stadium.field.grasscolor)
 rect(stadium.field.left, stadium.field.top,
  stadium.field.right,stadium.field.bottom,
  stadium.field.chalkcolor)
 rect(stadium.field.left, stadium.field.top,
  stadium.field.left+stadium.field.goalzonewidth,
  stadium.field.bottom, stadium.field.chalkcolor)
 rect(stadium.field.right, stadium.field.top,
  stadium.field.right-stadium.field.goalzonewidth,
  stadium.field.bottom, stadium.field.chalkcolor)
 print("stp",
   (stadium.field.left+stadium.field.right)/2-5,
   (stadium.field.top+stadium.field.bottom)/2-3)
end   

function draw_player(num)
--this should be in game_update
-- or its own function called
-- from game_update (player_update()?)
 if(players[num].dancing) then
  if(players[num].started_dancing==nil) then players[num].started_dancing=cycles end
  
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

 if(players[num].x < players[num].xmin) then players[num].x=players[num].xmin end
 if(players[num].y < players[num].ymin) then players[num].y=players[num].ymin end
 if(players[num].x > players[num].xmax) then players[num].x=players[num].xmax end
 if(players[num].y > players[num].ymax) then players[num].y=players[num].ymax end 

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
 coords[1].x=stadium.display.left+2
 coords[1].y=stadium.display.top+2
 coords[2].x=stadium.display.right-2-stadium.display.digit_width
 coords[2].y=stadium.display.top+2
 
 rectfill(stadium.display.left,stadium.display.top,
  stadium.display.right, stadium.display.bottom,
  stadium.display.woodcolor)

 for i=1,2 do
  if(players[i].score==0) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y,stadium.display.lightcolor)   
  end 
  if(players[i].score==1) then
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==2) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==3) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==4) then
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==5) then
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x,coords[i].y,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==6) then
   line(coords[i].x,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y,stadium.display.lightcolor)   
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==7) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
  end 
  if(players[i].score==8) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x,coords[i].y+stadium.display.digit_heights[i],coords[i].x,coords[i].y,stadium.display.lightcolor)   
  end 
  if(players[i].score==9) then
   line(coords[i].x,coords[i].y,coords[i].x+stadium.display.digit_width,coords[1].y,stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y,coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i],stadium.display.lightcolor)
   line(coords[i].x+stadium.display.digit_width,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,stadium.display.lightcolor)
   line(coords[i].x,coords[i].y+stadium.display.digit_heights[i]/2,coords[i].x,coords[i].y,stadium.display.lightcolor)
  end 

  if(stadium.display.digit_heights[i]<stadium.display.digit_height_max) then
   stadium.display.digit_heights[i]+=1
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
   if rad>60 then rad=62 end
  else
   rad=60-1.5*(i%3)-i/10
  end
  local l=middle-rad
  local r=middle+rad
  local h=top+i
  line(l,h,r,h,stadium.floor.color1)
  for j=l+2,r-2,4 do
   local c=stadium.floor.color2
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
 for seat=1,#stadium.seats do
  local seatx=stadium.seats[seat][1]
  local seaty=stadium.seats[seat][2]
  spr(6,seatx,seaty,2,2)
  --draw each audience member in 
  -- their seat, facing the ball
  local fan_sprite=stadium.audience[seat].sprite
  if(oddball.x < seatx+stadium.audience[seat].timing) then fan_sprite-=16 end
  if(oddball.x > seatx+8+stadium.audience[seat].timing) then fan_sprite+=16 end
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
 local compliments={"’stellar’","first place","–electric–","…like a ninja…","epic","rad"}
 adjective=compliments[1+flr(rnd(#compliments))]
end


function party_update()
 party_time=cycles-party_started
 if(party_time>120 or ((party_time>25) and (newbtnp("o",1) or newbtnp("o",2)))) then do_intro() end

 sound_effect_mgmt()
 newbtn_mgmt()
end

function party_draw()
 cls(5)

 draw_floor(80,65,63)
 draw_door(70,44)
 
 local p=1.1*(8+party_time/12)
 
 for i=1,#stadium.audience do
  local z=stadium.audience[i].sprite+32
  sspr(z*8%128,8*flr(z*8/128),8,8,
   60+p+(i%4)*(15-(p/1.5+10/(3+flr(i/6)))),--x
   61-p/12+flr(i/6)*(7-i/10),--y
   20/p*(flr(i/6)*6),--w
   20/p*(flr(i/6)*6),--h
   (cycles%3==0)--x flip
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
 if(party_time>10) then print("thanks for playing",10,15,clr1) end
 if(party_time>20 and flr(cycles/20)%2==0) then print("that was "..adjective.."!!",13,23,clr2) end

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
   if(y>party_line1(x)) then pset(x,y,party_fn(x,y)) end
   if(y<party_line2(x)) then pset(x,y,party_fn(x,y)) end
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
    players[p].js[newbtn_conv(b)]=nil
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
 
 local midfield=0.5*(stadium.field.top+stadium.field.bottom)-11+rnd(9)
 local distance=abs(players[p].x-oddball.x)
 if(p==2) distance+=3 else distance-=4
 local slope={oddball.dy*(0.95+rnd(0.04)),oddball.dx*(0.9+rnd(0.09))}
 slope.a=slope[1]/slope[2]
 local top=stadium.field.top local bottom=stadium.field.bottom
 local height=bottom-top
 local direction=oddball.dx/abs(oddball.dx)
 if(rnd()>0.5) players[p].js["l"]=1
 if(rnd()>0.5) players[p].js["r"]=1

 if(oddball.upforgrabs or players[p%2+1].holding or p!=oddball.approaching_player) then
  --amble toward midfield
  if(players[p].y<midfield and rnd()>0.5) players[p].js["d"]=1
  if(players[p].y>midfield and rnd()>0.5) players[p].js["u"]=1
 else
  local yprojection=oddball.y+slope[1]*(distance/abs(slope[2]))
  if(distance>ai_far_field) then
   --sizing it up faraway
   if(yprojection<top-5 or yprojection>bottom+5) then
    local to_wall,bounces,overage
    if(oddball.dy<0) then
     to_wall=oddball.y-stadium.field.top
    else
     to_wall=stadium.field.bottom-oddball.y
    end
    overage=abs(yprojection-oddball.y)-to_wall
    bounces=flr(overage/height)
    newyproj=overage%height
    if(bounces%2==1 and oddball.dy<0 or bounces%2==1 and oddball.dy>0) newyproj=height-newyproj
    newyproj+=stadium.field.top
   else
    newyproj=yprojection
   end
   if(players[p].y>newyproj) then
    players[p].js["u"]=1
   else
    players[p].js["d"]=1
   end   
  else
   -- near field
   if(players[p].y>yprojection+1) then
    players[p].js["u"]=1
   elseif(players[p].y<yprojection-1) then
    players[p].js["d"]=1
   end
  end
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
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0123456789
bbe02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468
55bb69cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147
5555bb26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26
555555bb27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05
55555555bb6c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4
5555555555bbe5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3
555555555555bba2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
55555555555555bba3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81
5555555555555555bbe82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60
555555599999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999983e94fa50b61c72d83e94f
55555559555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555592ea62ea62ea62ea62ea62e
5555555955555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555559c9630da741eb852fc9630d
55555559555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555596420eca86420eca86420ec
55555559559995959599959955959559955555999559959995555599959555999595959995995559955555555555555555555555590fedcba9876543210fedcb
5555555955595595959595959595959555555595559595959555559595955595959595595595959555555555555555555555555559aaaaaaaaaaaaaaaaaaaaaa
5555555955595599959995959599559995555599559595995555559995955599959995595595959555555555555555555555555559456789abcdef0123456789
5555555955595595959595959595955595555595559595959555559555955595955595595595959595555555555555555555555559e02468ace02468ace02468
55555559555955959595959595959599555555955599559595555595559995959599959995959599955555555555555555555555598be147ad0369cf258be147
555555595555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555926ae26ae26ae26ae26ae26
5555555955555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555559c16b05af49e38d27c16b05
55555559555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555596c28e4a06c28e4a06c28e4
f55555595555544454545444544455555454544455445555555555555444545554445544544454445444554455555555554555455907e5c3a18f6d4b2907e5c3
a555555955555545545454545545555554545454545555555455545554555455545554555545545455455455545554555545554559a2a2a2a2a2a2a2a2a2a2a2
af555559555555455444544455455555545454445444555555454545544554555445545555455445554554555545454555455545594d6f81a3c5e7092b4d6f81
a4f5555955555545545454545545555554445454555455555554555454555455545554555545545455455455555455545555555559e82c60a4e82c60a4e82c60
a50555595555554554545454554555555444545454455555555555555444544454445544554554545444554455555555554555455983e94fa50b61c72d83e94f
a62f5559555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555592ea62ea62ea62ea62ea62e
a741f55955555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555559c9630da741eb852fc9630d
a8642559555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555596420eca86420eca86420ec
a9876f59555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555590fedcba9876543210fedcb
aaaaaaf955555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555559aaaaaaaaaaaaaaaaaaaaaa
abcdef0999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999456789abcdef0123456789
ace0246f55555555555555555555555555555555555555555555555555555555bbe02468ace02468ace02468ace02468ace02468ace02468ace02468ace02468
ad0369cff555555555555555555555555555555555555555555555555555555555bb69cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258be147
ae26ae26a55555555555555555555555555555555555555555555555555555555555bb26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26
af49e38d2f555555555555555555555555555555555555555555555555555555555555bb27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05
a06c28e4a0f5555555555555555555555555555555555555555555555555555555555555bb6c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4
a18f6d4b290555555555555555555555555555555555555555555555555555555555555555bbe5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3
a2a2a2a2a2af8888888888888888888888888888888888888888888888888888888888888885bba2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2
a3c5e7092b4d888888888888888888888888888888888888888888888888888888888888888555bba3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81
a4e82c60a4e888fff88ff8f8f88ff8fff88888fff8fff8f888fff88888f8f8fff8ff888ff8855555bbe82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60
a50b61c72d8388f8f8f8f8f8f8f888f8888888f8f8f8f8f888f8888888f8f88f88f8f8f88885555555bb61c72d83e94fa50b61c72d83e94fa50b61c72d83e94f
a62ea62ea62e88ff88f8f8f8f8f888ff888888ff88fff8f888ff888888f8f88f88f8f8fff88555555555bb2ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62e
a741eb852fc988f8f8f8f8f8f8f8f8f8888888f8f8f8f8f888f8888888fff88f88f8f888f8855555555555bb2fc9630da741eb852fc9630da741eb852fc9630d
a86420eca86488f8f8ff888ff8fff8fff88888f8f8f8f8fff8f8888888fff8fff8f8f8ff8885555555555555bb6420eca86420eca86420eca86420eca86420ec
a9876543210f888888888888888888888888888888888888888888888888888888888888888555555555555555bbedcba9876543210fedcba9876543210fedcb
aaaaaaaaaaaa88888888888888888888888888888888888888888888888888888888888888833333333333333555bbaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
abcdef0123456789af555555555555555555555555555555555555555555555555555555555fff3f3f3fff3fff5555bbabcdef0123456789abcdef0123456789
ace02468ace02468acf55555555555555555555555555555555555555555555555555555555f333f3f33f333f5555555bbe02468ace02468ace02468ace02468
ad0369cf258be147ad055555555555555555555555555555555555555555555555555555555ff333f333f333f555555555bb69cf258be147ad0369cf258be147
ae26ae26ae26ae26ae2f5555555555555555555555555555555555555555555555555555555f333f3f33f333f55555555555bb26ae26ae26ae26ae26ae26ae26
af49e38d27c16b05af49f555555555555555555555555555555555555555555555555555545fff3f3f3fff33f5455555555555bb27c16b05af49e38d27c16b05
a06c28e4a06c28e4a06c255555555555555555555555555555555555555555555555555544533333333333333544555555555555bb6c28e4a06c28e4a06c28e4
a18f6d4b2907e5c3a18f6f555555555555555555555555555555555555555555555555554455555555555555554455555555555555bbe5c3a18f6d4b2907e5c3
a2a2a2a2a2a2a2a2a2a2a2f5555555555555555555555555555555555555555555555555446666666666666666445555555555555555bba2a2a2a2a2a2a2a2a2
a3c5e7092b4d6f81a3c5e70555555555555555555555555555555555555555555555555544666666666666666644555555555555555555bba3c5e7092b4d6f81
a4e82c60a4e82c60a4e82c6f5555555555555555555555555555555555555555555555554466646466464666664455555555555555555555bbe82c60a4e82c60
a50b61c72d83e94fa50b61c7f5555555555555555555555555555555555555555554545544666444644444644444aaa5555555555555555555bb61c72d83e94f
a62ea62ea62ea62ea62ea62ea555555555555555555555555555555555555555554444454446644444444414441aaaaa55555555555555555555bb2ea62ea62e
a741eb852fc9630da741eb852f5555555555555555555555555555555555555554444441444164444444441fff1aaaaa5555555555555555555555bb2fc9630d
a86420eca86420eca86420eca8f555555555555555555555555555555555555554444441fff169994a4444f9994aaaaa555555555555555555555555bb6420ec
a9876543210fedcba9876543210555555555555555555555555555555555555554a4444f999699a94a44a4444493344444444444335555555555555555bbedcb
aaaaaaaaaaaaaaaaaaaaaaaaaaaf55555555555555555555555555555555555554a333333434439a4444aa14414334444444444433555555555555555555bbaa
abcdef0123456789abcdef012345f5555555555555555555555555555555555555533333343443664444444442222665555555222222255555555555555555bb
ace02468ace02468ace02468ace02555555555555555555555555555555555555333333333344444444444444222266555555522222225555555555555555555
ad0369cf258be147ad0369cf258bef55555555555555555555555555555555555333333333344444444444444233333333352333333222255555555555555555
ae26ae26ae26ae26ae26ae26ae26aef5555555555555555555555555555555555333333333344444433344444233333333352333333222255555555555555555
af49e38d27c16b05af49e38d27c16b055555555555555555555555555555555553333333333444444333444442333333333b2333333222255555555555555555
a06c28e4a06c28e4a06c28e4a06c28ef555555555555555555555555555555555553333333344444433444433333333333333333333333255555555555555555
a18f6d4b2907e5c3a18f6d4b2907e5c3f55555555555555555555555555555555553333aaaaaaa22222444433333333333333333333333255555555555555555
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a55555555555555555555555555555555555533aaaaaaa22222444433333333333333333333333255555555555555555
a3c5e7092b4d6f81a3c5e7092b4d6f81af55555555555555555555555555555555555bbaaaaaaa22444444433333333333333333333333255555555555555555
a4e82c60a4e82c60a4e82c60a4e82c60a4f555555555555555555555555555555555aaaaaaa22222444444433333333333333333333333255555555555555555
a50b61c72d83e94fa50b61c72d83e94fa50555555555555555555555555555555555aaaaaaa22222444444433333333333333333333333255555555555555555
a62ea62ea62ea62ea62ea62ea62ea62ea62f55555555555555555555555555555555aaaaaaa22222444444444433333333333333333555555555555555555555
a741eb852fc9630da741eb852fc9630da741f5555555555555555555555555555555aaaaaaa22222444444444433333333333333333555555555555555555555
a86420eca86420eca86420eca86420eca86425555555555555555555555555555555aaaaaaa22222444444444433333333333333333555555555555555555555
a9876543210fedcba9876543210fedcba9876f555555555555555555555555555555aaaaaaa22222444444444444433333333333555555555555555555555555
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaf55555555555555555555555555999aaaaaaa22222444444444444433333333333555555555555555555555555
abcdef0123456789abcdef0123456789abcdef055555555555555555555555555999aaaaaaa22222444aaa4444444bbbbbbbbbbb555555555555555555555555
ace02468ace02468ace02468ace02468ace0246f5555555555555555555555555555aaaaaaa22222444aaa4444444bbbbbbbbbbb555555555555555555555555
ad0369cf258be147ad0369cf258be147ad0369cff555555555555555555555555555aaaaaaa22222444aaa4444444bbbbbbbbbbb555555555555555555555555
ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26a555555555555555555555555555aaaaaaa22222444aaaaaa4444bbbbbbbbbbb555555555555555555555555
af49e38d27c16b05af49e38d27c16b05af49e38d2f55555555555555555555555999aaaaaaa22222444aaaaaa4444bbbbbbbbbbb555555555555555555555555
a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a0f5555555555555555555555999aaaaaaa22222444aaaaaa4444bbbbbbbbbbb555555555555555555555555
a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2905555555555555555555555999aaaaaaa2222222222244444444aaaaaa5555555555555555555555555555
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2af55555555555555555555555555555555552222222244444444aaaaaa5555555555555555555555555555
a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4df5555555555555555555555555555555552222222244444444aaaaaa5555555555555555555555555555
a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e8255555555555555555555555555555555522222222555555555555555555555555555555555555555555
a50b61c72d83e94fa50b61c72d83e94fa50b61c72d83ef5555555555555555555555555555555555555555555555555555555555555555555555555555555555
a62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea6f555555555555555555555555555555555555555555555555555555555555555555555555555555555
a741eb852fc9630da741eb852fc9630da741eb852fc9630555555555555555555555555555555555555555555555555555555555555555555555555555555555
a86420eca86420eca86420eca86420eca86420eca86420ef55555555555555555555555555555555555555555555555555555555555555555555555555555555
a9876543210fedcba9876543210fedcba9876543210fedcbf5555555555555555555555555555555555555555555555555555555555555555555555555555555
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa5555555555555555555555555555555555555555555555555555555555555555555555555555555
abcdef0123456789abcdef0123456789abcdef0123456789af555555555555555555555555555555555555555555555555555555555555555555555555555555
ace02468ace02468ace02468ace02468ace02468ace02468acf55555555555555555555555555555555555555555555555555555555555555555555555555555
ad0369cf258be147ad0369cf258be147ad0369cf258be147ad055555555555555555555555555555555555555555888888888888555555555555555555555555
ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae2f5555555555555555555555555555555555555555888888888888555555555555555555555555
af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49f555555555555555555555555555555555555555888888888888555555555555555555555555
a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c2555555555555555555555555555555555555555fffffffff555555555555555555555555555
a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6f55555555555555555555555555555555555555fffffffff555555555555555555555555555
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2f5555555555555555555555555555555555555fffffffff555555555555555555555555555
a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e705555555555555555555555555555555555555fffffffff555ccc555555555555555555555
a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c6f555555555555555555555555555555555555fffffffff555ccc555555555555555555555
a50b61c72d83e94fa50b61c72d83e94fa50b61c72d83e94fa50b61c7f55555555555555555555555555555555555fffffffff555ccc555555555555555555555
a62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea55555555555555555555555555555555555555bbbbbb555ccc555555555555555555555
a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852f5555555555555555555555555555555555555bbbbbb555ccc555555555555555555555
a86420eca86420eca86420eca86420eca86420eca86420eca86420eca8f555555555555555555555555555555555555bbbbbb555ccc555555555555555555555
a9876543210fedcba9876543210fedcba9876543210fedcba9876543210555555555555555555555555555555555555bbbbbb666ccc555555555555555555555
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaf55555555555555555555555555555555555bbbbbb666ccc555555555555555555555
abcdef0123456789abcdef0123456789abcdef0123456789abcdef012345f5555555555555555555555555555555555bbbbbb666ccc555555555555555555555
ace02468ace02468ace02468ace02468ace02468ace02468ace02468ace025555555555555555555555555555555555bbbbbb555ccc555555555555555555555
ad0369cf258be147ad0369cf258be147ad0369cf258be147ad0369cf258bef555555555555555555555555555555555bbbbbb555ccc555555555555555555555
ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26ae26aef55555555555555555555555555555555bbbbbb555ccc555555555555555555555
af49e38d27c16b05af49e38d27c16b05af49e38d27c16b05af49e38d27c16b055555555555555555555555555555555666555555ccc555555555555555555555
a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28e4a06c28ef5555555555555555555555555555555666555555ccc555555555555555555555
a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3a18f6d4b2907e5c3f555555555555555555555555555555666555555ccc555555555555555555555
a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a2a555555555555555555555555555555666555555555555555555555555555555
a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81a3c5e7092b4d6f81af55555555555555555555555555555666555555555555555555555555555555
a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4e82c60a4f5555555555555555555555555555666555555555555555555555555555555
a50b61c72d83e94fa50b61c72d83e94fa50b61c72d83e94fa50b61c72d83e94fa505555555555555555555555555555555555555555555555555555555555555
a62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62ea62f555555555555555555555555555555555555555555555555555555555555
a741eb852fc9630da741eb852fc9630da741eb852fc9630da741eb852fc9630da741f55555555555555555555555555555555555555555555555555555555555
a86420eca86420eca86420eca86420eca86420eca86420eca86420eca86420eca864255555555555555555555555555555555555555555555555555555555555
a9876543210fedcba9876543210fedcba9876543210fedcba9876543210fedcba9876f5555555555555555555555555555555555555555555555555555555555

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

