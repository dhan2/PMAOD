@img.pro
function try6_read_pm_lat_lon, filename,label_separation=label_separation 

   
   if ( n_elements( label_separation ) eq 0 ) then begin
     label_separation = ' '
  endif else begin
     label_separation = label_separation
  endelse


  str   = ' '
  ; openfile to read
  openr, lun, filename, /get_lun
  
  

  
  count = 1L

  while ~ eof(lun) do begin

    readf, lun, str
 
    sub_str = strsplit( str, label_separation, /extract )   
    ;print, ' Line:', count, 'Number of elements: ', n_elements( sub_str )

    if count eq 1 then begin
      data = [ [sub_str] ]
    endif else begin
      data = [[data], [sub_str]]
    endelse

    ; counter add-up
    count = count + 1

    ; check if need to stop during reading
    
  endwhile

  free_lun, lun

  nobs = count - 1

  print, 'Number of observations: ', nobs
  
           
  vars      = ['site_code','latitude','longitude'] 
  
  void = execute( vars[0] + '= reform( (data[0,*]) )' )
  
  for i = 1, 2 do begin
      
  void = execute( vars[i] + '= reform( float(data[i,*]) )' )
   
  endfor 
  
  
  
 epa={site_code:site_code,latitude:latitude,longitude:longitude}
return,epa
  
 
  


  end
  
  
function try5_read_aeronet_lat_lon, filename,label_separation=label_separation 

   
   if ( n_elements( label_separation ) eq 0 ) then begin
     label_separation = ','
  endif else begin
     label_separation = label_separation
  endelse



  str   = ' '
  ; openfile to read
  openr, lun, filename, /get_lun
  readf, lun, str ;skip header
  readf, lun, str
  head  = strsplit( str, label_separation, /extract )
  

  
  count = 1L

  while ~ eof(lun) do begin

    readf, lun, str
 
    sub_str = strsplit( str, label_separation, /extract )   
    ;print, ' Line:', count, 'Number of elements: ', n_elements( sub_str )

    if count eq 1 then begin
      data = [ [sub_str] ]
    endif else begin
      data = [[data], [sub_str]]
    endelse

    ; counter add-up
    count = count + 1

    ; check if need to stop during reading
    
  endwhile

  free_lun, lun

  nobs = count - 1

  print, 'Number of observations: ', nobs
  varsnames = ['Site_Name'] 
           
  vars      = ['site_name'] 
  
  
  nvars = n_elements( varsnames )

  for i = 0, nvars-1 do begin

    index = where(head eq varsnames[i], ct )
    if ct eq 1 then begin
      j = index[0]
      
        void = execute( vars[i] + '= reform( (data[j,*]) )' )
     
    endif

  endfor
  
  
  
  varsnames = ['Longitude(decimal_degrees)','Latitude(decimal_degrees)' ] 
           
  vars      = ['longitude','latitude'] 
  
  
  nvars = n_elements( varsnames )

  for i = 0, nvars-1 do begin

    index = where(head eq varsnames[i], ct )
    if ct eq 1 then begin
      j = index[0]
      
        void = execute( vars[i] + '= reform(float(data[j,*]) )' )
     
    endif

  endfor
  
aeronet={site_name:site_name,latitude:latitude,longitude:longitude}
return,aeronet
  end
  
function try4_distance,lat1, lon1, lat2, lon2

EARTH_RADIUS = 6378.137

pi=3.14159265

a = lat1*pi/180- lat2*pi/180

b = lon1*pi/180 - lon2*pi/180

d = EARTH_RADIUS*2*asin(sqrt(sin(a/2)^2 + cos(lat1*pi/180)*cos(lat2*pi/180)*sin(b/2)^2))

return,d
end

pro select_match_pm_aeronet

aeronet=try5_read_aeronet_lat_lon('aeronet_locations_2011_lev20.txt')
epa=TRY6_READ_PM_LAT_LON('site_code_lat_lon.txt')

cnt=n_elements(aeronet.latitude)
;cnt_2=n_elements(epa.latitude)

distance_min=fltarr(cnt)
index_epa=intarr(cnt)

for i=0,cnt-1 do begin
distance_2=try4_distance(epa.latitude,epa.longitude,aeronet.latitude(i),aeronet.longitude(i))
distance_min(i)=min(distance_2)
index_epa(i)=where(distance_2 eq distance_min(i))
end


index_min=where(distance_min le 10,count_min)


;print,index_min

;print,index_epa(index_min)

win_x = 1200
win_y = 500




img, win_x, win_y,aeronet.latitude(index_min),aeronet.longitude(index_min),epa.latitude(index_epa(index_min)),epa.longitude(index_epa(index_min))



  
 image = tvrd(true=3, order=1)
 
 write_jpeg, 'epa_aeronet.jpg', $
          image, true=3, /order, quality=100

openw,lun, '88101.txt',/get_lun,width=500
printf,lun,'AERONET '+'latitude '+'longitude '+'PM2.5_site_code '+'latitude '+'longitude '+'distance'

cnt=n_elements(index_min)
for i=0,cnt-1 do begin
  printf,lun,aeronet.site_name(index_min[i]),aeronet.latitude(index_min[i]),$
    aeronet.longitude(index_min[i]),' ',epa.site_code(index_epa(index_min[i])),$
    epa.latitude(index_epa(index_min[i])),epa.longitude(index_epa(index_min[i])),$
    distance_min(index_min[i]) 

endfor
free_lun,lun
end

