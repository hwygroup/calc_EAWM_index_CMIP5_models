load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
undef("get_start_year")
function get_start_year(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    start_year   =   stringtoint(str_get_cols(a,ind1,ind1+3))
    return(start_year)
end
undef("get_start_month")
function get_start_month(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    start_month   =   stringtoint(str_get_cols(a,ind1+4,ind1+5))
    return(start_month)
end
undef("get_end_year")
function get_end_year(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    end_year   =   stringtoint(str_get_cols(a,ind1+7,ind1+10))
    return(end_year)
end
undef("get_end_month")
function get_end_month(a:string,b:string,c:string)
begin
    i1  =   indStrSubset(a,b)
    i2  =   indStrSubset(a,c)
    ind1    =   max(i1)+1
    ind2    =   min(i2)-1
    end_month   =   stringtoint(str_get_cols(a,ind1+11,ind1+12))
    return(end_month)
end




begin
    err = NhlGetErrorObjectId() 
    setvalues err 
    "errLevel" : "Fatal" ; only report Fatal errors 
    end setvalues 
    dir="/home/hwy/WORK3/CMIP5/ftp.ceda.ac.uk/badc/cmip5/data/cmip5/output1/"
    model="NCAR/CCSM4"
    expname="historical"
    id="r1i1p1"
    fast_mode=True
    i3  =   indStrSubset(model,"/")
    model_name=str_get_cols(model,max(i3)+1,100)
    print("model_name:"+model_name+" exp_name:"+expname+" id:"+id)
    fx_dir=dir+model+"/"+"historical"+"/fx/atmos/fx/r0i0p0/latest/areacella/"
    dir=dir+model+"/"+expname+"/mon/atmos/Amon/"+id+"/latest/"
    fx_fis  =   systemfunc("ls "+fx_dir) 
    ua_dir  =   dir+"ua/"
    va_dir  =   dir+"va/"
    ta_dir  =   dir+"ta/"

    print("script_name: "+get_script_name())
    ua_fis  =   systemfunc("ls "+ua_dir)
    va_fis  =   systemfunc("ls "+va_dir)
    ta_fis  =   systemfunc("ls "+ta_dir)
    max_ua_fis  =   dimsizes(ua_fis)
    max_va_fis  =   dimsizes(va_fis)
    max_ta_fis  =   dimsizes(ta_fis)

    size_ua_fis  =   systemfunc("du -sh "+ua_dir)
    size_va_fis  =   systemfunc("du -sh "+va_dir)
    size_ta_fis  =   systemfunc("du -sh "+ta_dir)
    print("size_ua_fis:"+size_ua_fis)
    print("size_va_fis:"+size_va_fis)
    print("size_ta_fis:"+size_ta_fis)

    if (isfilepresent(fx_dir+fx_fis)) then
        area_fi =   addfile(fx_dir+fx_fis,"r")
        area    =   area_fi->areacella
        printMinMax(area,0)
    else
        print("area_fi cannot be found")
        exit
    end if

    if (max_ua_fis .eq. max_va_fis .and. max_ua_fis .eq. max_ta_fis) then
        continue    
    else
        print("max_ua_fis .ne. max_va_fis .or. max_ua_fis .ne. max_ta_fis")
        exit
    end if

    start_year_ua    =   get_start_year(ua_fis(0),id+"_",".nc")
    start_year_va    =   get_start_year(va_fis(0),id+"_",".nc")
    start_year_ta    =   get_start_year(ta_fis(0),id+"_",".nc")
    start_month_ua    =   get_start_month(ua_fis(0),id+"_",".nc")
    start_month_va    =   get_start_month(va_fis(0),id+"_",".nc")
    start_month_ta    =   get_start_month(ta_fis(0),id+"_",".nc")

    end_year_ua    =   get_end_year(ua_fis(max_ua_fis-1),id+"_",".nc")
    end_year_va    =   get_end_year(va_fis(max_ua_fis-1),id+"_",".nc")
    end_year_ta    =   get_end_year(ta_fis(max_ua_fis-1),id+"_",".nc")
    end_month_ua    =   get_end_month(ua_fis(max_ua_fis-1),id+"_",".nc")
    end_month_va    =   get_end_month(va_fis(max_ua_fis-1),id+"_",".nc")
    end_month_ta    =   get_end_month(ta_fis(max_ua_fis-1),id+"_",".nc")

    if (start_year_ua .eq. start_year_va .and. start_year_ua .eq. start_year_ta) then
        continue
    else
        print("start_year_ua .ne. start_year_va .or. start_year_ua .ne. start_year_ta")
        exit
    end if

    if (start_month_ua .eq. start_month_va .and. start_month_ua .eq. start_month_ta .and. start_month_ua .eq. 1) then
        continue
    else
        print("start_month_ua .ne. start_month_va .or. start_month_ua .ne. start_month_ta" .or. "start_month_ua .ne. 1")
        exit
    end if

    if (end_year_ua .eq. end_year_va .and. end_year_ua .eq. end_year_ta) then
        continue
    else
        print("end_year_ua .ne. end_year_va .or. end_year_ua .ne. end_year_ta")
        exit
    end if

    if (end_month_ua .eq. end_month_va .and. end_month_ua .eq. end_month_ta .and. end_month_ua .eq. 12) then
        continue
    else
        print("end_month_ua .ne. end_month_va .or. end_month_ua .ne. end_month_ta" .or. "end_month_ua .ne. 12")
        exit
    end if

    start_year  =   start_year_ua
    end_year    =   end_year_ua

    print("start_year: "+start_year+" end_year:"+end_year)

    if (max_ua_fis .eq. 1) then
        ua_fis_in   =   addfile(ua_dir+"/"+ua_fis,"r")
        va_fis_in   =   addfile(va_dir+"/"+va_fis,"r")
        ta_fis_in   =   addfile(ta_dir+"/"+ta_fis,"r")
        ua_ref  =   ua_fis_in->ua(0,:,:,:)
        va_ref  =   va_fis_in->va(0,:,:,:)
        ta_ref  =   ta_fis_in->ta(0,:,:,:)
        time    =   ua_fis_in->time
        ;printVarSummary(ua)
        ;printVarSummary(va)
        ;printVarSummary(ta)
    else
        ua_fis_in   =   addfiles(ua_dir+"/"+ua_fis,"r")
        va_fis_in   =   addfiles(va_dir+"/"+va_fis,"r")
        ta_fis_in   =   addfiles(ta_dir+"/"+ta_fis,"r")
        ListSetType (ua_fis_in, "cat")
        ListSetType (va_fis_in, "cat")
        ListSetType (ta_fis_in, "cat")
        ua_ref  =   ua_fis_in[:]->ua(0,:,:,:)
        va_ref  =   va_fis_in[:]->va(0,:,:,:)
        ta_ref  =   ta_fis_in[:]->ta(0,:,:,:)
        time    =   ua_fis_in[:]->time
        ;printVarSummary(ua)
        ;print(time(0))
        ;printVarSummary(va)
        ;printVarSummary(ta)
    end if


    time    =   cd_calendar(time, 1)
    plev    =   ua_ref&plev
    num_plev    =   dimsizes(plev)
    ind_plev500 =   ind_resolve(ind(plev.eq.50000),dimsizes(plev))
    print("plev 500: "+plev(ind_plev500(:,0)))
    if (fast_mode) then
        pp2=ind_plev500(:,0)+2
        np2=ind_plev500(:,0)-2
        print("plev pp2: "+plev(pp2))
        print("plev np2: "+plev(np2))
    else
        pp2=num_plev-1
        np2=0
    end if

    lon     =   ua_ref&lon
    lat     =   ua_ref&lat
    num_time    =   dimsizes(time)
    num_lat     =   dimsizes(lat)
    gau_info    =   tofloat(gaus(num_lat/2))
    glat     = gau_info(:,0)  
    lat_diff    =   abs(lat-glat)
    max_diff    =   max(lat_diff)
    if (max_diff .lt. 0.1) then
        if_gauss    =   True
        gridType  = 0
    else
        if_gauss    =   False
        gridType  = 1
    end if

    lats    =   25.0
    late    =   55.0
    lons    =   100.0
    lone    =   150.0

    pv_ts   =   new(num_time,"double")
    pv_ts   =   pv_ts@_FillValue

    num_year    =   end_year-start_year+1
    eawm    =   new(num_year-1,"double")

    do k = 0, num_time-1
       modk=    mod(k,12)
       if (modk .eq. 11 .or. modk .eq. 0 .or. modk .eq. 1 .or. modk .eq. 2) then
            if (max_ua_fis .eq. 1) then
                ua  =   ua_fis_in->ua(k,np2:pp2,:,:)
                va  =   va_fis_in->va(k,np2:pp2,:,:)
                ta  =   ta_fis_in->ta(k,np2:pp2,:,:)
            else
                ua  =   ua_fis_in[:]->ua(k,np2:pp2,:,:)
                va  =   va_fis_in[:]->va(k,np2:pp2,:,:)
                ta  =   ta_fis_in[:]->ta(k,np2:pp2,:,:)
            end if
            PV  = pot_vort_isobaric(plev(np2:pp2),ua, va, ta,lat, gridType, 0) 
            PV  =   where(ismissing(PV),PV@_FillValue,PV*1.0e6)
            pv_500   =   PV({50000},:,:)
            pv_ts(k) =   wgt_areaave2(pv_500({lats:late},{lons:lone}),area({lats:late},{lons:lone}),0)-wgt_areaave2(pv_500({lats:late},:),area({lats:late},:),0)
            if (abs(pv_ts(k)) .gt. 1.0e+5) then
                exit
            end if
            print("date: "+time(k)+ " pv_ts(k):"+pv_ts(k))
       end if
    end do

    do k = 0, num_year-2
        eawm(k) =   dim_avg(pv_ts(k*12+11:k*12+14))
    end do

    end_year_1  =   end_year-1
    fiout   =   "eawm_DJFM_"+model_name+"_"+expname+"_"+id+"_"+start_year+"_"+end_year_1+".txt_fast_mode"
    asciiwrite (fiout , sprintf("%10.6e", eawm))
end
