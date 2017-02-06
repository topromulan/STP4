pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- super turtle pong 4
-- 2016-2017 macrowave

function _init()
 screen={}
 cycles=0 
 do_intro()
end

function _draw()
  screen.draw()

--  print(cycles,0,0,9,0)
  if(debug1!=nil) then
   print(debug1,0,50,9,0)
   if(debug1_memory!=debug1) then debug1_memory=debug1 debug1_reminder=cycles end
   if(cycles-debug1_reminder>150) then debug1=nil debug1_memory=nil debug1_reminder=nil end  
  end
  if(debug2!=nil) then
   print(debug2,0,60,9,0)
   if(debug2_memory!=debug2) then debug2_memory=debug2 debug2_reminder=cycles end
   if(cycles-debug2_reminder>150) then debug2=nil debug2_memory=nil debug2_reminder=nil end  
  end
  if(debug3!=nil) then
   print(debug3,0,109,9,0)
   if(debug3_memory!=debug3) then debug3_memory=debug3 debug3_reminder=cycles end
   if(cycles-debug3_reminder>150) then debug3=nil debug3_memory=nil debug3_reminder=nil end  
  end
  if(debug4!=nil) then
   print(debug4,0,119,9,0)
   if(debug4_memory!=debug4) then debug4_memory=debug4 debug4_reminder=cycles end
   if(cycles-debug4_reminder>150) then debug4=nil debug4_memory=nil debug4_reminder=nil end  
  end
end

function _update()
  cycles+=1

  --fix bug when it wraps
  if(cycles<0) then cycles=1 oddball.service_time=0 end

  screen.update()

end

function do_intro()

 intro_ending=false
 intro_ending_at=nil

 --coordinates of planets l/r
 lx=40 ly=20
 rx=80 ry=20

 lcolor=8
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
  
 cls(5)
end

function intro_update()
 if(btnp()!=0) intro_ending=true
 if(intro_ending) then
  if(intro_ending_at==nil) then
   intro_ending_at=cycles+55
   sfx(10) sfx(11)
  end
  if(cycles>intro_ending_at) play_game()
  rainfloor+=0.23
  for x=1,50 do
   pset(10+rnd(104),rainfloor-rnd(),0)
  end
 end 
 
 lx+=1
 if(lx>200) then lx=-200 end

 if(rnd()>0.975) then rx+=rnd()-0.5 end
 if(rnd()>0.985) then ry+=rnd()-0.5 end
 
 if(lx==50) then sfx(0) end

end

function intro_draw()
 rectfill(0,0,127,102,5)
 circfill(lx,ly,32+sin(lx/1000)*20,lcolor)
 circfill(rx,ry,30,rcolor)
 print("2017 macrowave",38,25,11) 

 if(intro_ending) intro_left=intro_ending_at-cycles
 if(intro_ending) then
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
 game_init()
 screen.update=game_update
 screen.draw=game_draw
end

