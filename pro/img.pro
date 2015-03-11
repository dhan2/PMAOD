

PRO img, win_x, win_y, a_lat,a_lon,lat, lon
 
  
 region_limit = [25, -125, 50, -65]


; set plot position
  xa = 0.05
  ya = 0.1
  xb = 0.95
  ybb = 0.95
  xl = region_limit(1)
  yb = region_limit(0)
  xr = region_limit(3)
  yt = region_limit(2)


loadct,39

; set up window
  set_plot, 'x' 
  device, retain=2,decompose=0
  !p.background=255L + 256L * (255+256L *255)
  !p.multi = [0, 1, 2]
  black = 1L + 256L * (1*256L *1) 
 
  window, 1, xsize=win_x, ysize=win_y  
  
  
  
  map_set, /continent, $
        charsize=0.8, mlinethick = 2,$
  limit = region_limit, color = black, /USA, $
        position=[xa, ya, xb, ybb], /CYLINDRICAL

  



    map_set, /noerase, /continent, $
         charsize=0.8, mlinethick = 2,$
  limit = region_limit, color = black, /USA, $
       position =[xa, ya, xb, ybb], /CYLINDRICAL

  xyouts, win_x/2.,  win_y-18, 'EPA_PM2.5_88101 and AERONET sites(distance<10km,2011)', color=black, $
       charsize=1.5, charthick=1.5, align = 0.5, /device

 plot, [xl, xr], [yb, yt], /nodata,xrange = [xl, xr], $
       yrange = [yb, yt], position =[xa, ya, xb, ybb], $
       ythick = 1, charsize = 1.5, charthick=1, xstyle=1, ystyle=1,$
       xminor = 1, xticks=12,color=black, yminor=2, xtick_get=xv,ytick_get=yv
       
     
A = FINDGEN(17) * (!PI*2/16.)

USERSYM, COS(A), SIN(A), /FILL     

 oplot,[lon],[lat],psym=8,color=254,symsize=2 


oplot,[a_lon],[a_lat],psym=5,color=33,symsize=2


 nxv = n_elements(xv)
 nyv = n_elements(yv)
 
  for i = 0, nxv-1 do begin
    oplot,  [xv(i), xv(i)], [yb, yt], linestyle=1, color=black
  endfor
 for i = 0, nyv-1 do begin
 
    oplot,  [xl, xr], [yv(i), yv(i)], linestyle=1, color=black
  endfor


end
