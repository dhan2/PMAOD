pro read_pm, filename,label_separation=label_separation 

   
   if ( n_elements( label_separation ) eq 0 ) then begin
     label_separation = ','
  endif else begin
     label_separation = label_separation
  endelse


  str   = ' '
  ; openfile to read
  openr, lun, filename, /get_lun
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
  varsnames = ['Date GMT','Time GMT'] 
           
  vars      = ['day_pm','time_pm'] 
  
  
  nvars = n_elements( varsnames )

  for i = 0, nvars-1 do begin

    index = where(head eq varsnames[i], ct )
    if ct eq 1 then begin
      j = index[0]
      
        void = execute( vars[i] + '= reform( (data[j,*]) )' )
     
    endif

  endfor
  
  
  
  varsnames = ['Sample Measurement' ] 
           
  vars      = ['pm25'] 
  
  
  nvars = n_elements( varsnames )

  for i = 0, nvars-1 do begin

    index = where(head eq varsnames[i], ct )
    if ct eq 1 then begin
      j = index[0]
      
        void = execute( vars[i] + '= reform(float(data[j,*]) )' )
     
    endif

  endfor
  
  end