function game_init()
 players={}
 stadium={}

 oddball = {}
 oddball.sprites = {11,12,13,29,45,44,43,27}

 players[1] = {}
 players[2] = {}

 players[1].sprites = {9,25,41,57,56,55,54}
 players[2].sprites = {10,26,42,58,59,60,61}
 
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
 
 trophy_for_player1=false
 trophy_for_player2=false
 party_message=nil

 stadium.field={}
 stadium.display={}

 stadium.fans={80,81,82,83,84,85,86,87,88}

 stadium.audience={}

 stadium.floor={}
 stadium.floor.top=26
 stadium.floor.height=33
 stadium.floor.color1=12
 stadium.floor.color2=13
 
 stadium.seats={
  {9,27},{22,26},{35,25},{48,24},
  {64,24},{77,25},{90,26},{103,27},

  {14,36},{28,35},{42,34},
          {56,33},
  {70,34},{84,35},{98,36},
  
  {19,45},{33,44},{47,43},
  {61,43},{75,44},{89,45},
  
 }
 
 stadium.field.left=5
 stadium.field.right=122
 stadium.field.top=60
 stadium.field.bottom=121
 stadium.field.middle=0.5*(stadium.field.left+stadium.field.right)
 stadium.field.chalkcolor=7
 stadium.field.grasscolor=3
 stadium.field.goalzonewidth=15

 stadium.display.left=25
 stadium.display.right=102
 stadium.display.top=5
 stadium.display.bottom=29
 stadium.display.lightcolor=10
 stadium.display.woodcolor=2
 stadium.display.digit_width=12
 stadium.display.digit_height_max=20
 stadium.display.digit_heights={2,2}

 players[1].x = stadium.field.left + stadium.field.goalzonewidth-13
 players[1].xmin = stadium.field.left-3
 players[1].xmax = stadium.field.left+stadium.field.goalzonewidth-5

 players[2].x=stadium.field.right - stadium.field.goalzonewidth+5
 players[2].xmin=stadium.field.right-stadium.field.goalzonewidth-2
 players[2].xmax=stadium.field.right-4

 players[1].y=stadium.field.top + 5
 players[2].y=stadium.field.bottom-13
 players[1].ymin=stadium.field.top-1
 players[1].ymax=stadium.field.bottom-8
 players[2].ymin=players[1].ymin
 players[2].ymax=players[1].ymax
 
 --seat the audience
 for seat=1,#stadium.seats do
  stadium.audience[seat]={}
  stadium.audience[seat].sprite=stadium.fans[1+flr(rnd(#stadium.fans))]
  stadium.audience[seat].timing=0
 end
 shuffle_audience_timing()
 
 oddball.upforgrabs=true
 oddball.service_time=cycles+10+rnd(3)
 oddball.dx=0 oddball.dy=0
 oddball.x=64 -- so it's not nil

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
  if(btn(4,num-1)) then
   --still winding up
   players[num].winding_up=true
   player_windup(num)
  else
   --let it fly
   players[num].holding=false
   players[num].winding_up=false
   oddball.dx=-1*(-3+2*num)*(1+rnd(0.5)+players[num].serve_power/10)
   oddball.dy=0.1-rnd(0.2)
   sfx(1+num) sfx(4)
  end
 else
  --dance unless within serving range
  -- or already dancing
  if(abs(oddball.x-players[num].x)>15 and not oddball.upforgrabs
    and not players[num].dancing) then
   players[num].dancing=true
   sfx(10) sfx(11)
  end
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
 local draw_it,num
 if(players[1].winding_up) then
  draw_it=true num=1
 elseif(players[2].winding_up) then
  draw_it=true num=2
 else
  draw_it=false
 end
 if(draw_it) then
  local x1,y1,x2,y2,middle,width
  middle=0.5*(stadium.field.left+stadium.field.right)
  width=10
  x1=middle-width/2 x2=middle+width/2 
  y1=stadium.field.bottom+1 y2=127
  meter_right=x1+(width-1)*(players[num].serve_power/10)
  rect(x1,y1,x2,y2,15)
  rectfill(x1+1,y1+1,x2-1,y2-1,14)
  rectfill(x1+1,y1+1,meter_right,y2-1,8)
 end  
end


function game_update()
 if(cycles>oddball.service_time) then
  if(players[1].score>=9) then
   player_wins(1) 
  end
  if(players[2].score>=9) then
   player_wins(2)
  end
 end
 
 local t=stadium.floor.color1
 stadium.floor.color1=stadium.floor.color2
 stadium.floor.color2=t

 -- original version:
 -- if(btnp(4)) then players[1].score += 1 end
 -- if(btnp(5)) then players[2].score += 1 end


 for p=1,2 do
  set_player_pose(p,1+flr(rnd(1.05)))
  players[p].moving=false
  if(btn(0,p-1)) then players[p].x-=0.75 players[p].moving=true end
  if(btn(1,p-1)) then players[p].x+=0.89+rnd(0.05) players[p].moving=true end
  if(btn(2,p-1)) then players[p].y-=0.95+rnd(0.03) players[p].moving=true end
  if(btn(3,p-1)) then players[p].y+=0.95+rnd(0.03) players[p].moving=true end
--  if(moving) then players[p].sprite=players[p].sprites[1+flr(rnd(2))] end
  if(players[p].moving) then set_player_pose(p,1+flr(rnd(2))) end
  if(btn(4,p-1) or players[p].winding_up) then player_service(p) end
--  if(btnp(5,p-1)) then players[p].score+=1 end
  if(btnp(5,p-1)) then players[p].score+=1 end
 end

 if(oddball.upforgrabs) then
  oddball.x = (stadium.field.left+stadium.field.right)/2-4
  oddball.y = (stadium.field.top+stadium.field.bottom)/2-4
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

 local approaching_player=1 if(oddball.dx > 0) then approaching_player=2 end 
 local slope=oddball.dy/oddball.dx if(approaching_player==2) then slope*=-1 end
 local offset
 
 if(abs(oddball.x-players[approaching_player].x)<2) then
  --check for paddle impact
  local shieldhity1=players[approaching_player].y-5
  local shieldhity2=players[approaching_player].y+7
  offset=flr(0.5+oddball.y-shieldhity1)
  if(oddball.y>=shieldhity1 and oddball.y<=shieldhity2) then
   if(not players[approaching_player].dancing) then
    --collision
    oddball.dx*=-1
    if(offset<2.1) then oddball.dy-=2
    elseif(offset<4.1) then oddball.dy-=0.25 oddball.dy*=1.2
    elseif(offset<8) then oddball.dy*=0.5 oddball.dy+=-0.2+rnd(0.4)
    elseif(offset<10) then oddball.dy+=0.25 oddball.dy*=1.2
    else
     oddball.dy+=2
    end
    shuffle_audience_timing()
   else
    --they screwed up boooo
    sfx(8) sfx(9)
   end
   
   if(slope>0.15 or offset>9.9) then
    set_player_pose(approaching_player,5)
   elseif(slope<-0.15 or offset<2.1) then
    set_player_pose(approaching_player,4)
   else
    set_player_pose(approaching_player,3)
   end
   players[approaching_player].stagger_effect=35
   sfx(1+approaching_player)
   --glancing blows
   --extra oomph
   if(btn(4,approaching_player-1)) then oddball.dx*=1.1 sfx(0) end   
  end
 end

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
  sfx(1)
  oddball.upforgrabs=true
  if(players[1].score<9 and players[2].score<9) then
   oddball.service_time=cycles+20+rnd(5)
  else
   --winner winner chicken dinner 
   oddball.service_time=cycles+55+rnd(10)
   players[scoring_player].dancing=true
   sfx(10) sfx(11)
  end
  players[scoring_player].dancing=true
 end
end

function shuffle_audience_timing()
 for i=1,#stadium.audience do
  stadium.audience[i].timing=-4+flr(rnd(9))
 end
end

function game_draw()
 cls()
 rect(0,0,127,127,5) --———

 draw_field() 
 draw_scoreboard()
 draw_floor()
 
 local exitx=(stadium.display.left+stadium.display.right)/2-12
 local exity=stadium.display.bottom-22
 draw_door(exitx,exity)

 draw_audience()
 draw_player(1)
 draw_player(2)
 draw_oddball()
 draw_windup()
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
   set_player_pose(num,6)
   players[num].stagger_effect=nil
  elseif(cycles-players[num].started_dancing<25) then
   players[num].stagger_effect=nil
   set_player_pose(num,7)
   players[num].stagger_effect=8
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

function draw_floor()

 for i=1,stadium.floor.height do
  local rad
  if(i<8) then
   rad=15+i^2
   if rad>60 then rad=62 end
  else
   rad=60-1.5*(i%3)-i/10
  end
  local l=stadium.field.middle-rad
  local r=stadium.field.middle+rad
  local h=stadium.floor.top+i
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
  party_message="player 1 wins"
 elseif(party_message==nil and num==2) then
  party_message="player 2 wins"
 else
  party_message="everybody wins!!"
 end
 music(0)
 party_update()
 adjective="stellar"  
end


function party_update()
 party_time=cycles-party_started
 if(party_time>120 or ((party_time>25) and (btnp(4,0)  or  btnp(4,1)))) then do_intro() end
end

function party_draw()
 cls(5)

 draw_door(76,40)
 
 local progress=8+party_time/12
 
 for i=1,#stadium.audience do
  local z=stadium.audience[i].sprite+32
  sspr(z*8%128,8*flr(z*8/128),8,8,
   50+progress+(i%6)*(10-10/(1+flr(i/6))),--dx
   54-progress/12+flr(i/6)*(7-i/10),--dy
   20/progress*(flr(i/6)*6),--dw
   20/progress*(flr(i/6)*6),--dh
   (cycles%3==0)--x flip
   )
 end
 party_drapes_draw()
 if(party_time>20) then print("thanks for playing",20,45,7) end
 if(party_time>28 and flr(cycles/20)%2==0) then print("that was "..adjective.."!!",25,55,7) end
 if(party_time>50) then print(party_message,28,65,11) end

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
   local color=15
   if(y>party_line1(x)) then pset(x,y,party_fn(x,y)) end
   if(y<party_line2(x)) then pset(x,y,party_fn(x,y)) end
--   pset(x,y,color)
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
00030000000404000000000004444440040040000000000007404070004444003330330000000000000000000000000000000000000000000000000000000000
002222000044440009999900065555600744770000aaaa0007444470111111003333333000000000000000000000000000000000000000000000000000000000
077772200664660a9a77a9900655b5607c77cc700c1ac1a00999977011ff11003777733000000000000000000000000000000000000000000000000000000000
0c7c72200d64d60a0cddcc006555bb567c77cc7001ca1ca00199190000eef4003474730000005555555555555555000000000000000000000000000000000000
02222220004444a000aaaae06555cb5677aaa74409999a990411b4400f999ff00f8ff00000005333333333333335000000000000000000000000000000000000
02222220009aa9a0e9e99e9e6555bb5645aa55440a99aaa04bd3b4940099990000f5fb0000005333333333333335000000000000000000000000000000000000
02222220099aa990e999999e6555b556455555a40aaaaaa04943d4940044440000bbbb0000005333333333333335000000000000000000000000000000000000
0055220004999940dd8008dd066666600aa55aa00090090050511505011011000000000000005333333333333335000000000000000000000000000000000000
00003000004004a00000000004444440004004000000000070400407004444000333033000005333333333333335000000000000333333330000000000000000
00222200004444a009999990065555600774477000aaaa0070444407011111103333333300545333333333333335450000000000337777330000000000000000
022222200066660099a77a990655b5607cc77cc70c1aac1007999970011ff1103377f77300445333333333333335440000000000034747300000000000000000
02777720006dd60000cddc006555b5567cc77cc701caa1c00019910000feef000374f4700044555555555555555544000000000000f8ff000000000000000000
027cc720004444000eaaaae06555c556477aa7749a9999a904b11b400f9999f000ff8f0000446666666666666666440000000000000f5fb00000000000000000
02222220009aa9a0e9e99e9e6555b556455aa5540aa99aa049bd3b940f9999f000bf5f00004466666666666666664400000000000000bbb00000000000000000
02222220099aa990e999999e6555b556455555540aaaaaa04943d4940044440000bbbb0000446666666666666666440000000000000000000000000000000000
0025520004499440dd8008dd066666600aa55aa00090090050511505011001100000000000446666666666666666440000000000000000000000000000000000
00000300004040000000000004444440000400400000000007400470004444000033303300446666666666666666440000000000000000000000000000000000
002222000044440000999990065555600077477000aaaa0007444470004111110333333300446666666666666666440000000000000000000000000000000000
02277770a066466009a77a990655556007cc77c70ac1ac100779999000411f110337777300446666666666666666440000000000000000000000000000000000
0227c7c0a06d46d0009cddc06555b55607cc77c70a1ca1c000919910004fee000337474300446666666666666666440000000000000000000000000000000000
022222200a4444000eaaaae0655bc556447aaa7499a99990044b11400ff999f0033ff8f000446666666666666666440000000000000000000000000000000000
02222220009aa900e9e99e9e655bb5564455aa540aaa99a0494bd3b40099990000bf5f0000446666666666666666440000000000000000000000000000000000
02222220099aa940e999999e6555b5564a5555540aaaaaa04943d4940044440000bbbb0000446666666666666666440000000000000000000000000000000000
0022550004999990dd8008dd066666600aa55aa00090090050511505001101100000000000446666666666666666440000000000000000000000000000000000
00030000004004000000000004444440004004000000000070400407000020000333033000446666666666666666440000000000000000000000000000000000
002222000044440009999990065555600444444000aaaa0070444407004444003333333300446666666666666666440000000000000000000000000000000000
02222220004444009999999906555560444444440aaaaaa007744770014444103333333300440666660666066660440000000000000000000000000000000000
0222222000444400009999006555b556444444440aaaaaa00044440001ffff100333333000000000000000000000000000000000000000000000000000000000
02222220004a94000444444e655bb556444444449aaaaaa9044444400ff99ff00033330000000000000000000000000000000000000000000000000000000000
022222200099a900e444444e655bb5564a4444440aaaaaa0494444940f99990000bbbb0000000000000000000000000000000000000000000000000000000000
02222220099a9990e4444edd6555b5564aa44a449aaaaaa0494444940044440000bbbb0000000000000000000000000000000000000000000000000000000000
002220000449aa40dde000000666666000444aa00000090050051505011001000000000000000000000000000000000000000000000000000000000000000000
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
00000000000000000000000000000000000000000000000000000000000000004444444333335555555555533333333333333444444444444443333344444333
00000000000000000000000000000000000000000000000000000000000000004444444433355555555553333333333333333334444444444444333444444133
00000000000000000000000000000000000000000000000000000000000000000444444444555555553333333333333333333333344444444444434444444331
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

