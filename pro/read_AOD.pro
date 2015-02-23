pro read_AOD, filename, nheadline=nheadline,$
                    label_separation=label_separation 

  ; check optional argument
  if ( n_elements(nheadline) eq 0 ) then nheadline = 4
  
   if ( n_elements( label_separation ) eq 0 ) then begin
     label_separation = ','
  endif else begin
     label_separation = label_separation
  endelse

  ; openfile to read
  openr, lun, filename, /get_lun

  str   = ' '

  ; read the header
  for i = 0, nheadline do readf, lun, str
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
  
  
  varsnames = ['Julian_Day','AOT_440', 'AOT_675', 'AOT_380','440-675Angstrom' ] 
           
  vars      = ['jday','AOT_440', 'AOT_675','AOT_380','Angstrom'] 
  
  
  nvars = n_elements( varsnames )

  for i = 0, nvars-1 do begin

    index = where(head eq varsnames[i], ct )
    if ct eq 1 then begin
      j = index[0]
      
        void = execute( vars[i] + '= reform( float(data[j,*]) )' )
     
    endif

  endfor
end
